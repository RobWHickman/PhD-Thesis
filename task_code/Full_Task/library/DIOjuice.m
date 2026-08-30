function DIOjuice(time,line)
% DIOjuice(time,line)
% In
%   time, [int] TTL up in s (must be larger than 0.010 s to generate a 
%          pulse)
%   line, [int] line or lines where the pulse will be sent (optional)
% Out
%   (not seen -->global: TaskOp.reward=1)
%
% note that if you send a TTL to one line in a port configurable device
% matlab will write to the whole port, not only to the line you want to
% send the pulse
%
% "putvalue" time overhead: ~5ms. this means that if you want a 100ms
% pulse, you should enter 0.095 s.
%
% rbm 07.07 
%     11.07 new wiring
%     01.08 uses moBitSe so not to modify the pre-pulse port values. 
%      4.09  warning for unrealistic pulse length
%      6.12 REvert to 10ms if unrealistic pulse length 
%      3.13 new latency measurements allow pulses 3ms long
%      8.14 Juice volume counters
global ExtDevice TaskOp
persistent names
if isempty(names)
    names = {'juice1', 'juice2'};
end

if nargin==1,
    setupB = strcmp(TaskOp.curSetup,'B');
    juCurSet = char(names(setupB+1));
    line = ExtDevice.outputDio.(juCurSet).Index;
end

% send the pulse
if time > 0.003
    TaskOp.reward(line) = TaskOp.reward(line)+1;    
    ModigBitSender(line, 1)
    WaitSecs(time);
    ModigBitSender(line, 0)
else
    warning('DIOjuice:TimeNotPossible','No juice delivery possible under 3ms, called diojuice with %d. Sending 3 ms.',time*1000)
    TaskOp.reward(line) = TaskOp.reward(line)+1;
    ModigBitSender(line, 1)
    WaitSecs(0.003);
    ModigBitSender(line, 0)
end

% % Fetch beta values
% if line==11,
%     beta = Stim.us.betasSetupA;
%     TaskOp.EvntHist.rewHistVol(1) = TaskOp.EvntHist.rewHistVol(1) + beta(1) + beta(2)*(time*1000);
% elseif line==12,
%     beta = Stim.us.betasSetupB;
%     TaskOp.EvntHist.rewHistVol(2) = TaskOp.EvntHist.rewHistVol(2) + beta(1) + beta(2)*(time*1000);
% end
% % update juice magnitude counter
