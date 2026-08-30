function [] = ModigDoubleMonitorBehavior(varargin)
% A routine to sample behavior: eye movements and key touch.
% This function is activated by a timer function (Timers.input.behavior_monitor)
% at fixed rate (TaskOp.Input.behavior.sampling_rate)
% The timer is started inside 'ModigTaskLoop.m' in the 'StartTrial' subroutine
% The timer is stopped after ITI timer starts. (cf. 'ModigShiftEvent.m')
% Juice delivery blocks the MATLAB thread therefore, though the analog data
% is logged it can't be accesed. It verifies if the eye is on a given
% position or not, the default behavior is 'not in range'. 
%
% % [] = ModigDoubleMonitorBehavior(varargin)
% 
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
% See also MODIGMONITORBEHAVIOR, MODIGMONITORTABLE, MODIGTASKLOOP, 
%
% RBM 10.07 
%      1.09
%     07.09  introduction of TaskOp.lostHold, used for error counting in
%               fixation tasks
%       7.13 angled camera correction (CvC)
%
global MENUs Timers breaksession IO 
% UserInfo
persistent mouseEyeTouch

% mouseEyeTouch is true if you want to use the mouse position as proxy for
% the eye position AND you want to use the touch screen.

if isempty(mouseEyeTouch)
    mouseEyeTouch = IO.Input.eye.monitor && ...
            strcmp(IO.Input.eye.tracking_method,'mouse') && ...
                IO.Input.use_touch_screen;
end


try 
    switch varargin{1}
        case {'stop',0}
            stop(Timers.Input.behavior_monitor);
        case {'start',1}
            if isvalid(Timers.Input.behavior_monitor)
                if strcmpi(get(Timers.Input.behavior_monitor,'Running'),'off')
                    start(Timers.Input.behavior_monitor);
                end
                Evnt = SampleBehavior(mouseEyeTouch);
            end
        case {'pause',2}
            stop(Timers.Input.behavior_monitor);
        case {'resume',3}
            if isvalid(Timers.Input.behavior_monitor)
                if strcmpi(get(Timers.Input.behavior_monitor,'Running'),'off')            
                    start(Timers.Input.behavior_monitor); 
                end
            end
        case {'sample'}
            Evnt = SampleBehavior(mouseEyeTouch);
    end
catch
    fprintf(' MODIG....\n Error while monitoring behaviour...\n ')
    e = lasterror;
    disp(e.stack(1))
    breaksession = 1;

    rethrow(lasterror)   
end

% call UpdateMonitor if ModigMonitor is on
if strcmp(MENUs.ModigMonitorTable.status, 'ON') && exist('Evnt','var')
    UpdateMonitor(MENUs.ModigMonitorTable.handles.MONITOR_AXIS,...
        MENUs.ModigMonitorTable.handles.key_fb_A, ...
        MENUs.ModigMonitorTable.handles.key_fb_B, Evnt, mouseEyeTouch);
end

% check for session breaks
ModigTaskLoop('CheckBreakSession');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Evnt = SampleBehavior(met)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global IO BehaveData TaskOp Tbl UserInfo %Timers %VisParam %MENUs
persistent buzzsound fixHolder holdHolder touchScreenBit curSetup

curSetup = 1+strcmp(TaskOp.curSetup,'B');
if isempty(buzzsound) || isempty(fixHolder) || isempty(touchScreenBit) || isempty(holdHolder)
    buzzsound = repmat(tan(-pi:0.1:pi),1,10);
    buzzsound = max(-1,min(buzzsound,1));
    fixHolder = 0;
    holdHolder = 0;
    
    if isfield( Tbl.Bit,'touchScreen') && UserInfo.lab_connection,
        touchScreenBit = Tbl.Bit.touchScreen.bit_asignment;
    else
        % the touchscreen bit might be assigend to line 0
        touchScreenBit = 99; 
    end
end
    
Evnt.key = [];
Evnt.eye = [];
Evnt.touch = [];

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

        % fprintf('Elapsed time %0.3g\n',elapsedTime)
        %         BehaveData.Tbl(currentRow,8)=elapsedTime; % DEBUG tool
        
        TaskOp.eye.state = 0;        

        switch TaskOp.eye.req
            case 'centralFixation'               
                eyeIn = Evnt.eye.x > limits(1) && Evnt.eye.x < limits(2)...
                     && Evnt.eye.y > limits(3) && Evnt.eye.y < limits(4);
                if eyeIn == 1
                    % eye signal within range 
                     TaskOp.eye.state = 1;
                     TaskOp.correct   = 1;
%                      fprintf('IN \n')
              
                elseif eyeIn == 0 && (TaskOp.eye.filter_time < elapsedTime)
                   errorSignal = 1;
                   TaskOp.error_type = 1;
%                     fprintf('ERROR \n')
%               elseif eyeIn==0
%                fprintf('OUT \n')
                end
            case 'centralFixationCircle'               
                eyeDis = sqrt((Evnt.eye.x-limits(1))^2 + (Evnt.eye.y-limits(2))^2);
                eyeIn = eyeDis < limits(3);
                if eyeIn==1,
                    % eye signal within range 
                     TaskOp.eye.state = 1;
                     TaskOp.correct   = 1;
%                      fprintf('IN \n')
                elseif eyeIn==0 && (TaskOp.eye.filter_time < elapsedTime)
                   errorSignal = 1;
                   TaskOp.error_type = 1;
%                     fprintf('ERROR \n')
%                 else
%                     fprintf('OUT \n')
                end
            case 'choiceFixation'
%                  fprintf('eye filter time %0.3g\n',TaskOp.eye.filter_time)
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
%                     fprintf('eye filter time %0.3g eye state %d \n',TaskOp.eye.filter_time,TaskOp.eye.state)
                     errorSignal = 1;
                     TaskOp.error_type = 1;
                end                
            case 'choiceFixationCircle'
                eyeIn = zeros(2,1);
                for i = 1:2,
                    eyeDis = sqrt((Evnt.eye.x-limits(i,1))^2 + (Evnt.eye.y-limits(i,2))^2);
                    eyeIn(i) = eyeDis < limits(i,3);
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
                     TaskOp.error_type = 1;
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
    BehaveData.Tbl(currentRow,6:7) = Evnt.hand;
    if TaskOp.hand.req
        TaskOp.hand.state = 0;
        het = BehaveData.Tbl(currentRow,1) - TaskOp.hand.filter_startTime;
        hft = TaskOp.hand.filter_time;

        if Evnt.hand(curSetup) == 1 
             TaskOp.hand.state = 1;
             TaskOp.correct    = 1;
        elseif Evnt.hand(curSetup) == 0 && (hft < het)            
            errorSignal = 1; 
            TaskOp.error_type = 2;
        end
    end
else
    Evnt.hand = [];
    BehaveData.Tbl(currentRow,6:7) = 2;
end

%% verify touch screen requirements
if IO.Input.use_touch_screen,

    if met,
        Evnt.touch = Evnt.eye;
    else
        Evnt.touch = GetMousePosition;
    end
      TaskOp.touch.state = 0;

      % if necessary evaluate if touch is on the required position...
    if isfield(TaskOp.touch,'req') && ~isempty(TaskOp.touch.req)
        limits = TaskOp.touch.limits; % defined in ModigShiftEvent
       
        elapsedTime = BehaveData.Tbl(currentRow,1) - TaskOp.touch.filter_startTime;
        switch TaskOp.touch.req
            case 'oneTouchArea'
                touchIn = Evnt.touch.x > limits(1) && Evnt.touch.x < limits(2)...
                     && Evnt.touch.y > limits(3) && Evnt.touch.y < limits(4);
                if touchIn == 1
                    % touch signal within range 
                     TaskOp.touch.state = 1;
                     TaskOp.correct   = 1;
                elseif touchIn == 0 && (TaskOp.touch.filter_time < elapsedTime)
                   errorSignal = 1;
                   TaskOp.error_type = 3;
                end
            case 'twoTouchAreas'
                touchIn = zeros(2,1);
                % TODO, faster logic!
                for i = 1:size(limits,1)
                    touchIn(i) = Evnt.touch.x > limits(i,1) && Evnt.touch.x < limits(i,2)...
                            && Evnt.touch.y > limits(i,3) && Evnt.touch.y < limits(i,4);
                end
                if touchIn(1) == 1
                    % touch signal within choice 1
                     TaskOp.touch.state = 1;
                     TaskOp.correct   = 1;
                     TaskOp.choice    = 1;
                elseif touchIn(2) == 1
                    % touch signal within choice 2
                     TaskOp.touch.state = 1;
                     TaskOp.correct   = 1;
                     TaskOp.choice    = 2;
                elseif sum(touchIn) == 0 && (TaskOp.touch.filter_time < elapsedTime)
                     errorSignal = 1;
                     TaskOp.error_type = 3;
                end                
        end
    end
else
    Evnt.touch = [];
%     BehaveData.Tbl(currentRow,2:5) = 0; 
end
%% interrupt with error or correct
if errorSignal
    TaskOp.hand.state  = 0;
    TaskOp.eye.state   = 0;
    TaskOp.touch.state = 0;
    TaskOp.correct     = 0;
    TaskOp.error_event = TaskOp.cur_event_id;
    TaskOp.lostHold = fixHolder > 0;
    fixHolder = 0;
    % Call error event
    ModigShiftEvent('shift', 2, TaskOp.cur_event_id);
elseif TaskOp.eyeHold==0 && TaskOp.eyeInterrupt   && TaskOp.eye.state
     TaskOp.interrupt = 1;
    stealTimer(touchScreenBit);

elseif TaskOp.handHold==0 && TaskOp.handInterrupt  && TaskOp.hand.state
     TaskOp.interrupt = 1;
    stealTimer(touchScreenBit);

elseif TaskOp.touchInterrupt && TaskOp.touch.state && Evnt.hand(curSetup) == 0
     TaskOp.interrupt = 1;
     % save touch Interrupt coordinates.
    BehaveData.tchInt = [Evnt.touch.x Evnt.touch.y];
    % note, changing the timerfcn of a running timer doesn't modifies it, it is
    % delayed after the timer stops --you can't change it here.    
    stealTimer(touchScreenBit);
    
elseif TaskOp.eyeHold && TaskOp.eyeInterrupt  && TaskOp.eye.state
    % create anchor time if we don't have one
    if fixHolder==0,
       fixHolder =  BehaveData.Tbl(currentRow,1);
       
%         fprintf('fixHolder at: %g',fixHolder)% Debug

       % change tolerance time to mark errors in case the hand or eye state
       % is lost...
       TaskOp.eye.filter_time = 0;
    end

    % compare anchor to current time, [seconds]
    elTime = BehaveData.Tbl(currentRow,1)-fixHolder;
    
    % interrupt if holdTime has elapsed,
    if elTime > TaskOp.eyeHoldTime,
        % fprintf('Executed  timer %s @ %g s after hold started\n',TaskOp.cur_event_name,elTime)
        fixHolder = 0;
        TaskOp.interrupt = 1;
        stealTimer(touchScreenBit);        
    end
elseif TaskOp.handHold && TaskOp.handInterrupt && TaskOp.hand.state
    % create anchor time if we don't have one
    if holdHolder==0,
       holdHolder =  BehaveData.Tbl(currentRow,1);
       
%         fprintf('holdHolder at: %g',holdHolder)
       % change tolerance time to mark errors in case the hand or eye state
       % is lost...
       TaskOp.hand.filter_time = 0;       
    end

    % compare anchor to current time, [seconds]
    elTime = BehaveData.Tbl(currentRow,1)-fixHolder;
    
    % interrupt if holdTime has elapsed,
    if elTime > TaskOp.handHoldTime,
        % fprintf('Executed  timer %s @ %g s after hold started\n',TaskOp.cur_event_name,elTime)
        holdHolder = 0;
        TaskOp.interrupt = 1;
        stealTimer(touchScreenBit);        
    end
end

%% GetHandStatus
function hand = GetHandStatus(mode)
%
global ExtDevice %TaskOp
persistent handlines

if isempty(handlines) && ~isempty(ExtDevice)
    handlines(1) = ExtDevice.inputDio.KT1.Index;
    handlines(2) = ExtDevice.inputDio.KT2.Index;
end

if strcmp(mode, 'key')
    [ keyIsDown, tS, keyCode ] = KbCheck;
    % LeftShift is key touch!
    if keyCode(160)
        hand = [1 1];
    else 
        hand = [0 0];
    end
elseif strcmp(mode,'daq')
    % calling getvalue with the name of the line is 1ms faster than calling
    % its index
%     hand = getvalue(ExtDevice.inputDio.Line(lineNo));
%     hand = getvalue(ExtDevice.inputDio.(handLine));
    prehand = getvalue(ExtDevice.inputDio);
    hand = prehand(handlines);
end

%% GetMousePosition
function mouse = GetMousePosition
%
global VisParam 
% global UserInfo TaskOp
% [mouse.ox mouse.oy] = GetMouse(VisParam.scr_num);
% [mouse.ox mouse.oy] = GetMouse(VisParam.scr_handle);
[mouse.ox mouse.oy] = GetMouse(1);

mouse.x = mouse.ox;

% (o,o) is up left in PTB/OSX, and bottom left in WIN!
% mouse.y = abs(mouse.oy - VisParam.scr_rect(4)); % is equivalent to:
mouse.y = abs(VisParam.scr_rect(4) - mouse.oy );

%% GetEyePosition
function eye = GetEyePosition
% eye = GetEyePosition
%
% Return original uncalibrated values (eye.ox, eye.oy) and
% calibrated coordinates (eye.x, eye.y)
global IO ExtDevice Timers TaskOp centerEye %VisParam %UserInfo
persistent ctr eyeLines adjAngRad

% Initalize our persistent/global
if isempty(centerEye) || isempty(ctr) || isempty(eyeLines)
   eyeLines = [1 2; 3 4]; % [AI0 and AI1: setup A ; AI2 and AI3: setup B]
   
%    ctr = VisParam.scr_rect(3:4)/2; 
   ctr = [1024 768]/2; % monkey on the lateral edge
   centerEye = 0;
   
   TaskOp.Cal.Eye.Gain.x(1:2) = 600;
   TaskOp.Cal.Eye.Gain.y(1:2) = 600;
end

switch IO.Input.eye.tracking_method
    case 'mouse'
        eye = GetMousePosition;
    otherwise
        % TODO, check accuracy of our data sampling, see monkeylogic documentation
        preview  = mean(peekdata(ExtDevice.aiObject, ...
            Timers.Input.behavior_monitor.Period * ExtDevice.aiObject.SampleRate),1) + 6;         
        eye.ox  = preview(eyeLines(curSetupRow,1));
        eye.oy  = preview(eyeLines(curSetupRow,2));
        
        if isnan(TaskOp.Cal.Eye.Gain.x)
            TaskOp.Cal.Eye.Gain.x = 50;
            TaskOp.Cal.Eye.Gain.y = 50;
        elseif numel(TaskOp.Cal.Eye.Gain.x)==1,
            TaskOp.Cal.Eye.Gain.x(2) = TaskOp.Cal.Eye.Gain.x(1);
            TaskOp.Cal.Eye.Gain.y(2) = TaskOp.Cal.Eye.Gain.y(1);            
        end
        
        % save current raw analog sample to be the P.O.R. 
        if centerEye == 1
            TaskOp.Cal.Eye.Offset.x = eye.ox;
            TaskOp.Cal.Eye.Offset.y = eye.oy;  
%             centerEye = 0;
        end
        
        
%         %%%%% THIS ONE IS THE WORKING VERSION (Camera in normal position)
%         eye.y = ctr(2) + (eye.ox - TaskOp.Cal.Eye.Offset.x) * TaskOp.Cal.Eye.Gain.x(1);
%         eye.x = ctr(1) + (eye.oy - TaskOp.Cal.Eye.Offset.y) * TaskOp.Cal.Eye.Gain.y(1);
%         %%%%%%%

        %%%%%% Upsidedown camera
        eye.y = ctr(2) + (eye.ox - TaskOp.Cal.Eye.Offset.x) * TaskOp.Cal.Eye.Gain.x(1);
        eye.x = ctr(1) - (eye.oy - TaskOp.Cal.Eye.Offset.y) * TaskOp.Cal.Eye.Gain.y(1);
        %%%%%%%
        
        %%%%%%% Compensate angled camera
        if centerEye==0,
            d = sqrt(eye.y .^2 + eye.x .^2);
            angRad = atan(eye.y ./ eye.x);

            eye.x=cos(angRad-adjAngRad).*d;
            eye.y=sin(angRad-adjAngRad).*d;

            % Mirror in origin for negative X values
            negX = eye.x<0;
            eye.x(negX) = eye.x(negX)*-1;
            eye.y(negX) = eye.y(negX)*-1;
        else
            centerEye = 0;
        end
        %%%%%%%%%%%%%%
        
        % Calibrated eye coord 
        % monitor fliped 90 deg!
%         eye.y = ctr(2) + (eye.ox - TaskOp.Cal.Eye.Offset.x) * TaskOp.Cal.Eye.Gain.x;
%         eye.x = ctr(1) - (eye.oy - TaskOp.Cal.Eye.Offset.y) * TaskOp.Cal.Eye.Gain.y;
        % inverted camera, mnk looks right, signal moves negative:
%         eye.x = ctr(1)+(eye.ox+TaskOp.Cal.Eye.Offset.x)*TaskOp.Cal.Eye.Gain.x;
%         eye.y = ctr(2)-(eye.oy-TaskOp.Cal.Eye.Offset.y)*TaskOp.Cal.Eye.Gain.y;

        % inverted camera, mnk looks up, signal moves negative:
%         eye.y =
%         ctr(2)+(eye.oy+TaskOp.Cal.Eye.Offset.y)*TaskOp.Cal.Eye.Gain.y;

        % Calibrate with two gains, one when the eye position is negative
        % to the center and another when it is positive. [-gain +gain]
%         xOffset=eye.ox - TaskOp.Cal.Eye.Offset.x;
%         eye.y = ctr(2) + xOffset * TaskOp.Cal.Eye.Gain.x((xOffset>0)+1);
%         yOffset=eye.oy - TaskOp.Cal.Eye.Offset.y;
%         eye.x = ctr(1) + yOffset * TaskOp.Cal.Eye.Gain.y((yOffset>0)+1);
end

%% fx UpdateMonitor
function UpdateMonitor(h_axis, keyA, keyB, Evnt, met)
% UpdateMonitor(h_axis, keyA, keyB, Evnt, met)
%
% Updates eye position and key touch status on experimenter's screen -->
% ModigMonitorTable.fig/.m

global TaskOp BehaveData
persistent handColors %strings

if isempty(handColors)
    handColors = [1 1 .5; 1 .5 .5]; % up/down
end

if ~isempty(Evnt.eye)
    if isempty(TaskOp.eye_handle) || ~ishandle(TaskOp.eye_handle) 
        % we make sure to draw in ModigMonitor by calling its 'Parent'
        TaskOp.eye_handle = plot(Evnt.eye.x, Evnt.eye.y, 'or', ...
            'MarkerFaceColor', [1 0 0],...
            'MarkerSize', 10, ...
            'Parent',h_axis); 
    else
        % faster data re-plotting than delete-then-plot-new
        set(TaskOp.eye_handle, 'xdata', Evnt.eye.x);
        set(TaskOp.eye_handle, 'ydata', Evnt.eye.y);
    end
    
    if get(h_axis,'UserData')==1
        % Scatter plot of previous eye positions
        scatter(h_axis,Evnt.eye.x, Evnt.eye.y, 4, [1 0 0],...
                'Tag', 'eyeHistory');
    end
end

% Now we plot the position where the touch happenend
if ~isempty(Evnt.touch) && met==0,
    if isempty(TaskOp.touchHandle) || ~ishandle(TaskOp.touchHandle) 
        if isempty(BehaveData.tchInt), 
            BehaveData.tchInt=zeros(1,2);
        end
        TaskOp.touchHandle = plot(BehaveData.tchInt(1), BehaveData.tchInt(2), '^', ...
            'MarkerFaceColor', [0 1 0],...
            'MarkerSize', 15, ...
            'Parent',h_axis);
    else
        % faster data re-plotting than delete-then-plot-new
        set(TaskOp.touchHandle, 'xdata', BehaveData.tchInt(1));
        set(TaskOp.touchHandle, 'ydata', BehaveData.tchInt(2));
    end
end

if ~isempty(Evnt.hand)
    set(keyA, 'BackgroundColor', handColors(Evnt.hand(1)+1,:))
    set(keyB, 'BackgroundColor', handColors(Evnt.hand(2)+1,:))
end

%% fx Steal Timer
function stealTimer(touchScreenBit)

global Timers BehaveData TaskOp

 % steal currently running timerFcn 
toBeExec = Timers.Event.(TaskOp.cur_event_name).TimerFcn;

% generate TS
x.Type = 'TimerFcn';
x.Data = BehaveData.Tbl(end,1);
Timers.Event.(TaskOp.cur_event_name).UserData = [Timers.Event.(TaskOp.cur_event_name).UserData; x];
% disp(sprintf('executing: %s',TaskOp.cur_event_name)) % DEBUG tool

% set touchScreen bit up and down --should delay feedback by 5ms--
if TaskOp.touchInterrupt && touchScreenBit < 99
    ModigBitSender(touchScreenBit+1,1);
    ModigBitSender(touchScreenBit+1,0);
end
    
% execute it
if size(toBeExec,2)==2
    eval(toBeExec{2});
else
    eval(toBeExec);
end