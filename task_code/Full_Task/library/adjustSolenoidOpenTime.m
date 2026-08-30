function openTime = adjustSolenoidOpenTime(betas, target, pulses, interpulse)
% openTime = adjustSolenoidOpenTime(betas, target, pulses, interpulse)
%
% adjusts the solenoid open time for each pulse depending on multiple 
% regression results from calibration data using the equation:
%
%   y = b0 + b_pulses * pulses + b_opentime * opentime + error
%
% if betas are 4 elements long, and interpulse is defined, it uses the
% expansion of the equation
%
%   y = b0 + b_pulses * pulses + b_opentime * opentime + b_interpulse*interpulse + error
%
% If betas is 2-elements long, it uses:
%
%    y = b0 + b_opentime * opentime + error
%
% See also 
%
% rbm 03.10
% rbm 6.12, no pulses equation  

if numel(betas) == 2,
    openTime = round((target - betas(1)) / betas(2));
elseif numel(betas) == 3,
    openTime = round((target - betas(1) - betas(2)*pulses) / betas(3));
elseif numel(betas)==4 && ~isempty(interpulse)
    openTime = round((target - betas(1) - betas(2)*pulses - betas(4)*interpulse) / betas(3));
else
    error('adjustSolenoidOpenTime no result! bad input')
end
% change from ms to s
openTime = openTime/1000;