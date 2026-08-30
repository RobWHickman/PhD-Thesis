function cb = ModigPreparePages_BDM_BC

global Tbl VisParam TC TO TP

% Prepare VisParam parameters:
VisParam.pages          = unique(cell2mat(Tbl.TaskTbl(:,Tbl.TaskTblColumnID.vis_page)));
VisParam.pages          = VisParam.pages(VisParam.pages>0);
VisParam.num_page       = length(VisParam.pages);
s_WindowNumber          = num2str(VisParam.scr_handle);

% Flip strings:
flpstr   = 'Screen(''Flip'',VisParam.scr_handle);';
flpnoclr = 'Screen(''Flip'',VisParam.scr_handle,[],1);';
TrialNumber = TC.All.TrialNC+1;
TrialType   = TC.All.TrialType(TrialNumber);
ITI_BKG     = TO.Stimuli.BDM.ITIBKG;
% Load draw commands into VisParam global:
switch TrialType
    case 1
        
        s_MMarkerCol            = num2str(TO.Rewards.Water.BDM.MMOffColor);
        s_MMarkerColOn          = num2str(TO.Rewards.Water.BDM.MMOnColor);
        s_CMarkerCol            = num2str(TO.Rewards.Water.BDM.CMColor);
        s_PayRectCol            = num2str(TO.Stimuli.BDM.PayRect.Col);
        s_PayRectPos            = num2str(TO.Stimuli.BDM.PayRect.Pos);
        
        if strcmp(TP.BDM.AuctionType,'BDM_Forced') 
            s_TargetCol             = num2str(TO.Stimuli.BDMf.TargetCol);
            s_TargetPos             = num2str(TO.Stimuli.BDMf.TargetPos);
        else
            s_TargetCol             = ' ';
            s_TargetPos             = ' ';
        end
        
        s_RectWidth             = num2str(TO.Stimuli.BDM.D_FrameWidth);
        % BDM PARAMS:
        if strcmp(TP.BDM.BiddingType,'C')
            s_MMarkerPos            = num2str(TO.Rewards.Water.BDM.MMPos);
            s_CMarkerPos            = num2str(TO.Rewards.Water.BDM.CMPos);
            Offer_BidBarFScale      = TO.Rewards.Water.BDM.FineScale;
            Offer_BidBarScale       = TO.Rewards.Water.BDM.Scale;
            PayRect                 = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_PayRectCol,'], [', s_PayRectPos,']);');
            Offer_BarBorder         = TO.Rewards.Water.BDM.Border;
            Offer_BidBar            = TO.Rewards.Water.BDM.Bar;
        elseif strcmp(TP.BDM.BiddingType,'D')
            if strcmp(TP.Effector,'Joy')
                s_MMarkerPos            = num2str(TO.Rewards.Water.BDM.DMMPos);
            end
            s_CMarkerPos            = num2str(TO.Rewards.Water.BDM.DCMPos);
            Offer_BidBarFScale      = ' ';
            Offer_BidBarScale       = ' ';
            PayRect                 = TO.Stimuli.BDM.DPayRect;
            Offer_BarBorder         = ' '; % Could be the same as in continuous case...
            Offer_BidBar            = TO.Rewards.Water.BDM.DBar;
        end

        % PAGE 1: PRE_TRIAL - Black background - FLIP:
        
        % PAGE 2: JOY_HOLD  - Fixation cross   - FLIPNOCLEAR:
        if strcmp(TP.BDM.AuctionType,'BDM') 
            Joy_Hold_FC             = TO.Stimuli.BDM.Fixation;
        elseif strcmp(TP.BDM.AuctionType,'First') 
            Joy_Hold_FC             = TO.Stimuli.BDM.Fixation_First;
        elseif strcmp(TP.BDM.AuctionType,'BDM_PAV')
            Joy_Hold_FC             = TO.Stimuli.BDM.Fixation_BDM_PAV;
        elseif strcmp(TP.BDM.AuctionType,'BDM_Forced')    
            Joy_Hold_FC             = TO.Stimuli.BDM.Fixation_Forced;
        end

        % PAGE 3: Offer     - Stimuli          - FLIP:     
        if strcmp(TP.Effector,'Joy')
            Offer_FC                = ' ';
            if strcmp(TP.BDM.BiddingType,'C')
            	Offer_MMarker           = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_MMarkerCol,'], [', s_MMarkerPos,']);');
                MBid_MMarker            = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_MMarkerColOn,'], [', s_MMarkerPos,']);');  
            elseif strcmp(TP.BDM.BiddingType,'D')
                Offer_MMarker           = strcat('Screen(''FrameRect'', [', s_WindowNumber,'], [', s_MMarkerCol,'], [', s_MMarkerPos,'], [', s_RectWidth,']);');
                MBid_MMarker            = strcat('Screen(''FrameRect'', [', s_WindowNumber,'], [', s_MMarkerColOn,'], [', s_MMarkerPos,'], [', s_RectWidth,']);');  
            end            
        else
            Offer_MMarker           = ' ';
            if strcmp(TP.BDM.AuctionType,'BDM_PAV')
                if strcmp(TP.BDM.BiddingType,'C')
                    MBid_MMarker        = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_MMarkerColOn,'], [', num2str(TO.Stimuli.BDM.PAV_MPOS_C),']);');  
                elseif  strcmp(TP.BDM.BiddingType,'D')
                    MBid_MMarker        = strcat('Screen(''FrameRect'', [', s_WindowNumber,'], [', s_MMarkerColOn,'], [', num2str(TO.Stimuli.BDM.PAV_MPOS_D),'], [', s_RectWidth,']);');  
                end
            else
                MBid_MMarker        = TO.Stimuli.BDM.CoverCent;
            end
            Offer_FC                = Joy_Hold_FC;
        end
        
        if strcmp(TP.BDM.AuctionType,'BDM_Forced')
            Target = strcat('Screen(''FrameRect'', [', s_WindowNumber,'], [', s_TargetCol,'], [', s_TargetPos,'], [', s_RectWidth,']);');
        else
            Target = ' ';
        end
        
        Offer_Reward            = TP.Reward.BDM.Position;
        % PAGE 4: MonkBid  - NO CHANGES HERE   - FLIPNOCLEAR: (DYNAMIC EPOCH)
                
        % PAGE 5: CompBid  - Present CBID      - FLIPNOCLEAR:
        if strcmp(TP.BDM.BiddingType,'C')
            CompBid_CMarker         = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_CMarkerCol,'], [', s_CMarkerPos,']);');
        elseif strcmp(TP.BDM.BiddingType,'D')
            CompBid_CMarker         = strcat('Screen(''FrameRect'', [', s_WindowNumber,'], [', s_CMarkerCol,'], [', s_CMarkerPos,'], [', s_RectWidth,']);');
        end
        % PAGE 6: PaymentW - Present remaining - FLIPNOCLEAR:

        % PAGE 7: PaymentL - Present remaining - FLIPNOCLEAR:
        if strcmp(TP.BDM.AuctionType,'First')
            CoverRect               = TO.Stimuli.BDM.CoverLeft_FP;
            WaterCover              = TO.Stimuli.BDM.CoverRight_FP;
            Trial_BKG               = TO.Stimuli.BDM.NormalBKG_FP;
        else
            CoverRect               = TO.Stimuli.BDM.CoverLeft;
            WaterCover              = TO.Stimuli.BDM.CoverRight;
            Trial_BKG               = TO.Stimuli.BDM.NormalBKG;
        end
        % PAGE 8: Endowment- Deliver Water     - FLIPNOCLEAR: (WITH DELAY)
        % PAGE 9: WATER DELIVERY:
        %WaterCover              = TO.Stimuli.BDM.CoverRight;
        
        % PAGE 10: RewardW  - Deliver Juice     - FLIPNOCLEAR:
        Win_Frame               = TP.Reward.BDM.FramePosition;
        % PAGE 11: RewardL  - Deliver Juice     - FLIPNOCLEAR:
        % PAGE 12: JUICE DELIVERY:
        % PAGE 13: ERROR    - GREY BACKGROUND   - FLIP:
        Error_BKG               = TO.Stimuli.BDM.ErrorBKG;
        % PAGE 14: ITI      - BLACK BACKGROUND  - FLIP:
        
        % PREPARE PAGES:
        VisParam.page(1).draw   = Trial_BKG;
        VisParam.page(2).draw   = Joy_Hold_FC;
        VisParam.page(3).draw   = [Offer_FC Offer_BarBorder Offer_BidBar Offer_BidBarFScale Offer_BidBarScale Offer_Reward Target Offer_MMarker];
        VisParam.page(4).draw   = [MBid_MMarker];
        VisParam.page(5).draw   = CompBid_CMarker;
        VisParam.page(6).draw   = PayRect;
        VisParam.page(7).draw   = CoverRect;
        VisParam.page(8).draw   = [' '];
        VisParam.page(9).draw   = [WaterCover];
        VisParam.page(10).draw  = [' '];
        VisParam.page(11).draw  = [' '];
        VisParam.page(12).draw  = [Win_Frame];
        VisParam.page(13).draw  = Error_BKG;
        VisParam.page(14).draw  = ITI_BKG;

        VisParam.page(1).flip   = flpstr;
        VisParam.page(2).flip   = flpnoclr;
        VisParam.page(3).flip   = flpstr;
        VisParam.page(4).flip   = flpnoclr;
        VisParam.page(5).flip   = flpnoclr;
        VisParam.page(6).flip   = flpnoclr;
        VisParam.page(7).flip   = flpnoclr;
        VisParam.page(8).flip   = flpnoclr;
        VisParam.page(9).flip   = flpnoclr;
        VisParam.page(10).flip  = flpnoclr;
        VisParam.page(11).flip  = flpnoclr;
        VisParam.page(12).flip  = flpnoclr;
        VisParam.page(13).flip  = flpstr;
        VisParam.page(14).flip  = flpstr;

        VisParam.page(1).str    = [Trial_BKG, flpstr];
        VisParam.page(2).str    = [Joy_Hold_FC, flpnoclr];
        VisParam.page(3).str    = [Offer_FC, Offer_MMarker, Offer_BarBorder, Offer_BidBar,  Offer_BidBarFScale, Offer_BidBarScale, Offer_Reward, Target, flpstr];
        VisParam.page(4).str    = [flpnoclr];
        VisParam.page(5).str    = [CompBid_CMarker, flpnoclr];
        VisParam.page(6).str    = [PayRect, flpnoclr];
        VisParam.page(7).str    = [CoverRect, flpnoclr];
        VisParam.page(8).str    = [flpnoclr];
        VisParam.page(9).str    = [WaterCover, flpnoclr];
        VisParam.page(10).str   = [flpnoclr];
        VisParam.page(11).str   = [flpnoclr];
        VisParam.page(12).str   = [Win_Frame, flpnoclr];
        VisParam.page(13).str   = [Error_BKG, flpstr];
        VisParam.page(14).str   = [ITI_BKG, flpstr];

        VisParam.exp_page(1).obj_handle     = [];
        VisParam.exp_page(2).obj_handle     = [];
        VisParam.exp_page(3).obj_handle     = [];
        VisParam.exp_page(4).obj_handle     = [];
        VisParam.exp_page(5).obj_handle     = [];
        VisParam.exp_page(6).obj_handle     = [];
        VisParam.exp_page(7).obj_handle     = [];
        VisParam.exp_page(8).obj_handle     = [];
        VisParam.exp_page(9).obj_handle     = [];
        VisParam.exp_page(10).obj_handle    = [];
        VisParam.exp_page(11).obj_handle    = [];
        VisParam.exp_page(12).obj_handle    = [];
        VisParam.exp_page(13).obj_handle    = [];
        VisParam.exp_page(14).obj_handle    = [];
        
    case 2 %BCs
        % BC PARAMS:
        s_VMarkerPosL           = num2str(TO.Rewards.Water.BCs.MarkerLeftPosition);
        s_VMarkerPosR           = num2str(TO.Rewards.Water.BCs.MarkerRightPosition);
        s_VMarkerCol            = num2str(TO.Rewards.Water.BCs.MarkerColor);
        % PAGE 1: PRE_TRIAL - Black background - FLIP:
        Trial_BKG               = TO.Stimuli.BCs.NormalBKG;
        % PAGE 2: JOY_HOLD  - Fixation cross   - FLIPNOCLEAR:
        Joy_Hold_FC             = TO.Stimuli.BCs.Fixation;
        % PAGE 3: Offer     - Stimuli          - FLIP:
        switch TP.BCs.FractalSide
            case 1 % Left
                Left_Offer      = TP.Reward.BCs.LeftPosition;
                Right_Offer     = TO.Rewards.Water.BCs.BarRightPosition;
                Value_Marker    = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VMarkerCol,'], [', s_VMarkerPosR,']);');
            case 2 % Right
                Right_Offer     = TP.Reward.BCs.RightPosition;
                Left_Offer      = TO.Rewards.Water.BCs.BarLeftPosition;
                Value_Marker    = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VMarkerCol,'], [', s_VMarkerPosL,']);');
        end
        % PAGE 4: CHOICE  - NO CHANGES HERE, Marker is 'invisible'  - FLIPNOCLEAR: (DYNAMIC EPOCH)
        % Cover unchosen within dynamicbehaviourmonitor.
        % PAGE 5: PRESENT CHOICE - FLIPNOCLEAR:
        % PAGE 6: Water Delay - FLIPNOCLEAR:
        % PAGE 7: Juice Delay - FLIPNOCLEAR:
        % PAGE 8: Water Reward - FLIPNOCLEAR:
        % PAGE 9: Juice Reward - FLIPNOCLEAR:
        % PAGE 10: ERROR - FLIP:
        Error_BKG               = TO.Stimuli.BCs.ErrorBKG;
        % PAGE 11: ITI - FLIP:
        % PREPARE PAGES:
        VisParam.page(15).draw  = Trial_BKG;
        VisParam.page(16).draw  = Joy_Hold_FC;
        VisParam.page(17).draw  = [Left_Offer Right_Offer Value_Marker];
        VisParam.page(18).draw  = [' '];
        VisParam.page(19).draw  = [' '];
        VisParam.page(20).draw  = [' '];
        VisParam.page(21).draw  = [' '];
        VisParam.page(22).draw  = [' '];
        VisParam.page(23).draw  = [' '];
        VisParam.page(24).draw  = [' '];
        VisParam.page(25).draw  = Error_BKG;
        VisParam.page(26).draw  = ITI_BKG;

        VisParam.page(15).flip  = flpstr;
        VisParam.page(16).flip  = flpnoclr;
        VisParam.page(17).flip  = flpstr;
        VisParam.page(18).flip  = flpnoclr;
        VisParam.page(19).flip  = flpnoclr;
        VisParam.page(20).flip  = flpnoclr;
        VisParam.page(21).flip  = flpnoclr;
        VisParam.page(22).flip  = flpstr;
        VisParam.page(23).flip  = flpstr;
        VisParam.page(24).flip  = flpstr;
        VisParam.page(25).flip  = flpstr;
        VisParam.page(26).flip  = flpstr;

        VisParam.page(15).str   = [Trial_BKG, flpstr];
        VisParam.page(16).str   = [Joy_Hold_FC, flpnoclr];
        VisParam.page(17).str   = [Left_Offer, Right_Offer, Value_Marker, flpstr];
        VisParam.page(18).str   = [flpnoclr];
        VisParam.page(19).str   = [flpnoclr];
        VisParam.page(20).str   = [flpnoclr];
        VisParam.page(21).str   = [flpnoclr];
        VisParam.page(22).str   = [flpstr];
        VisParam.page(23).str   = [flpstr];
        VisParam.page(24).str   = [flpstr];
        VisParam.page(25).str   = [Error_BKG, flpstr];
        VisParam.page(26).str   = [ITI_BKG, flpstr];

        VisParam.exp_page(15).obj_handle     = [];
        VisParam.exp_page(16).obj_handle     = [];
        VisParam.exp_page(17).obj_handle     = [];
        VisParam.exp_page(18).obj_handle     = [];
        VisParam.exp_page(19).obj_handle     = [];
        VisParam.exp_page(20).obj_handle     = [];
        VisParam.exp_page(21).obj_handle     = [];
        VisParam.exp_page(22).obj_handle     = [];
        VisParam.exp_page(23).obj_handle     = [];
        VisParam.exp_page(24).obj_handle     = [];
        VisParam.exp_page(25).obj_handle     = [];
        VisParam.exp_page(26).obj_handle     = [];
 case 3 %BCb
        % BC PARAMS:
        s_VMarkerPosL           = num2str(TO.Rewards.Water.BCb.MarkerLeftPosition);
        s_VMarkerPosR           = num2str(TO.Rewards.Water.BCb.MarkerRightPosition);
        s_VMarkerCol            = num2str(TO.Rewards.Water.BCb.MarkerColor);
        
        if strcmp(TP.BDM.BiddingType,'C')
            s_VRectL                = num2str(TO.Stimuli.BCb.PayRect.LPos);
            s_VRectR                = num2str(TO.Stimuli.BCb.PayRect.RPos);
            s_VRectCol              = num2str(TO.Stimuli.BCb.PayRect.Col);
        end
        
        % PAGE 1: PRE_TRIAL - Black background - FLIP:
        Trial_BKG               = TO.Stimuli.BCs.NormalBKG;
        % PAGE 2: JOY_HOLD  - Fixation cross   - FLIPNOCLEAR:
        Joy_Hold_FC             = TO.Stimuli.BCb.Fixation;
        % PAGE 3: Offer     - Stimuli          - FLIP:
        Left_Scale      = TO.Rewards.Water.BCb.LScale;
        Left_FScale     = TO.Rewards.Water.BCb.LFineScale;
        Right_Scale     = TO.Rewards.Water.BCb.RScale;
        Right_FScale    = TO.Rewards.Water.BCb.RFineScale;
        
        LBorder         = TO.Rewards.Water.BCb.BarLBorder;
        RBorder         = TO.Rewards.Water.BCb.BarRBorder;
        Bar_LBlackout   = TO.Rewards.Water.BCb.BlackoutL;
        Bar_RBlackout   = TO.Rewards.Water.BCb.BlackoutR;
        
        if strcmp(TP.Effector,'Joy')
            Offer_FC                = ' ';
            Cover_Cent              = ' ';  
        else
            Cover_Cent              = TO.Stimuli.BDM.CoverCent;
            Offer_FC                = TO.Stimuli.BCb.Fixation;
        end
        
        switch TP.BCb.FractalSide
            case 1 % Left 
                Left_Offer1     = TP.Reward.BCb.LeftPosition;
                Right_Offer1    = ' ';
                Frame           = TP.Reward.BCb.LeftPositionFrame;
                if strcmp(TP.BDM.BiddingType,'D')
                    PayRectR        = ' ';
                    Left_Offer2     = TO.Rewards.Water.BDM.DLBar;
                    Right_Offer2    = TO.Rewards.Water.BDM.DRBar;
                    Value_MarkerR   = ' ';
                    LBorder         = ' ';
                    RBorder         = ' ';
                    PayRectL        = ' ';
                    if TP.BCb.DivNL ~= 0
                        PayRectL        = TO.Stimuli.BDM.DPayRect;
                        Value_MarkerL   = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VMarkerCol,'], [', num2str(TO.Rewards.Water.BCb.MarkerLeftPosition),']);');
                    else
                        Value_MarkerL   = ' ';
                    end
                    
                    if TP.BCb.BiasFix == 1 && TP.BCb.DivNR ~= 0
                            PayRectR        = TO.Stimuli.BDM.DPayRectBF;
                            Value_MarkerR   = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VMarkerCol,'], [', num2str(TO.Rewards.Water.BCb.MarkerRightPosition),']);');
                    end
                    
                elseif strcmp(TP.BDM.BiddingType,'C')
                    PayRectL        = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VRectCol,'], [', s_VRectL,']);');
                    PayRectR        = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VRectCol,'], [', s_VRectR,']);'); %' ';  %%%%4
                    Value_MarkerL   = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VMarkerCol,'], [', s_VMarkerPosL,']);');
                    Value_MarkerR   = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VMarkerCol,'], [', s_VMarkerPosR,']);');
                    Left_Offer2     = TO.Rewards.Water.BCb.BarLeftPosition;
                    Right_Offer2    = TO.Rewards.Water.BCb.BarRightPosition;
                end

                if TP.BCb.BiasFix == 1
                    Left_Offer1     = ' ';
                    Frame           = ' ';
                end
            
            case 2 % Right
                Right_Offer1    = TP.Reward.BCb.RightPosition;
                Left_Offer1     = ' ';
                Frame           = TP.Reward.BCb.RightPositionFrame;
                
                if strcmp(TP.BDM.BiddingType,'D')
                    PayRectL        = ' ';
                    Left_Offer2     = TO.Rewards.Water.BDM.DLBar;
                    Right_Offer2    = TO.Rewards.Water.BDM.DRBar;
                    Value_MarkerL   = ' ';
                    LBorder         = ' ';
                    PayRectR        = ' ';
                    RBorder         = ' ';
                    
                    if TP.BCb.DivNR ~= 0
                        PayRectR        = TO.Stimuli.BDM.DPayRect;
                        Value_MarkerR   = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VMarkerCol,'], [', num2str(TO.Rewards.Water.BCb.MarkerRightPosition),']);');
                    else
                        Value_MarkerR   = ' ';
                    end
                    
                    if TP.BCb.BiasFix == 1 && TP.BCb.DivNL ~= 0
                            PayRectL        = TO.Stimuli.BDM.DPayRectBF;
                            Value_MarkerL   = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VMarkerCol,'], [', num2str(TO.Rewards.Water.BCb.MarkerLeftPosition),']);');
                    end
                    
                elseif strcmp(TP.BDM.BiddingType,'C')
                    PayRectL        = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VRectCol,'], [', s_VRectL,']);');
                    PayRectR        = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VRectCol,'], [', s_VRectR,']);');
                    Value_MarkerL   = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VMarkerCol,'], [', s_VMarkerPosL,']);');
                    Value_MarkerR   = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_VMarkerCol,'], [', s_VMarkerPosR,']);');
                    Left_Offer2     = TO.Rewards.Water.BCb.BarLeftPosition;
                    Right_Offer2    = TO.Rewards.Water.BCb.BarRightPosition;
                end

                if TP.BCb.BiasFix == 1
                    Right_Offer1    = ' ';
                    Frame           = ' ';
                end
                
        end
        % PAGE 4: CHOICE  - NO CHANGES HERE, Marker is 'invisible'  - FLIPNOCLEAR: (DYNAMIC EPOCH)
        % Cover unchosen within dynamicbehaviourmonitor.
        % PAGE 5: PRESENT CHOICE - FLIPNOCLEAR:
        % PAGE 6: Water Delay - FLIPNOCLEAR:
        % PAGE 7: Juice Delay - FLIPNOCLEAR:
        % PAGE 8: Water Reward - FLIPNOCLEAR:
        % PAGE 9: Juice Reward - FLIPNOCLEAR:
        % PAGE 10: ERROR - FLIP:
        Error_BKG               = TO.Stimuli.BCs.ErrorBKG;
        % PAGE 11: ITI - FLIP:
        % PREPARE PAGES:
        VisParam.page(15).draw  = Trial_BKG;
        VisParam.page(16).draw  = Joy_Hold_FC;
        VisParam.page(17).draw  = [Offer_FC RBorder LBorder Left_Offer1 Left_Offer2 Right_Offer1 Right_Offer2 Left_Scale Left_FScale Right_Scale Right_FScale Value_MarkerL Value_MarkerR PayRectL PayRectR];
        VisParam.page(18).draw  = [Cover_Cent];
        VisParam.page(19).draw  = [' '];
        VisParam.page(20).draw  = [' '];
        VisParam.page(21).draw  = [' '];
        VisParam.page(22).draw  = [Bar_LBlackout Bar_RBlackout];
        VisParam.page(23).draw  = [Frame];
        VisParam.page(24).draw  = [' '];
        VisParam.page(25).draw  = Error_BKG;
        VisParam.page(26).draw  = ITI_BKG;
        VisParam.page(27).draw  = [' '];
        
        VisParam.page(15).flip  = flpstr;
        VisParam.page(16).flip  = flpnoclr;
        VisParam.page(17).flip  = flpstr;
        VisParam.page(18).flip  = flpnoclr;
        VisParam.page(19).flip  = flpnoclr;
        VisParam.page(20).flip  = flpnoclr;
        VisParam.page(21).flip  = flpnoclr;
        VisParam.page(22).flip  = flpnoclr;
        VisParam.page(23).flip  = flpnoclr;
        VisParam.page(24).flip  = flpstr;
        VisParam.page(25).flip  = flpstr;
        VisParam.page(26).flip  = flpstr;
        VisParam.page(27).flip  = flpnoclr;

        VisParam.page(15).str   = [Trial_BKG, flpstr];
        VisParam.page(16).str   = [Joy_Hold_FC, flpnoclr];
        VisParam.page(17).str   = [Offer_FC, RBorder, LBorder, Left_Offer1, Left_Offer2, Right_Offer1, Right_Offer2, Left_Scale, Left_FScale, Right_Scale, Right_FScale, Value_MarkerL, Value_MarkerR, PayRectL, PayRectR, flpstr];
        VisParam.page(18).str   = [Cover_Cent, flpnoclr];
        VisParam.page(19).str   = [flpnoclr];
        VisParam.page(20).str   = [flpnoclr];
        VisParam.page(21).str   = [flpnoclr];
        VisParam.page(22).str   = [Bar_LBlackout, Bar_RBlackout, flpnoclr];
        VisParam.page(23).str   = [Frame, flpnoclr];
        VisParam.page(24).str   = [flpstr];
        VisParam.page(25).str   = [Error_BKG, flpstr];
        VisParam.page(26).str   = [ITI_BKG, flpstr];
        VisParam.page(27).str   = [flpnoclr];
        
        VisParam.exp_page(15).obj_handle     = [];
        VisParam.exp_page(16).obj_handle     = [];
        VisParam.exp_page(17).obj_handle     = [];
        VisParam.exp_page(18).obj_handle     = [];
        VisParam.exp_page(19).obj_handle     = [];
        VisParam.exp_page(20).obj_handle     = [];
        VisParam.exp_page(21).obj_handle     = [];
        VisParam.exp_page(22).obj_handle     = [];
        VisParam.exp_page(23).obj_handle     = [];
        VisParam.exp_page(24).obj_handle     = [];
        VisParam.exp_page(25).obj_handle     = [];
        VisParam.exp_page(26).obj_handle     = [];
        VisParam.exp_page(27).obj_handle     = [];
end
cb=1;