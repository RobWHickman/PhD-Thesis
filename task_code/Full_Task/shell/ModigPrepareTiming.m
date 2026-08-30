function cb = ModigPrepareTiming(varargin)
% Prepare timing setting before every trial
% Time duration for each event is randomized by looking at 'base' and 'var' 
% (PrepareTimingParams subroutine).
% Then, the timer for each event is set such that at the time out of each event, 
% the timer for the next event is started (SetEventTimers subroutine). 
% A timer to monitor behavioral input is set separately.

% Called by ModigTaskLoop.m (Initialize subroutine)
% coded by skoba (skoba-tky@umin.ac.jp) 8 June 2005
% skoba 1 September 2005
% RBM, switchyard to call particular subfunctions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0,
% time duration of each event
% is determined by time_base and time_var before every trial. 
% See PrepareTimingParams subroutine for detail
cb1 = PrepareTimingParams;

% timers to measure duration of each event inside a trial is set before
% every trial. See PrepareTimers subroutine for detail.
% cb2 = SetEventTimers;                                                   
% cb3 = ModigSetTimer('Input','behavior_monitor');
% a trial is started only if above two subroutines were successfully
% finished (cb == 1).
% cb = cb1 * cb2 * cb3;                                                   

if cb1 == 0
    warning('MODIG:MoPreTim1','timing parameters were not set properly')
end
% if cb2 == 0
%     warning('MODIG:MoPreTim2','Event timers were not set properly')
% end
% if cb3 == 0
%     warning('MODIG:MoPreTim3','behavioral monitoring were not set properly')
% end
% NOTE: Output timers are set by ModigPrepareOutput_XXX.m called by 
%   ModigTaskLoop in initialize subroutine.

elseif ischar(varargin{1}),
    try
        [varargout{1:nargout}] = feval(varargin{:});
    catch
        rethrow(lasterror);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb= PrepareTimingParams
% make a randomized event duration combining 'base' and 'var': 
% time_randomized is combination of fixed 'base' duration and random 
% part from 'var' duration
% then, make an adjustment taking into account visual presentation delay. 
% As it takes time to draw texture on the subject monitor (say visual_delay),
% trigger an event shift 'visual_delay' earlier than planned timing. (This is 
% optional which a user can select from main menu -> HARD -> display)
global Task %TaskOp VisStat Tbl TimeAdj VisStat

cb = 1;
items = fields(Task)';
for ii = 1: length(items)
    item = Task.(cell2mat(items(ii)));
    if isfield(item,'time_base') && isfield(item,'time_var'),
%         time_randomized = ModigRandTime(item.time_base - item.time_var,...
%                                         item.time_base + item.time_var,'flat');
        time_randomized = ModigRandTime(item.time_base, item.time_var,'truncated exp');
        Task.(cell2mat(items(ii))).time_randomized = time_randomized;
        Task.(cell2mat(items(ii))).time_planned = time_randomized;
    else
        cb = 0;
        warning('Time empty for epoch %s, check input to setTimer',(cell2mat(items(ii))))
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb = SetEventTimers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prepare timers that run in casscade during a single trial.
% When Timers.task.event_1 reaches pre-set time, it triggers next timer 
% Timers.task.event_2, etc.
% ITI timer is set after a trial.
global Task
cb = 1;
%%%%%% SET UP TIMERS FOR TASK EVENT CONTROL %%%%%%%
event_list = fields(Task);
for ee = event_list'
    % ITI timer cannot be set at the begining of trial because it is
    % supposed to be running at this time. ITI timer will be set at the 
    % begining of post-trial period
    if ~strcmpi(cell2mat(ee),'ITI')
        ModigSetTimer('Event',cell2mat(ee)); 
    end
end


