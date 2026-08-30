function [DP] = DiscretePos(JPOS)

global TO

Part    = TO.Stimuli.BDM.BarHeight/TO.Params.BDM.D_nDivs;

Vec     = [0:Part:TO.Stimuli.BDM.BarHeight];

for k = 2:length(Vec)
    LowerLim = Vec(k-1);
    UpperLim = Vec(k);
    if JPOS >= LowerLim && JPOS < UpperLim
        Out(k-1) = 1;
    else
        Out(k-1) = 0;
    end
    
    if k == length(Vec)
        if JPOS >= LowerLim && JPOS <= UpperLim
            Out(k-1) = 1;
        else
            Out(k-1) = 0;
        end
    end
end

DP = find(Out);
    