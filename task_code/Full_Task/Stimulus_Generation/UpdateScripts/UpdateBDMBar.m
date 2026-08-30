global TP VisParam TO

% Make Bar and get position data:
if strcmp(TP.BDM.CurrencyType,'W')
    TO.Rewards.Water.Type                                                      = 'Water';
    [TO.Rewards.Water.BDM.Bar, TO.Rewards.Water.BDM.Border, TO.Stimuli.BarPos] = MakeBDMBar('Right', VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, TO.Stimuli.Bar.Lc, TO.Stimuli.Bar.Rc, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
elseif strcmp(TP.BDM.CurrencyType,'B')
    TO.Rewards.Water.Type                                                      = 'Blackcurrant';
    [TO.Rewards.Water.BDM.Bar, TO.Rewards.Water.BDM.Border, TO.Stimuli.BarPos] = MakeBDMBar('Right', VisParam.scr_handle, TO.Stimuli.Bar.Juice_Color, TO.Stimuli.Bar.Lc, TO.Stimuli.Bar.Rc, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
end

TP.BDM.D_VarPosVec  = randi(TO.Params.BDM.D_nDivs, 1000, 1);

% Create scale:
if TO.Stimuli.Control.MainScale
    TO.Rewards.Water.BDM.Scale                          = MakeScale(VisParam.scr_handle, TO.Stimuli.Bar.Water_SColor, TO.Stimuli.Bar.Water_SLines, TO.Stimuli.BarPos, TO.Stimuli.Bar.Water_SWidth);
else
    TO.Rewards.Water.BDM.Scale                          = ' ';
end

if TO.Stimuli.Control.FineScale
    TO.Rewards.Water.BDM.FineScale                      = MakeFineScale(VisParam.scr_handle, TO.Stimuli.Bar.Water_SColor, TO.Stimuli.Bar.Water_fSLines, TO.Stimuli.BarPos, TO.Stimuli.Bar.Water_fSWidth);
else
    TO.Rewards.Water.BDM.FineScale                      = ' ';
end
% Marker parameters:
TO.Rewards.Water.BDM.MMIniPos                       = [TO.Stimuli.BarPos(1), TO.Stimuli.BarPos(4) - (TO.Stimuli.MMarker.C_Height), TO.Stimuli.BarPos(3) + TO.Stimuli.MMarker.C_Width, TO.Stimuli.BarPos(4)];
TO.Rewards.Water.BDM.MMDefPos                       = [TO.Stimuli.BarPos(1), TO.Stimuli.BarPos(4) - (TO.Stimuli.MMarker.C_Height), TO.Stimuli.BarPos(3) + TO.Stimuli.MMarker.C_Width, TO.Stimuli.BarPos(4)];
TO.Rewards.Water.BDM.MMPos                          = TO.Rewards.Water.BDM.MMDefPos;

TO.Rewards.Water.BDM.CMDefPos                       = [TO.Stimuli.BarPos(1), TO.Stimuli.BarPos(4) - TO.Stimuli.CMarker.C_Height, TO.Stimuli.BarPos(3) + TO.Stimuli.CMarker.C_Width, TO.Stimuli.BarPos(4)];

% Bar parameters:
TO.Params.BDM.BarRange                              = TO.Stimuli.BDM.BarHeight - TO.Stimuli.MMarker.C_Height;
TO.Params.BDM.BarMin                                = TO.Stimuli.BarPos(2);          
TO.Params.BDM.BarMax                                = TO.Stimuli.BarPos(4);

% PayRect:
TO.Stimuli.BDM.PayRect.DefPos   = [TO.Stimuli.BarPos(1), TO.Stimuli.BarPos(4), TO.Stimuli.BarPos(3), TO.Stimuli.BarPos(4)];

% Touchscreen zone:
TO.Stimuli.BDM.TouchZone        = TO.Stimuli.BarPos;

UpdateBCbBar;

% Discrete bar stimuli:
DiscreteBar(TO.Params.BDM.D_nDivs,TO.Stimuli.BDM.D_DivSpacing,TO.Stimuli.BDM.D_MBidEdge,TO.Stimuli.BDM.D_CBidEdge);

TO.Rewards.Water.BDM.DMMDefPos      = TO.Stimuli.BDM.D_PosMat(1,:);
TO.Rewards.Water.BDM.DMMDefPos(3)   = TO.Rewards.Water.BDM.DMMDefPos(3) + TO.Stimuli.BDM.D_MBidEdge;

% Forced bid targets:
ForcedBidTarget(TO.Params.BDM.D_nDivs,TP.BDMf.Sorting);