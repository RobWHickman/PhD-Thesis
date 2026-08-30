function UpdateFractals(BHV, BMV, BLV, OHV, OMV, OLV, WHV, WMV, WLV, NRV)

global TP TO

FN  = TP.Rewards.FractalNames;

% High Value Blackcurrant Reward:
TO.Rewards.B_High.Volume    = BHV;
TO.Rewards.B_High.Type      = 'Blackcurrant';
TO.Rewards.B_High.PCoeffs    = [4, 4];
[TO.Rewards.B_High.BDM.Position, TO.Rewards.B_High.BDM.FramePosition] = MakeBDMFrac('Left', FN{1}, 1, TO.Stimuli.Frac.BDM_Lc, TO.Stimuli.Frac.BDM_Rc, TO.Stimuli.Frac.BColor, TO.Stimuli.Frac.BWidth);
[TO.Rewards.B_High.BCs.LeftPosition, ~]  = MakeBCFrac('Left', FN{1}, 7, TP.BCs.LeftLimit, TP.BCs.RightLimit);
[TO.Rewards.B_High.BCs.RightPosition, ~] = MakeBCFrac('Right', FN{1}, 8, TP.BCs.RightLimit, TP.BCs.RightLimit);
[TO.Rewards.B_High.BCb.LeftPosition, TO.Rewards.B_High.BCb.LeftPositionFrame]  = MakeBCFrac('Left', FN{1}, 9, TP.BCb.LeftLimit1, TP.BCb.LeftLimit1);
[TO.Rewards.B_High.BCb.RightPosition, TO.Rewards.B_High.BCb.RightPositionFrame] = MakeBCFrac('Right', FN{1}, 10, TP.BCb.RightLimit2, TP.BCb.RightLimit2);
% Mid Value Blackcurrant Reward:
TO.Rewards.B_Mid.Volume    = BMV;
TO.Rewards.B_Mid.Type      = 'Blackcurrant';
TO.Rewards.B_Mid.PCoeffs   = [4, 4];
[TO.Rewards.B_Mid.BDM.Position, TO.Rewards.B_Mid.BDM.FramePosition] = MakeBDMFrac('Left', FN{2}, 2, TO.Stimuli.Frac.BDM_Lc, TO.Stimuli.Frac.BDM_Rc, TO.Stimuli.Frac.BColor, TO.Stimuli.Frac.BWidth);
[TO.Rewards.B_Mid.BCs.LeftPosition, ~]  = MakeBCFrac('Left', FN{2}, 11, TP.BCs.LeftLimit, TP.BCs.RightLimit);
[TO.Rewards.B_Mid.BCs.RightPosition, ~] = MakeBCFrac('Right', FN{2}, 12, TP.BCs.RightLimit, TP.BCs.RightLimit);
[TO.Rewards.B_Mid.BCb.LeftPosition, TO.Rewards.B_Mid.BCb.LeftPositionFrame]  = MakeBCFrac('Left', FN{2}, 13, TP.BCb.LeftLimit1, TP.BCb.LeftLimit1);
[TO.Rewards.B_Mid.BCb.RightPosition, TO.Rewards.B_Mid.BCb.RightPositionFrame] = MakeBCFrac('Right', FN{2}, 14, TP.BCb.RightLimit2, TP.BCb.RightLimit2);
% Low Value Blackcurrant Reward:
TO.Rewards.B_Low.Volume    = BLV;
TO.Rewards.B_Low.Type      = 'Blackcurrant';
TO.Rewards.B_Low.PCoeffs   = [4, 4];
[TO.Rewards.B_Low.BDM.Position, TO.Rewards.B_Low.BDM.FramePosition] = MakeBDMFrac('Left', FN{3}, 3, TO.Stimuli.Frac.BDM_Lc, TO.Stimuli.Frac.BDM_Rc, TO.Stimuli.Frac.BColor, TO.Stimuli.Frac.BWidth);
[TO.Rewards.B_Low.BCs.LeftPosition, ~]  = MakeBCFrac('Left', FN{3}, 15, TP.BCs.LeftLimit, TP.BCs.RightLimit);
[TO.Rewards.B_Low.BCs.RightPosition, ~] = MakeBCFrac('Right', FN{3}, 16, TP.BCs.RightLimit, TP.BCs.RightLimit);
[TO.Rewards.B_Low.BCb.LeftPosition, TO.Rewards.B_Low.BCb.LeftPositionFrame]  = MakeBCFrac('Left', FN{3}, 17, TP.BCb.LeftLimit1, TP.BCb.LeftLimit1);
[TO.Rewards.B_Low.BCb.RightPosition, TO.Rewards.B_Low.BCb.RightPositionFrame] = MakeBCFrac('Right', FN{3}, 18, TP.BCb.RightLimit2, TP.BCb.RightLimit2);
% High value water reward:
TO.Rewards.W_High.Volume    = WHV;
TO.Rewards.W_High.Type      = 'Water';
TO.Rewards.W_High.PCoeffs    = [4, 4];
[TO.Rewards.W_High.BDM.Position, TO.Rewards.W_High.BDM.FramePosition] = MakeBDMFrac('Left', FN{4}, 4, TO.Stimuli.Frac.BDM_Lc, TO.Stimuli.Frac.BDM_Rc, TO.Stimuli.Frac.BColor, TO.Stimuli.Frac.BWidth);
[TO.Rewards.W_High.BCs.LeftPosition, ~]  = MakeBCFrac('Left', FN{4}, 19, TP.BCs.LeftLimit, TP.BCs.RightLimit);
[TO.Rewards.W_High.BCs.RightPosition, ~] = MakeBCFrac('Right', FN{4}, 20, TP.BCs.RightLimit, TP.BCs.RightLimit);
[TO.Rewards.W_High.BCb.LeftPosition, TO.Rewards.W_High.BCb.LeftPositionFrame]  = MakeBCFrac('Left', FN{4}, 21, TP.BCb.LeftLimit1, TP.BCb.LeftLimit1);
[TO.Rewards.W_High.BCb.RightPosition, TO.Rewards.W_High.BCb.RightPositionFrame] = MakeBCFrac('Right', FN{4}, 22, TP.BCb.RightLimit2, TP.BCb.RightLimit2);
% Mid Value water Reward:
TO.Rewards.W_Mid.Volume    = WMV;
TO.Rewards.W_Mid.Type      = 'Water';
TO.Rewards.W_Mid.PCoeffs   = [4, 4];
[TO.Rewards.W_Mid.BDM.Position, TO.Rewards.W_Mid.BDM.FramePosition] = MakeBDMFrac('Left', FN{5}, 5, TO.Stimuli.Frac.BDM_Lc, TO.Stimuli.Frac.BDM_Rc, TO.Stimuli.Frac.BColor, TO.Stimuli.Frac.BWidth);
[TO.Rewards.W_Mid.BCs.LeftPosition, ~]  = MakeBCFrac('Left', FN{5}, 23, TP.BCs.LeftLimit, TP.BCs.RightLimit);
[TO.Rewards.W_Mid.BCs.RightPosition, ~] = MakeBCFrac('Right', FN{5}, 24, TP.BCs.RightLimit, TP.BCs.RightLimit);
[TO.Rewards.W_Mid.BCb.LeftPosition, TO.Rewards.W_Mid.BCb.LeftPositionFrame]  = MakeBCFrac('Left', FN{5}, 25, TP.BCb.LeftLimit1, TP.BCb.LeftLimit1);
[TO.Rewards.W_Mid.BCb.RightPosition, TO.Rewards.W_Mid.BCb.RightPositionFrame] = MakeBCFrac('Right', FN{5}, 26, TP.BCb.RightLimit2, TP.BCb.RightLimit2);
% Low Value water Reward:
TO.Rewards.W_Low.Volume    = WLV;
TO.Rewards.W_Low.Type      = 'Water';
TO.Rewards.W_Low.PCoeffs   = [4, 4];
[TO.Rewards.W_Low.BDM.Position, TO.Rewards.W_Low.BDM.FramePosition] = MakeBDMFrac('Left', FN{6}, 6, TO.Stimuli.Frac.BDM_Lc, TO.Stimuli.Frac.BDM_Rc, TO.Stimuli.Frac.BColor, TO.Stimuli.Frac.BWidth);
[TO.Rewards.W_Low.BCs.LeftPosition, ~]  = MakeBCFrac('Left', FN{6}, 27, TP.BCs.LeftLimit, TP.BCs.RightLimit);
[TO.Rewards.W_Low.BCs.RightPosition, ~] = MakeBCFrac('Right', FN{6}, 28, TP.BCs.RightLimit, TP.BCs.RightLimit);
[TO.Rewards.W_Low.BCb.LeftPosition, TO.Rewards.W_Low.BCb.LeftPositionFrame]  = MakeBCFrac('Left', FN{6}, 29, TP.BCb.LeftLimit1, TP.BCb.LeftLimit1);
[TO.Rewards.W_Low.BCb.RightPosition, TO.Rewards.W_Low.BCb.RightPositionFrame] = MakeBCFrac('Right', FN{6}, 30, TP.BCb.RightLimit2, TP.BCb.RightLimit2);
% High value orange reward:
TO.Rewards.O_High.Volume    = OHV;
TO.Rewards.O_High.Type      = 'Water';
TO.Rewards.O_High.PCoeffs    = [4, 4];
[TO.Rewards.O_High.BDM.Position, TO.Rewards.O_High.BDM.FramePosition] = MakeBDMFrac('Left', FN{7}, 31, TO.Stimuli.Frac.BDM_Lc, TO.Stimuli.Frac.BDM_Rc, TO.Stimuli.Frac.BColor, TO.Stimuli.Frac.BWidth);
[TO.Rewards.O_High.BCs.LeftPosition, ~]  = MakeBCFrac('Left', FN{7}, 32, TP.BCs.LeftLimit, TP.BCs.RightLimit);
[TO.Rewards.O_High.BCs.RightPosition, ~] = MakeBCFrac('Right', FN{7}, 33, TP.BCs.RightLimit, TP.BCs.RightLimit);
[TO.Rewards.O_High.BCb.LeftPosition, TO.Rewards.O_High.BCb.LeftPositionFrame]  = MakeBCFrac('Left', FN{7}, 34, TP.BCb.LeftLimit1, TP.BCb.LeftLimit1);
[TO.Rewards.O_High.BCb.RightPosition, TO.Rewards.O_High.BCb.RightPositionFrame] = MakeBCFrac('Right', FN{7}, 35, TP.BCb.RightLimit2, TP.BCb.RightLimit2);
% Mid Value orange Reward:
TO.Rewards.O_Mid.Volume    = OMV;
TO.Rewards.O_Mid.Type      = 'Water';
TO.Rewards.O_Mid.PCoeffs   = [4, 4];
[TO.Rewards.O_Mid.BDM.Position, TO.Rewards.O_Mid.BDM.FramePosition] = MakeBDMFrac('Left', FN{8}, 36, TO.Stimuli.Frac.BDM_Lc, TO.Stimuli.Frac.BDM_Rc, TO.Stimuli.Frac.BColor, TO.Stimuli.Frac.BWidth);
[TO.Rewards.O_Mid.BCs.LeftPosition, ~]  = MakeBCFrac('Left', FN{8}, 37, TP.BCs.LeftLimit, TP.BCs.RightLimit);
[TO.Rewards.O_Mid.BCs.RightPosition, ~] = MakeBCFrac('Right', FN{8}, 38, TP.BCs.RightLimit, TP.BCs.RightLimit);
[TO.Rewards.O_Mid.BCb.LeftPosition, TO.Rewards.O_Mid.BCb.LeftPositionFrame]  = MakeBCFrac('Left', FN{8}, 39, TP.BCb.LeftLimit1, TP.BCb.LeftLimit1);
[TO.Rewards.O_Mid.BCb.RightPosition, TO.Rewards.O_Mid.BCb.RightPositionFrame] = MakeBCFrac('Right', FN{8}, 40, TP.BCb.RightLimit2, TP.BCb.RightLimit2);
% Low Value orange Reward:
TO.Rewards.O_Low.Volume    = OLV;
TO.Rewards.O_Low.Type      = 'Water';
TO.Rewards.O_Low.PCoeffs   = [4, 4];
[TO.Rewards.O_Low.BDM.Position, TO.Rewards.O_Low.BDM.FramePosition] = MakeBDMFrac('Left', FN{9}, 41, TO.Stimuli.Frac.BDM_Lc, TO.Stimuli.Frac.BDM_Rc, TO.Stimuli.Frac.BColor, TO.Stimuli.Frac.BWidth);
[TO.Rewards.O_Low.BCs.LeftPosition, ~]  = MakeBCFrac('Left', FN{9}, 42, TP.BCs.LeftLimit, TP.BCs.RightLimit);
[TO.Rewards.O_Low.BCs.RightPosition, ~] = MakeBCFrac('Right', FN{9}, 43, TP.BCs.RightLimit, TP.BCs.RightLimit);
[TO.Rewards.O_Low.BCb.LeftPosition, TO.Rewards.O_Low.BCb.LeftPositionFrame]  = MakeBCFrac('Left', FN{9}, 44, TP.BCb.LeftLimit1, TP.BCb.LeftLimit1);
[TO.Rewards.O_Low.BCb.RightPosition, TO.Rewards.O_Low.BCb.RightPositionFrame] = MakeBCFrac('Right', FN{9}, 45, TP.BCb.RightLimit2, TP.BCb.RightLimit2);
% No Value Reward:
TO.Rewards.NR.Volume    = NRV;
TO.Rewards.NR.Type   = 'Blackcurrant';
TO.Rewards.NR.PCoeffs   = [4, 4];
[TO.Rewards.NR.BDM.Position, TO.Rewards.NR.BDM.FramePosition] = MakeBDMFrac('Left', FN{10}, 46, TO.Stimuli.Frac.BDM_Lc, TO.Stimuli.Frac.BDM_Rc, TO.Stimuli.Frac.BColor, TO.Stimuli.Frac.BWidth);
[TO.Rewards.NR.BCs.LeftPosition, ~]  = MakeBCFrac('Left', FN{10}, 47, TP.BCs.LeftLimit, TP.BCs.RightLimit);
[TO.Rewards.NR.BCs.RightPosition, ~] = MakeBCFrac('Right', FN{10}, 48, TP.BCs.RightLimit, TP.BCs.RightLimit);
[TO.Rewards.NR.BCb.LeftPosition, TO.Rewards.NR.BCb.LeftPositionFrame]  = MakeBCFrac('Left', FN{10}, 49, TP.BCb.LeftLimit1, TP.BCb.LeftLimit1);
[TO.Rewards.NR.BCb.RightPosition, TO.Rewards.NR.BCb.RightPositionFrame] = MakeBCFrac('Right', FN{10}, 50, TP.BCb.RightLimit2, TP.BCb.RightLimit2);
[TO.Stimuli.BCb.RightFracCover] = BCFracCover('Right', TP.BCb.RightLimit2, TP.BCb.RightLimit2);
[TO.Stimuli.BCb.LeftFracCover] = BCFracCover('Left', TP.BCb.LeftLimit1, TP.BCb.LeftLimit1);
