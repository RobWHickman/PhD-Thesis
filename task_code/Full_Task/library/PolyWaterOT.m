function [y] = PolyWaterOT(x)
% x is the desired target quantity in grams.
% y is the corresponding opening time.

%% Coefficients:
% WATER - WHITE SOLENOID:
p(1) = 33.674042999415920;
p(2) = -98.346627029729690;
p(3) = 2.571984000144974e+02;
p(4) = -0.659553461034433;

% Cubic giving opening time from target amount:
y = polyval(p,x);

if y < 0
    y = 0;
end

Budget = x

end

% p(1) = -10.053949951989324;
% p(2) = 61.509181964164550;
% p(3) = -1.329367152265403e+02;
% p(4) = 3.006187148189652e+02;
% p(5) = -7.076759830626536;
