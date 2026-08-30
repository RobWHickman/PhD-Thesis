% This script generates the general task parameters for the BDM/BC task.
global TP VisParam TC Stim Task

TP.BDM.AuctionType          = 'BDM';

TP.BDM.Risky                = false;
TP.BCb.Risky                = false;

% Sceeen parameters:
TP.BCs.LeftLimit            = 4*VisParam.scr_rect(3)/12;
TP.BCs.RightLimit           = 8*VisParam.scr_rect(3)/12;
TP.BCs.CenterPos            = VisParam.scr_rect(3)/2;

TP.BCb.LeftLimit1           = (2*VisParam.scr_rect(3)/12) -10;
TP.BCb.RightLimit2          = (10*VisParam.scr_rect(3)/12) +10;
TP.BCb.LeftLimit            = 4*VisParam.scr_rect(3)/12;
TP.BCb.RightLimit           = 8*VisParam.scr_rect(3)/12;
TP.BCb.LeftCenter           = 3*VisParam.scr_rect(3)/12;
TP.BCb.RightCenter          = 9*VisParam.scr_rect(3)/12;

% Touch restrictions:
TP.Restriction.ChoiceTouch  = false;
TP.Restriction.NoOfferTouch = false;
TP.Restriction.OneTouch     = false;
TP.Restriction.FirstTouch   = false;

% Bias fixing:
TP.BCb.MarkerOffset         = 0;
TP.BCb.BiasFix              = 0;
TP.BCb.RGainBias            = 1;
TP.BCb.LGainBias            = 1;
TP.BCb.BiasFactor           = 1;
TP.BCb.RSO                  = 0;
TP.BCb.LSO                  = 0;
TP.BCb.BiasFix_LPH          = 0;
TP.BCb.BiasFix_HV           = 1;
TP.BCb.BiasFix_LV           = 0;

% Task specific joystick options:
TP.BDM.Joy.Window           = 15;
TP.BDM.VaryMarkerPos        = false;
TP.BDM.Joy.Gain             = 125;
TP.BCb.Joy.Gain             = 12;

% BDM distribution parameters:
TP.BDM.Distribution         = [0 0];
TP.BDM.CDistType            = 'C';
TP.BDM.BiddingType          = 'C';
TP.BDM.FixedAlpha           = 4;
TP.BDM.FixedBeta            = 4;

% Currency parameters:
TP.BDM.CurrencyType = 'W';

% Blocking parameters:
TP.BDM.BlockS               = 10;
TP.BCs.BlockS               = 10;
TP.BCb.BlockS               = 10;

TP.BDM.JBlockS               = 3;
TP.BCs.JBlockS               = 10;
TP.BCb.JBlockS               = 10;

TC.BDM.BlockType            = 'R';
TC.BCb.BlockType            = 'B';

TP.BCb.JuiceSet            = [0, 0, 0, 0, 1, 1, 1, 1, 1, 0];
TP.BCs.JuiceSet            = [0, 0, 0, 0, 1, 1, 0, 0, 0, 0];
TP.BDM.JuiceSet            = [0, 0, 0, 0, 1, 1, 1, 1, 1, 0];

TP.BCs.WaterSet            = [0.125:0.125:1];
TP.BCb.WaterSet            = [0:1/9:1];

% Fractal set:
TP.Rewards.FractalNames     = {'B30','B20','B10','RA1','RA4','RA6','RA2','RA3','RA5','NR'};

% Session data:
TC.All.SessionType              = 'BDM';
[~, TC.All.Day]                 = weekday(date);
TC.All.MonkeyID                 = 'U';

% Set counters to nil-value:
TC.All.TrialN                   = 0;
TC.All.TrialNC                  = 0;
TC.All.Consumption.Juice        = 0;
TC.All.Consumption.Water        = 0;
TC.All.Consumption.Total        = 0;
TC.All.Error.nError             = 0;
TC.All.Error.nNoChoice          = 0;
TC.All.Error.nNoHold            = 0;
TC.All.Error.nNotCentred        = 0;
TC.All.Error.nOutTouch          = 0;
TC.All.Error.nSecondTouch       = 0;
TC.All.Error.nTargetMiss        = 0;

TC.BDM.TrialN               = 0;
TC.BDM.TrialNC              = 0;
TC.BDMf.TrialNC             = 0;
TC.BCs.TrialN               = 0;
TC.BCs.TrialNC              = 0;
TC.BCb.TrialN               = 0;
TC.BCb.TrialNC              = 0;

TC.BDM.Error.nError         = 0;
TC.BDM.Error.nNoHold        = 0;
TC.BDM.Error.nNoBid         = 0;
TC.BDM.Error.nNotCentred    = 0;
TC.BDM.Error.nSecondTouch   = 0;
TC.BDM.Error.nOutTouch      = 0;
TC.BDM.Error.nTargetMiss    = 0;

TC.BCs.Error.nError         = 0;
TC.BCs.Error.nNoHold        = 0;
TC.BCs.Error.nNotCentred    = 0;
TC.BCs.Error.nNoChoice      = 0;

TC.BCb.Error.nError         = 0;
TC.BCb.Error.nNoHold        = 0;
TC.BCb.Error.nNotCentred    = 0;
TC.BCb.Error.nNoChoice      = 0;
TC.BCb.Error.nSecondTouch   = 0;
TC.BCb.Error.nOutTouch      = 0;

TC.BDM.Consumption.Juice    = 0;
TC.BDM.Consumption.Water    = 0;
TC.BDM.Consumption.Total    = 0;

TC.BCs.Consumption.Juice    = 0;
TC.BCs.Consumption.Water    = 0;
TC.BCs.Consumption.Total    = 0;

TC.BCb.Consumption.Juice    = 0;
TC.BCb.Consumption.Water    = 0;
TC.BCb.Consumption.Total    = 0;

% Fractal sides:
TC.BCs.FractalSides         = PermTypes(1000,1,2); 
TC.BCb.FractalSides         = PermTypes(1000,1,2);

% Water vectors:
TC.BCb.WaterOffers          = PermVecInBlock(TP.BCb.WaterSet, 125);

% Behavioural requirements:
Stim.JoyHold                = [];
Stim.JoyHold.handReq        = 1;
Stim.JoyHold.handInterrupt  = 1;
Stim.JoyHold.hold           = 1;
Stim.JoyHold.holdTime       = .5;
Stim.JoyHold.filter_time    = (Task.Joy_Hold.time_planned/1000)-Stim.JoyHold.holdTime-0.1;
Stim.JoyHold.default        = 1;