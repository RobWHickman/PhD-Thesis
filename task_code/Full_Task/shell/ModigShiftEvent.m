function varargout = ModigShiftEvent(varargin)
% Shift task event
% 1st argument: "fixed" to 'shift'
% 2nd argument: identifier that the call to MoJuSit_(prj) is a timer(1) or
%               from MOMOBE(2)
% 3rd argument: number id of the CURRENT event
% ex. ModigShiftEvent('shift',1,5);
%
%   This function does the following:
% 0. Judge what the next event should be. ("ModigJudgeSituation_(prj).m")
% 1. stop timer of the previous event (it shoud have been stopped, just for sure)
% 2. present a visual page of the next event, (1,2: "Shiftevent" subroutine)
% 3. send digital output corresponding to the visual event.
% 4. send digital output (e.g. solenoid) if appropriate,
% 5. start timer of the next event (ex. start timer for solenoid if next event is rewarding time)
% 6. store time stamp of the event shift ("ModigEventShiftLog(param)")
% 7. show stimuli on the experimenter's screen. ("ShowExpVisualPage(param.next_page)")
%
%
% SK Wrote it
% RBM 08.07  comment expansion, tolerance window draw, multiple drawing in 
%       ShowExpModMon, getty comm commented out, 
% rbm 12.07 introduced an if structure for breaksession. sometimes a timer
%           called the subsequent trial and creates havoc. no more havoc!
% rbm 1.08 de-nested sub function calls
% CRvC 7.13 additions for ModigLog

global TaskOp breaksession 
% global BehaveData %ExtDevice UserInfo
persistent buzzsound
if isempty(buzzsound)
    buzzsound = repmat(tan(-pi:0.1:pi),1,10);
    buzzsound = max(-1,min(buzzsound,1));
end

% op = Priority;
% disp(sprintf('dbg msg--> priority: %d @ call %d \n', op, varargin{3}))

if strcmpi(varargin{1},'shift'),
    str = ['ModigJudgeSituation_',TaskOp.prj,...
        '(',num2str(varargin{2}),',',num2str(varargin{3}),');'];
    try
        param = eval(str);
%         fprintf('Evaluated MJS_prj \n')
    catch
        fprintf('Error while evaluating: %s \n',str)
        breaksession = 1;        
    end

    if param.ok
        if breaksession ~= 1
            ShiftEvent(param);

            notEmpty = isfield_sk(param,'expPageMod');
            if ~notEmpty, param.expPageMod=0; end

            ShowVisualPage(param.next_page, param.on_bit, param.off_bit);
            ShowExpVisualPage(param.next_page+param.expPageMod-1);
           
            fprintf('*** %s *** \t Page %d \t Exp. page %d\n',param.next_event_name,...
                param.next_page,param.next_page+param.expPageMod-1)
            start(param.next_timer)
        else
            fprintf('broken session ModigShiftEvent  @: %s.', param.next_timer.name)
            ModigCommand('stop_session');
        end
    else
        fprintf('\n eval(Mojusit_%s) with: %d and %d unsuccesful',...
            TaskOp.prj,varargin{2},varargin{3})
        breaksession = 1;
    end
else
    if ischar(varargin{1}), % INVOKE NAMED SUBFUNCTION OR CALLBACK
        try
            [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
        catch
            disp(lasterr);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb = ShiftEvent(param)
% shift event phase
global Tbl Timers breaksession TaskOp MENUs VisParam 

% if previous timer is running, stop it
if strcmp(param.prev_timer.running,'on')
    stop(param.prev_timer); 
%     fprintf('Stopped previous timer %s \n',param.prev_timer.Name)
end

% if we have a next timer
if ~isempty(param.next_timer)
    if strcmp(param.next_timer.running,'off')
        
        % pass parameters to global TaskOp
        TaskOp.prev_event_name           = param.prev_event_name;
        TaskOp.cur_event_id              = param.next_id;
        TaskOp.cur_event_name            = param.next_event_name;

        if isfield(param,'hand')
            TaskOp.hand.req             = param.hand.req;
            TaskOp.hand.filter_time     = param.hand.filter_time;  
            
            % time anchor for hand requirement,
            if TaskOp.hand.req
                TaskOp.hand.filter_startTime = GetSecs;
            else
                TaskOp.hand.filter_startTime = 0;
            end 
        end
        
        if isfield(param,'eye')
            TaskOp.eye.filter_time           = param.eye.filter_time;
            TaskOp.eye.req                   = param.eye.req;
            TaskOp.eye.limits                = param.eye.limits;
            
            % time anchor for eye filter time as required
            if ~isempty(TaskOp.eye.filter_time)
                TaskOp.eye.filter_startTime = GetSecs;
%                 disp(TaskOp.eye.filter_time)
            else
                TaskOp.eye.filter_startTime = [];
            end
        end
        
        if isfield(param,'touch')
            TaskOp.touch.filter_time           = param.touch.filter_time;
            TaskOp.touch.req                   = param.touch.req;
            TaskOp.touch.limits                = param.touch.limits;
            
             % time anchor for touch filter time as required
            if ~isempty(TaskOp.touch.req)
                TaskOp.touch.filter_startTime = GetSecs;
            else
                TaskOp.touch.filter_startTime = [];
            end
        end
        cb = 1;
    else
        warning('MODIG:TimerIssue','timer ''%s'' running ahead of time',...
            param.next_timer.name)
        stop(param.next_timer);
        ShiftEvent(param);
    end
else 
    warning('MODIG:TimerIssue','empty timer @: %s', ...
        param.next_timer.name);
    ModigCommand('stop_session')
    cb = 0;
end

% on starting ITI,  
if strcmpi(param.next_event_name,'ITI')
    
    % time stamp when the ITI really starts
    [TH_bt ITI_start_time EMPTY_it] = isfield_sk(TaskOp,'EvntHist.ITI_start_time');
    if ~EMPTY_it
        TaskOp.EvntHist.prev_ITI_start_time = ITI_start_time;
    else
        TaskOp.EvntHist.prev_ITI_start_time = GetSecs;
    end
    TaskOp.EvntHist.ITI_start_time = GetSecs;
        
    % stop sampling behavior
    [TH_bt btimer EMPTY_bt] = isfield_sk(Timers,'Input.behavior_monitor');
    if ~EMPTY_bt
        stop(btimer);
    end
    
    % hide MoMo children
    curMon = Tbl.MenuTbl{1}; % find which current monitor is being used.
    curActHdl = 'MONITOR_AXIS';
    [TH exp_page EMPTY] = isfield_sk(VisParam,'exp_page');
    mmh = MENUs.(curMon).handles;
    if ishandle(mmh.(curActHdl))
        % hide all children,
        for i = 1:size(exp_page,2),
            if any(ishandle(exp_page(i).obj_handle)),
                set(exp_page(i).obj_handle,'visible','off');
            else
                warning('MODIG:invalidHandles', ...
                    'VisParam.exp_page(%2.0f) is not a handle, deleting...',i)
                VisParam.exp_page(i) = []; % sort of dangerous!
                breaksession = 1;
            end
        end
   end
      
    % ModigTaskLoop is waiting for this color change in subroutine
    % 'PostTrial'  and enable 'remedy'
    set(MENUs.ModigMainMenu.handles.CNTR_PUSH_REMEDY,'BackgroundColor',[0.12 0.7 0.4]);
    drawnow;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ShowVisualPage(page, on, off)
% show page for current event
% effectively the time point of event shifting

global VisParam Task TaskOp UserInfo breaksession ModigLog
persistent tries
if isempty(tries)
    tries = 0;
end

if page~=0 
    if page <= size(VisParam.page,2) 
        eval(VisParam.page(page).draw);  
        % try-catch since sometimes there's no output from Screen -I'm
        % guessing no flip
        try
            Task.(TaskOp.cur_event_name).flipTimeStamp = eval(VisParam.page(page).flip);
        catch
            if ~isfield(TaskOp,'cur_event_name') || isempty(TaskOp.cur_event_name)
                TaskOp.cur_event_name = 'pre_trial';
            end
            tries = tries+1;
            fprintf('Tried %d times to show visual page\n',tries);                       
            if tries > 100,
                breaksession = 1;
                return
            end
            ShowVisualPage(page,on,off);
        end
        tries = 0;
        
       % change bits...
       if (~isempty(on) || ~isempty(off))        
           if UserInfo.lab_connection 
                % new execution times are ~1ms
                ModigBitSender([on; off]'+1,[ones(1,length(on)) zeros(1,length(off))]);
           end
           if TaskOp.log.on             
                   % get time stamp
                   ts = GetSecs;
                   % Check if relevant fields are already there 
                   if ~isfield(ModigLog,'Event');
                       ModigLog=setfield(ModigLog,'Event',[]);
                       ModigLog=setfield(ModigLog,'CurBVals',zeros(1,14)); %Keep track of bitvalues to avoid unnecessary recording of bittimes whenbit is already in that state
                       ModigLog=setfield(ModigLog,'FlagFirst',ones(1,14)); %Flag first on/offset to determine initial state of bit
                       ModigLog.Event=setfield(ModigLog.Event,{14},'onset',[]);
                       ModigLog.Event=setfield(ModigLog.Event,{14},'offset',[]);
%                        ModigLog.Event=setfield(ModigLog.Event,{14},'init',[]);
                   end
                   % Write timestamp to relevant bits in ModigLog global for
                   % per trial saving in ModigTaskLoop LogData %TO DO: Not
                   % working well yet
                   for bn=1:length(on);
                       Addts=[ModigLog.Event(on(bn)+1).onset ts];
                       ModigLog.Event(on(bn)+1).onset=Addts;
                       ModigLog.CurBVals(1,on(bn)+1)=1;
                       if ModigLog.FlagFirst(1,on(bn)+1)==1;
%                            ModigLog.Event(on(bn)+1).init=0;
                           ModigLog.FlagFirst(1,on(bn)+1)=0;
                       end
                   end
                   for bn=1:length(off);
                       if ModigLog.CurBVals(1,off(bn)+1)==1 || ModigLog.FlagFirst(1,off(bn)+1)==1;
                       Addts=[ModigLog.Event(off(bn)+1).offset ts];
                       ModigLog.Event(off(bn)+1).offset=Addts;
                       ModigLog.CurBVals(1,off(bn)+1)=0;
                       end
                       if ModigLog.FlagFirst(1,off(bn)+1)==1;
%                           ModigLog.Event(off(bn)+1).init=1;
                          ModigLog.FlagFirst(1,off(bn)+1)=0; 
                       end
                   end
           end
       end
    else
        error('ModigShiftEvent:called page isn''t defined in VisParam')
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ShowExpVisualPage(page)
% show page for current event
global VisParam breaksession

[TH exp_page EMPTY] = isfield_sk(VisParam,'exp_page');
if ~EMPTY
    for i = 1:size(exp_page,2)
        % if we have as many handles as items in the variable
        if sum(ishandle(exp_page(i).obj_handle))==length(exp_page(i).obj_handle)
            if page == i
                set(exp_page(i).obj_handle,'visible','on');
                VisParam.exp_page(i).visible = 1; % redundant variable?
            elseif page ~= i
                % hide all not-called-upon children, including page 0 
                set(exp_page(i).obj_handle,'visible','off');
                VisParam.exp_page(i).visible = 0;
            end
%         else
%             warning('MODIG:invalidHandles', ...
%                 'VisParam.exp_page(%2.0f) is not a handle',i)
%             breaksession = 1; 
        end
    end    
    drawnow
end