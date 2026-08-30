function [MARKER] = ChoiceMarker_Touch(x,y)
global VisParam

MarkerP                 = [x-25, y-25, x+25, y+25];
MarkerP                 = num2str(MarkerP);
s_MarkerCol             = num2str([250 0 0]);
s_WindowNumber          = num2str(VisParam.scr_handle);

MARKER = strcat('Screen(''FillOval'', [', s_WindowNumber,'], [', s_MarkerCol,'], [', MarkerP,']);');