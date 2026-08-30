function RelPos = PositionJoyX(JoyVolt)

if JoyVolt > 0.58
    JoyVolt = 0.58;
elseif JoyVolt < -0.58
    JoyVolt = -0.58;
end

MaxVolt = 1.16;
JoyVolt = JoyVolt + 0.58; % Max = 1.16, Min = 0.

RelPos = JoyVolt/MaxVolt;

if RelPos > 1
    RelPos = 1;
elseif RelPos < 0
    RelPos = 0;
end


