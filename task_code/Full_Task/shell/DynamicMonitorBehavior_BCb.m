function [flipwhen, errorInterrupt] = DynamicMonitorBehavior_BCb(rate,runTime)
% [flipwhen, errorInterrupt] = myTimerMonitorBehavior(rate,runTime)
%
% Input:
%   rate [hz]
%   runTime, [s]
%   global MENUs breaksession IO UserInfo
% Output:
%   flipwhen, revised time to flip screen 
%   errorInterrupt, logical, TRUE interrupt trial because of a behavioural
%       error
%
%   See also ModigRunTrial
%
% rbm
global MENUs breaksession IO UserInfo VisParam Stim TaskOp BehaveData TP TO
persistent mouseEyeTouch 
if isempty(mouseEyeTouch)
    mouseEyeTouch = IO.Input.eye.monitor && ...
            strcmp(IO.Input.eye.tracking_method,'mouse') && ...
                UserInfo.use_touch_screen;
end

% GET POSITION IN TABLE SO FAR:
StartingRow = size(BehaveData.Tbl,1)+1; % The row number for the first data-point in this round of sampling.
WindowRow   = StartingRow + 8*(TP.BDM.Joy.Window);
flipwhen = 0;
errorInterrupt = 0;

% deal with inputs
if nargin==0,
    runTime = 5;
    rate = 50;
end
% approximate rate -make while loop wait
cycleMax = 1/rate;

% time keepers
start = GetSecs;
stopBehaviorTimer = 0;
loops=1;

% Invisible choice marker
Marker_Pos              = TP.BCs.CenterPos + TP.BCb.MarkerOffset;
YCent                   = VisParam.scr_rect(4)/2;
TP.BCb.ChoiceDone       = 0;
s_WindowNumber          = num2str(VisParam.scr_handle);
WindowSize              = TO.Params.BCb.OfferWidth/2;
s_MarkerCol             = num2str([0 0 250]);
%% Actual timer
while stopBehaviorTimer==0
    % time keeper
    now = GetSecs;
    eTime = now-start;
    stopBehaviorTimer = runTime<eTime;
    %% behavioural operation
    Evnt = SampleBehavior(mouseEyeTouch,WindowRow,StartingRow);
    %% MoveMarker:

        if Evnt.joyX < 0 % Going left
            TP.BCb.BiasFactor = TP.BCb.LGainBias;
        elseif Evnt.joyX > 0 % Going Right
            TP.BCb.BiasFactor = TP.BCb.RGainBias;
        else % Zero velocity
            TP.BCb.BiasFactor = 1;
        end
            
        Marker_Pos = Marker_Pos + (TP.BCb.Joy.Gain*Evnt.joyX*TP.BCb.BiasFactor);
        % Stops marker 'flying' off the end of the screen:
        if Marker_Pos < 25
            Marker_Pos = 25;
        elseif Marker_Pos > (VisParam.scr_rect(3) - 25)
            Marker_Pos = VisParam.scr_rect(3) - 25;
        end
        
        eval(VisParam.page(17).draw);
        MarkerP = [Marker_Pos-25, YCent-25, Marker_Pos+25, YCent+25];
        MarkerP = num2str(MarkerP);
        MARKER = strcat('Screen(''FillOval'', [', s_WindowNumber,'], [', s_MarkerCol,'], [', MarkerP,']);');
        eval(MARKER);
        Screen('Flip',VisParam.scr_handle);
    
    % END OF EDIT
    if Marker_Pos < (TP.BCb.LeftCenter+WindowSize-TP.BCb.LSO) && Marker_Pos > (TP.BCb.LeftCenter-WindowSize-TP.BCb.LSO)           % Marker In left-choice zone.
        TP.BCb.ChoiceSide = 1;
        TP.BCb.ChoiceDone = 1;
        s_MarkerCol = num2str([250 0 0]);
        if TP.BCb.FractalSide  == 1 % Fractal offer is on left, left side chosen
            TP.BCb.ChoiceType = 1;
        else
            TP.BCb.ChoiceType = 2;
        end
        Cover = TO.Stimuli.BCs.CoverRight;
    elseif Marker_Pos > (TP.BCb.RightCenter-WindowSize+TP.BCb.RSO) && Marker_Pos < (TP.BCb.RightCenter+WindowSize+TP.BCb.RSO)         % Marker In right-choice zone.
        TP.BCb.ChoiceSide = 2;
        TP.BCb.ChoiceDone = 1;
        s_MarkerCol = num2str([250 0 0]);
        if TP.BCb.FractalSide  == 2 % Fractal offer is on right, right side chosen
            TP.BCb.ChoiceType = 1;
        else
            TP.BCb.ChoiceType = 2;
        end
        Cover = TO.Stimuli.BCs.CoverLeft;
    else
        TP.BCb.ChoiceSide    = NaN;
        TP.BCb.ChoiceDone    = 0;
        s_MarkerCol = num2str([0 0 250]);
        Cover = ' ';
    end
    
    TP.BCb.MarkerHistory(loops,:) = Marker_Pos;    % Update the marker history matrix.
    
    %% update experimenter monitor
    if strcmp(MENUs.ModigMonitorTable.status, 'ON') && exist('Evnt','var')
        UpdateMonitor(MENUs.ModigMonitorTable.handles.MONITOR_AXIS,...
            MENUs.ModigMonitorTable.handles.key_fb_A, ...
            MENUs.ModigMonitorTable.handles.key_fb_B, Evnt, mouseEyeTouch);
    end
    
    % break while loop if Evnt says "interrupt" or "error"
    if Evnt.flipwhen>0,
        flipwhen = Evnt.flipwhen;
        break,
    end
    
    if Evnt.errorInterrupt,
        errorInterrupt = Evnt.errorInterrupt;
        break,
    end
    
    % check for juice delivery or breaking session
    ModigTaskLoop CheckBreakSession
    
    if breaksession
        break
    end
    
    % rate keeper
    prev            = now;
    now             = GetSecs;
    thisCycleTime   = now-prev;
    waitThisLong    = cycleMax-thisCycleTime;
    WaitSecs(waitThisLong); 
    loops           =loops+1;
end
% We need to send to error if bid is not locked by the end of the loop...
if TP.BCb.ChoiceDone == 1
    eval(VisParam.page(17).draw);
    MARKER = strcat('Screen(''FillOval'', [', s_WindowNumber,'], [100 0 0], [', MarkerP,']);');
    eval(MARKER);
    eval(Cover);
    Screen('Flip',VisParam.scr_handle,[],1);
    disp('Choice Made');
else
    TaskOp.correct         = 0;
    TaskOp.Error.NoChoice  = 1;
    errorInterrupt         = 1;
end
% One last time so that stimuli are present on next epoch screen?


% fprintf('Behaviour Looped: %d\n',loops) % debug tool
%% Sample behaviour /main function/
function Evnt = SampleBehavior(met,WR,SR)
% Evnt = SampleBehavior(met)
% In:
%     met = mouse eye tracking
% Out:
%     Evnt.{key, eye, touch, flipwhen, errorInterrupt}
% 
global IO BehaveData TaskOp Tbl UserInfo
persistent fixHolder touchScreenBit curSetup handHolder

curSetup = 1+strcmp(TaskOp.curSetup,'B');
if isempty(fixHolder) || isempty(touchScreenBit)
    fixHolder = 0;
    handHolder = 0;
    
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
Evnt.flipwhen = 0;
Evnt.errorInterrupt = 0;
Evnt.failedToReadMouse = 0;

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
            case 'centralFixationCircle'
                eyeDis = sqrt((Evnt.eye.x-limits(1))^2 + (Evnt.eye.y-limits(2))^2);
                eyeIn = eyeDis < limits(3);
                
                if eyeIn == 1
                    % eye signal within central fixation circle
                     TaskOp.eye.state = 1;
                     TaskOp.correct   = 1;
                     TaskOp.choice    = 1;                
                elseif eyeIn == 0 && (TaskOp.eye.filter_time < elapsedTime)
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
    if TaskOp.hand.req,
        TaskOp.hand.state = 0;
        het = BehaveData.Tbl(currentRow,1) - TaskOp.hand.filter_startTime;
        hft = TaskOp.hand.filter_time;
        if Evnt.hand(curSetup) == 1 
             TaskOp.hand.state = 1;
             TaskOp.correct    = 1;
        elseif Evnt.hand(curSetup) == 0 && (hft < het || hft==0)
            errorSignal = 1; 
        end
    end
else
    Evnt.hand = [];
    BehaveData.Tbl(currentRow,6:7) = 2;
end

%% verify joystick requirements
if IO.Input.joy.monitor == 1
    
    Evnt.joyY                       = GJPY;
    Evnt.joyX                       = GJPX;
    BehaveData.Tbl(currentRow,9)    = Evnt.joyY;
    BehaveData.Tbl(currentRow,10)   = Evnt.joyX;
    BehaveData.Tbl(currentRow,11)   = 1;

end
%% verify touch screen requirements
if IO.Input.use_touch_screen,
    if met,
        Evnt.touch = Evnt.eye;
    else
        Evnt.touch = GetMousePosition;
    end
    
    if isempty(Evnt.touch),
        Evnt.failedToReadMouse = 1;
        return
    end
    
    TaskOp.touch.state = 0;
    
    % if necessary evaluate if touch is on the required position...
    if isfield(TaskOp.touch,'req') && ~isempty(TaskOp.touch.req),
        limits = TaskOp.touch.limits; % defined in ModigRunTrial
       
        elapsedTime = BehaveData.Tbl(currentRow,1) - TaskOp.touch.filter_startTime;
        switch TaskOp.touch.req
            case 'oneTouchArea'               
                touchIn = Evnt.touch.x > limits(1) && Evnt.touch.x < limits(2)...
                       && Evnt.touch.y > limits(3) && Evnt.touch.y < limits(4);
                if touchIn == 1                    
                    % touch signal within range 
                     TaskOp.touch.state = 1;                     
                     TaskOp.correct     = 1;
                elseif touchIn == 0 && (TaskOp.touch.filter_time < elapsedTime)
                     errorSignal = 1;
                end
            case 'twoTouchAreas'
                touchIn = zeros(2,1);
                for i = 1:size(limits,1)
                    touchIn(i) = Evnt.touch.x > limits(i,1) && Evnt.touch.x < limits(i,2)...
                            && Evnt.touch.y > limits(i,3) && Evnt.touch.y < limits(i,4);
                end
                if touchIn(1) == 1
                    % touch signal within choice 1
                     TaskOp.touch.state = 1;
                     TaskOp.correct     = 1;
                     TaskOp.choice      = 1;
                elseif touchIn(2) == 1
                    % touch signal within choice 2
                     TaskOp.touch.state = 1;
                     TaskOp.correct     = 1;
                     TaskOp.choice      = 2;
                elseif sum(touchIn) == 0 && (TaskOp.touch.filter_time < elapsedTime)
                     errorSignal = 1;
                end                
        end
    end
else
    Evnt.touch = [];
end
%% interrupts...
% error -> go to
if errorSignal
    TaskOp.hand.state  = 0;
    TaskOp.eye.state   = 0;
    TaskOp.touch.state = 0;
    TaskOp.correct     = 0;
    TaskOp.error_event = TaskOp.cur_event_id;
    TaskOp.eyeLostHold = fixHolder > 0;
    TaskOp.handLostHold = handHolder > 0;
    fixHolder = 0;
    % return control 
    Evnt.errorInterrupt = 1;         
    
   % Move to next epoch if eye inside required area
elseif TaskOp.eyeHold==0 && TaskOp.eyeInterrupt && TaskOp.eye.state     
    TaskOp.interrupt = 1;
    % create a new flipwhen to be passed to ModigRunTrial
    Evnt.flipwhen = GetSecs+0.016;
    
    % Move to next epoch if key rest is touched
elseif TaskOp.handHold==0 && TaskOp.handInterrupt  && TaskOp.hand.state
    TaskOp.interrupt = 1;
    % create a new flipwhen to be passed to ModigRunTrial
    Evnt.flipwhen = GetSecs+0.016;
    
    % move to next epoch if touchscreen is touched inside required area
    % (and key rest isn't touched)
elseif TaskOp.touchInterrupt && TaskOp.touch.state && Evnt.hand(curSetup) == 0
    TaskOp.interrupt = 1;
    % save touch Interrupt coordinates.
    BehaveData.tchInt = [Evnt.touch.x Evnt.touch.y];
    BehaveData.Tbl(currentRow,8) = 1;
    % create a new flipwhen to be passed to ModigRunTrial
    Evnt.flipwhen = GetSecs+0.016;
    
    % If eye gaze must be held, create 'holder' and evaluate when to move
    % to next epoch
elseif TaskOp.eyeHold && TaskOp.eyeInterrupt  && TaskOp.eye.state
    % create anchor time if we don't have one
    if fixHolder==0,
       fixHolder =  BehaveData.Tbl(currentRow,1);
       % change tolerance time to mark errors in case the hand or eye state
       % is lost...
       TaskOp.eye.filter_time = 0;
    end

    % compare anchor to current time, [seconds]
    elTime = BehaveData.Tbl(currentRow,1)-fixHolder;
    
    % interrupt if holdTime has elapsed,
    if elTime > TaskOp.eyeHoldTime,
        fixHolder = 0;
        TaskOp.interrupt = 1;
        Evnt.flipwhen = GetSecs+0.016;
    end
    
    % If key restmust be held, create 'holder' and evaluate when to move
    % to next epoch
elseif TaskOp.handHold && TaskOp.handInterrupt && TaskOp.hand.state
    % create anchor time if we don't have one
    if handHolder==0,
       handHolder =  BehaveData.Tbl(currentRow,1);
       % change tolerance time to mark errors in case the hand or eye state
       % is lost...
       TaskOp.hand.filter_time = 0;      
    end

    % compare anchor to current time, [seconds]
    elTime = BehaveData.Tbl(currentRow,1)-handHolder;
    % interrupt if holdTime has elapsed,
    if elTime > TaskOp.handHoldTime,
        handHolder = 0;
        TaskOp.interrupt = 1;
        Evnt.flipwhen = GetSecs+0.016;     
    end
end


%% Subfx. obtain hand status
function hand = GetHandStatus(mode)
% hand = GetHandStatus(mode)
%
% mode, string with either: {'key', 'daq'}
% hand, 1x2 logical
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
    prehand = getvalue(ExtDevice.inputDio);
    hand = prehand(handlines);
end

%% subfx. obtain Joystick Y-axis position
function joy = GetJoyPosY

global ExtDevice IO

preview = peekdata(ExtDevice.aiObject, 4);      % Preview the last 3 samples of the aiObject on channel 4.
preview = preview(:,2);
joy     = - (mean(preview));         % Take the average sampled, ignoring samples outside the IQR.
if abs(joy) <= IO.Input.joy.Sensitivity_Threshold;
    joy = 0;
elseif joy > 0.49
    joy = 0.49;
elseif joy < -0.49
    joy = -0.49;
end

%% subfx. obtain Joystick X-axis position
function joy = GetJoyPosX

global ExtDevice IO

preview = peekdata(ExtDevice.aiObject, 4);      % Preview the last 3 samples of the aiObject on channel 4.
preview = preview(:,1);
joy     = (mean(preview) - 1.32);         % Take the average sampled, ignoring samples outside the IQR.
if abs(joy) <= IO.Input.joy.Sensitivity_Threshold;
    joy = 0;
end

%% subfx. obtain mouse position
function mouse = GetMousePosition
% mouse = GetMousePosition
global VisParam 
persistent tries
if ~exist('tries','var'),
    tries = 0;
end
% sometimes it fails to read mouse position, we need a fallback solution
try
    [mouse.ox mouse.oy] = GetMouse(1);
catch
    tries = tries+1;
    if tries <100,
        mouse = GetMousePosition;    
    else
        mouse.ox = 0;
        mouse.oy = 0;
    end
end
mouse.x = mouse.ox;

% (o,o) is up left in PTB/OSX, and bottom left in WIN!
% mouse.y = abs(mouse.oy - VisParam.scr_rect(4)); % is equivalent to:
mouse.y = abs(VisParam.scr_rect(4) - mouse.oy );

if tries>0,
    fprintf('Tried %d times to sample mouse position \n',tries)
end
tries = 0;

%% Subfx. obtain eye position
function eye = GetEyePosition
% eye = GetEyePosition
%
% Return original uncalibrated values (eye.ox, eye.oy) and
% calibrated coordinates (eye.x, eye.y)
global IO ExtDevice TaskOp centerEye 
persistent ctr eyeLines

% Initalize our persistent/global
if isempty(centerEye) || isempty(ctr) || isempty(eyeLines)
   eyeLines = [1 2]; % AI0 and AI1
   ctr = [1024 768]/2; % monkey on the lateral edge
   centerEye = 0;
end

switch IO.Input.eye.tracking_method
    case 'mouse'
        eye = GetMousePosition;
    otherwise
        preview  = mean(peekdata(ExtDevice.aiObject, ...
            ExtDevice.aiObject.SampleRate/IO.Input.behavior.sampling_rate),1) + 6;         
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
        elseif numel(TaskOp.Cal.Eye.Gain.x)==1,
            TaskOp.Cal.Eye.Gain.x(2) = TaskOp.Cal.Eye.Gain.x(1);
            TaskOp.Cal.Eye.Gain.y(2) = TaskOp.Cal.Eye.Gain.y(1);            
        end
        % Calibrate with two gains, one when the eye position is negative
        % to the center and another when it is positive. [-gain +gain]
        xOffset=eye.ox - TaskOp.Cal.Eye.Offset.x;
%         eye.y = ctr(2) + xOffset * TaskOp.Cal.Eye.Gain.x((xOffset>0)+1);
        yOffset=eye.oy - TaskOp.Cal.Eye.Offset.y;
%         eye.x = ctr(1) + yOffset * TaskOp.Cal.Eye.Gain.y((yOffset>0)+1);

        % Calibrate with one gain
        eye.y = ctr(2) + xOffset * TaskOp.Cal.Eye.Gain.x(1);
%         eye.x = ctr(1) + yOffset * TaskOp.Cal.Eye.Gain.y(1);
        eye.x = ctr(1) - yOffset * TaskOp.Cal.Eye.Gain.y(1);

end

%% subfx. plot eye, touch hand positions
function UpdateMonitor(h_axis, keyA, keyB, Evnt, met)
% UpdateMonitor(h_axis, keyA, keyB, Evnt, met)
%
% Updates eye position and key touch status on experimenter's screen
% handles contained in: (h_axis, keyA, keyB)
global TaskOp TG
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
        % we make sure to draw in ModigMonitor by calling its 'Parent'
        TaskOp.touchHandle = plot(Evnt.touch.ox, Evnt.touch.y, '^', ...
            'MarkerFaceColor', [0 0 1],...
            'MarkerSize', 15, ...
            'Parent',h_axis); 
    else
        % faster data re-plotting than delete-then-plot-new
        set(TaskOp.touchHandle, 'xdata', Evnt.touch.ox);
        set(TaskOp.touchHandle, 'ydata', Evnt.touch.y);
    end
end

if ~isempty(Evnt.hand)
    set(keyA, 'BackgroundColor', handColors(Evnt.hand(1)+1,:))
    set(TG.BDM_BC_GUI.Handles.Touch_IO, 'BackgroundColor',handColors(Evnt.hand(1)+1,:)); 
    set(keyB, 'BackgroundColor', handColors(Evnt.hand(2)+1,:))
end

% we need to flush event queue to draw eye and touch positions
drawnow
