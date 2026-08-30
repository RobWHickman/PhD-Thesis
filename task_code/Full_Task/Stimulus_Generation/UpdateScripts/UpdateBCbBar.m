global TP TO VisParam

if strcmp(TP.BDM.CurrencyType,'W')
    TO.Rewards.Water.Type                                                                = 'Water';
    [TO.Rewards.Water.BCb.BarLeftPosition, TO.Rewards.Water.BCb.BarLBorder, TO.Stimuli.BarLPos_b]   = MakeBDMBar('Left',VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, TP.BCb.LeftLimit, TP.BCb.LeftLimit, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
    [TO.Rewards.Water.BCb.BarRightPosition, TO.Rewards.Water.BCb.BarRBorder, TO.Stimuli.BarRPos_b]  = MakeBDMBar('Right',VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, TP.BCb.RightLimit, TP.BCb.RightLimit, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
elseif strcmp(TP.BDM.CurrencyType,'B')
    TO.Rewards.Water.Type                                                                = 'Blackcurrant';
    [TO.Rewards.Water.BCb.BarLeftPosition, TO.Rewards.Water.BCb.BarLBorder, TO.Stimuli.BarLPos_b]   = MakeBDMBar('Left',VisParam.scr_handle, TO.Stimuli.Bar.Juice_Color, TP.BCb.LeftLimit, TP.BCb.LeftLimit, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
    [TO.Rewards.Water.BCb.BarRightPosition, TO.Rewards.Water.BCb.BarRBorder, TO.Stimuli.BarRPos_b]  = MakeBDMBar('Right',VisParam.scr_handle, TO.Stimuli.Bar.Juice_Color, TP.BCb.RightLimit, TP.BCb.RightLimit, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
end

% BCb Bar covers:
[~, TO.Rewards.Water.BCb.BlackoutL, ~]   = MakeBDMBar2('Left',VisParam.scr_handle, [0 0 0], TP.BCb.LeftLimit, TP.BCb.LeftLimit, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, [0 0 0], TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
[~, TO.Rewards.Water.BCb.BlackoutR, ~]   = MakeBDMBar2('Right',VisParam.scr_handle, [0 0 0], TP.BCb.RightLimit, TP.BCb.RightLimit, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, [0 0 0], TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);

% BC Bar:
[TO.Rewards.Water.BCs.BarLeftPosition, BarLPos]     = MakeBCBar('Left',VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, TP.BCs.LeftLimit, TP.BCs.RightLimit);
[TO.Rewards.Water.BCs.BarRightPosition, BarRPos]    = MakeBCBar('Right',VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, TP.BCs.LeftLimit, TP.BCs.RightLimit);

TO.Rewards.Water.BCs.DefMarkerLeftPosition          = [BarLPos(1), BarLPos(4)- TO.Rewards.Water.BCb.ValHeight, BarLPos(3), BarLPos(4)];
TO.Rewards.Water.BCs.DefMarkerRightPosition         = [BarRPos(1), BarRPos(4)- TO.Rewards.Water.BCb.ValHeight, BarRPos(3), BarRPos(4)];

TO.Params.BCs.BarRange                              = BarRPos(4) - BarRPos(2)- TO.Rewards.Water.BCb.ValHeight;

% BCb Scale:
if TO.Stimuli.Control.MainScale
    TO.Rewards.Water.BCb.LScale                         = MakeScale(VisParam.scr_handle, TO.Stimuli.Bar.Water_SColor, TO.Stimuli.Bar.Water_SLines, TO.Stimuli.BarLPos_b, TO.Stimuli.Bar.Water_SWidth);
    TO.Rewards.Water.BCb.RScale                         = MakeScale(VisParam.scr_handle, TO.Stimuli.Bar.Water_SColor, TO.Stimuli.Bar.Water_SLines, TO.Stimuli.BarRPos_b, TO.Stimuli.Bar.Water_SWidth);
else
    TO.Rewards.Water.BCb.LScale                         = ' ';
    TO.Rewards.Water.BCb.RScale                         = ' ';
end

if TO.Stimuli.Control.FineScale
    TO.Rewards.Water.BCb.LFineScale                     = MakeFineScale(VisParam.scr_handle, TO.Stimuli.Bar.Water_SColor, TO.Stimuli.Bar.Water_fSLines, TO.Stimuli.BarLPos_b, TO.Stimuli.Bar.Water_fSWidth);
    TO.Rewards.Water.BCb.RFineScale                     = MakeFineScale(VisParam.scr_handle, TO.Stimuli.Bar.Water_SColor, TO.Stimuli.Bar.Water_fSLines, TO.Stimuli.BarRPos_b, TO.Stimuli.Bar.Water_fSWidth);
else
    TO.Rewards.Water.BCb.LFineScale                     = ' ';
    TO.Rewards.Water.BCb.RFineScale                     = ' ';
end

% BCb Marker:
TO.Rewards.Water.BCb.DefMarkerLeftPosition          = [TO.Stimuli.BarLPos_b(1), TO.Stimuli.BarLPos_b(4)- TO.Rewards.Water.BCb.ValHeight, TO.Stimuli.BarLPos_b(3), TO.Stimuli.BarLPos_b(4)];
TO.Rewards.Water.BCb.DefMarkerRightPosition         = [TO.Stimuli.BarRPos_b(1), TO.Stimuli.BarRPos_b(4)- TO.Rewards.Water.BCb.ValHeight, TO.Stimuli.BarRPos_b(3), TO.Stimuli.BarRPos_b(4)];

% BCb PayRect:
TO.Stimuli.BCb.PayRect.LDefPos                      = [TO.Stimuli.BarLPos_b(1), TO.Stimuli.BarLPos_b(4), TO.Stimuli.BarLPos_b(3), TO.Stimuli.BarLPos_b(4)];
TO.Stimuli.BCb.PayRect.RDefPos                      = [TO.Stimuli.BarRPos_b(1), TO.Stimuli.BarRPos_b(4), TO.Stimuli.BarRPos_b(3), TO.Stimuli.BarRPos_b(4)];

% BCb Bar Params:
TO.Params.BCb.BarRange                              = TO.Stimuli.BarLPos_b(4) - TO.Stimuli.BarLPos_b(2);