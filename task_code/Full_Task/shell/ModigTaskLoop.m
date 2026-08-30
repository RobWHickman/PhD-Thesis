function varargout = ModigTaskLoop(varargin)
% varargout = ModigTaskLoop(varargin)
% 
% The main loop to repeat trials
% It loops until the value breaksession is set 0. [ModigCommand('stop_session') 
% does this]
%
% "Initialize" subroutine set trial conditions at the begining of each trial.
% "StartTrial" subroutine starts a trial.
% "PostTrial" subroutine summarize a trial.
%
% Priority is set high during a trial so that software timers keep running 
%   "accurately".
%
% coded by skoba (skoba-tky@umin.ac.jp) 8 June 2005
% last modified by skoba 11 August 2006
% RBM 08.07 changed order of calls to subfunctions
% rbm 11.07 updates new MoMaMe/prjArea
%      6.08 handshake and iti timings 
%       7.08 different seqDisp code
%       9.11 
%       3.12 commented out "ListenChar". Command window isn't called every
%       trial and interrupts during trial execution by pressing keys 'c' or
%       'q'
global breaksession TaskOp ExtDevice 
% global MENUs

if nargin == 0,
    while breaksession == 0
        % initialize parameters (trial condition, visual pages, timers)
        cb_init = Initialize;    

        % start a trial if initialization was successful
        if cb_init == 1                             
            % start the first timer (Timers.task.event_1) and
            % start behavioral data sampling
            cb_start = StartTrial;
            if cb_start == 0
                ModigCommand('stop_session');  
            else
              % processes after a trial (wait for
              % behavior sampling timer to stop and start ITI timer)
                PostTrial;
                if TaskOp.log.on
                    LogData;
                end
                Summary;
                SeqDisp;
                CheckBreakSession; 
                % go to Project-specific  post trial file 
                if exist(strcat('ModigPostTrial_',TaskOp.prj),'file')==2,
                    eval(strcat('ModigPostTrial_',TaskOp.prj));            
                end
                if ~isempty(ExtDevice),
                    flushdata(ExtDevice.aiObject)
                end
            end
        else
            warning('Unsuccesful trial initialization')
            ModigCommand('stop_session');  
        end
    end
    breaksession = 0;
elseif ischar(varargin{1}),
    try
        [varargout{1:nargout}] = feval(varargin{:});
    catch
        rethrow(lasterror);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb = Initialize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trial-by-trial initialization
global TaskOp MENUs VisParam BehaveData Task UserInfo ExtDevice 

cb = 1;
% initialize and save data in storage arrays: TaskOp.EvntHist
TaskOp.EvntHist.Tbl = {};

[TH, StartTime, Empty] = isfield_sk(TaskOp,'EvntHist.cur_trial_start_time');
if ~Empty
    TaskOp.EvntHist.prev_trial_start_time = TaskOp.EvntHist.cur_trial_start_time;
end

[TH, prev_ITI_base, Empty] = isfield_sk(Task,'ITI.time_base');
if ~Empty
    TaskOp.EvntHist.prev_ITI_base = prev_ITI_base;
else
    TaskOp.EvntHist.prev_ITI_base = 0;
end

[TH, prev_ITI_var, Empty] = isfield_sk(Task,'ITI.time_var');
if ~Empty
    TaskOp.EvntHist.prev_ITI_var = prev_ITI_var;
else
    TaskOp.EvntHist.prev_ITI_var = 0;
end

[TH, prev_ITI_rand, Empty] = isfield_sk(Task,'ITI.time_randomized');
if ~Empty
    TaskOp.EvntHist.prev_ITI_rand = prev_ITI_rand;
else
    TaskOp.EvntHist.prev_ITI_var = 0;
end

% initizalize an array to store eye position data
BehaveData.Tbl      = [];
TaskOp.eye_state    = 0;
TaskOp.hand_state   = 0;
TaskOp.touch_state  = 0;

% Verify ModigMonitor status, if it is present we 'select it'
if ~isfield(MENUs,'ModigMonitor')
    VisParam.draw = 0;
elseif strcmpi(MENUs.ModigMonitor.status,'OFF');
    VisParam.draw = 0;
elseif strcmpi(MENUs.ModigMonitor.status,'ON');
    if ishandle(VisParam.h_MONITOR_AXIS) && TaskOp.repeatError==0
        axes(VisParam.h_MONITOR_AXIS); 
        hold on;
        VisParam.draw = 1;
    end
else
    VisParam.draw = 0;
end

% clear array to store flip time stamps
task_fields = fields(Task);
for tt = task_fields'
    Task.(char(tt)).flipTimeStamp = 0;
end

% if we want new params,
if TaskOp.repeatError == 0,
    % Load project-specific files indicating , we need:
    %   -ModigRandSeq_(prj),        shuffle sequence, if appropriate
    %   -ModigPrepareTrial_(prj),   Set parameters in each trial
    %   -ModigPreparePages_(prj),   Prepare graphic presentation in all the
    %                               pages, by drawing onto off screen
    if TaskOp.Trial.to_be_shuffled
        code_name = strcat('ModigRandSeq_',TaskOp.prj);
        if exist(code_name,'file')        
            eval([code_name,';']);
            TaskOp.Trial.to_be_shuffled = 0;
            TaskOp.Trial.just_shuffled = 1;
        end
    elseif  TaskOp.Trial.to_be_shuffled == 0 && TaskOp.Trial.just_shuffled == 1
        TaskOp.Trial.just_shuffled = 0;
    end

    % Prepare epoch timing
    ModigPrepareTiming;

    % Prepare trial parameters
    code_name = strcat('ModigPrepareTrial_',TaskOp.prj,';');
    if exist(code_name(1:end-1),'file')
        eval(code_name);
    end
end

    % prepare trial visual pages
    code_name = strcat('ModigPreparePages_',TaskOp.prj,';');
    if exist(code_name(1:end-1),'file')
        eval(code_name);
    end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb = StartTrial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global  Tbl TaskOp  breaksession MENUs UserInfo IO
global ExtDevice ModigLog
% global Stim Task VisParam

% Make sure all functions (SCREEN.mex) are in memory.
Screen('Screens');    

buf = findcell_sk(Tbl.TaskTbl(:,Tbl.TaskTblColumnID.evnt_name),'ITI');
% previous event was ITI
prev_event_id = buf(1);
% next event is pre_trial
next_event_id = 1;     

% DEBUG, allocate variables for task operation. check in
% ModigJudgeSit...prj !!!
TaskOp.eye.req        = [];
TaskOp.hand.req       = [];
TaskOp.touch.req      = [];
TaskOp.eye.state      = 0;
TaskOp.hand.state     = 0;
TaskOp.touch.state    = 0;
TaskOp.correct        = 0;
TaskOp.error_event    = 0;
TaskOp.ignored        = 0;
TaskOp.cur_event_id   = next_event_id;
TaskOp.cur_event_name = cell2mat(Tbl.TaskTbl(next_event_id,...
    Tbl.TaskTblColumnID.evnt_name));

% variable initiation as well. 
if ~isfield(IO.Input.behavior,'sample'),
    IO.Input.behavior.sample = 1;
end

 % moved HS after stopping ITI timer to have an accurate trial timing.
% Otherwise, a long ITI might reduce the amount of data stored by Getty
% since we tell Getty for how long it should store data with or without
% the next ITI. However, lately all handshake codes are taking at least
% 2.5 s, so I moved the ITI time after the handshake.

% Send data to Getty.
if UserInfo.lab_connection && UserInfo.gettyHandshake
    % generate values to be sent to Getty, use
    % ModigMakeGettyArray if you don't have an array
    valToGetty = eval(['ModigMakeGettyArray_',TaskOp.prj]);

    switch UserInfo.typeOfHandshake,
        case 'NI',
        % MATLAB-based handshake is pretty slow, it takes 25ms per bit.  
        ModigHandshake(ExtDevice.inputDio, ExtDevice.outputDio, valToGetty), 
        
        case 'TCP',
        % TCP/IP based handshake
        TCPSendMessage(ExtDevice.inputDio,ExtDevice.outputDio,valToGetty);   
    end
end
  
% Get and store values for ModigLog in a struct within TaskOp irrespective of labconnection or handshake %% Addition for ModigLog CRvC
if get(MENUs.ModigMainMenu.handles.CNTR_CHECK_LOG,'value')
    valToGetty = eval(['ModigMakeGettyArray_',TaskOp.prj]);
    ModigLog=setfield(ModigLog,'AddVals',valToGetty);
    ModigLog.AddVals=[ModigLog.AddVals(2:80) zeros(1,1)];
end

% recover ITI timer TS, they're saved onto the next trial trecon. 
%   flip TS is saved on the *previous* trial trecon
% trts = trialRecon('data'); 
% TaskOp.trecon = trts; 

% change Remedy button to red -what Modig waits for-
set(MENUs.ModigMainMenu.handles.CNTR_PUSH_REMEDY,'BackgroundColor',...
    [1 0 0]);
% devote all resources to running the task
Priority(2);

if breaksession==1,
    disp('---session broken after handshake ModigTaskLoop--')
    ModigCommand('stop_session');
else
    % Record current trial start time /should be passed to MoMoBe/        
    TaskOp.EvntHist.cur_trial_start_time = GetSecs;

    % activate touch screen
    if isfield(IO.Input,'use_touch_screen') && IO.Input.use_touch_screen==1,
        %runED('e',1);
        HideCursor
    end

    % start the trial
    ModigRunTrial(1);
end
cb = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PostTrial

global TaskOp MENUs UserInfo %VisParam
% Wait until another function (ModigShiftEvent) changes this property in 
% the GUI to move into the next lines
waitfor(MENUs.ModigMainMenu.handles.CNTR_PUSH_REMEDY,'BackgroundColor',[0.12 0.7 0.4]);

% Tell Getty the trial is over
if UserInfo.lab_connection && UserInfo.gettyHandshake && strcmp(UserInfo.typeOfHandshake,'TCP'), 
    ModigBitSender(24,1);
    fprintf(1,'Trial end bit up\n');
    WaitSecs(0.1);
    ModigBitSender(24,0);
    fprintf(1,'Trial end bit down\n');
end

% disable touch screen
if UserInfo.use_touch_screen,
    myTouchScreens = 1;
    runED('d', myTouchScreens);
    SetMouse(2048,0);
    ShowCursor;
end

% reconstruct Trial timer time stamps
% trts = trialRecon('data');
% For every row that is non-ITI, save flip time stamp 
% itiid = strcmp(fields(Timers.Event),'ITI');
% TaskOp.trecon(~itiid,:) = trts(~itiid,:);
% TaskOp.trecon(itiid,7)    = trts(itiid,7); % save flip TS
%TODO: ITI TS=0?

% ModigRunTrial version
% TaskOp.treconHistory = [TaskOp.treconHistory, TaskOp.trecon];
% TaskOp.trecon = [];
% out = trialRecon2;
% keyboard

% if we're plotting the eye position history, delete the previous handles
eyeHistHdl = findobj('tag','eyeHistory');
if ~isempty(eyeHistHdl) && ishandle(eyeHistHdl(1))    
    delete(eyeHistHdl)
end
        
Priority(0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Summary(option)
% updates trial related numbers in ModigMainMenu and
% saves (some) of this values to global TaskOp. Also prints the headers for 
% the log file in .xls
% UNDER CONSTRUCTION: Prints behavioural parameters to a datastruct for
% analysis without getty data-acquisition
global TaskOp MENUs breaksession %UserInfo Stim

if nargin == 0
    option = 2 - breaksession; % if session broken don't update counters
end

if option == 2,
    % update the project specific counters
    fileStr = ['updateMoMaMe_',TaskOp.prj];
    if exist(fileStr,'file')
        cmd = [fileStr,'(''update'')'];
        eval(cmd)
    end

    TaskOp.count.day_total   = TaskOp.count.day_total + 1;
    TaskOp.count.block_total = TaskOp.count.block_total + 1;

    if TaskOp.correct,
        TaskOp.count.day_correct   = TaskOp.count.day_correct+1;
        TaskOp.count.block_correct = TaskOp.count.block_correct+1;
        TaskOp.count.seq         = TaskOp.count.seq + 1; 
        if TaskOp.count.seq > TaskOp.count.total_seq
            TaskOp.count.seq = 1;
        end
        % trial counter update
        if strcmpi(TaskOp.running_mode,'fixed_num_trials')
            TaskOp.count.set_remaining = TaskOp.count.set_remaining - 1;
        end
    else
        % update go-nogo counter to avoid repeating prev. error trial
        if strcmpi(TaskOp.prj,'GO_NOGO'),
            TaskOp.count.seq         = TaskOp.count.seq + 1; 
        end
        TaskOp.count.day_error   = TaskOp.count.day_error+1;
        TaskOp.count.block_error = TaskOp.count.block_error+1;
    end

    % update ignored trials,
    % you need to add 'TaskOp.ignored = 1' in the MoJuSit case you consider the 
    % trial  to be ignored. 
    TaskOp.count.day_ignored = TaskOp.count.day_ignored + TaskOp.ignored;
    TaskOp.count.block_ignored = TaskOp.count.block_ignored + TaskOp.ignored;
    TaskOp.ignored = 0;

    % update "rewards" received which in reality is times the juice solenoid
    % was opened.-- it's also updated by MoCo/juice (day)
    % note that without lab connection all correct trials won't be rewarded
    % TODO: flexible code accomodating different juice arrangements
    setupB = strcmp(TaskOp.curSetup,'B');
    line = 11 + setupB;
    TaskOp.count.day_rew = TaskOp.count.day_rew + TaskOp.reward(line);
    TaskOp.count.block_rew = TaskOp.count.block_rew + TaskOp.reward(line);
    
    % check if there was an "other" reward in the trial, fetch the counter
    % and update it
    otherLine = 12 - setupB;
%     if TaskOp.reward(otherLine)>0,
%         if TaskOp.curSetup=='A', myEnd = 'B'; else myEnd = 'A'; end
%         hdlPB=['MENUs.ModigMainMenu.handles.pushbuttonSetup', myEnd];
%         otherCount = get(eval(hdlPB),'UserData');
%         otherCount.day_rew = otherCount.day_rew + TaskOp.reward(otherLine);
%         otherCount.block_rew = otherCount.block_rew + TaskOp.reward(otherLine);
%         set(eval(hdlPB),'UserData',otherCount)
%     end
    
    % save reward history for each trial
    if ~isfield(TaskOp.EvntHist,'rewHistory'),
        TaskOp.EvntHist.rewHistory = zeros(1,2);
        trialRow = 1;
    else
        trialRow = size(TaskOp.EvntHist.rewHistory,1)+1;
    end
    
    TaskOp.EvntHist.rewHistory(trialRow,1+setupB) = TaskOp.reward(line)>0;
    TaskOp.EvntHist.rewHistory(trialRow,2-setupB) = TaskOp.reward(otherLine)>0;


    % since Taskop.reward is "yoked" with juice delivery if the trial was
    % correct and no juice was given we say it's a noRew in accordance with the
    % use in Boticelli. 
    nr = TaskOp.correct-(TaskOp.reward(line)>0);
    TaskOp.count.day_noRew = TaskOp.count.day_noRew + nr;
    TaskOp.count.block_noRew = TaskOp.count.block_noRew + nr;
    TaskOp.reward = zeros(size(TaskOp.reward));

    % update juice volumen counter
%     set(MENUs.ModigMainMenu.handles.textJuiceVol_A,'String',...
%         sprintf('%d ml',round(TaskOp.EvntHist.rewHistVol(1))))
%     set(MENUs.ModigMainMenu.handles.textJuiceVol_B,'String',...
%         sprintf('%d ml',round(TaskOp.EvntHist.rewHistVol(2))))
    
end

% update correct/error and ratios in ModigMainMenu
if option == 2 || option == 1,
    if TaskOp.count.block_total >0
        blockCorrect = round(100*TaskOp.count.block_correct/TaskOp.count.block_total);
    else
        blockCorrect = 0;
    end
    if TaskOp.count.day_total > 0
        dayPercent = round(100*TaskOp.count.day_correct/TaskOp.count.day_total);
    else
        dayPercent = 0;
    end
    
    upFi ={'block_ignored';'day_ignored';'day_rew'; 'block_rew'; 
            'day_noRew'; 'block_noRew'};
    for i =1:6, 
        set(MENUs.ModigMainMenu.handles.(char(upFi(i))),'string',...
            TaskOp.count.(char(upFi(i)))), 
    end

    set(MENUs.ModigMainMenu.handles.CNTR_TEXT_BLOCK_TOTAL,...
        'string',num2str(TaskOp.count.block_total));
    set(MENUs.ModigMainMenu.handles.CNTR_TEXT_BLOCK_CORRECT, ...
        'string', num2str(TaskOp.count.block_correct));
    set(MENUs.ModigMainMenu.handles.CNTR_TEXT_BLOCK_ERROR, ...
        'string', num2str(TaskOp.count.block_error));
    set(MENUs.ModigMainMenu.handles.CNTR_TEXT_BLOCK_PERCENT, ...
        'string', num2str(blockCorrect));

    set(MENUs.ModigMainMenu.handles.CNTR_TEXT_DAY_TOTAL,...
        'string',num2str(TaskOp.count.day_total));
    set(MENUs.ModigMainMenu.handles.CNTR_TEXT_DAY_CORRECT, ...
        'string', num2str(TaskOp.count.day_correct));
    set(MENUs.ModigMainMenu.handles.CNTR_TEXT_DAY_ERROR, ...
        'string', num2str(TaskOp.count.day_error));
    set(MENUs.ModigMainMenu.handles.CNTR_TEXT_DAY_PERCENT, ...
        'string', num2str(dayPercent));

    if strcmpi(TaskOp.running_mode,'fixed_num_trials')
      set(MENUs.ModigMainMenu.handles.CNTR_TEXT_REMAINING_TRIALS,...
            'string',num2str(TaskOp.count.set_remaining));
    end
    
end

if strcmpi(TaskOp.running_mode,'fixed_num_trials') && TaskOp.count.set_remaining<=0 && option==2
    ModigCommand('stop_session');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LogData
% generates behavioural parameters and bittimes into a datastruct for
% analysis without getty data-acquisition  
% Related lines: Modig Task Loop 47-49, 247-252 & ModigShiftEvent 232-269 
% Modig Command 366-379, 382-385
global breaksession UserInfo IO Tbl ModigDir ModigLog TaskOp BehaveData

% Decide filename to search and/or use by date and blocknumber
if ~isfield (ModigLog,'filename')
    dt=datevec(date);
    SessNum = 1;
    savfolder = ModigDir.Log;
    filename =  sprintf('%s\\ModigLog_%d-%d-%d_Session_%d',savfolder,dt(1),dt(2),dt(3),SessNum);
    ModigLog = setfield(ModigLog,'filename',filename);
    ModigLog = setfield(ModigLog,'date',dt);
    ModigLog = setfield(ModigLog,'SessionNum',SessNum);
    if exist(strcat(ModigLog.filename,'.mat'),'file')==2; %This will ensure that if Modig crashes it will find the correct new session file to use.
        stop=0;
        while stop==0;
            SessNum=SessNum+1;
            filename =  sprintf('%s\\ModigLog_%d-%d-%d_Session_%d',savfolder,dt(1),dt(2),dt(3),SessNum);
            if exist(strcat(ModigLog.filename,'.mat'),'file')==2;
            else
                stop=1;
            end
        end
    end
end
if ~breaksession
    %   trialno = TaskOp.count.block_total; %Fix later: (Uses block trialnumber when only one file per day is made)
    %   will overwrite if new block is started how to create sessionnumber?  
    if exist(strcat(ModigLog.filename,'.mat'),'file')~=2; %Things to do when first time
        %Create New Datafile and insert first values and values of first trial
        ModigDataLog = struct('HEADER',[],'FORMAT',[],'TRIAL',[]);
        ModigDataLog.HEADER = struct('day',ModigLog.date(1),'month',ModigLog.date(2),'year',ModigLog.date(3),...
            'animal',[UserInfo.setupA UserInfo.setupB],'session',[],'trials',1,...
            'analog_freq',IO.Input.behavior.sampling_rate,'analog_channels',2,'comments','No comments entered');
        BNums=Tbl.BitTbl(:,2);
        BNames=Tbl.BitTbl(:,1);
        ModigDataLog.FORMAT = struct('BIT_ASIGN',cell2struct(BNums, BNames,1),'MaxBit',max(cat(Tbl.BitTbl{:,2})));   
    end
    % If datafile already exist, previous trial datastruct is loaded
    if exist(strcat(ModigLog.filename,'.mat'),'file')==2;
        ModigDataLog = load(ModigLog.filename); %Load relevant file
        ModigDataLog.HEADER.trials = ModigDataLog.HEADER.trials+1; %count this trial
    end
    
    % Find onsets and offsets for KT's
    KTTime=BehaveData.Tbl(:,1); %Get relevant data
    KT1=BehaveData.Tbl(:,6);
    KT2=BehaveData.Tbl(:,7);
    KT1On=find([0; KT1]-[KT1; 0]==-1); %derivation of starting points of 1 or 0
    KT1Off=find([0; KT1]-[KT1; 0]==1);
    KT2On=find([0; KT2]-[KT2; 0]==-1);
    KT2Off=find([0; KT2]-[KT2; 0]==1);
    % Make sure if there is an offset at end of trial that this moves up
    % one index to correspond to the last time stamp
    KT1Off(KT1Off>max(size(KT1)))=max(size(KT1));
    KT2Off(KT2Off>max(size(KT2)))=max(size(KT2));
    % Get timestamps for KT on & off
    ModigLog.Event(2).onset=KTTime(KT1On);
    ModigLog.Event(2).offset=KTTime(KT1Off);
    ModigLog.Event(4).onset=KTTime(KT2On);
    ModigLog.Event(4).offset=KTTime(KT2Off);
    
    % Recalculate BitTimes to zero at first onset
    ZPoint=TaskOp.EvntHist.cur_trial_start_time;
    NumEventDetection=zeros(1,14);
    for NE=1:14
        NumEventDetection(NE)=numel(ModigLog.Event(NE).onset); %Get numbers of bit changes
        ModigLog.Event(NE).onset=unique((ModigLog.Event(NE).onset-ZPoint)*1000);
        ModigLog.Event(NE).offset=unique((ModigLog.Event(NE).offset-ZPoint)*1000);                  
    end     
    
    % TO DO: Fix multiple onsets and offsets Remove unnessecary offsets (seems to be the main problem now) 
    
    % Write data about this trial to ModigDataLog
    trialno = ModigDataLog.HEADER.trials; %get current trialnumber
    ModigDataLog.TRIAL = setfield(ModigDataLog.TRIAL,{trialno},'Adddata',[ModigLog.AddVals]); % Log AddVals sent to Getty
    ModigDataLog.TRIAL = setfield(ModigDataLog.TRIAL,{trialno},'Duration',TaskOp.trecon{9,9}-TaskOp.trecon{2,9}); % Log Trial Duration
    ModigDataLog.TRIAL = setfield(ModigDataLog.TRIAL,{trialno},'NumEventDetection',NumEventDetection); 
    ModigDataLog.TRIAL = setfield(ModigDataLog.TRIAL,{trialno},'Event',ModigLog.Event); % TO DO: the timestamps need to be calculated relative to the trialstart in ms
    
    % Prompt for comments %TODO, conditional on... well what? Maybe
    % unticking the tickbox? How?
    
    % save updated file
    save(ModigLog.filename,'-struct','ModigDataLog');
    sprintf('data logged trial %4.0f',trialno);
    
    % Empty ModigLog to start fresh in next trial and clean up
    RemFields={'AddVals','Event'};
    ModigLog=rmfield(ModigLog,RemFields);
    clear ModigDataLog BNums BNames SessNum
      
    % Use global BehaveData
    %         ModigDataLog.TRIAL(trialno).EyeData = struct?(Not sure whether to use
    %         this yet)
        
    fprintf('Data logged trial %4.0f\n',trialno)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CheckBreakSession
% pressing the 'c' or 'q' key breaks session
global breaksession TaskOp
global centerEye
% global ExtDevice
[key_down, key_secs, key_code] = KbCheck;

if key_down
    KeyName = KbName(find(key_code)); % c= 67, q = 81
    if strcmpi(KeyName(1),'c') || strcmpi(KeyName(1),'q')
        breaksession = 1;
        TaskOp.correct = 0;
        Priority(0);
        disp('session broken by user pressing ''c'' or ''q''')
        ModigCommand('stop_session');
    elseif strcmpi(KeyName(1),'j') % j =74
        DIOjuice(0.035)
    elseif strcmp(KeyName(1),'control') && strcmp(KeyName(2),'e')
        % makes the next eye sample the offset or P.O.R.
        disp('centering eye...')
        centerEye = 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SeqDisp
% SEQuence DISPlay in ModigMainMenu.fig, 
% project specific in some cases
global TaskOp Stim MENUs 

switch TaskOp.prj,
    case {'IMP_GIVING','DICTATOR','PAVLOVIAN_FIX','GO_NOGO'}
        % update only current setup left: setup A, right: player B 
        cs = TaskOp.curSetup;
        range = TaskOp.count.seq-2:1:TaskOp.count.seq+2;
        recTrials = range>0 & range<size(TaskOp.(cs).trialOrder,1)+1;
        disp_seq = zeros(5,2);
        disp_seq(recTrials,:) = TaskOp.(cs).trialOrder(range(recTrials),:);

        posSides = {'A', 'B'};
        side(1,:) = 'LT';
        side(2,:) = 'RT';    
        loc = ['A','B','C','D','E'];

        k = find(strcmpi(cs,posSides)==1);
        for ss = 1:5
            h_seq = eval(strcat('MENUs.ModigMainMenu.handles.CNTR_EDIT_',side(k,:),'_',loc(ss)));
            set(h_seq,'String',mat2str(disp_seq(ss,:)),'HorizontalAlignment','right');
        end
        drawnow
    case {'OBS_LEARN','OBS_LEARNFIX'}
        setupB = strcmp(TaskOp.curSetup,'B');
        idx = 1+mod(TaskOp.count.choices(setupB+1,:),TaskOp.count.total_seq);
        range(:,1) = idx(1)-2:1:idx(1)+2;
        range(:,2) = idx(2)-2:1:idx(2)+2;

        recTrials = range>0 & range<size(Stim.us.lists,1)+1;
        disp_seq = ones(5,2)*-1;
        disp_seq(recTrials(:,1),1) = Stim.us.lists(range(recTrials(:,1),1),1);
        disp_seq(recTrials(:,2),2) = Stim.us.lists(range(recTrials(:,2),2),2);    

        % update only current setup left: setup A, right: player B 
        cs = TaskOp.curSetup;
        posSides = {'A', 'B'};
        side(1,:) = 'LT';
        side(2,:) = 'RT';    
        loc = ['A','B','C','D','E'];

        k = find(strcmpi(cs,posSides)==1);
        for ss = 1:5
            h_seq = eval(strcat('MENUs.ModigMainMenu.handles.CNTR_EDIT_',side(k,:),'_',loc(ss)));
            set(h_seq,'String',mat2str(disp_seq(ss,:)),'HorizontalAlignment','right');
        end
        drawnow
    otherwise
        range = TaskOp.count.seq-2:1:TaskOp.count.seq+2;
        recTrials = range>0 & range<size(TaskOp.count.trialOrder,1)+1;
        disp_seq = zeros(5,2);
        disp_seq(recTrials,:) = TaskOp.count.trialOrder(range(recTrials),:);

        side = 'LT';
        loc = ['A','B','C','D','E'];

        for ss = 1:5
            h_seq = eval(strcat('MENUs.ModigMainMenu.handles.CNTR_EDIT_',side,'_',loc(ss)));
            set(h_seq,'String',mat2str(disp_seq(ss,:)),'HorizontalAlignment','right');
        end
        drawnow
end

