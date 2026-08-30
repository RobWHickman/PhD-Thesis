global TO VisParam TP
% Sets up the objects that the task will use. A separate script initialises behavioural and task parameters.
% Need to add forced trial materials.

%% Constants:
DefaultStimulusParameters;
%% Fractals:
UpdateFractals(0.6, 0.4, 0.2, 0.75, 0.60, 0.3, 0.9, 0.45, 0.15, 0);
%% Bar-related stimuli:
UpdateBDMBar;

%% Other stimuli:
% Fixation targets:
if strcmp(TP.BDM.CurrencyType,'W')
    TO.Rewards.Water.Type                                                                = 'Water';
    TO.Stimuli.BDM.Fixation                                                              = MakeFixation('Cross',VisParam.scr_handle, [250 250 0]);  %YELLOW - CROSS  = BDM
    TO.Stimuli.BDM.Fixation_BDM_PAV                                                      = MakeFixation('Cross',VisParam.scr_handle, [250 0 0]);    %RED    - CROSS  = BDMPav
    TO.Stimuli.BDM.Fixation_Forced                                                       = MakeFixation('Cross',VisParam.scr_handle, [0 0 250]);    %BLUE   - CROSS  = BDMForced
    TO.Stimuli.BDM.Fixation_First                                                        = MakeFixation('Oval',VisParam.scr_handle, [250 250 0]);   %YELLOW - OVAL   = FirstPrice
    TO.Stimuli.BCb.Fixation                                                              = MakeFixation('Square',VisParam.scr_handle, [250 250 0]); %YELLOW - SQUARE = BCb
elseif strcmp(TP.BDM.CurrencyType,'B')
    TO.Rewards.Water.Type                                                                = 'Blackcurrant';
    TO.Stimuli.BDM.Fixation                                                              = MakeFixation('Cross',VisParam.scr_handle, [250 0 0]); %RED
    TO.Stimuli.BCb.Fixation                                                              = MakeFixation('Square',VisParam.scr_handle, [250 0 0]);%RED
end

TO.Stimuli.BCs.Fixation         = MakeFixation('Square',VisParam.scr_handle, [0 0 250]);

% Stimulus covers:
TO.Stimuli.BCs.CoverLeft        = MakeBCCover('Left', VisParam.scr_handle, [0 0 0]);
TO.Stimuli.BCs.CoverRight       = MakeBCCover('Right', VisParam.scr_handle, [0 0 0]);
TO.Stimuli.BDM.CoverLeft        = MakeBCCover('Left', VisParam.scr_handle, [0 0 0]);
TO.Stimuli.BDM.CoverRight       = MakeBCCover('Right', VisParam.scr_handle, [0 0 0]);
TO.Stimuli.BDM.CoverCent        = MakeBCCover('Centre', VisParam.scr_handle, [0 0 0]);

% First price:
TO.Stimuli.BDM.CoverLeft_FP     = MakeBCCover('Left', VisParam.scr_handle, [25 25 125]);
TO.Stimuli.BDM.CoverRight_FP    = MakeBCCover('Right', VisParam.scr_handle, [25 25 125]);
TO.Stimuli.BDM.NormalBKG_FP     = MakeBkg(VisParam.scr_handle, [25 25 125]);

% Backgrounds:
TO.Stimuli.BDM.ITIBKG           = MakeBkg(VisParam.scr_handle, [0 0 200]);
TO.Stimuli.BCs.NormalBKG        = MakeBkg(VisParam.scr_handle, [0 0 0]);
TO.Stimuli.BCs.ErrorBKG         = MakeBkg(VisParam.scr_handle, [125 125 125]);
TO.Stimuli.BDM.NormalBKG        = MakeBkg(VisParam.scr_handle, [0 0 0]);
TO.Stimuli.BDM.ErrorBKG         = MakeBkg(VisParam.scr_handle, [125 125 125]);

% RISKY:
TO.Stimuli.Risky.Deliveries     = ones(1,1000);