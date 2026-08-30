function SetJoyParams(Monitor, CentreFix, CThreshold, SThreshold)

global IO

IO.Input.joy.monitor                = Monitor;      % Monitor joystick data?
IO.Input.joy.Centre_Threshold       = CThreshold;   % Threshold on Joystick_Centre_Window
IO.Input.joy.Sensitivity_Threshold  = SThreshold;   % Threshold on Joystick_Sensitivity
IO.Input.joy.DefCentreFix           = CentreFix;    % Impose centre-position restriction on joystick?

end