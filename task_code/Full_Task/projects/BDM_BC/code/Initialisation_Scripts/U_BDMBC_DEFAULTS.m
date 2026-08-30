% ULYSSES BDM DEFAULTS
global TP TO

% Standard BDM options:
TP.BDM.CDistType                = 'C';
TP.BDM.Joy.Gain                 = 125;

% Options for random starting position:
TP.BDM.VaryMarkerPos            = true;
TO.Rewards.Water.BDM.MMVar      = 1;
TO.Rewards.Water.BDM.VarRelPos  = zeros(1,1000);

for k = 1:1000
    TO.Rewards.Water.BDM.VarRelPos(k) = TO.Rewards.Water.BDM.MMVar*rand;
end

% Options for risky-reward BDM:
TP.BDM.Risky                    = false;
TP.BCb.Risky                    = false;

if TP.BDM.Risky
    SetRiskyDefaults
end

% Options for learning task:
TP.BDM.Learning                 = true;

if TP.BDM.Learning
    TP.Rewards.FractalNames     = {'B30','B20','B10','RL1','RL4','RL6','RL2','RL3','RL5','NR'};
    UpdateFractals(0, 0, 0, 1, 0.6, 0.2, 0, 0, 0, 0);
    TO.Rewards.O_High.PCoeffs   = [3.3333, 0.6667];
    TO.Rewards.O_Mid.PCoeffs    = [4, 4];
    TO.Rewards.O_Low.PCoeffs    = [0.6667, 3.3333];
end

% Reward-Set:
TP.BCb.JuiceSet            = [0, 0, 0, 0, 0, 0, 1, 1, 1, 0];
TP.BDM.JuiceSet            = [0, 0, 0, 0, 0, 0, 1, 1, 1, 0];