% SetGUIDefaults

global TG

TG.BDM_BC_GUI.Fig       = BDM_BC_GUI_Task;
TG.BDM_BC_GUI.Handles   = guihandles(TG.BDM_BC_GUI.Fig);

TG.BDM.BH_MBidVec = [];
TG.BDM.BM_MBidVec = [];
TG.BDM.BL_MBidVec = [];
TG.BDM.OH_MBidVec = [];
TG.BDM.OM_MBidVec = [];
TG.BDM.OL_MBidVec = [];
TG.BDM.WH_MBidVec = [];
TG.BDM.WM_MBidVec = [];
TG.BDM.WL_MBidVec = [];
TG.BDM.NR_MBidVec = [];

TG.BCb.BiasFix_LN = 0;
TG.BCb.BiasFix_RN = 0;

TG.BCb.BiasFix_LDom = 0;
TG.BCb.BiasFix_RDom = 0;
TG.BCb.BiasFix_Good = 0;

TG.BCb.LDCN = 0;
TG.BCb.RDCN = 0;
TG.BCb.LCN  = 0;
TG.BCb.RCN  = 0;
TG.BCb.RSet = [];
TG.BCb.SSet = [];

TG.BCb.BundleCurrency   = [];
TG.BCb.BundleReward     = [];
TG.BCb.Choices          = [];