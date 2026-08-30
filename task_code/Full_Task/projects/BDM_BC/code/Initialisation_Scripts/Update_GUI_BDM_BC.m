%Update GUI

global TG TC TP TO

% Update consumption data:
set(TG.BDM_BC_GUI.Handles.All_Water_Consumed,'String',num2str(TC.All.Consumption.Water, '%.3g'));
set(TG.BDM_BC_GUI.Handles.All_Juice_Consumed,'String',num2str(TC.All.Consumption.Juice, '%.3g'));
set(TG.BDM_BC_GUI.Handles.All_Total_Consumed,'String',num2str(TC.All.Consumption.Total, '%.3g'));

set(TG.BDM_BC_GUI.Handles.BCb_Water_Consumed,'String',num2str(TC.BCb.Consumption.Water, '%.3g'));
set(TG.BDM_BC_GUI.Handles.BCb_Juice_Consumed,'String',num2str(TC.BCb.Consumption.Juice, '%.3g'));
set(TG.BDM_BC_GUI.Handles.BCb_Total_Consumed,'String',num2str(TC.BCb.Consumption.Total, '%.3g'));

set(TG.BDM_BC_GUI.Handles.BDM_Water_Consumed,'String',num2str(TC.BDM.Consumption.Water, '%.3g'));
set(TG.BDM_BC_GUI.Handles.BDM_Juice_Consumed,'String',num2str(TC.BDM.Consumption.Juice, '%.3g'));
set(TG.BDM_BC_GUI.Handles.BDM_Total_Consumed,'String',num2str(TC.BDM.Consumption.Total, '%.3g'));

% Update error data:
set(TG.BDM_BC_GUI.Handles.All_Error_NoHold,'String',num2str(TC.All.Error.nNoHold, '%d'));
set(TG.BDM_BC_GUI.Handles.All_Error_NoChoice,'String',num2str(TC.All.Error.nNoChoice, '%d'));
set(TG.BDM_BC_GUI.Handles.All_Error_NotCentred,'String',num2str(TC.All.Error.nNotCentred, '%d'));
set(TG.BDM_BC_GUI.Handles.All_Error_Count,'String',num2str(TC.All.Error.nError, '%d'));
set(TG.BDM_BC_GUI.Handles.All_Error_OutTouch,'String',num2str(TC.All.Error.nOutTouch, '%d'));
set(TG.BDM_BC_GUI.Handles.All_Error_SecondTouch,'String',num2str(TC.All.Error.nSecondTouch, '%d'));
set(TG.BDM_BC_GUI.Handles.All_Error_TargetMiss,'String',num2str(TC.All.Error.nTargetMiss, '%d'));

set(TG.BDM_BC_GUI.Handles.BDM_Error_NoHold,'String',num2str(TC.BDM.Error.nNoHold, '%d'));
set(TG.BDM_BC_GUI.Handles.BDM_Error_NoChoice,'String',num2str(TC.BDM.Error.nNoBid, '%d'));
set(TG.BDM_BC_GUI.Handles.BDM_Error_NotCentred,'String',num2str(TC.BDM.Error.nNotCentred, '%d'));
set(TG.BDM_BC_GUI.Handles.BDM_Error_Count,'String',num2str(TC.BDM.Error.nError, '%d'));
set(TG.BDM_BC_GUI.Handles.BDM_Error_OutTouch,'String',num2str(TC.BDM.Error.nOutTouch, '%d'));
set(TG.BDM_BC_GUI.Handles.BDM_Error_SecondTouch,'String',num2str(TC.BDM.Error.nSecondTouch, '%d'));
set(TG.BDM_BC_GUI.Handles.BDM_Error_TargetMiss,'String',num2str(TC.BDM.Error.nTargetMiss, '%d'));

set(TG.BDM_BC_GUI.Handles.BCb_Error_NoHold,'String',num2str(TC.BCb.Error.nNoHold, '%d'));
set(TG.BDM_BC_GUI.Handles.BCb_Error_NoChoice,'String',num2str(TC.BCb.Error.nNoChoice, '%d'));
set(TG.BDM_BC_GUI.Handles.BCb_Error_NotCentred,'String',num2str(TC.BCb.Error.nNotCentred, '%d'));
set(TG.BDM_BC_GUI.Handles.BCb_Error_Count,'String',num2str(TC.BCb.Error.nError, '%d'));
set(TG.BDM_BC_GUI.Handles.BCb_Error_OutTouch,'String',num2str(TC.BCb.Error.nOutTouch, '%d'));
set(TG.BDM_BC_GUI.Handles.BCb_Error_SecondTouch,'String',num2str(TC.BCb.Error.nSecondTouch, '%d'));

% Current trial data:
TrialNumber = TC.All.TrialNC;
if TrialNumber > 0
    switch TC.All.TrialType(TrialNumber)
        case 1 % BDM
            if TC.BDM.TrialNC >= 1
            TSN        = TC.BDM.TrialNC;
            PreviousID = TC.BDM.RewardIDs(TSN);
            CurrentID  = TC.BDM.RewardIDs(TSN+1);
            NextID     = TC.BDM.RewardIDs(TSN+2);
            
            set(TG.BDM_BC_GUI.Handles.All_Past_RewardID,'String',num2str(PreviousID, '%d'));
            set(TG.BDM_BC_GUI.Handles.All_Current_RewardID,'String',num2str(CurrentID, '%d'));
            set(TG.BDM_BC_GUI.Handles.All_Next_RewardID,'String',num2str(NextID, '%d'));
            end
        case 3 % BCb
            if TC.BCb.TrialNC >= 1
            TSN        = TC.BCb.TrialNC;
            PreviousID = TC.BCb.RewardIDs(TSN);
            CurrentID  = TC.BCb.RewardIDs(TSN+1);
            NextID     = TC.BCb.RewardIDs(TSN+2);
            
                set(TG.BDM_BC_GUI.Handles.All_Past_RewardID,'String',num2str(PreviousID, '%d'));
                set(TG.BDM_BC_GUI.Handles.All_Current_RewardID,'String',num2str(CurrentID, '%d'));
                set(TG.BDM_BC_GUI.Handles.All_Next_RewardID,'String',num2str(NextID, '%d'));
            end
    end
end

% Trial numbers
set(TG.BDM_BC_GUI.Handles.All_TrialN,'String',num2str(TC.All.TrialN, '%d'));
set(TG.BDM_BC_GUI.Handles.All_TrialNC,'String',num2str(TC.All.TrialNC, '%d'));
set(TG.BDM_BC_GUI.Handles.BDM_TrialN,'String',num2str(TC.BDM.TrialN, '%d'));
set(TG.BDM_BC_GUI.Handles.BDM_TrialNC,'String',num2str(TC.BDM.TrialNC, '%d'));
set(TG.BDM_BC_GUI.Handles.BCb_TrialN,'String',num2str(TC.BCb.TrialN, '%d'));
set(TG.BDM_BC_GUI.Handles.BCb_TrialNC,'String',num2str(TC.BCb.TrialNC, '%d'));
Rate_All = 1 - (TC.All.Error.nError/TC.All.TrialN);
Rate_BDM = 1 - (TC.BDM.Error.nError/TC.BDM.TrialN);
Rate_BCb = 1 - (TC.BCb.Error.nError/TC.BCb.TrialN);
set(TG.BDM_BC_GUI.Handles.All_Rate,'String',num2str(Rate_All, '%.3g'));
set(TG.BDM_BC_GUI.Handles.BDM_Rate,'String',num2str(Rate_BDM, '%.3g'));
set(TG.BDM_BC_GUI.Handles.BCb_Rate,'String',num2str(Rate_BCb, '%.3g'));

% Mean M-Bids:
if strcmp(TC.All.Trial,'BDM') && TP.BDM.Error ~= 1
    TrialNumber = TC.BDM.TrialNC;
    if TrialNumber > 0
        switch TP.BDM.RewardID
            case 1
                TG.BDM.OL_MBidVec = [TG.BDM.OL_MBidVec, NaN];
                TG.BDM.OM_MBidVec = [TG.BDM.OM_MBidVec, NaN];
                TG.BDM.OH_MBidVec = [TG.BDM.OH_MBidVec, NaN];
                TG.BDM.BL_MBidVec = [TG.BDM.BL_MBidVec, NaN];
                TG.BDM.BM_MBidVec = [TG.BDM.BM_MBidVec, NaN];
                TG.BDM.BH_MBidVec = [TG.BDM.BH_MBidVec, (TP.BDM.MBID*TO.Rewards.Water.MaxVolume)];
                TG.BDM.WH_MBidVec = [TG.BDM.WH_MBidVec, NaN];
                TG.BDM.WM_MBidVec = [TG.BDM.WM_MBidVec, NaN];
                TG.BDM.WL_MBidVec = [TG.BDM.WL_MBidVec, NaN];
                TG.BDM.NR_MBidVec = [TG.BDM.NR_MBidVec, NaN];
                TG.BDM.BH_MeanMBid             = nanmean(TG.BDM.BH_MBidVec);
                TG.BDM.BH_StdMBid              = nanvar(TG.BDM.BH_MBidVec);
                TG.BDM.BH_MedMBid              = nanmedian(TG.BDM.BH_MBidVec);
                set(TG.BDM_BC_GUI.Handles.BH_Mean,'String',num2str(TG.BDM.BH_MeanMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.BH_Med,'String',num2str(TG.BDM.BH_MedMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.BH_Std,'String',num2str(TG.BDM.BH_StdMBid, '%.3g'));
            case 2
                TG.BDM.OL_MBidVec = [TG.BDM.OL_MBidVec, NaN];
                TG.BDM.OM_MBidVec = [TG.BDM.OM_MBidVec, NaN];
                TG.BDM.OH_MBidVec = [TG.BDM.OH_MBidVec, NaN];
                TG.BDM.BL_MBidVec = [TG.BDM.BL_MBidVec, NaN];
                TG.BDM.BH_MBidVec = [TG.BDM.BH_MBidVec, NaN];
                TG.BDM.BM_MBidVec = [TG.BDM.BM_MBidVec, (TP.BDM.MBID*TO.Rewards.Water.MaxVolume)];
                TG.BDM.WH_MBidVec = [TG.BDM.WH_MBidVec, NaN];
                TG.BDM.WM_MBidVec = [TG.BDM.WM_MBidVec, NaN];
                TG.BDM.WL_MBidVec = [TG.BDM.WL_MBidVec, NaN];
                TG.BDM.NR_MBidVec = [TG.BDM.NR_MBidVec, NaN];
                TG.BDM.BM_MeanMBid             = nanmean(TG.BDM.BM_MBidVec);
                TG.BDM.BM_StdMBid              = nanvar(TG.BDM.BM_MBidVec);
                TG.BDM.BM_MedMBid              = nanmedian(TG.BDM.BM_MBidVec);
                set(TG.BDM_BC_GUI.Handles.BM_Mean,'String',num2str(TG.BDM.BM_MeanMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.BM_Med,'String',num2str(TG.BDM.BM_MedMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.BM_Std,'String',num2str(TG.BDM.BM_StdMBid, '%.3g'));
            case 3
                TG.BDM.OL_MBidVec = [TG.BDM.OL_MBidVec, NaN];
                TG.BDM.OM_MBidVec = [TG.BDM.OM_MBidVec, NaN];
                TG.BDM.OH_MBidVec = [TG.BDM.OH_MBidVec, NaN];
                TG.BDM.BH_MBidVec = [TG.BDM.BH_MBidVec, NaN];
                TG.BDM.BM_MBidVec = [TG.BDM.BM_MBidVec, NaN];
                TG.BDM.BL_MBidVec = [TG.BDM.BL_MBidVec, (TP.BDM.MBID*TO.Rewards.Water.MaxVolume)];
                TG.BDM.WH_MBidVec = [TG.BDM.WH_MBidVec, NaN];
                TG.BDM.WM_MBidVec = [TG.BDM.WM_MBidVec, NaN];
                TG.BDM.WL_MBidVec = [TG.BDM.WL_MBidVec, NaN];
                TG.BDM.NR_MBidVec = [TG.BDM.NR_MBidVec, NaN];
                TG.BDM.BL_MeanMBid             = nanmean(TG.BDM.BL_MBidVec);
                TG.BDM.BL_StdMBid              = nanvar(TG.BDM.BL_MBidVec);
                TG.BDM.BL_MedMBid              = nanmedian(TG.BDM.BL_MBidVec);
                set(TG.BDM_BC_GUI.Handles.BL_Mean,'String',num2str(TG.BDM.BL_MeanMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.BL_Med,'String',num2str(TG.BDM.BL_MedMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.BL_Std,'String',num2str(TG.BDM.BL_StdMBid, '%.3g'));
            case 4
                TG.BDM.OL_MBidVec = [TG.BDM.OL_MBidVec, NaN];
                TG.BDM.OM_MBidVec = [TG.BDM.OM_MBidVec, NaN];
                TG.BDM.OH_MBidVec = [TG.BDM.OH_MBidVec, NaN];
                TG.BDM.BH_MBidVec = [TG.BDM.BH_MBidVec, NaN];
                TG.BDM.BM_MBidVec = [TG.BDM.BM_MBidVec, NaN];
                TG.BDM.BL_MBidVec = [TG.BDM.BL_MBidVec, NaN];
                TG.BDM.WH_MBidVec = [TG.BDM.WH_MBidVec, (TP.BDM.MBID*TO.Rewards.Water.MaxVolume)];
                TG.BDM.WM_MBidVec = [TG.BDM.WM_MBidVec, NaN];
                TG.BDM.WL_MBidVec = [TG.BDM.WL_MBidVec, NaN];
                TG.BDM.NR_MBidVec = [TG.BDM.NR_MBidVec, NaN];
                TG.BDM.WH_MeanMBid             = nanmean(TG.BDM.WH_MBidVec);
                TG.BDM.WH_StdMBid              = nanvar(TG.BDM.WH_MBidVec);
                TG.BDM.WH_MedMBid              = nanmedian(TG.BDM.WH_MBidVec);
                set(TG.BDM_BC_GUI.Handles.WH_Mean,'String',num2str(TG.BDM.WH_MeanMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.WH_Med,'String',num2str(TG.BDM.WH_MedMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.WH_Std,'String',num2str(TG.BDM.WH_StdMBid, '%.3g'));
            case 5
                TG.BDM.OL_MBidVec = [TG.BDM.OL_MBidVec, NaN];
                TG.BDM.OM_MBidVec = [TG.BDM.OM_MBidVec, NaN];
                TG.BDM.OH_MBidVec = [TG.BDM.OH_MBidVec, NaN];
                TG.BDM.BH_MBidVec = [TG.BDM.BH_MBidVec, NaN];
                TG.BDM.BM_MBidVec = [TG.BDM.BM_MBidVec, NaN];
                TG.BDM.BL_MBidVec = [TG.BDM.BL_MBidVec, NaN];
                TG.BDM.WH_MBidVec = [TG.BDM.WH_MBidVec, NaN];
                TG.BDM.WM_MBidVec = [TG.BDM.WM_MBidVec, (TP.BDM.MBID*TO.Rewards.Water.MaxVolume)];
                TG.BDM.WL_MBidVec = [TG.BDM.WL_MBidVec, NaN];
                TG.BDM.NR_MBidVec = [TG.BDM.NR_MBidVec, NaN];
                TG.BDM.WM_MeanMBid             = nanmean(TG.BDM.WM_MBidVec);
                TG.BDM.WM_StdMBid              = nanvar(TG.BDM.WM_MBidVec);
                TG.BDM.WM_MedMBid              = nanmedian(TG.BDM.WM_MBidVec);
                set(TG.BDM_BC_GUI.Handles.WM_Mean,'String',num2str(TG.BDM.WM_MeanMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.WM_Med,'String',num2str(TG.BDM.WM_MedMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.WM_Std,'String',num2str(TG.BDM.WM_StdMBid, '%.3g'));
            case 6
                TG.BDM.OL_MBidVec = [TG.BDM.OL_MBidVec, NaN];
                TG.BDM.OM_MBidVec = [TG.BDM.OM_MBidVec, NaN];
                TG.BDM.OH_MBidVec = [TG.BDM.OH_MBidVec, NaN];
                TG.BDM.BH_MBidVec = [TG.BDM.BH_MBidVec, NaN];
                TG.BDM.BM_MBidVec = [TG.BDM.BM_MBidVec, NaN];
                TG.BDM.BL_MBidVec = [TG.BDM.BL_MBidVec, NaN];
                TG.BDM.WH_MBidVec = [TG.BDM.WH_MBidVec, NaN];
                TG.BDM.WM_MBidVec = [TG.BDM.WM_MBidVec, NaN];
                TG.BDM.WL_MBidVec = [TG.BDM.WL_MBidVec, (TP.BDM.MBID*TO.Rewards.Water.MaxVolume)];
                TG.BDM.NR_MBidVec = [TG.BDM.NR_MBidVec, NaN];
                TG.BDM.WL_MeanMBid             = nanmean(TG.BDM.WL_MBidVec);
                TG.BDM.WL_StdMBid              = nanvar(TG.BDM.WL_MBidVec);
                TG.BDM.WL_MedMBid              = nanmedian(TG.BDM.WL_MBidVec);
                set(TG.BDM_BC_GUI.Handles.WL_Mean,'String',num2str(TG.BDM.WL_MeanMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.WL_Med,'String',num2str(TG.BDM.WL_MedMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.WL_Std,'String',num2str(TG.BDM.WL_StdMBid, '%.3g'));
            case 7
                TG.BDM.OL_MBidVec = [TG.BDM.OL_MBidVec, NaN];
                TG.BDM.OM_MBidVec = [TG.BDM.OM_MBidVec, NaN];
                TG.BDM.BH_MBidVec = [TG.BDM.BH_MBidVec, NaN];
                TG.BDM.BL_MBidVec = [TG.BDM.BL_MBidVec, NaN];
                TG.BDM.BM_MBidVec = [TG.BDM.BM_MBidVec, NaN];
                TG.BDM.OH_MBidVec               = [TG.BDM.OH_MBidVec, (TP.BDM.MBID*TO.Rewards.Water.MaxVolume)];
                TG.BDM.WH_MBidVec = [TG.BDM.WH_MBidVec, NaN];
                TG.BDM.WM_MBidVec = [TG.BDM.WM_MBidVec, NaN];
                TG.BDM.WL_MBidVec = [TG.BDM.WL_MBidVec, NaN];
                TG.BDM.NR_MBidVec = [TG.BDM.NR_MBidVec, NaN];
                TG.BDM.OH_MeanMBid             = nanmean(TG.BDM.OH_MBidVec);
                TG.BDM.OH_StdMBid              = nanvar(TG.BDM.OH_MBidVec);
                TG.BDM.OH_MedMBid              = nanmedian(TG.BDM.OH_MBidVec);
                set(TG.BDM_BC_GUI.Handles.OH_Mean,'String',num2str(TG.BDM.OH_MeanMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.OH_Med,'String',num2str(TG.BDM.OH_MedMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.OH_Std,'String',num2str(TG.BDM.OH_StdMBid, '%.3g'));
            case 8
                TG.BDM.OL_MBidVec = [TG.BDM.OL_MBidVec, NaN];
                TG.BDM.BH_MBidVec = [TG.BDM.BH_MBidVec, NaN];
                TG.BDM.OH_MBidVec = [TG.BDM.OH_MBidVec, NaN];
                TG.BDM.BL_MBidVec = [TG.BDM.BL_MBidVec, NaN];
                TG.BDM.BM_MBidVec = [TG.BDM.BM_MBidVec, NaN];
                TG.BDM.OM_MBidVec               = [TG.BDM.OM_MBidVec, (TP.BDM.MBID*TO.Rewards.Water.MaxVolume)];
                TG.BDM.WH_MBidVec = [TG.BDM.WH_MBidVec, NaN];
                TG.BDM.WM_MBidVec = [TG.BDM.WM_MBidVec, NaN];
                TG.BDM.WL_MBidVec = [TG.BDM.WL_MBidVec, NaN];
                TG.BDM.NR_MBidVec = [TG.BDM.NR_MBidVec, NaN];
                TG.BDM.OM_MeanMBid             = nanmean(TG.BDM.OM_MBidVec);
                TG.BDM.OM_StdMBid              = nanvar(TG.BDM.OM_MBidVec);
                TG.BDM.OM_MedMBid              = nanmedian(TG.BDM.OM_MBidVec);
                set(TG.BDM_BC_GUI.Handles.OM_Mean,'String',num2str(TG.BDM.OM_MeanMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.OM_Med,'String',num2str(TG.BDM.OM_MedMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.OM_Std,'String',num2str(TG.BDM.OM_StdMBid, '%.3g'));
            case 9
                TG.BDM.OM_MBidVec = [TG.BDM.OM_MBidVec, NaN];
                TG.BDM.BH_MBidVec = [TG.BDM.BH_MBidVec, NaN];
                TG.BDM.OH_MBidVec = [TG.BDM.OH_MBidVec, NaN];
                TG.BDM.BL_MBidVec = [TG.BDM.BL_MBidVec, NaN];
                TG.BDM.BM_MBidVec = [TG.BDM.BM_MBidVec, NaN];
                TG.BDM.OL_MBidVec               = [TG.BDM.OL_MBidVec, (TP.BDM.MBID*TO.Rewards.Water.MaxVolume)];
                TG.BDM.WH_MBidVec = [TG.BDM.WH_MBidVec, NaN];
                TG.BDM.WM_MBidVec = [TG.BDM.WM_MBidVec, NaN];
                TG.BDM.WL_MBidVec = [TG.BDM.WL_MBidVec, NaN];
                TG.BDM.NR_MBidVec = [TG.BDM.NR_MBidVec, NaN];
                TG.BDM.OL_MeanMBid             = nanmean(TG.BDM.OL_MBidVec);
                TG.BDM.OL_StdMBid              = nanvar(TG.BDM.OL_MBidVec);
                TG.BDM.OL_MedMBid              = nanmedian(TG.BDM.OL_MBidVec);
                set(TG.BDM_BC_GUI.Handles.OL_Mean,'String',num2str(TG.BDM.OL_MeanMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.OL_Med,'String',num2str(TG.BDM.OL_MedMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.OL_Std,'String',num2str(TG.BDM.OL_StdMBid, '%.3g'));
            case 10
                TG.BDM.OM_MBidVec = [TG.BDM.OM_MBidVec, NaN];
                TG.BDM.BH_MBidVec = [TG.BDM.BH_MBidVec, NaN];
                TG.BDM.OH_MBidVec = [TG.BDM.OH_MBidVec, NaN];
                TG.BDM.BL_MBidVec = [TG.BDM.BL_MBidVec, NaN];
                TG.BDM.BM_MBidVec = [TG.BDM.BM_MBidVec, NaN];
                TG.BDM.OL_MBidVec = [TG.BDM.OL_MBidVec, NaN];
                TG.BDM.WH_MBidVec = [TG.BDM.WH_MBidVec, NaN];
                TG.BDM.WM_MBidVec = [TG.BDM.WM_MBidVec, NaN];
                TG.BDM.WL_MBidVec = [TG.BDM.WL_MBidVec, NaN];
                TG.BDM.NR_MBidVec = [TG.BDM.NR_MBidVec, (TP.BDM.MBID*TO.Rewards.Water.MaxVolume)];
                TG.BDM.NR_MeanMBid             = nanmean(TG.BDM.NR_MBidVec);
                TG.BDM.NR_StdMBid              = nanvar(TG.BDM.NR_MBidVec);
                TG.BDM.NR_MedMBid              = nanmedian(TG.BDM.NR_MBidVec);
                set(TG.BDM_BC_GUI.Handles.NR_Mean,'String',num2str(TG.BDM.NR_MeanMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.NR_Med,'String',num2str(TG.BDM.NR_MedMBid, '%.3g'));
                set(TG.BDM_BC_GUI.Handles.NR_Std,'String',num2str(TG.BDM.NR_StdMBid, '%.3g'));
        end
    end
end

% Collect Bias Fix Data
if strcmp(TC.All.Trial,'BCb')
    
    if TP.BCb.BiasFix == 1
    
        if TP.BCb.ChoiceSide == 1
            TG.BCb.BiasFix_LN = TG.BCb.BiasFix_LN + 1;
        elseif TP.BCb.ChoiceSide == 2
            TG.BCb.BiasFix_RN = TG.BCb.BiasFix_RN + 1;
        end
    
        set(TG.BDM_BC_GUI.Handles.Fix_Bias_LN,'String',num2str(TG.BCb.BiasFix_LN, '%.3g'));
        set(TG.BDM_BC_GUI.Handles.Fix_Bias_RN,'String',num2str(TG.BCb.BiasFix_RN, '%.3g'));
        
        LDom = 0;
        RDom = 0;
        Good = 0;
        
        if TP.BCb.BiasFix_HV ~= TP.BCb.BiasFix_LV % As long as low value and high value are not equal:
            if TP.BCb.BiasFixLH
                % Left side has high value
                if TP.BCb.ChoiceSide == 1
                    LDom = 0;
                    RDom = 0;
                    Good = 1;
                elseif TP.BCb.ChoiceSide == 2
                    LDom = 0;
                    RDom = 1;
                    Good = 0;
                end
            else
                % Right side has high value
                if TP.BCb.ChoiceSide == 1
                    LDom = 1;
                    RDom = 0;
                    Good = 0;
                elseif TP.BCb.ChoiceSide == 2
                    LDom = 0;
                    RDom = 0;
                    Good = 1;
                end
            end
            
            TG.BCb.BiasFix_LDom = TG.BCb.BiasFix_LDom + LDom;
            TG.BCb.BiasFix_RDom = TG.BCb.BiasFix_RDom + RDom;
            TG.BCb.BiasFix_Good = TG.BCb.BiasFix_Good + Good;
            
            set(TG.BDM_BC_GUI.Handles.Fix_Bias_LDom,'String',num2str(TG.BCb.BiasFix_LDom, '%.3g'));
            set(TG.BDM_BC_GUI.Handles.Fix_Bias_RDom,'String',num2str(TG.BCb.BiasFix_RDom, '%.3g'));
            set(TG.BDM_BC_GUI.Handles.Fix_Bias_Good,'String',num2str(TG.BCb.BiasFix_Good, '%.3g'));
            
        end
        
        
    else % Trial is a normal BCb trial.
        
      if TP.BCb.ChoiceSide == 1
          TG.BCb.LCN  = TG.BCb.LCN + 1;
          TG.BCb.RSet(length(TG.BCb.RSet)+1) = TP.BCb.RewardID;
          TG.BCb.SSet(length(TG.BCb.RSet)+1) = 1;
      elseif TP.BCb.ChoiceSide == 2
          TG.BCb.RCN  = TG.BCb.RCN + 1;
          TG.BCb.RSet(length(TG.BCb.RSet)+1) = TP.BCb.RewardID;
          TG.BCb.SSet(length(TG.BCb.RSet)+1) = 2;
      end
      
      
      if TP.BCb.ChoiceType == 2 && (TP.BCb.WaterOffer1 >= (TP.BCb.WaterOffer2-0.01)) && (TP.BCb.WaterOffer1 <= (TP.BCb.WaterOffer2+0.01))% Chose water only when water + fractal was on offer
          if TP.BCb.ChoiceSide == 1
            TG.BCb.LDCN = TG.BCb.LDCN + 1;
          elseif TP.BCb.ChoiceSide == 2
            TG.BCb.RDCN = TG.BCb.RDCN + 1;
          end
      end
      
      % Bias data:
      [pE, Bias, pCI] = BernoulliTest(TG.BCb.LCN,TG.BCb.RCN,0.1,'Left','Right');
      
      Total     = TG.BCb.LCN + TG.BCb.RCN;
      LeftFrac  = round(100*(TG.BCb.LCN/Total));
      RightFrac = 100 - LeftFrac;
      
      RatioString = strcat(num2str(LeftFrac,'%.2g'),':',num2str(RightFrac,'%.2g'));
      
      % Logistic analysis:
      if TP.BCb.Error ~= 1
          TG.BCb.BundleCurrency(length(TG.BCb.BundleCurrency)+1)    = TP.BCb.WaterOffer1;
          TG.BCb.BundleReward(length(TG.BCb.BundleReward)+1)        = TP.BCb.RewardID;
          TG.BCb.Choices(length(TG.BCb.Choices)+1)                  = TP.BCb.ChoiceType; % 1 is bundle, 2 is solo.
      end
      
      % Update GUI:
      set(TG.BDM_BC_GUI.Handles.BCb_SideRatio,'String',RatioString);
      set(TG.BDM_BC_GUI.Handles.BCb_BiasSide,'String',Bias);
      
      set(TG.BDM_BC_GUI.Handles.BCb_LChosen,'String',num2str(TG.BCb.LCN, '%.3g'));
      set(TG.BDM_BC_GUI.Handles.BCb_RChosen,'String',num2str(TG.BCb.RCN, '%.3g'));
      set(TG.BDM_BC_GUI.Handles.BCb_LDominatedChosen,'String',num2str(TG.BCb.LDCN, '%.3g'));
      set(TG.BDM_BC_GUI.Handles.BCb_RDominatedChosen,'String',num2str(TG.BCb.RDCN, '%.3g'));
    end   
end

% Set values to GUI:
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles)