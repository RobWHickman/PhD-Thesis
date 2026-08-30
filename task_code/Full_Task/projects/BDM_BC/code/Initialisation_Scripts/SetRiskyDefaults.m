% SetRiskyDefaults

global TP TO TC

UpdateFractals(0.6, 0.4, 0.2, 1.9, 1.55, 0.85, 0, 1.2, 0.5, 0);

% Vector of reward presentation:
Juices                          = 1:10;
if strcmp(TC.All.SessionType, 'BDM')
    Set_Logic                       = logical(TP.BDM.JuiceSet);
elseif strcmp(TC.All.SessionType,'BCb')
    Set_Logic                       = logical(TP.BCb.JuiceSet);
end

Juices                              = Juices(Set_Logic);
nJuices                             = length(Juices);
nReps                               = round(200/nJuices);
TO.Stimuli.Risky.RewardSet          = repmat(Juices, 1, nReps);
TO.Stimuli.Risky.RewardSet          = TO.Stimuli.Risky.RewardSet(randperm(length(TO.Stimuli.Risky.RewardSet)));
TO.Stimuli.Risky.RewardSet          = [TO.Stimuli.Risky.RewardSet, TO.Stimuli.Risky.RewardSet];

% Vector of deliveries:
nWin                                = round(nReps/2);
nLoss                               = nWin;
Wins                                = ones(1,nWin);
Losses                              = zeros(1,nLoss);
Deliveries                          = [Wins, Losses];

for j = 1:10
    Deliveries2                     = Deliveries(randperm(length(Deliveries)));
    Del(j,:)                        = repmat(Deliveries2, 1, ceil(length(TO.Stimuli.Risky.RewardSet)/length(Deliveries)));
end

for j = Juices
    if strcmp(TC.All.SessionType, 'BDM')
        IX                              = find(TO.Stimuli.Risky.RewardSet == j);
    elseif strcmp(TC.All.SessionType,'BCb')
        IX                              = find(TC.BCb.RewardIDs == j);
    end
    Count                           = 1:length(IX);
    FullCount(IX)                   = Count;
    
end

if strcmp(TC.All.SessionType, 'BDM')
    for j = 1:length(TO.Stimuli.Risky.RewardSet)

        CurReward                       = TO.Stimuli.Risky.RewardSet(j);
        Count                           = FullCount(j);
        TO.Stimuli.Risky.Deliveries(j)  = Del(CurReward, Count);

    end
elseif strcmp(TC.All.SessionType,'BCb')
    for j = 1:length(TC.BCb.RewardIDs)

        CurReward                       = TC.BCb.RewardIDs(j);
        Count                           = FullCount(j);
        TO.Stimuli.Risky.Deliveries(j)  = Del(CurReward, Count);

    end
end
%% MODIFY ACTUAL REWARD SET:

TC.BDM.RewardIDs = TO.Stimuli.Risky.RewardSet;
