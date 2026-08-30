function [MARKER] = ChoiceMarker(Side)
global VisParam TP

Lc  = TP.BCb.LeftCenter;
Rc  = TP.BCb.RightCenter;
H   = VisParam.scr_rect(4)/6;

switch Side
    case 1
        C = Lc;
    case 2
        C = Rc;
end

MarkerP                 = [C-25, H-25, C+25, H+25];
MarkerP                 = num2str(MarkerP);
s_MarkerCol             = num2str([250 0 0]);
s_WindowNumber          = num2str(VisParam.scr_handle);

MARKER = strcat('Screen(''FillOval'', [', s_WindowNumber,'], [', s_MarkerCol,'], [', MarkerP,']);');