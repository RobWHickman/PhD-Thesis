function [joy] = GJPX

global ExtDevice IO

preview = peekdata(ExtDevice.aiObject, 4);
preview = preview(:,1);
joy     = - (mean(preview)) + 0.45;   % THIS LINE!
% Take the average sampled, ignoring samples outside the IQR.

if abs(joy) <= IO.Input.joy.Sensitivity_Threshold;
    joy = 0;
end