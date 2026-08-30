function UpdateSettings(Type)

global IO TG TP TO TC

switch Type
    case 'SetUp'
        % Joystick parameters:
        set(TG.BDM_BC_GUI.Handles.Joy_Use,'String',num2str(IO.Input.joy.monitor));
        set(TG.BDM_BC_GUI.Handles.Joy_Centre,'String',num2str(IO.Input.joy.DefCentreFix));
        set(TG.BDM_BC_GUI.Handles.Joy_Centre_Threshold,'String',num2str(IO.Input.joy.Centre_Threshold));
        set(TG.BDM_BC_GUI.Handles.Joy_Sensitivity_Threshold,'String',num2str(IO.Input.joy.Sensitivity_Threshold));
        set(TG.BDM_BC_GUI.Handles.Joy_Window,'String',num2str(TP.BDM.Joy.Window));
        
        % Session settings:
        set(TG.BDM_BC_GUI.Handles.MonkeyID,'String',TC.All.MonkeyID);
%         set(TG.BDM_BC_GUI.Handles.Current_Session_Type,'String',TC.All.SessionType);
        
        % BDM parameters:
        set(TG.BDM_BC_GUI.Handles.C_Dist,'String',TP.BDM.CDistType);
        set(TG.BDM_BC_GUI.Handles.Bidding_Type,'String',TP.BDM.BiddingType);
%         set(TG.BDM_BC_GUI.Handles.BDM_Juice_Set,'String',num2str(TP.BDM.JuiceSet));
%         set(TG.BDM_BC_GUI.Handles.BDM_JBlock_Type,'String',TC.BDM.BlockType);
        set(TG.BDM_BC_GUI.Handles.BDM_Block_Length,'String',num2str(TP.BDM.BlockS));
        set(TG.BDM_BC_GUI.Handles.BDM_JBlock_Length,'String',num2str(TP.BDM.JBlockS));
        % BCB parameters:
%         set(TG.BDM_BC_GUI.Handles.BCb_Juice_Set,'String',num2str(TP.BCb.JuiceSet));
        set(TG.BDM_BC_GUI.Handles.BCb_Block_Length,'String',num2str(TP.BCb.BlockS));
%         set(TG.BDM_BC_GUI.Handles.BCb_JBlock_Type,'String',TC.BCb.BlockType);
        set(TG.BDM_BC_GUI.Handles.BCb_JBlock_Length,'String',num2str(TP.BCb.JBlockS));
        
        % Bidding parameters:
        set(TG.BDM_BC_GUI.Handles.Fixed_Alpha,'String',num2str(TP.BDM.FixedAlpha));
        set(TG.BDM_BC_GUI.Handles.Fixed_Alpha,'String',num2str(TP.BDM.FixedBeta));
        set(TG.BDM_BC_GUI.Handles.BH_Alpha,'String',num2str(TO.Rewards.B_High.PCoeffs(1)));
        set(TG.BDM_BC_GUI.Handles.BH_Beta,'String',num2str(TO.Rewards.B_High.PCoeffs(2)));
        set(TG.BDM_BC_GUI.Handles.BM_Alpha,'String',num2str(TO.Rewards.B_Mid.PCoeffs(1)));
        set(TG.BDM_BC_GUI.Handles.BM_Beta,'String',num2str(TO.Rewards.B_Mid.PCoeffs(2)));
        set(TG.BDM_BC_GUI.Handles.BL_Alpha,'String',num2str(TO.Rewards.B_Low.PCoeffs(1)));
        set(TG.BDM_BC_GUI.Handles.BL_Beta,'String',num2str(TO.Rewards.B_Low.PCoeffs(2)));
        set(TG.BDM_BC_GUI.Handles.OH_Alpha,'String',num2str(TO.Rewards.O_High.PCoeffs(1)));
        set(TG.BDM_BC_GUI.Handles.OH_Beta,'String',num2str(TO.Rewards.O_High.PCoeffs(2)));
        set(TG.BDM_BC_GUI.Handles.OM_Alpha,'String',num2str(TO.Rewards.O_Mid.PCoeffs(1)));
        set(TG.BDM_BC_GUI.Handles.OM_Beta,'String',num2str(TO.Rewards.O_Mid.PCoeffs(2)));
        set(TG.BDM_BC_GUI.Handles.OL_Alpha,'String',num2str(TO.Rewards.O_Low.PCoeffs(1)));
        set(TG.BDM_BC_GUI.Handles.OL_Beta,'String',num2str(TO.Rewards.O_Low.PCoeffs(2)));
end

guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);

end