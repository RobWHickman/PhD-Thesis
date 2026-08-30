function RelPos = PositionJoy(JoyVolt)

if JoyVolt > 0.49
    JoyVolt = 0.49;
elseif JoyVolt < -0.49
    JoyVolt = -0.49;
end

MaxVolt = 0.98;
JoyVolt = JoyVolt + 0.49; % Max = 1.1, Min = 0.

RelPos = JoyVolt/MaxVolt;

if RelPos > 1
    RelPos = 1;
elseif RelPos < 0
    RelPos = 0;
end






