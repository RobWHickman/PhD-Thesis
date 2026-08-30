function [Alpha, Beta] = GenBeta(Mean,Var)

Alpha = (((Mean^2)-(Mean^3))/Var) - Mean;
Beta  = (Alpha/Mean) - Alpha;

end