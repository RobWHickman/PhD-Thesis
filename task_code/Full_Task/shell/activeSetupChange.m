function changed = activeSetupChange
% changed = activeSetupChange
% "in".   TaskOp.roleChangeCorrect
%         TaskOp.correct
%         TaskOp.roleChangeTrials
%         TaskOp.curSetup
%         TaskOp.respBlackBkg
%
% out, changed, 1 if flipped the current screen and changed the cur setup
%   to the other one, 0 if not
%
% rbm 5.08 

global MENUs TaskOp VisParam

% switch active setup in double setup
persistent switchCount
if isempty(switchCount),
    switchCount = 0;
end
changed = 0;

if TaskOp.roleChangeCorrect,
    tally = TaskOp.roleChangeCorrect + TaskOp.correct;
else
    tally = 2;
end

if tally==2
    % otherwise if roleChTr>1, it will count error trials to switch as well
    switchCount = switchCount + 1; 
    if switchCount >= TaskOp.roleChangeTrials 
        if TaskOp.respBlackBkg,
            % flip current setup to black background
            Screen('FillRect',VisParam.scr_handle,0);
            Screen('Flip',VisParam.scr_handle);
        end

        if TaskOp.curSetup=='A',        myEnd = 'B'; else      myEnd = 'A'; end
        hdlPB=['MENUs.ModigMainMenu.handles.pushbuttonSetup', myEnd];
        hdl  = 'MENUs.ModigMainMenu.handle';

        str = strcat('shiftSetupMoMaMe(''pushbuttonSetup'',',hdlPB,',[],guidata(',hdl,'))');
        switchCount =0;
        TaskOp.repeatError = 0;
        changed = 1;
        eval(str)
    end
end