function [eTimerTime elapsedTimes] = checkTimerTiming(ti)

if nargin == 0;
    ti = timerfind;
end
allTimes = ti.UserData;

tsArray.Type = 'd';
tsArray.Data = zeros(1,6);
tsArray = [tsArray; tsArray];
timName = 'dummy';

for i = 1:size(ti,1), 
    if ~isempty(allTimes{i}), 
        tsArray = [tsArray allTimes{i}];
        timName = [timName; {ti(i).Name}];
    end,
end
tsArray(:,1) = [];
timName = timName(2:end,:);
eTimerTime = zeros(size(tsArray,2),1);
elapsedTimes = cell2struct(timName,timName,1);
for i = 1:size(tsArray,2),
    eTimerTime(i) = etime(tsArray(2,i).Data, tsArray(1,i).Data);
    elapsedTimes.(char(timName(i))) = eTimerTime(i);
end

