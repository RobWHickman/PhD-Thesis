function param = ModigJudgeSituation_BDM_BC(time_beh,prev_id)

global Tbl Task IO TP TC Stim TaskOp VisParam TO
% dynamic 1 for BDM, 2 for BCs and 3 for BCb
persistent bt
if isempty(bt),
    % output table:
    bt = cell2mat(Tbl.BitTbl(:,2));
    nbt(1) = find( strcmp(Tbl.BitTbl(:,1),'KT1')==1);
    nbt(2) = find( strcmp(Tbl.BitTbl(:,1),'KT2')==1);
    nbt(3) = find( strcmp(Tbl.BitTbl(:,1),'Lick1')==1);
    nbt(4) = find( strcmp(Tbl.BitTbl(:,1),'Neuron')==1);
    nbt(5) = find( strcmp(Tbl.BitTbl(:,1),'EMG')==1);
    bt(nbt)=[];
end
% Initalize variables
param.time_beh          = time_beh;
TrialType = TC.All.TrialType(TC.All.TrialNC+1); 
if (TrialType == 2 || TrialType == 3) && prev_id == 1
    prev_id = 15;
end
param.prev_id           = prev_id;
param.hand.req          = 0;
param.hand.filter_time  = 0;
param.hand.interrupt    = 0;
param.hand.hold         = 0;
param.hand.holdTime     = 0;


IO.Input.use_touch_screen   = false;

param.prev_event_name = cell2mat(Tbl.TaskTbl(param.prev_id,Tbl.TaskTblColumnID.evnt_name));
param.next_time       = Task.(param.prev_event_name).time_planned/1000;

% To restict touch to the screen in all epochs (over-written by choice
% epoch):
if TP.Restriction.ChoiceTouch == 1
   IO.Input.use_touch_screen   = true;
   param.touch.req             = 'NoTouch';
   param.touch.limits          = [0, 0, VisParam.scr_rect(3), VisParam.scr_rect(4)];
   param.touch.filter_time     = param.next_time - 0.1;
   param.touch.interrupt       = 0;
end

if strcmp(TP.Effector, 'Touch') % COULD BE MOVED TO APPLY TO ALL EPOCHS...
   SetMouse(0,0,1);
end

param.expPageMod    = 0;

TaskOp.eyeInterrupt     = 0;
TaskOp.handInterrupt    = 0;
TaskOp.eyeHold          = 0;
TaskOp.handHold         = 0;
TaskOp.eyeHoldTime      = 0;
TaskOp.handHoldTime     = 0;
TaskOp.repeatError      = 0;

param.on_bit            = [];
param.off_bit           = [];

param.juiceString       = [];

param.dynamic           = 0;

switch param.time_beh
    case 1 % called by timer
        switch TrialType
            case 1 %BDM
                switch param.prev_id
                    case 1 % Pre_Trial
                        param.next_id           = 2;
                        if strcmp(TP.Effector, 'Touch')
                            HideCursor
                        end
                    case 2 % Joy_Hold
                        param.hand.req          = Stim.JoyHold.handReq;
                        param.hand.filter_time  = Stim.JoyHold.filter_time;
                        param.hand.interrupt    = Stim.JoyHold.handInterrupt;
                        param.hand.hold         = Stim.JoyHold.hold;
                        param.hand.holdTime     = Stim.JoyHold.holdTime;
                        param.next_id           = 3;
                    case 3 % Offer  
                        param.next_id           = 4;
                       if TP.Restriction.NoOfferTouch == 1
                           IO.Input.use_touch_screen   = true;
                           param.touch.req             = 'NoTouch';
                           param.touch.limits          = [0, 0, VisParam.scr_rect(3), VisParam.scr_rect(4)];
                           param.touch.filter_time     = Task.Offer.time_planned/1000;
                           param.touch.interrupt       = 0;
                           
                           param.hand.req          = Stim.JoyHold.handReq;
                           param.hand.filter_time  = Stim.JoyHold.filter_time;
                           param.hand.interrupt    = Stim.JoyHold.handInterrupt;
                           param.hand.hold         = Stim.JoyHold.hold;
                           param.hand.holdTime     = Stim.JoyHold.holdTime;
                       end
                    case 4 % MonkBid
                        if strcmp(TP.Effector, 'Joy')
                            IO.Input.joy.CentreFix  = 0; % Stop centre-joystick requirement.
                            if strcmp(TP.BDM.BiddingType,'C') % Continuous version
                                param.dynamic           = 1; % Open Dynamic modigmonitorbehaviour script.
                            elseif strcmp(TP.BDM.BiddingType,'D')
                                param.dynamic           = 6; % Open discrete version of script.
                            end
                        else
                            if strcmp(TP.BDM.AuctionType,'BDM_PAV')
                                param.dynamic = 0;
                                IO.Input.use_touch_screen   = true;
                                param.touch.req             = 'NoTouch';
                                param.touch.limits          = [0, 0, VisParam.scr_rect(3), VisParam.scr_rect(4)];
                                param.touch.filter_time     = Task.MonkBid.time_planned/1000 - 0.1;
                                param.touch.interrupt       = 0;
                            else
                                param.dynamic = 0;
                                IO.Input.use_touch_screen   = true;
                                if strcmp(TP.BDM.BiddingType,'C')
                                    if strcmp(TP.BDM.AuctionType,'BDM_Forced')
                                        param.touch.req             = 'Target_C';
                                        param.touch.limits          = TO.Stimuli.BDMf.TargetPos;
                                    else
                                        param.touch.req             = 'oneTouchArea';
                                        param.touch.limits          = TO.Stimuli.BDM.TouchZone;
                                    end
                                elseif strcmp(TP.BDM.BiddingType,'D')
                                    if strcmp(TP.BDM.AuctionType,'BDM_Forced')
                                        param.touch.req             = 'Target_D';
                                        param.touch.limits          = TO.Stimuli.BDMf.TargetPos;
                                    else
                                        param.touch.req             = 'DiscreteBid';
                                        param.touch.limits          = TO.Stimuli.BDM.TouchZone;
                                    end
                                end
                                
                                param.touch.filter_time     = Task.MonkBid.time_planned/1000 - 0.1;
                                param.touch.interrupt       = 0;
                            end    
                        end
                        param.next_id           = 5;                  
                    case 5 % CompBid
                        if TP.BDM.MBID > TP.BDM.CBID % WIN
                            if strcmp(TP.BDM.AuctionType,'BDM') || strcmp(TP.BDM.AuctionType,'BDM_PAV') || strcmp(TP.BDM.AuctionType,'BDM_Forced')
                                TP.BDM.RemainingWater   = (TP.BDM.WaterMax -(TP.BDM.CBID*TP.BDM.WaterMax));
                            elseif strcmp(TP.BDM.AuctionType,'First')
                                TP.BDM.RemainingWater   = (TP.BDM.WaterMax -(TP.BDM.MBID*TP.BDM.WaterMax));
                                TO.Stimuli.BDM.PayRect.Pos(2) = TO.Params.BDM.FP_BidPoint;
                                s_PayRectPos            = num2str(TO.Stimuli.BDM.PayRect.Pos);
                                s_PayRectCol            = num2str(TO.Stimuli.BDM.PayRect.Col);
                                s_WindowNumber          = num2str(VisParam.scr_handle);
                                VisParam.page(6).draw   = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_PayRectCol,'], [', s_PayRectPos,']);');
                            end
                            TP.BDM.Outcome          = 1;
                            param.next_id           = 6;
                        elseif TP.BDM.MBID == TP.BDM.CBID % DRAW
                            coinflip = rand;
                            if coinflip > 0.5 % WIN
                                if strcmp(TP.BDM.AuctionType,'BDM') || strcmp(TP.BDM.AuctionType,'BDM_Forced') || strcmp(TP.BDM.AuctionType,'BDM_PAV')
                                    TP.BDM.RemainingWater   = (TP.BDM.WaterMax -(TP.BDM.CBID*TP.BDM.WaterMax));
                                elseif strcmp(TP.BDM.AuctionType,'First')
                                    TP.BDM.RemainingWater   = (TP.BDM.WaterMax -(TP.BDM.MBID*TP.BDM.WaterMax));
                                    TO.Stimuli.BDM.PayRect.Pos(2) = TO.Params.BDM.FP_BidPoint;
                                    s_PayRectPos            = num2str(TO.Stimuli.BDM.PayRect.Pos);
                                    s_PayRectCol            = num2str(TO.Stimuli.BDM.PayRect.Col);
                                    s_WindowNumber          = num2str(VisParam.scr_handle);
                                    VisParam.page(6).draw   = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_PayRectCol,'], [', s_PayRectPos,']);');
                                end
                                TP.BDM.Outcome          = 1;
                                param.next_id           = 6;
                            else % LOSS
                                TP.BDM.Outcome          = 0;
                                TP.BDM.RemainingWater   = TP.BDM.WaterMax;
                                param.next_id           = 7;
                            end
                        else % LOSS
                            TP.BDM.Outcome          = 0;
                            TP.BDM.RemainingWater   = TP.BDM.WaterMax;
                            param.next_id           = 7;
                        end
                    case 6 % Payment - win
                        TP.BDM.RewardVol        = TP.Reward.Volume;
                        param.next_id           = 8; 
                    case 7 % Payment - Loss
                        TP.BDM.RewardVol        = 0;
                        VisParam.page(9).draw  = ' '; % No frame if reward lost
                        param.next_id           = 8; 
                    case 8 % Present screen and wait for water delivery
                        param.next_id           = 9;
                    case 9 % WATER DELIVERY
                        param.juiceString = calibrateJuiceDelivery('WaterDelivery',TP.BDM.RemainingWater); % NEW LOCATION FOR DELIVERY STRING.
                        TC.All.Consumption.Water       = TP.BDM.RemainingWater + TC.All.Consumption.Water;
                        TC.All.Consumption.Total       = TP.BDM.RemainingWater + TC.All.Consumption.Total;
                        TC.BDM.Consumption.Water       = TP.BDM.RemainingWater + TC.BDM.Consumption.Water;
                        TC.BDM.Consumption.Total       = TP.BDM.RemainingWater + TC.BDM.Consumption.Total;
                        if TP.BDM.Outcome == 1
                            param.next_id           = 10;
                            TP.BDM.RewardVol        = TP.Reward.Volume;
                        else
                            TP.BDM.RewardVol        = 0;
                            param.next_id           = 11;
                            VisParam.page(12).draw  = ' '; % Don't put on frame if reward was not won.
                        end
                        TP.BDM.WaterRecieved    = TP.BDM.RemainingWater;
                    case 10 % Reward - win
                        param.next_id           = 12;
                    case 11 % Reward - Loss
                        param.next_id           = 12;  
                    case 12 % JUICE DELIVERY
                        param.next_id           = 14;
                        if TP.BDM.Risky
                            if TO.Stimuli.Risky.Deliveries(TC.All.TrialNC+1) == 1
                                param.juiceString       = calibrateJuiceDelivery('JuiceDelivery',TP.BDM.RewardVol);    % NEW LOCATION FOR DELIVERY STRING.
                                TC.All.Consumption.Juice       = TP.BDM.RewardVol + TC.All.Consumption.Juice;
                                TC.All.Consumption.Total       = TP.BDM.RewardVol + TC.All.Consumption.Total;
                                TC.BDM.Consumption.Juice       = TP.BDM.RewardVol + TC.BDM.Consumption.Juice;
                                TC.BDM.Consumption.Total       = TP.BDM.RewardVol + TC.BDM.Consumption.Total;
                                TP.BDM.JuiceRecieved           = TP.BDM.RewardVol;
                            else
                                disp('NoDelivery');
                                TP.BDM.JuiceRecieved            = 0;
                            end
                        else
                                param.juiceString              = calibrateJuiceDelivery('JuiceDelivery',TP.BDM.RewardVol);    % NEW LOCATION FOR DELIVERY STRING.
                                TC.All.Consumption.Juice       = TP.BDM.RewardVol + TC.All.Consumption.Juice;
                                TC.All.Consumption.Total       = TP.BDM.RewardVol + TC.All.Consumption.Total;
                                TC.BDM.Consumption.Juice       = TP.BDM.RewardVol + TC.BDM.Consumption.Juice;
                                TC.BDM.Consumption.Total       = TP.BDM.RewardVol + TC.BDM.Consumption.Total;
                                TP.BDM.JuiceRecieved           = TP.BDM.RewardVol;
                        end
                    case 13% Error
                        PsychPortAudio('Start',Stim.ErrorSound,1,[],1);
                        TP.BDM.Error            = 1;
                        
                        IO.Input.use_touch_screen   = false;
                        param.touch.req             = [];
                        param.touch.limits          = [0, 0, VisParam.scr_rect(3), VisParam.scr_rect(4)];
                        param.touch.filter_time     = param.next_time - 0.1;
                        param.touch.interrupt       = 0;
                        
                        TC.BDM.Error.nError     = TC.BDM.Error.nError + 1;
                        TC.BDM.Error.nNoHold    = TC.BDM.Error.nNoHold + TaskOp.Error.NoHold;
                        TC.BDM.Error.nNoBid     = TC.BDM.Error.nNoBid + TaskOp.Error.NoChoice;
                        TC.BDM.Error.nNotCentred= TC.BDM.Error.nNotCentred + TaskOp.Error.NotCentred;
                        TC.BDM.Error.nSecondTouch= TC.BDM.Error.nSecondTouch + TaskOp.Error.SecondTouch;
                        TC.BDM.Error.nOutTouch  = TC.BDM.Error.nOutTouch + TaskOp.Error.OutTouch;
                        TC.BDM.Error.nTargetMiss= TC.BDM.Error.nTargetMiss + TaskOp.Error.TargetMiss;
                        
                        TP.BDM.WaterRecieved    = 0;
                        TP.BDM.JuiceRecieved    = 0;
                        TP.BDM.CBID             = NaN;
                        
                        param.next_id           = 14;
                        TP.BDM.correct          = 0;

                    case 14% ITI
                        param.next_id           = 1;
                        
                        IO.Input.use_touch_screen   = false;
                        param.touch.req             = [];
                        param.touch.limits          = [0, 0, VisParam.scr_rect(3), VisParam.scr_rect(4)];
                        param.touch.filter_time     = param.next_time - 0.1;
                        param.touch.interrupt       = 0;
                        
                        TC.All.TrialN = TC.All.TrialN + 1;
                        TC.BDM.TrialN = TC.BDM.TrialN + 1;
                        if TP.BDM.Error  ~=1
                            TC.All.TrialNC = TC.All.TrialNC + 1;
                            TC.BDM.TrialNC = TC.BDM.TrialNC + 1;
                            if strcmp(TP.BDM.AuctionType,'BDM_Forced')
                                TC.BDMf.TrialNC = TC.BDMf.TrialNC  + 1;
                            end
                        end
                        ModigSaveData_BDM_BC;
                        HideCursor
                end
            case 2
                switch param.prev_id
                    case 15 % Pre_Trial
                        param.next_id           = 16;           
                    case 16 % Joy_Hold
                        param.hand.req          = Stim.JoyHold.handReq;
                        param.hand.filter_time  = Stim.JoyHold.filter_time;
                        param.hand.interrupt    = Stim.JoyHold.handInterrupt;
                        param.hand.hold         = Stim.JoyHold.hold;
                        param.hand.holdTime     = Stim.JoyHold.holdTime;
                        param.next_id           = 17;
                    case 17 % Offer                      
                        param.next_id           = 18; 
                    case 18 % Choice
                        IO.Input.joy.CentreFix  = 0;
                        param.dynamic           = 2;
                        param.next_id           = 19;
                    case 19 % Present choice
                        switch TP.BCs.ChoiceType
                            case 1 % JUICE
                                param.next_id           = 21;
                            case 2 % Water
                                param.next_id           = 20;
                        end
                    case 20 % Water Delay
                        param.next_id = 22;
                    case 21 % Juice Delay
                        param.next_id = 23;
                    case 22 % Water Delivery
                        param.juiceString               = calibrateJuiceDelivery('WaterDelivery_BC',TP.BCs.WaterOffer);
                        TC.All.Consumption.Water        = TP.BCs.WaterOffer + TC.All.Consumption.Water;
                        TC.All.Consumption.Total        = TP.BCs.WaterOffer + TC.All.Consumption.Total;
                        TC.BCs.Consumption.Water        = TP.BCs.WaterOffer + TC.BCs.Consumption.Water;
                        TC.BCs.Consumption.Total        = TP.BCs.WaterOffer + TC.BCs.Consumption.Total;
                        TP.BCs.WaterRecieved            = TP.BCs.WaterOffer;
                        param.next_id = 24;
                    case 23 % Juice Delivery
                        TP.BCs.RewardVol                = TP.Reward.Volume;
                        param.juiceString               = calibrateJuiceDelivery('JuiceDelivery_BC',TP.BCs.RewardVol);
                        TC.All.Consumption.Juice        = TP.BCs.RewardVol + TC.All.Consumption.Juice;
                        TC.All.Consumption.Total        = TP.BCs.RewardVol + TC.All.Consumption.Total;
                        TC.BCs.Consumption.Juice        = TP.BCs.RewardVol + TC.BCs.Consumption.Juice;
                        TC.BCs.Consumption.Total        = TP.BCs.RewardVol + TC.BCs.Consumption.Total;
                        TP.BCs.JuiceRecieved            = TP.BCs.RewardVol;
                        param.next_id = 26;
                    case 24 % WaterWait
                        param.next_id = 26;
                    case 25 % Error
                        PsychPortAudio('Start',Stim.ErrorSound,1,[],1);
                        TP.BCs.Error            = 1;
                        
                        TC.BCs.Error.nError     = TC.BCs.Error.nError + 1;
                        TC.BCs.Error.nNoHold    = TC.BCs.Error.nNoHold + TaskOp.Error.NoHold;
                        TC.BCs.Error.nNoChoice  = TC.BCs.Error.nNoChoice + TaskOp.Error.NoChoice;
                        TC.BCs.Error.nNotCentred= TC.BCs.Error.nNotCentred + TaskOp.Error.NotCentred;

                        param.next_id           = 26;
                        TP.BCs.correct          = 0;
                    case 26
                        param.next_id           = 15;
                        TC.All.TrialN = TC.All.TrialN + 1;
                        TC.BCs.TrialN = TC.BCs.TrialN + 1;
                        if TP.BCs.Error  ~=1
                            TC.All.TrialNC = TC.All.TrialNC + 1;
                            TC.BCs.TrialNC = TC.BCs.TrialNC + 1;
                        end
                        ModigSaveData_BDM_BC;    
                end
            case 3 % BCb
                switch param.prev_id
                    case 15 % Pre_Trial
                        param.next_id           = 16;
                        if strcmp(TP.Effector, 'Touch')
                            HideCursor
                        end
                    case 16 % Joy_Hold
                        param.hand.req          = Stim.JoyHold.handReq;
                        param.hand.filter_time  = Stim.JoyHold.filter_time;
                        param.hand.interrupt    = Stim.JoyHold.handInterrupt;
                        param.hand.hold         = Stim.JoyHold.hold;
                        param.hand.holdTime     = Stim.JoyHold.holdTime;
                        param.next_id           = 17;
                    case 17 % Offer
                        param.next_id           = 18;
                        if strcmp(TP.Effector, 'Touch') % COULD BE MOVED TO APPLY TO ALL EPOCHS...
                           if TP.Restriction.NoOfferTouch == 1
                            IO.Input.use_touch_screen   = true;
                            param.touch.req             = 'NoTouch';
                            param.touch.limits          = [0, 0, VisParam.scr_rect(3), VisParam.scr_rect(4)];
                            param.touch.filter_time     = Task.Offer_BC.time_planned/1000;
                            param.touch.interrupt       = 0;
                            
                           	param.hand.req              = Stim.JoyHold.handReq;
                            param.hand.filter_time      = Stim.JoyHold.filter_time;
                            param.hand.interrupt        = Stim.JoyHold.handInterrupt;
                            param.hand.hold             = Stim.JoyHold.hold;
                            param.hand.holdTime         = Stim.JoyHold.holdTime;
                           end
                        end
                    case 18 % Choice
                        if strcmp(TP.Effector, 'Joy')
                            IO.Input.joy.CentreFix  = 0;
                            param.dynamic           = 3;
                        else
                            param.dynamic           = 0;
                            IO.Input.use_touch_screen   = true;
                            param.touch.req             = 'twoTouchAreas';
                            TO.Stimuli.BCb.TouchZone    = [50, 50, TP.BCb.LeftLimit-TP.BCb.LSO, VisParam.scr_rect(4) - 50; TP.BCb.RightLimit+TP.BCb.RSO, 50, VisParam.scr_rect(3)-50, VisParam.scr_rect(4)-50];
                            param.touch.limits          = TO.Stimuli.BCb.TouchZone;
                            param.touch.filter_time     = Task.Choice_BC.time_planned/1000 - 0.1;
                            param.touch.interrupt       = 0;
                        end
                        param.next_id           = 19;
                    case 19 % Present choice
                        param.next_id           = 20;
                    case 20 % Water Delay
                        param.next_id = 22;
                    case 22 % Water Delivery
                        switch TP.BCb.ChoiceType
                            case 1 % JUICE
                                param.next_id           = 27; % JuiceDelay
                                param.juiceString       = calibrateJuiceDelivery('WaterDelivery_BC',TP.BCb.WaterOffer1);
                                WaterOffer              = TP.BCb.WaterOffer1;
                            case 2 % Water
                                param.next_id           = 24; % WaterWait
                                param.juiceString       = calibrateJuiceDelivery('WaterDelivery_BC',TP.BCb.WaterOffer2);
                                WaterOffer              = TP.BCb.WaterOffer2;
                        end
                        TC.All.Consumption.Water        = WaterOffer + TC.All.Consumption.Water;
                        TC.All.Consumption.Total        = WaterOffer + TC.All.Consumption.Total;
                        TC.BCb.Consumption.Water        = WaterOffer + TC.BCb.Consumption.Water;
                        TC.BCb.Consumption.Total        = WaterOffer + TC.BCb.Consumption.Total;
                        TP.BCb.WaterRecieved            = WaterOffer;
                    case 27 % Juice Delay
                        param.next_id = 23;
                    case 23 % Juice Delivery
                        if TP.BCb.ChoiceType == 1
                            if TO.Stimuli.Risky.Deliveries(TC.All.TrialNC+1) == 1
                                TP.BCb.RewardVol                = TP.Reward.Volume;
                                TP.BCb.JuiceRecieved            = TP.BCb.RewardVol;
                                param.juiceString               = calibrateJuiceDelivery('JuiceDelivery_BC',TP.BCb.RewardVol);
                                TC.All.Consumption.Juice        = TP.BCb.RewardVol + TC.All.Consumption.Juice;
                                TC.All.Consumption.Total        = TP.BCb.RewardVol + TC.All.Consumption.Total;
                                TC.BCb.Consumption.Juice        = TP.BCb.RewardVol + TC.BCb.Consumption.Juice;
                                TC.BCb.Consumption.Total        = TP.BCb.RewardVol + TC.BCb.Consumption.Total;
                            else
                                TP.BCb.RewardVol                = TP.Reward.Volume;
                                disp('NoDelivery');
                                TP.BCb.JuiceRecieved            = 0;
                            end
                        end
                            param.next_id = 26;
                    case 24 % WaterWait
                        param.next_id = 26;
                    case 25 % Error
                        PsychPortAudio('Start',Stim.ErrorSound,1,[],1);
                        TP.BCb.Error            = 1;
                        
                        IO.Input.use_touch_screen   = false;
                        param.touch.req             = [];
                        param.touch.limits          = [0, 0, VisParam.scr_rect(3), VisParam.scr_rect(4)];
                        param.touch.filter_time     = param.next_time - 0.1;
                        param.touch.interrupt       = 0;
                        
                        TC.BCb.Error.nError     = TC.BCb.Error.nError + 1;
                        TC.BCb.Error.nNoHold    = TC.BCb.Error.nNoHold + TaskOp.Error.NoHold;
                        TC.BCb.Error.nNoChoice  = TC.BCb.Error.nNoChoice + TaskOp.Error.NoChoice;
                        TC.BCb.Error.nNotCentred= TC.BCb.Error.nNotCentred + TaskOp.Error.NotCentred;
                        TC.BCb.Error.nSecondTouch= TC.BCb.Error.nSecondTouch + TaskOp.Error.SecondTouch;
                        TC.BCb.Error.nOutTouch  = TC.BCb.Error.nOutTouch + TaskOp.Error.OutTouch;
                        
                        param.next_id           = 26;
                        TP.BCb.correct          = 0;
                    case 26
                        param.next_id           = 15;
                        
                        IO.Input.use_touch_screen   = false;
                        param.touch.req             = [];
                        param.touch.limits          = [0, 0, VisParam.scr_rect(3), VisParam.scr_rect(4)];
                        param.touch.filter_time     = param.next_time - 0.1;
                        param.touch.interrupt       = 0;
                        
                        TC.All.TrialN = TC.All.TrialN + 1;
                        TC.BCb.TrialN = TC.BCb.TrialN + 1;
                        if TP.BCb.Error ~=1
                            TC.All.TrialNC = TC.All.TrialNC + 1;
                            TC.BCb.TrialNC = TC.BCb.TrialNC + 1;
                        end
                        ModigSaveData_BDM_BC;
                        if strcmp(TP.Effector, 'Touch')
                            HideCursor
                        end      
                end
        end
    case 2 % called by behavior during an error
       fprintf('error @ %s\n',char(Tbl.TaskTbl(param.prev_id,Tbl.TaskTblColumnID.evnt_name)))
       IO.Input.joy.CentreFix        = 0;
       switch param.prev_id
           case 1
               TaskOp.ignored = 1;
           case 2
               TaskOp.count.noTouch = TaskOp.count.noTouch+1;
%            case 4
%                TaskOp.count.noTouch = TaskOp.count.noTouch+1;
%            case 18
%                TaskOp.count.noTouch = TaskOp.count.noTouch+1;
       end
       param.errSnd = 1;
       switch TC.All.TrialType(TC.All.TrialNC+1)
           case 1
                param.next_id = 13;
           case 2
                param.next_id = 25;
           case 3
                param.next_id = 25;
       end
end

% Recover timer and event names from global Tbl
param.prev_event_name = cell2mat(Tbl.TaskTbl(param.prev_id,Tbl.TaskTblColumnID.evnt_name));
param.next_event_name = cell2mat(Tbl.TaskTbl(param.next_id,Tbl.TaskTblColumnID.evnt_name));
param.next_page       = cell2mat(Tbl.TaskTbl(param.next_id, Tbl.TaskTblColumnID.vis_page));
param.next_time       = Task.(param.prev_event_name).time_planned/1000;
param.ok              = 1;
