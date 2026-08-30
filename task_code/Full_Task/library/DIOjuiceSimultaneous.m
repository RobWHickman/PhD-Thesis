function DIOjuiceSimultaneous(times,lines)
% DIOjuiceSimultaneous(times,lines)
% In
%   times, [2 x int] TTL up in s (must be larger than 0.010 s to generate a 
%          pulse)
%   lines, [2 x int] line or lines where the pulse will be sent 
% Out
%   (not seen -->global: TaskOp.reward(line(s))=1)
%
% note that if you send a TTL to one line in a port configurable device
% matlab will write to the whole port, not only to the line you want to
% send the pulse
%
% "putvalue" time overhead: ~1ms. this means that if you want a 100ms
% pulse, you should enter 0.099 s.
%
% See also DIOjuice
%
% rbm 3.13 
% global TaskOp

if any(times)<0.01,
     warning('DIOjuice:TimeNotPossible',...
         'No juice under 9ms, called diojuice with %d. Sending 10ms.',times*1000)
     times(any(times)<0.01) = 0.01;
end

% send the pulses
upDownDelay = 0.001; % putvalue overhead
if times(1)~=times(2),
    [~, id]= min(times);
    firstWait  = times(id)-upDownDelay;
    secondWait = times(3-id)-times(id)-upDownDelay;

    ModigBitSender(lines, [1 1])
    WaitSecs(firstWait);
    ModigBitSender(lines(id), 0)
    WaitSecs(secondWait);
    ModigBitSender(lines(3-id), 0)
else
    ModigBitSender(lines, [1 1])
    WaitSecs(times(1)-upDownDelay);
    ModigBitSender(lines, [0 0])
end

% TaskOp.reward(lines) = TaskOp.reward(lines)+1;

