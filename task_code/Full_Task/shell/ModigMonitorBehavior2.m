function [] = ModigMonitorBehavior2(varargin)
% [] = ModigMonitorBehavior(varargin)
%
% A routine to sample behavior: eye movements and key touch.
% This function is activated by a timer function (Timers.input.behavior_monitor)
% at fixed rate (TaskOp.Input.behavior.sampling_rate)
% The timer is started inside 'ModigTaskLoop.m' in the 'StartTrial' subroutine
% The timer is stopped after ITI timer starts. (cf. 'ModigShiftEvent.m')
% Juice delivery blocks the MATLAB thread therefore, though the analog data
% is logged it can't be accesed. It verifies if the eye is on a given
% position or not, the default behavior is 'not in range'. 
%
% Input: cell-string: start, stop, resume, pause
% Output: Eye position on ModigMonitor (no output in variables), 
% Updates the globals: TaskOp --> fix and hold 
%                      BehaveData --> eye (tongue and hand movements)
%
%
% NOTE. Timers.Input.behavior_monitor is the timer using this function
% as a callback and it's set by ModigSetTimer
%
% A future version might include a juice spout sampler. 
%
% it sends a bit up and down when the touchInterrupt condition is met. to
% do this you need to declare the 'touchScreen' bit in your BitTbl.
% 
% See also MODIGMONITOR, MODIGTASKLOOP, MODIGSHIFTEVENT, MODIGSETTIMER
%
%
% coded by skoba (skoba-tky@umin.ac.jp) 9 June 2005
% last modified by skoba 15 Sep 2005
% RBM   3.5.07  commented out calibration parameters for 'mouse' eye
%           emulation on GetEyePosition, changed behavior of MonitorUpdate,
%           comment enrichment, changed function output from varargout to []
%       1.6.07  hand status check, eye requirements changed, included key
%               touch state,
%       8.07    simplified eye evaluation by preallocating variables in the
%       ModigShiftEvent loop, updated updateMonitor for new ModigMonitor
%       and changed eye calibration to GetEyePostion, included filter time
%       to acquire fixation and hand touching the key. 
%       10.07 double setup input, updatemonitor optimization
%       11.07 small change for new wiring in subFx GHS
%       1.08  interrupt and hold abilities introduced, standarized time
%       requirements to GetSecs
%       4.08
%       6.08 touch screen touched bit up and down

% TODO: write GetTongueStatus??
global MENUs Timers breaksession

try 
    switch varargin{1}
        case {'stop',0}
            stop(Timers.Input.behavior_monitor);
            ModigMessage('m','behavior monitor stopped',1);
        case {'start',1}
            if isvalid(Timers.Input.behavior_monitor)
                if strcmpi(get(Timers.Input.behavior_monitor,'Running'),'off')
                    start(Timers.Input.behavior_monitor);
                    ModigMessage('m','behavior monitor started',1);
                end
                Evnt = SampleBehavior;
            end
        case {'pause',2}
            stop(Timers.Input.behavior_monitor);
            ModigMessage('m','behavior monitor ''paused''',1);
        case {'resume',3}
            if isvalid(Timers.Input.behavior_monitor)
                if strcmpi(get(Timers.Input.behavior_monitor,'Running'),'off')            
                    start(Timers.Input.behavior_monitor); 
                    ModigMessage('m','behavior monitor restarted',1);
                end
            end
        case {'sample'}
            Evnt = SampleBehavior;
    end
catch
    breaksession = 1;
    rethrow(lasterror)
    return
end

% call UpdateMonitor if ModigMonitor is on
if strcmp(MENUs.ModigMonitor.status, 'ON') & exist('Evnt','var')
    UpdateMonitor(MENUs.ModigMonitor.handles.MONITOR_AXIS,...
        MENUs.ModigMonitor.handles.key_fb, Evnt);
end

%% check for session breaks
ModigTaskLoop('CheckBreakSession');

%
function Evnt = SampleBehavior
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global IO BehaveData TaskOp Timers Tbl UserInfo %VisParam %MENUs
persistent buzzsound fixHolder touchScreenBit

if isempty(buzzsound) || isempty(fixHolder) || isempty(touchScreenBit)
    buzzsound = repmat(tan(-pi:0.1:pi),1,10);
    buzzsound = max(-1,min(buzzsound,1));
    fixHolder = 0;
    
    if isfield( Tbl.Bit,'touchScreen') && UserInfo.lab_connection,
        touchScreenBit = Tbl.Bit.touchScreen.bit_asignment;
    else
        % the touchscreen bit might be assigend to line 0
        touchScreenBit = 99; 
    end
end
    
Evnt.key = [];
Evnt.eye = [];

% update global BehaveData
currentRow = size(BehaveData.Tbl,1)+1;
BehaveData.Tbl(currentRow,1) = GetSecs;

errorSignal = 0;

%% eye analysis
if IO.Input.eye.monitor,
   
    Evnt.eye = GetEyePosition;

    BehaveData.Tbl(currentRow,BehaveData.Column.eye_x_raw) = Evnt.eye.ox;
    BehaveData.Tbl(currentRow,BehaveData.Column.eye_y_raw) = Evnt.eye.oy;
    BehaveData.Tbl(currentRow,BehaveData.Column.eye_x_cal) = Evnt.eye.x;
    BehaveData.Tbl(currentRow,BehaveData.Column.eye_y_cal) = Evnt.eye.y;

    % evaluate if necessary if eye is on the required position...
    if ~isempty(TaskOp.eye.req)
        limits = TaskOp.eye.limits; % defined in ModigShiftEvent
        elapsedTime = BehaveData.Tbl(currentRow,1) - TaskOp.eye.filter_startTime;
        TaskOp.eye.state = 0;
        switch TaskOp.eye.req
            case 'centralFixation'
                eyeIn = Evnt.eye.x > limits(1) && Evnt.eye.x < limits(2)...
                     && Evnt.eye.y > limits(3) && Evnt.eye.y < limits(4);
                if eyeIn == 1
                    % eye signal within range 
                     TaskOp.eye.state = 1;
                     TaskOp.correct   = 1;
                     fprintf('EyeIn')
                elseif eyeIn == 0 && (TaskOp.eye.filter_time < elapsedTime)
                   errorSignal = 1;
                end
            case 'choiceFixation'
                eyeIn = zeros(2,1);
                for i = 1:size(limits,1)
                    eyeIn(i) = Evnt.eye.x > limits(i,1) && Evnt.eye.x < limits(i,2)...
                            && Evnt.eye.y > limits(i,3) && Evnt.eye.y < limits(i,4);
                end
                if eyeIn(1) == 1
                    % eye signal within choice 1
                     TaskOp.eye.state = 1;
                     TaskOp.correct   = 1;
                     TaskOp.choice    = 1;
                elseif eyeIn(2) == 1
                    % eye signal within choice 2
                     TaskOp.eye.state = 1;
                     TaskOp.correct   = 1;
                     TaskOp.choice    = 2;
                elseif sum(eyeIn) == 0 && (TaskOp.eye.filter_time < elapsedTime)
                     errorSignal = 1;
                end                
        end
    end
else
    Evnt.eye = [];
    BehaveData.Tbl(currentRow,2:5) = 0; 
end

%% verify hand requirements 
if IO.Input.hand.monitor == 1,
    Evnt.hand = GetHandStatus(IO.Input.hand.tracking_method);
    BehaveData.Tbl(currentRow,6) = Evnt.hand;
    if TaskOp.hand.req
        TaskOp.hand.state = 0;
        het = BehaveData.Tbl(currentRow,1) - TaskOp.hand.filter_startTime;
        hft = TaskOp.hand.filter_time;
        if Evnt.hand == 1
             TaskOp.hand.state = 1;
             TaskOp.correct    = 1;
        elseif Evnt.hand == 0 && (hft < het || hft==0)
            errorSignal = 1; 
        end
    end
else
    Evnt.hand = [];
    BehaveData.Tbl(currentRow,6) = 2;
end

% if IO.Input.tongue.monitor,
%     Evnt.tongue = GetTongueStatus;
% else
%     Evnt.tongue = [];
% end

%% interrupt with error or correct
if errorSignal
    TaskOp.hand.state  = 0;
    TaskOp.eye.state   = 0;
    TaskOp.correct     = 0;
    TaskOp.error_event = TaskOp.cur_event_id;
    fixHolder = 0;
    ModigShiftEvent('shift', 2, TaskOp.cur_event_id);
elseif TaskOp.hold==0 && ...
        ((TaskOp.handInterrupt && TaskOp.hand.state) || ...
         (TaskOp.eyeInterrupt && TaskOp.eye.state) || ....
         (TaskOp.eye.state && TaskOp.touchInterrupt && Evnt.hand==0))
     
     TaskOp.interrupt = 1;
    % note, changing the timerfcn of a running timer doesn't modifies it, it is
    % delayed after the timer stops --you can't change it here.
    
    % steal currently running timerFcn 
    toBeExec = Timers.Event.(TaskOp.cur_event_name).TimerFcn;
    
    % generate TS
    x.Type = 'TimerFcn';
    x.Data = BehaveData.Tbl(currentRow,1);
    Timers.Event.(TaskOp.cur_event_name).UserData = [Timers.Event.(TaskOp.cur_event_name).UserData; x];
%     disp(sprintf('executing: %s',TaskOp.cur_event_name))

    % set touchScreen bit up and down --should delay feedback by 5ms--
    if touchScreenBit < 99 && TaskOp.touchInterrupt,
        ModigBitSender(touchScreenBit+1,1);
        ModigBitSender(touchScreenBit+1,0);
    end
    
    % execute it
    if size(toBeExec,2)==2
        eval(toBeExec{2});
    else
        eval(toBeExec);
    end
elseif TaskOp.hold && ((TaskOp.handInterrupt && TaskOp.hand.state) ||...
        (TaskOp.eyeInterrupt && TaskOp.eye.state))
    % create anchor time if we don't have one
    if fixHolder==0,
       fixHolder =  BehaveData.Tbl(currentRow,BehaveData.Column.time);
       
       % change tolerance time to mark errors in case the hand or eye state
       % is lost...
       TaskOp.hand.filter_time = 0;
       TaskOp.eye.filter_time = 0;
    end

    % compare anchor to current time, [seconds]
    elTime = BehaveData.Tbl(currentRow,1)-fixHolder;
    
    % interrupt if holdTime has elapsed,
    if elTime > TaskOp.holdTime,
        fixHolder = 0;
        TaskOp.interrupt = 1;
         % steal currently running timerFcn 
        toBeExec = Timers.Event.(TaskOp.cur_event_name).TimerFcn;
        % generate TS
        x.Type = 'TimerFcn';
        x.Data = BehaveData.Tbl(currentRow,1);
        Timers.Event.(TaskOp.cur_event_name).UserData = [Timers.Event.(TaskOp.cur_event_name).UserData; x];

        % execute it
        if size(toBeExec,2)==2
            eval(toBeExec{2});
        else
            eval(toBeExec);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hand = GetHandStatus(mode)
%
global ExtDevice TaskOp

if strcmp(TaskOp.curSetup,'B')
    handLine = 'KT2';
else
    handLine = 'KT1';
end
    
if strcmp(mode, 'key')
    [ keyIsDown, tS, keyCode ] = KbCheck;
    % LeftShift is key touch!
    if keyCode(160)
        hand = 1;
    else 
        hand = 0;
    end
elseif strcmp(mode,'daq')
    % calling getvalue with the name of the line is 1ms faster than calling
    % its index
%     hand = getvalue(ExtDevice.inputDio.Line(lineNo));
    hand = getvalue(ExtDevice.inputDio.(handLine));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function tongue = GetTongueStatus(mode)
% %
% % not written yet
% disp(mode)
% tongue = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function eye = GetEyePosition
% eye = GetEyePosition
%
% Return original uncalibrated values (eye.ox, eye.oy) and
% calibrated coordinates (eye.x, eye.y)
global IO ExtDevice Timers TaskOp centerEye VisParam UserInfo
persistent ctr eyeLines
% Initalize our persistent/global
if isempty(centerEye) || isempty(ctr) || isempty(eyeLines)
   if strcmp(TaskOp.curSetup,'A')
       eyeLines = [1 2];
    elseif strcmp(TaskOp.curSetup,'B')
        eyeLines = [3 4];
    else
        eyeLines = [1 2];
   end
   ctr = VisParam.scr_rect(3:4)/2; 
   centerEye = 0;
end

switch IO.Input.eye.tracking_method
    case 'mouse'
%         [eye.ox eye.oy] = GetMouse(VisParam.scr_num);
        [eye.ox eye.oy] = GetMouse(VisParam.scr_handle);
        % if we're using double setup in a monitor,
        if VisParam.scr_num==2 && UserInfo.use_split==1,
            if strcmp(TaskOp.curSetup,'A')
                eye.x = eye.ox - VisParam.scr_rect(3);
            else
                eye.x = eye.ox;
            end
        else
            eye.x = eye.ox;
        end
        
        % (o,o) is up left in PTB/OSX, and bottom left in WIN!
        
        eye.y = abs(eye.oy - VisParam.scr_rect(4));             
    otherwise
% TODO, check accuracy of our data sampling, see monkeylogic documentation
        preview  = mean(peekdata(ExtDevice.aiObject, ...
            Timers.Input.behavior_monitor.Period * ExtDevice.aiObject.SampleRate),1) + 6;         
        eye.ox  = preview(eyeLines(1));
        eye.oy  = preview(eyeLines(2));
        
        % save current raw analog sample to be the P.O.R. 
        if centerEye == 1
            TaskOp.Cal.Eye.Offset.x = eye.ox;
            TaskOp.Cal.Eye.Offset.y = eye.oy;
            centerEye = 0;
        end
        
        if isnan(TaskOp.Cal.Eye.Gain.x)
            TaskOp.Cal.Eye.Gain.x = 50;
            TaskOp.Cal.Eye.Gain.y = 50;
        end
        % Calibrated eye coord 
        eye.x = ctr(1)-(eye.ox-TaskOp.Cal.Eye.Offset.x)*TaskOp.Cal.Eye.Gain.x;
        eye.y = ctr(2)-(eye.oy-TaskOp.Cal.Eye.Offset.y)*TaskOp.Cal.Eye.Gain.y;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function UpdateMonitor(h_axis, key, Evnt)
% UpdateMonitor(h_axis, key, Evnt)
%
% Updates eye position and key touch status on experimenter's screen -->
% ModigMonitor.fig/.m

global TaskOp 
persistent handColors strings

if isempty(handColors)
    handColors = [1 1 .5; 1 .5 .5]; % up/down
    strings    = {'UP', 'DOWN'};
end

if ~isempty(Evnt.eye)
    if isempty(TaskOp.eye_handle) || ~ishandle(TaskOp.eye_handle) 
        % we make sure to draw in ModigMonitor by calling its 'Parent'
        TaskOp.eye_handle = plot(Evnt.eye.x, Evnt.eye.y, '+c', ...
            'MarkerFaceColor', [1 0 0],...
            'MarkerSize', 4, ...
            'Parent',h_axis); 
    else
        % faster data re-plotting than delete-then-plot-new
        set(TaskOp.eye_handle, 'xdata', Evnt.eye.x);
        set(TaskOp.eye_handle, 'ydata', Evnt.eye.y);
    end
end

if ~isempty(Evnt.hand)
    set(key, 'BackgroundColor', handColors(Evnt.hand+1,:))
    set(key, 'String', strings(Evnt.hand+1))
end