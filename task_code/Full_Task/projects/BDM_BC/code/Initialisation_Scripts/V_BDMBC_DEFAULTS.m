% VICER BDM DEFAULTS
global TP TO

TP.BDM.CDistType                    = 'C';
TP.BDM.Joy.Gain                     = 125;
TP.BDM.VaryMarkerPos                = true;
TO.Rewards.Water.BDM.RelMPos        = 0;

TO.Rewards.Water.BDM.MMDefPos(2)    = TO.Rewards.Water.BDM.MMIniPos(2) - (TO.Rewards.Water.BDM.RelMPos*TO.Params.BDM.BarRange);
TO.Rewards.Water.BDM.MMDefPos(4)    = TO.Rewards.Water.BDM.MMIniPos(4) - (TO.Rewards.Water.BDM.RelMPos*TO.Params.BDM.BarRange);
TO.Rewards.Water.BDM.MMPos          = TO.Rewards.Water.BDM.MMDefPos;

% Risky reward task:
TP.BDM.Risky                    = false;
TP.BCb.Risky                    = false;


% Learning task:
TP.BDM.Learning                 = false;

if TP.BDM.Learning
    TP.Rewards.FractalNames     = {'B30','B20','B10','RL1','RL4','RL6','RL2','RL3','RL5','NR'};
end