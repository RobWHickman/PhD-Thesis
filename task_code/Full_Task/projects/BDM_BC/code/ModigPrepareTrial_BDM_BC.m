function runned = ModigPrepareTrial_BDM_BC
% Prepares trial parameters in project BDM and Binary Choice

global Stim TaskOp TC TP TO IO VisParam

TrialNumber = TC.All.TrialNC+1;
TrialType   = TC.All.TrialType(TrialNumber);

TaskOp.Error.NotCentred = 0;
TaskOp.Error.NoChoice   = 0;
TaskOp.Error.NoHold     = 0;
TaskOp.Error.OutTouch   = 0;
TaskOp.Error.SecondTouch= 0;
TaskOp.Error.TargetMiss = 0;

IO.Input.joy.CentreFix  = IO.Input.joy.DefCentreFix;

%% Task specific variables:
switch TrialType
    case 1 % BDM
        
        TrialNumber = TC.BDM.TrialNC+1;

        TC.All.Trial                = 'BDM';
        TP.BDM.correct              = 1;
        TP.BDM.Error                = 0;
        TP.BDM.BlockNumber          = TC.BDM.Block(TrialNumber);
        TP.BDM.RewardID             = TC.BDM.RewardIDs(TrialNumber);
        TP.BDM.MBID                 = NaN;
        TP.BDM.Outcome              = NaN;
        TP.BDM.Bidlock              = NaN;
        TP.BDM.MarkerHistory        = nan(300,4);
        
        TP.BDM.WaterRecieved        = 0;
        TP.BDM.JuiceRecieved        = 0;

        switch TP.BDM.RewardID
            case 1
                TP.Reward = TO.Rewards.B_High;
            case 2
                TP.Reward = TO.Rewards.B_Mid;
            case 3
                TP.Reward = TO.Rewards.B_Low;
            case 4
                TP.Reward = TO.Rewards.W_High;
            case 5
                TP.Reward = TO.Rewards.W_Mid;
            case 6
                TP.Reward = TO.Rewards.W_Low;
            case 7
                TP.Reward = TO.Rewards.O_High;
            case 8
                TP.Reward = TO.Rewards.O_Mid;
            case 9
                TP.Reward = TO.Rewards.O_Low;
            case 10
                TP.Reward = TO.Rewards.NR;
        end
        
        if TP.BDM.Risky
            TP.Reward.Type = 'Risky';
        end
        
        if TP.BDM.Learning
            TP.Reward.Type = 'Learning';
        end
        
        TP.BDM.WaterMax                     = TO.Rewards.Water.MaxVolume;
        
        [TP.BDM.CBID, TP.BDM.Distribution, TP.BDM.D_CBIDn]  = CBidMaker(TP.BDM.BiddingType, TP.BDM.CDistType);
        
        if strcmp(TP.BDM.AuctionType,'BDM_Forced')
            if strcmp(TP.BDM.BiddingType,'D')
                TP.BDMf.TargetID                = TP.BDMf.TargetLoc(TC.BDMf.TrialNC+1);
                TO.Stimuli.BDMf.TargetPos       = TO.Stimuli.BDM.D_PosMat(TP.BDMf.TargetID,:);
                TP.BDM.D_CBIDn                  = TP.BDMf.CBID(TC.BDMf.TrialNC+1);
                TP.BDM.CBID                     = TP.BDM.D_CBIDn/TO.Params.BDM.D_nDivs;
            elseif strcmp(TP.BDM.BiddingType,'C')
                TP.BDMf.TargetID                = TP.BDMf.TargetLoc(TC.BDMf.TrialNC+1);
                TO.Stimuli.BDMf.TargetPos       = TO.Params.BDMf.TargetMat(TP.BDMf.TargetID,:);
                TP.BDM.CBID                     = (TP.BDMf.CBID(TC.BDMf.TrialNC+1))/TO.Params.BDM.D_nDivs;
            end
        end
        

        TO.Rewards.Water.BDM.MMPos          = TO.Rewards.Water.BDM.MMDefPos;
        TO.Rewards.Water.BDM.DMMPos         = TO.Rewards.Water.BDM.DMMDefPos;
        
        % RANDOM MARKER POSITION:
        if TP.BDM.VaryMarkerPos
            TO.Rewards.Water.BDM.MMPos([2 4])   = TO.Rewards.Water.BDM.MMPos([2 4]) - (TO.Rewards.Water.BDM.VarRelPos(TrialNumber)*TO.Params.BDM.BarRange);
            TO.Rewards.Water.BDM.VarID          = TP.BDM.D_VarPosVec(TrialNumber);
            TO.Rewards.Water.BDM.DMMPos         = TO.Stimuli.BDM.D_PosMat(TO.Rewards.Water.BDM.VarID,:);
            TO.Rewards.Water.BDM.DMMDefPos(3)   = TO.Rewards.Water.BDM.DMMDefPos(3) + TO.Stimuli.BDM.D_MBidEdge;
        end
        
        % COMPUTER MARKER:
        if strcmp(TP.BDM.BiddingType,'C')
            TO.Rewards.Water.BDM.CMPos          = TO.Rewards.Water.BDM.CMDefPos;
            TO.Rewards.Water.BDM.CMPos([2 4])   = TO.Rewards.Water.BDM.CMPos([2 4]) - (TP.BDM.CBID*TO.Params.BDM.BarRange);
        elseif strcmp(TP.BDM.BiddingType,'D')
            TO.Rewards.Water.BDM.DCMPos         = TO.Stimuli.BDM.D_PosMat(TP.BDM.D_CBIDn,:);
            TO.Rewards.Water.BDM.DCMPos(3)      = TO.Rewards.Water.BDM.DCMPos(3) + TO.Stimuli.BDM.D_CBidEdge;
        end
        
        TO.Stimuli.BDM.PayRect.Pos          = TO.Stimuli.BDM.PayRect.DefPos;
        
        if strcmp(TP.BDM.AuctionType,'BDM_PAV')
            if strcmp(TP.BDM.BiddingType,'D')
                TO.Stimuli.BDM.PAV_MPOS_D       = TO.Stimuli.BDM.D_PosMat(TP.BDM.PAV_BidsD(TrialNumber),:);
                TO.Stimuli.BDM.PAV_MPOS_D(3)    = TO.Stimuli.BDM.PAV_MPOS_D(3) + TO.Stimuli.BDM.D_MBidEdge;
                TP.BDM.MBID                     = TP.BDM.PAV_BidsD(TrialNumber)/TO.Params.BDM.D_nDivs;
            elseif strcmp(TP.BDM.BiddingType,'C')
                TO.Stimuli.BDM.PAV_MPOS_C       = TO.Rewards.Water.BDM.CMDefPos;
                TO.Stimuli.BDM.PAV_MPOS_C([2 4])= TO.Stimuli.BDM.PAV_MPOS_C([2 4]) - (TP.BDM.PAV_BidsC(TrialNumber)*TO.Params.BDM.BarRange);
                TP.BDM.MBID                     = TP.BDM.PAV_BidsC(TrialNumber);
            end
        end
        
        if strcmp(TP.BDM.BiddingType,'C')
            TO.Stimuli.BDM.PayRect.Pos(2)       = TO.Rewards.Water.BDM.CMPos(4);
        elseif strcmp(TP.BDM.BiddingType,'D')
            [TO.Stimuli.BDM.DPayRect, ~]        = MakeBDMDBar(VisParam.scr_handle, TO.Stimuli.BDM.PayRect.Col, TO.Stimuli.BDM.D_DivHeight, TO.Stimuli.BDM.D_BasePos, TP.BDM.D_CBIDn, TO.Stimuli.BDM.D_DivSpacing);
        end
        
        if TO.Stimuli.BDM.PayRect.Pos(2) > TO.Stimuli.BDM.PayRect.Pos(4)
            TO.Stimuli.BDM.PayRect.Pos      = TO.Stimuli.BDM.PayRect.DefPos;
        end

    case 2 % BCs
        
        TrialNumber                 = TC.BCs.TrialNC+1;
        TC.All.Trial                = 'BCs';
        TP.BCs.correct              = 1;
        TP.BCs.Error                = 0;
        TP.BCs.BlockNumber          = TC.BCs.Block(TrialNumber);
        TP.BCs.RewardID             = TC.BCs.RewardIDs(TrialNumber);
        
        TP.BCs.JuiceRecieved        = 0;
        TP.BCs.WaterRecieved        = 0;
        
        TP.BCs.ChosenID             = NaN;
        TP.BCs.ChoiceType           = 0;
        TP.BCs.ChoiceSide           = NaN;
        TP.BCs.ChoiceDone           = NaN;
        TP.BCs.MarkerHistory        = nan(300,4);

        TP.BCs.FractalSide          = TC.BCs.FractalSides(TrialNumber);
        WaterValue                  = TC.BCs.WaterOffers(TrialNumber);
        
        switch TP.BCs.RewardID
            case 1
                TP.Reward = TO.Rewards.B_High;
            case 2
                TP.Reward = TO.Rewards.B_Mid;
            case 3
                TP.Reward = TO.Rewards.B_Low;
        end 
        TP.BCs.WaterMax                                 = TO.Rewards.Water.MaxVolume;
        TP.BCs.WaterOffer                               = WaterValue*TP.BCs.WaterMax;  
        TO.Rewards.Water.BCs.MarkerLeftPosition         = TO.Rewards.Water.BCs.DefMarkerLeftPosition;
        TO.Rewards.Water.BCs.MarkerRightPosition        = TO.Rewards.Water.BCs.DefMarkerRightPosition;
        TO.Rewards.Water.BCs.MarkerLeftPosition([2 4])  = TO.Rewards.Water.BCs.MarkerLeftPosition([2 4]) - (WaterValue*(TO.Params.BCs.BarRange));
        TO.Rewards.Water.BCs.MarkerRightPosition([2 4]) = TO.Rewards.Water.BCs.MarkerRightPosition([2 4]) - (WaterValue*(TO.Params.BCs.BarRange));
    
    case 3
        
        TrialNumber                 = TC.BCb.TrialNC+1;
        TC.All.Trial                = 'BCb';
        TP.BCb.correct              = 1;
        TP.BCb.Error                = 0;
        TP.BCb.BlockNumber          = TC.BCb.Block(TrialNumber);
        TP.BCb.RewardID             = TC.BCb.RewardIDs(TrialNumber);
        TP.BCb.JuiceRecieved        = 0;
        TP.BCb.WaterRecieved        = 0;
        
        TP.BCb.ChosenID             = NaN;
        TP.BCb.ChoiceType           = 0;                                    % 1 is bundle only, 2 is water only
        TP.BCb.ChoiceSide           = NaN;
        TP.BCb.ChoiceDone           = NaN;
        TP.BCb.MarkerHistory        = nan(300,4);

        TP.BCb.FractalSide          = TC.BCb.FractalSides(TrialNumber);
        WaterValue1                 = TC.BCb.WaterOffers(TrialNumber);
        WaterValue2                 = 1; %0;                                   % Should be equal to 1. %%%%%%%%%%%%%1
         
        switch TP.BCb.RewardID
            case 1
                TP.Reward = TO.Rewards.B_High;
            case 2
                TP.Reward = TO.Rewards.B_Mid;
            case 3
                TP.Reward = TO.Rewards.B_Low;
            case 4
                TP.Reward = TO.Rewards.W_High;
            case 5
                TP.Reward = TO.Rewards.W_Mid;
            case 6
                TP.Reward = TO.Rewards.W_Low;
            case 7
                TP.Reward = TO.Rewards.O_High;
            case 8
                TP.Reward = TO.Rewards.O_Mid;
            case 9
                TP.Reward = TO.Rewards.O_Low;
            case 10
                TP.Reward = TO.Rewards.NR;
        end 
        
        if TP.BCb.Risky
            TP.Reward.Type = 'Risky';
        end
        
        TP.BCb.WaterMax                                 = TO.Rewards.Water.MaxVolume;
        TP.BCb.WaterOffer1                              = WaterValue1*TP.BCb.WaterMax;
        TP.BCb.WaterOffer2                              = WaterValue2*TP.BCb.WaterMax;
        TO.Rewards.Water.BCb.MarkerLeftPosition         = TO.Rewards.Water.BCb.DefMarkerLeftPosition;
        TO.Rewards.Water.BCb.MarkerRightPosition        = TO.Rewards.Water.BCb.DefMarkerRightPosition;
        
        TP.BCb.FractalSide = TC.BCb.FractalSides(TrialNumber);
        
        if TP.BCb.BiasFix == 1;
            rng('shuffle')
            SideChoice          = rand;
            TP.BCb.FractalSide  = 1; % Doesn't matter which side fractal is on, so set to left.
            if SideChoice < TP.BCb.BiasFix_LPH % So the high value is on the left;
                WaterValue1         = TP.BCb.BiasFix_HV;
                WaterValue2         = TP.BCb.BiasFix_LV;
                TP.BCb.BiasFixLH    = true;
            else % High value is on the right;
                WaterValue1         = TP.BCb.BiasFix_LV;
                WaterValue2         = TP.BCb.BiasFix_HV;
                TP.BCb.BiasFixLH    = false;
            end
            TP.BCb.WaterOffer1  = WaterValue1*TP.BCb.WaterMax;
            TP.BCb.WaterOffer2  = WaterValue2*TP.BCb.WaterMax;
            TP.Reward.Volume    = 0;
            
        end
        
        switch TP.BCb.FractalSide
            case 1 % Fractal on Left (WaterOffer1 on left also - variable option)
                if strcmp(TP.BDM.BiddingType,'D')
                    TP.BCb.DivNL = round((1-WaterValue1)*TO.Params.BDM.D_nDivs);
                    TO.Rewards.Water.BCb.MarkerRightPosition = nan;
                    if TP.BCb.DivNL ~= 0
                        TO.Rewards.Water.BCb.MarkerLeftPosition    = TO.Stimuli.BDM.D_LPosMat(TP.BCb.DivNL,:);
                        TO.Rewards.Water.BCb.MarkerLeftPosition(3) = TO.Rewards.Water.BCb.MarkerLeftPosition(3) + TO.Stimuli.BDM.D_CBidEdge;
                        [TO.Stimuli.BDM.DPayRect, ~]        = MakeBDMDBar(VisParam.scr_handle, TO.Stimuli.BDM.PayRect.Col, TO.Stimuli.BDM.D_DivHeight, TO.Stimuli.BCb.D_LBasePos, TP.BCb.DivNL, TO.Stimuli.BDM.D_DivSpacing);
                    end
                    
                    if TP.BCb.BiasFix == 1;
                       % Left value and Rect accounted for, just do right:
                        TP.BCb.DivNR = round((1-WaterValue2)*TO.Params.BDM.D_nDivs);
                        if TP.BCb.DivNR ~= 0;
                            TO.Rewards.Water.BCb.MarkerRightPosition = TO.Stimuli.BDM.D_RPosMat(TP.BCb.DivNR,:);
                            TO.Rewards.Water.BCb.MarkerRightPosition(3) = TO.Rewards.Water.BCb.MarkerRightPosition(3) + TO.Stimuli.BDM.D_CBidEdge;
                            [TO.Stimuli.BDM.DPayRectBF, ~]        = MakeBDMDBar(VisParam.scr_handle, TO.Stimuli.BDM.PayRect.Col, TO.Stimuli.BDM.D_DivHeight, TO.Stimuli.BCb.D_RBasePos, TP.BCb.DivNR, TO.Stimuli.BDM.D_DivSpacing);
                        end
                    end
                elseif strcmp(TP.BDM.BiddingType,'C')
                    TO.Rewards.Water.BCb.MarkerLeftPosition([2 4])  = TO.Rewards.Water.BCb.MarkerLeftPosition([2 4]) - ((1-WaterValue1)*(TO.Params.BCb.BarRange));
                    TO.Rewards.Water.BCb.MarkerRightPosition([2 4]) = TO.Rewards.Water.BCb.MarkerRightPosition([2 4]) - ((1-WaterValue2)*(TO.Params.BCb.BarRange));
                    TO.Stimuli.BCb.PayRect.LPos         = TO.Stimuli.BCb.PayRect.LDefPos;
                    TO.Stimuli.BCb.PayRect.RPos         = TO.Stimuli.BCb.PayRect.RDefPos;
                    TO.Stimuli.BCb.PayRect.LPos(2)      = TO.Rewards.Water.BCb.MarkerLeftPosition(4);
                    TO.Stimuli.BCb.PayRect.RPos(2)      = TO.Rewards.Water.BCb.MarkerRightPosition(4);
                end
            case 2 % Fractal on Right (WaterOffer1 on right also)
                if strcmp(TP.BDM.BiddingType,'D')
                    TP.BCb.DivNR = round((1-WaterValue1)*TO.Params.BDM.D_nDivs);
                    TO.Rewards.Water.BCb.MarkerLeftPosition = nan;
                    if TP.BCb.DivNR ~= 0
                        TO.Rewards.Water.BCb.MarkerRightPosition    = TO.Stimuli.BDM.D_RPosMat(TP.BCb.DivNR,:);
                        TO.Rewards.Water.BCb.MarkerRightPosition(3) = TO.Rewards.Water.BCb.MarkerRightPosition(3) + TO.Stimuli.BDM.D_CBidEdge;
                        [TO.Stimuli.BDM.DPayRect, ~]        = MakeBDMDBar(VisParam.scr_handle, TO.Stimuli.BDM.PayRect.Col, TO.Stimuli.BDM.D_DivHeight, TO.Stimuli.BCb.D_RBasePos, TP.BCb.DivNR, TO.Stimuli.BDM.D_DivSpacing);
                    end
                    
                    if TP.BCb.BiasFix == 1;
                       % Left value and Rect accounted for, just do right:
                        TP.BCb.DivNL = round((1-WaterValue2)*TO.Params.BDM.D_nDivs);
                        if TP.BCb.DivNL ~= 0;
                            TO.Rewards.Water.BCb.MarkerLeftPosition = TO.Stimuli.BDM.D_LPosMat(TP.BCb.DivNL,:);
                            TO.Rewards.Water.BCb.MarkerLeftPosition(3) = TO.Rewards.Water.BCb.MarkerLeftPosition(3) + TO.Stimuli.BDM.D_CBidEdge;
                            [TO.Stimuli.BDM.DPayRectBF, ~]        = MakeBDMDBar(VisParam.scr_handle, TO.Stimuli.BDM.PayRect.Col, TO.Stimuli.BDM.D_DivHeight, TO.Stimuli.BCb.D_LBasePos, TP.BCb.DivNL, TO.Stimuli.BDM.D_DivSpacing);
                        end
                    end
                    
                elseif strcmp(TP.BDM.BiddingType,'C')
                    TO.Rewards.Water.BCb.MarkerRightPosition([2 4]) = TO.Rewards.Water.BCb.MarkerRightPosition([2 4]) - ((1-WaterValue1)*(TO.Params.BCb.BarRange));
                    TO.Rewards.Water.BCb.MarkerLeftPosition([2 4]) = TO.Rewards.Water.BCb.MarkerLeftPosition([2 4]) - ((1-WaterValue2)*(TO.Params.BCb.BarRange));
                    TO.Stimuli.BCb.PayRect.RPos         = TO.Stimuli.BCb.PayRect.RDefPos;
                    TO.Stimuli.BCb.PayRect.LPos         = TO.Stimuli.BCb.PayRect.LDefPos;
                    TO.Stimuli.BCb.PayRect.LPos(2)      = TO.Rewards.Water.BCb.MarkerLeftPosition(4);
                    TO.Stimuli.BCb.PayRect.RPos(2)      = TO.Rewards.Water.BCb.MarkerRightPosition(4);
                end
        end
       
end

%% Initialize behavioural holders:           
TaskOp.handInterrupt = 0;
TaskOp.interrupt = 0;
TaskOp.hold = 0;
TaskOp.holdTime = 0;

%% Alphabetically  sort stim structure:
Stim = sort_structure(Stim);

runned = 1;