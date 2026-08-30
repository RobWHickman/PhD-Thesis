global TO TP VisParam

% Stimulus controls:
TO.Stimuli.Control.MainScale = true;
TO.Stimuli.Control.FineScale = true;

% Fractal parameters:
TO.Stimuli.Frac.BColor      = [200 0 0];
TO.Stimuli.Frac.BWidth      = 10;
TO.Stimuli.Frac.BDM_Lc      = VisParam.scr_rect(3)/3;
TO.Stimuli.Frac.BDM_Rc      = 0;

% Bar colors:
TO.Stimuli.Bar.Water_Color  = [250 250 100]; % Pale Yellow
TO.Stimuli.Bar.Juice_Color  = [200 100 100]; % Light Pink

% Bar border:
TO.Stimuli.Bar.Water_BColor = [250 250 250];
TO.Stimuli.Bar.Water_BWidth = 5;

% Bar value:
TO.Rewards.Water.MaxVolume  = 1.2;

% Discrete bar parameters:
TO.Stimuli.BDM.D_FrameWidth = 10;

% Bar position:
TO.Stimuli.Bar.Base_Distance= 0.1*(VisParam.scr_rect(4));
TO.Stimuli.Bar.Lc           = (2*(VisParam.scr_rect(3)/6));
TO.Stimuli.Bar.Rc           = (4*(VisParam.scr_rect(3)/6));
TO.Stimuli.BDM.BarWidth     = VisParam.scr_rect(3)/6;
TO.Stimuli.BDM.BarHeight    = 0.8*(VisParam.scr_rect(4));

% Scale parameters:
TO.Stimuli.Bar.Water_SWidth = 10;
TO.Stimuli.Bar.Water_fSWidth= 2;
TO.Stimuli.Bar.Water_SLines = 4;
TO.Stimuli.Bar.Water_fSLines= 19;
TO.Stimuli.Bar.Water_SColor = [100 100 100];

% BCb Touch regions:
TO.Params.BCs.OfferWidth                            = VisParam.scr_rect(3)/6;
TO.Params.BCb.OfferWidth                            = VisParam.scr_rect(3)/3;

TO.Stimuli.BCb.TouchZone        = [50, 50, TP.BCb.LeftLimit, VisParam.scr_rect(4) - 50; TP.BCb.RightLimit, 50, VisParam.scr_rect(3)-50, VisParam.scr_rect(4)-50];


% Marker parameters:
TO.Rewards.Water.BDM.MMOffColor                     = [50 0 0];
TO.Rewards.Water.BDM.CMColor                        = [0 200 0];
TO.Rewards.Water.BDM.MMOnColor                      = [200 0 0];
TO.Rewards.Water.BDM.MMVar                          = 0;
TO.Rewards.Water.BDM.RelMPos                        = 0;
TO.Rewards.Water.BDM.VarRelPos                      = 0;

TO.Stimuli.MMarker.C_Height                         = 20;
TO.Stimuli.MMarker.C_Width                          = 20;

TO.Stimuli.CMarker.C_Height                         = 20;
TO.Stimuli.CMarker.C_Width                          = 20;

TO.Rewards.Water.BCb.ValHeight                      = 10;
TO.Rewards.Water.BCs.MarkerColor                    = [250 250 250];
TO.Rewards.Water.BCb.MarkerColor                    = [0 250 0];

% PayRect:
TO.Stimuli.BDM.PayRect.Col      = [25 25 25];
TO.Stimuli.BCb.PayRect.Col      = [25 25 25];

% Discrete parameters:
TO.Params.BDM.D_nDivs           = 9;
TO.Stimuli.BDM.D_DivSpacing     = 10;
TO.Stimuli.BDM.D_MBidEdge       = 40;
TO.Stimuli.BDM.D_CBidEdge       = 20;

% Target parameters:
TP.BDMf.Sorting = 'Random';