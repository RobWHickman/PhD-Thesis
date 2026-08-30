function ModigRunTrial(identifier)
% 
% Input: 'identifier', integer that can take values [1, 2]. And serves the
%   same function as first identifier when calling ModigShiftEvent.
%
% TODO: flip with no clear, important in touch tasks
%
%   See also ModigShiftEvent
%
% rbm

global VisParam TaskOp Task breaksession IO Tbl MENUs TC

if nargin==0,
    identifier =1;
end

str = ['ModigJudgeSituation_',TaskOp.prj]; % MJS_prj to be called

refreshRate = Screen('GetFlipInterval', VisParam.scr_handle); 
currentTS = TaskOp.EvntHist.cur_trial_start_time;

%% RUN TRIAL:
TaskOp.trecon           = [];
runTrial                = 1;
param.next_id           = find(strcmpi(Tbl.TaskTbl(:,1),'pre_trial')); % start with Pre_trial

if strcmp(TC.All.Trial,'BCs') || strcmp(TC.All.Trial,'BCb')
    param.next_id = 15;
end


while runTrial && breaksession==0,
% Behavioural conditions:
TaskOp.eyeInterrupt     = 0;
TaskOp.handInterrupt    = 0;
TaskOp.eyeHold          = 0;
TaskOp.handHold         = 0;
TaskOp.eyeHoldTime      = 0;
TaskOp.handHoldTime     = 0;

% Obtain behavioural requirements from MJS:
pagenumber              = param.next_id;
preStr                  = sprintf('%s(%d,%d);',str,identifier,param.next_id);
param                   = eval(preStr);

% Pass parameters to TaskOp:
TaskOp.prev_event_name  = param.prev_event_name;
TaskOp.cur_event_id     = param.next_id;
TaskOp.cur_event_name   = param.next_event_name;
TaskOp.next_page        = param.next_page;

% Re-estimate flip time for current page, and flip screen:
eval(VisParam.page(pagenumber).draw); % was param.next_page as index
waitMore = 0;
flipTheScreen(waitMore, refreshRate);
moveBits(param)

% Time keeping:
r = size(TaskOp.trecon,1);
currentTS = Task.(TaskOp.cur_event_name).flipTimeStamp;
TaskOp.trecon(r+1,1) = currentTS;

% Deliver reward: 
% ~10 ms delay between Bit On/off and start of reward delivery
if isfield(param,'juiceString')
    if ~isempty(param.juiceString),
            eval(param.juiceString)
    end
else
    fprintf('!!! %s doesn''t define param.juiceString\n',str)
end

% Show Experimental monitor: (REMOVE THIS?)
ModigShiftEvent('ShowExpVisualPage',param.next_page);    

% Estimate next flip time:
now = GetSecs;
if param.next_page > 1,
    flipwhen = currentTS + param.next_time - refreshRate;
    finalWait = flipwhen - now -(refreshRate); % #ADJUST OFFSET DEPENDING ON SYSTEM
else
    flipwhen = currentTS + param.next_time;
    finalWait = flipwhen  - now;
end
fprintf('Current Epoch: %s. \tShowed page %d. \tWill wait for %1.3g[s] out of %1.3g[s] planned. \n',...
        param.prev_event_name,pagenumber,finalWait, param.next_time); % Was param.next_page in place of pagenumber

%% Sample behaviour if required:
if IO.Input.behavior.sample==0,
    WaitSecs(finalWait); 
elseif isfield(param,'simulateActor') && param.simulateActor==1,
    simFhandle = eval(['@ModigSimulator_',TaskOp.prj]); 
    simOut = feval(simFhandle, param);
    if simOut.rt>0,
        WaitSecs(simOut.rt);
    else
        WaitSecs(finalWait);
    end        
else
    % Pass hand requirements:
    if isfield(param,'hand')
        TaskOp.hand.req             = param.hand.req;
        TaskOp.hand.filter_time     = param.hand.filter_time;  
        TaskOp.handInterrupt        = param.hand.interrupt;
        TaskOp.handHold             = param.hand.hold;
        TaskOp.handHoldTime         = param.hand.holdTime;                                
        % time anchor for hand requirement,
        if ~isempty(TaskOp.hand.filter_time)
            TaskOp.hand.filter_startTime = now;
        else
            TaskOp.hand.filter_startTime = 0;
        end 
    end
    
    % Pass eye requirements:
    if isfield(param,'eye')
        TaskOp.eye.filter_time       = param.eye.filter_time;
        TaskOp.eye.req               = param.eye.req;
        TaskOp.eye.limits            = param.eye.limits;
        TaskOp.eyeInterrupt          = param.eye.interrupt;
        TaskOp.eyeHold               = param.eye.hold;
        TaskOp.eyeHoldTime           = param.eye.holdTime;
    % Time anchor for eye filter time as required
        if ~isempty(TaskOp.eye.filter_time)
            TaskOp.eye.filter_startTime = now;
        else
            TaskOp.eye.filter_startTime = [];
        end
    end
    
    % Pass touch requirements:
    if isfield(param,'touch')
        TaskOp.touch.filter_time    = param.touch.filter_time;
        TaskOp.touch.req            = param.touch.req;
        TaskOp.touch.limits         = param.touch.limits;
        TaskOp.touchInterrupt       = param.touch.interrupt;
    % Time anchor for touch filter time as required
        if ~isempty(TaskOp.touch.req)
            TaskOp.touch.filter_startTime = now;
        else
            TaskOp.touch.filter_startTime = [];
        end
    end

% Start behaviour sampling:
    switch param.dynamic
        case 0
            [newFlip, errorInterrupt] = myTimerMonitorBehavior(IO.Input.behavior.sampling_rate, finalWait);
        case 1
            [newFlip, errorInterrupt] = DynamicMonitorBehavior_BDM(IO.Input.behavior.sampling_rate, finalWait);
        case 2
            [newFlip, errorInterrupt] = DynamicMonitorBehavior_BCs(IO.Input.behavior.sampling_rate, finalWait);
        case 3
            [newFlip, errorInterrupt] = DynamicMonitorBehavior_BCb(IO.Input.behavior.sampling_rate, finalWait);
        case 4
            [newFlip, errorInterrupt] = DynamicMonitorBehavior_BDMTP(IO.Input.behavior.sampling_rate, finalWait);
        case 5
            [newFlip, errorInterrupt] = DynamicMonitorBehavior_BDMTPBar(IO.Input.behavior.sampling_rate, finalWait);
        case 6
            [newFlip, errorInterrupt] = DynamicMonitorBehavior_BDM_D(IO.Input.behavior.sampling_rate, finalWait);
        case 7
            [newFlip, errorInterrupt] = DynamicMonitorBehavior_BDM_Touch(IO.Input.behavior.sampling_rate, finalWait);
    end
    
    if errorInterrupt==1,
        preStr = sprintf('%s(%d,%d);',str,2,param.prev_id);
        param = eval(preStr);                      % Evaluate the error in MJS

        eval(VisParam.page(param.next_page).draw); % Draw the next page.            
        flipTheScreen(GetSecs+refreshRate, refreshRate);    
        moveBits(param)
%         if isfield(param,'errSnd') && param.errSnd,
%             errorSound;
%         end
    elseif newFlip>0
        fprintf('Interrupting now. Skipping %1.3g[s] \n',flipwhen-newFlip)
    end
end          
%% If starting pre_trial (next trial), stop trial loop. 
if strcmpi(param.next_event_name,'pre_trial') || strcmpi(param.next_event_name,'pre_trial_BC'),
    runTrial = 0;
    [TH_bt, ITI_start_time, EMPTY_it] = isfield_sk(TaskOp,'EvntHist.ITI_start_time'); %True ITI time-stamp.
    
    if ~EMPTY_it
        TaskOp.EvntHist.prev_ITI_start_time = ITI_start_time;
    else
        TaskOp.EvntHist.prev_ITI_start_time = GetSecs;
    end
    
    TaskOp.EvntHist.ITI_start_time = GetSecs;

% ModigTaskLoop is waiting for this color change in subroutine 'PostTrial'  and enable 'remedy'
    set(MENUs.ModigMainMenu.handles.CNTR_PUSH_REMEDY,'BackgroundColor',[0.12 0.7 0.4]);
    drawnow;       
    fprintf('\n')
end

end % END OF WHILE LOOP.
Priority(0);     
ShowCursor;
% delete object handles if the trial was correct
if TaskOp.correct,
    curMon = Tbl.MenuTbl{1}; 
    delete(get(MENUs.(curMon).handles.MONITOR_AXIS,'children'))
end


%% Move bits UP and DOWN sub-function
function moveBits(param)
global UserInfo

if (~isempty(param.on_bit) || ~isempty(param.off_bit))        
   if UserInfo.lab_connection 
        ModigBitSender([param.on_bit; param.off_bit]'+1,...
            [ones(1,length(param.on_bit)) zeros(1,length(param.off_bit))]);
   else
       fprintf('ON:  %s\nOFF: %s\n',mat2str(param.on_bit),mat2str(param.off_bit))
   end
end
    
%% Flip sub-function
function flipTheScreen(flipwhen, refreshRate)
% flipTheScreen(flipwhen, refreshRate)

global Task VisParam TaskOp
persistent tries 

if isempty(tries),
    tries = 0;
end

try
    if TaskOp.next_page > 0,
        flipwhen(flipwhen<0) = GetSecs+refreshRate;
        Task.(TaskOp.cur_event_name).flipTimeStamp = eval(VisParam.page(TaskOp.next_page).flip);    
    else
        Task.(TaskOp.cur_event_name).flipTimeStamp = GetSecs;
    end
catch    
    tries = tries+1;    
    if tries >10,
        keyboard
        error('Give up showing the visual page!')
    end
    flipTheScreen(flipwhen+refreshRate, refreshRate)
end

if tries >0,
    fprintf('Tried %d time(s) to show visual page\n',tries);
end
tries = 0;



