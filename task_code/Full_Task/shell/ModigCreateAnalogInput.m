function aiObject = ModigCreateAnalogInput(sampling)
%
%

% RBM 06.07

if nargin == 0
    sampling = 200;
end
% create AI object
ai = analoginput('nidaq','Dev1');
% add channel(s)
addchannel(ai, [0 1 2 3]);
ai.SampleRate        = sampling;
ai.SamplesPerTrigger = inf;
ai.UserData          = zeros(1,3);

aiObject = ai;

% aiObject = daq.createSession('ni');
% addAnalogInputChannel(aiObject,'Dev1', 'ai0', 'Voltage');
