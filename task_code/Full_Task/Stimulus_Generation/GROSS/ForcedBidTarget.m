function ForcedBidTarget(nTargets,Sorting)

global TO TP

TO.Stimuli.BDMf.TargetCol            = [0 0 250];

TargHeight = TO.Stimuli.BDM.BarHeight/nTargets;
TO.Params.BDMf.TargetHeight = TargHeight;
TO.Params.BDMf.nTargets     = nTargets;

for k = 1:nTargets % So lower k value for lower bids.
    TO.Params.BDMf.TargetMat(k,1) = TO.Stimuli.BarPos(1);
    TO.Params.BDMf.TargetMat(k,3) = TO.Stimuli.BarPos(3);
    TO.Params.BDMf.TargetMat(k,4) = TO.Stimuli.BarPos(4) - ((k-1)*TargHeight);
    TO.Params.BDMf.TargetMat(k,2) = TO.Stimuli.BarPos(4) - (k*TargHeight);
end

% Set-up vectors:
BaseBids    = [1:nTargets];
BaseBids    = repmat(BaseBids,1,nTargets);
BaseTargs   = sort(BaseBids);                   % Each target is repeated for each CBID.

TP.BDMf.TargetLoc   = [];
TP.BDMf.CBID        = [];

if strcmp(Sorting,'Block')
    TP.BDMf.TargetLoc = repmat(BaseTargs,1,30);
    TP.BDMf.CBID      = repmat(BaseBids,1,30);
elseif strcmp(Sorting,'Random')
    GroupSize   = length(BaseBids);
    for k = 1:30
        rng('shuffle')
        PIX         = randperm(GroupSize);
        NewBids     = BaseBids(PIX);
        NewTargs    = BaseTargs(PIX);
        TP.BDMf.TargetLoc = [TP.BDMf.TargetLoc NewTargs];
        TP.BDMf.CBID      = [TP.BDMf.CBID NewBids];
    end
end

end
