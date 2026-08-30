function [pE, Bias, pCI] = BernoulliTest(nSample1,nSample2,pLevel,varargin)

if length(varargin) == 2
    if ischar(varargin{1}) && ischar(varargin{2})
        Sample1_Name = varargin{1};
        Sample2_Name = varargin{2};
    else
        disp('Additional arguments must both be strings!')
    end
elseif length(varargin) == 1 || length(varargin) > 2 
    disp('Must present two name arguments!')
    Sample1_Name = 'Sample1';
    Sample2_Name = 'Sample2';
else
    Sample1_Name = 'Sample1';
    Sample2_Name = 'Sample2';
end

TrialN = nSample1 + nSample2;

[pE, pCI] = binofit(nSample1, TrialN, pLevel);

Prob = 0.5;

if Prob > pCI(1) && Prob < pCI(2) % 0.5 is between the two confidence intervals
    Bias = 'None';
elseif Prob > pCI(2)
    Bias = Sample2_Name;
elseif Prob < pCI(1)
    Bias = Sample1_Name;
end

end