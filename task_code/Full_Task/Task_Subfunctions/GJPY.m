function [joy] = GJPY

global ExtDevice IO

preview = peekdata(ExtDevice.aiObject, 4);
preview = preview(:,2);
joy     = - (mean(preview)) + 0.006; % THIS LINE!

% Take the average sampled, ignoring samples outside the IQR.

if abs(joy) <= IO.Input.joy.Sensitivity_Threshold;
    joy = 0;
elseif joy > 0.49
    joy = 0.49;
elseif joy < -0.49
    joy = -0.49;
    
end
