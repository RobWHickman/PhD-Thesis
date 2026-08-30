function adaptiveError(display)
% adaptive error when running Getty, so to reflect time that
% Getty won't release control
%
% can be called in MoJuSit_(prj) to modify 'on the fly' the error timer
%


global TaskOp Timers

if isfield(TaskOp,'trLTimer')
    start = TaskOp.EvntHist.cur_trial_start_time;
    gettyRelease = start+(TaskOp.trLTimer/1000);
    now = GetSecs;
    waitThisLong = gettyRelease - now;
    waitThisLong = round(waitThisLong*1000)/1000;
    Timers.Event.error.startDelay = waitThisLong;

    if nargin==1 && display
        disp(sprintf('error timeout.  %3.4g out of: %3.4g', waitThisLong,TaskOp.trLTimer/1000))
    end
end