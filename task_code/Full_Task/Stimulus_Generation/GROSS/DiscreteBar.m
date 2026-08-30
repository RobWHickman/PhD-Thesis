function DiscreteBar(nDivs,DivSpacing,MBidEdge,CBidEdge)

global VisParam TO TP TC

TO.Stimuli.BDM.D_BasePos   = TO.Stimuli.BarPos;
TO.Stimuli.BCb.D_LBasePos  = TO.Stimuli.BarLPos_b;
TO.Stimuli.BCb.D_RBasePos  = TO.Stimuli.BarRPos_b;

TO.Stimuli.BDM.D_DivHeight                          = (TO.Stimuli.BDM.BarHeight - (DivSpacing*(nDivs-1)))/nDivs;

TO.Stimuli.BDM.D_MBidEdge                           = MBidEdge;
TO.Stimuli.BDM.D_CBidEdge                           = CBidEdge;

[TO.Rewards.Water.BDM.DBar, TO.Stimuli.BDM.D_PosMat]= MakeBDMDBar(VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, TO.Stimuli.BDM.D_DivHeight, TO.Stimuli.BDM.D_BasePos, nDivs, DivSpacing);



% Dependent on spacing and nDivs:
TO.Params.BDM.D_LowerLims                           = TO.Stimuli.BDM.D_PosMat(:,2); % Higher up on screen;
TO.Params.BDM.D_UpperLims                           = TO.Stimuli.BDM.D_PosMat(:,4); % Lower down on screen;

% For pavlovian version, forced bids are dependent upon nDivs:
TP.BDM.PAV_BidsD                                    = repmat([1:nDivs],1,1000);
TP.BCb.WaterSet                                     = [0:1/nDivs:1];
TC.BCb.WaterOffers                                  = PermVecInBlock(TP.BCb.WaterSet, 125);
TP.BDM.PAV_BidsC                                    = (randi(nDivs+1,1,1000)-1)/nDivs;

% BCb discrete stimuli:
[TO.Rewards.Water.BDM.DLBar, TO.Stimuli.BDM.D_LPosMat]= MakeBDMDBar(VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, TO.Stimuli.BDM.D_DivHeight, TO.Stimuli.BCb.D_LBasePos, nDivs, DivSpacing);
[TO.Rewards.Water.BDM.DRBar, TO.Stimuli.BDM.D_RPosMat]= MakeBDMDBar(VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, TO.Stimuli.BDM.D_DivHeight, TO.Stimuli.BCb.D_RBasePos, nDivs, DivSpacing);