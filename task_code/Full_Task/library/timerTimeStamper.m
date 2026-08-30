function timerTimeStamper(obj, event, varargin)
% timerTimeStamper(obj, event, varargin)
%
% timerTimeStamper is ment to be used as a callback to save the time, which
% is passed in the structure event, to the userData field of the timer.
% Which can be later on used for deciphering when a timer went on.
%
% It accepts a third input (string) which is 'eval'uated right after saving 
% the timestamp. It might generate an error when a nested cell array is 
% passed as the third argument.  
%
% rbm 08.07

% event.Data = event.Data.time;
event.Data = GetSecs;
if isempty(obj.UserData),
    obj.UserData = event;
else
    obj.UserData = [obj.UserData; event];
end

for i = 1:size(varargin,2)
    if ~isempty(varargin) 
        eval(char(varargin{i}));
    end
end