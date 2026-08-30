function [Data] = ModigSaveData_BDM_BC
global BehaveData Task IO TC TP TO TaskOp
% Elsewhere, for GUI probably, need to record:
% 1. Consumption so far
% 2. n_Chose L/R
% 3. n_Choce W/J
% 4. update MMhistory in modig monitor behaviour scripts.
TC.All.Error.nError       = TC.BDM.Error.nError + TC.BCb.Error.nError;
TC.All.Error.nNoChoice    = TC.BDM.Error.nNoBid + TC.BCb.Error.nNoChoice;
TC.All.Error.nNoHold      = TC.BDM.Error.nNoHold + TC.BCb.Error.nNoHold;
TC.All.Error.nNotCentred  = TC.BDM.Error.nNotCentred + TC.BCb.Error.nNotCentred;
TC.All.Error.nSecondTouch = TC.BDM.Error.nSecondTouch + TC.BCb.Error.nSecondTouch;
TC.All.Error.nOutTouch    = TC.BDM.Error.nOutTouch + TC.BCb.Error.nOutTouch;
TC.All.Error.nTargetMiss  = TC.BDM.Error.nTargetMiss;
% Update the GUI:
Update_GUI_BDM_BC

% ----------- COUNTERS: contents --------------------------
% 1. Day of week (TC.All.Day)
% 2. Trial type (TC.All.TrialType)
% 3. Blocks vector (TC.BDM/BCs.Block)
% 4. Consumption data (TC.All.Consumption.Total/Juice/Water)
% 5. Error counts (TC.All.Error.nTotal/nHold/nChoice/nNotCentred)
% 6. Monkey ID (TC.All.MonkeyID)
% 7. Reward ID vector (TC.BDM/BCs.RewardIDs)
% 8. Water offers vector
% 9. Offer sides vector                                             - NOTE: What is this being used for at the moment?!
% 10. Fractal sides vector

Data.Counters.All.TrialN               = TC.All.TrialN;
Data.Counters.All.TrialNC              = TC.All.TrialNC;
Data.Counters.All.Error                = TC.All.Error;
Data.Counters.All.Consumption          = TC.All.Consumption;
Data.Counters.All.Monkey               = TC.All.MonkeyID;
Data.Counters.All.TrialType            = TC.All.Trial;
Data.Counters.All.Day                  = TC.All.Day;

Data.Counters.BCb.TrialN               = TC.BCb.TrialN;
Data.Counters.BCb.TrialNC              = TC.BCb.TrialNC;
Data.Counters.BCb.Error                = TC.BCb.Error;
Data.Counters.BCb.Consumption          = TC.BCb.Consumption;

Data.Counters.BCs.TrialN               = TC.BCs.TrialN;
Data.Counters.BCs.TrialNC              = TC.BCs.TrialNC;
Data.Counters.BCs.Error                = TC.BCs.Error;
Data.Counters.BCs.Consumption          = TC.BCs.Consumption;

Data.Counters.BDM.TrialN               = TC.BDM.TrialN;
Data.Counters.BDM.TrialNC              = TC.BDM.TrialNC;
Data.Counters.BDM.Error                = TC.BDM.Error;
Data.Counters.BDM.Consumption          = TC.BDM.Consumption;

Data.Counters.BDM.F_TrialNC            = TC.BDMf.TrialNC;
% ----------- PARAMETERS: contents ------------------------
% 1. Rewarded water (TP.BDM.RemainingWater/TP.BCs.WaterOffer)
% 2. Rewarded juice (TP.BDM.RewardVol/TP.BCs.RewardVol)
% 3. Offered juice (TP.Reward.Volume)
% 4. Offered water (TP.BDM.WaterMax/TP.BCs.WaterOffer)


Data.Parameters                 = TP;
Data.Parameters.BDM.MMPos       = TO.Rewards.Water.BDM.MMPos;
Data.Parameters.BDM.MMRelPos    = TO.Rewards.Water.BDM.RelMPos;
Data.Parameters.BDM.RandMMPos   = TO.Rewards.Water.BDM.VarRelPos;
Data.Parameters.BDM.VarMMPos    = TO.Rewards.Water.BDM.MMVar;

% FOR RISKY CONDITION:
Data.Parameters.Risky.Deliveries= TO.Stimuli.Risky.Deliveries;
Data.Parameters.Risky.On        = TP.BDM.Risky || TP.BCb.Risky;
Data.Parameters.Risky.Type      = TC.All.SessionType;

if strcmp(TC.All.SessionType, 'BDM')
    Data.Parameters.Risky.Rewards   = TC.BDM.RewardIDs;
elseif strcmp(TC.All.SessionType, 'BCb')
    Data.Parameters.Risky.Rewards   = TC.BCb.RewardIDs;
end
% ----------- Behavioural data: contents -------------------
Data.ErrorTypes                 = TaskOp.Error;

switch TC.All.Trial
    case 'BDM'
        
        EpochStamps         = [Task.Pre_Trial.flipTimeStamp, Task.Joy_Hold.flipTimeStamp, Task.Offer.flipTimeStamp, ...
                            Task.MonkBid.flipTimeStamp, Task.CompBid.flipTimeStamp, Task.Payment.flipTimeStamp, Task.Endowment.flipTimeStamp, ...
                            Task.WaterDelivery.flipTimeStamp, Task.Reward.flipTimeStamp,  Task.PaymentW.flipTimeStamp, ...
                            Task.PaymentL.flipTimeStamp, Task.RewardW.flipTimeStamp, Task.RewardL.flipTimeStamp, Task.JuiceDelivery.flipTimeStamp, Task.ITI.flipTimeStamp, Task.Error.flipTimeStamp];
        
        Error               = TP.BDM.Error;
        
    case 'BCs'
        
        EpochStamps         = [Task.Pre_Trial_BC.flipTimeStamp, Task.Joy_Hold_BC.flipTimeStamp, Task.Offer_BC.flipTimeStamp, ...
                            Task.Choice_BC.flipTimeStamp, Task.PresentChoice_BC.flipTimeStamp, Task.WaterDelay_BC.flipTimeStamp, Task.JuiceDelay_BC.flipTimeStamp, ...
                            Task.WaterDelivery_BC.flipTimeStamp, Task.JuiceDelivery_BC.flipTimeStamp, Task.WaterWait.flipTimeStamp, Task.ITI_BC.flipTimeStamp, Task.Error_BC.flipTimeStamp];
        
        Error               = TP.BCs.Error;
        
        
    case 'BCb'
        EpochStamps         = [Task.Pre_Trial_BC.flipTimeStamp, Task.Joy_Hold_BC.flipTimeStamp, Task.Offer_BC.flipTimeStamp, ...
                            Task.Choice_BC.flipTimeStamp, Task.PresentChoice_BC.flipTimeStamp, Task.WaterDelay_BC.flipTimeStamp, Task.JuiceDelay_BCb.flipTimeStamp, ...
                            Task.WaterDelivery_BC.flipTimeStamp, Task.JuiceDelivery_BC.flipTimeStamp, Task.WaterWait.flipTimeStamp, Task.ITI_BC.flipTimeStamp, Task.Error_BC.flipTimeStamp];
        
        Error               = TP.BCb.Error;
end

Data.Behaviour.Joy.Threshold   = IO.Input.joy.Sensitivity_Threshold;
Data.Behaviour.Joy.CentreReq   = IO.Input.joy.DefCentreFix;
Data.Behaviour.Joy.CentreThr   = IO.Input.joy.Centre_Threshold;
Data.Behaviour.EpochStamps     = EpochStamps;
Data.Behaviour.EyeStamps       = BehaveData.Tbl(:,2:5);
Data.Behaviour.TimeStamps      = BehaveData.Tbl(:,1);
Data.Behaviour.HandStamps      = BehaveData.Tbl(:,6:7);

if strcmp(TP.Effector,'Joy')
    Data.Behaviour.JoystickVoltage = BehaveData.Tbl(:,9:11);
end
%% Save data structure:
Filename                             = date;
Filename                             = strcat(TC.All.DataTitle,Filename);
DATASTRUCT                           = load(Filename);
DATACELL                             = DATASTRUCT.DATACELL;
DATACELL{TC.All.TrialN,1}            = Data;
DATACELL{TC.All.TrialN,2}            = TC.All.Trial;
DATACELL{TC.All.TrialN,3}            = Error;
save(Filename,'DATACELL');
clear Data

end
