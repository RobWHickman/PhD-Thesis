function [StimStr, PosVec] = MakeTouchField(windowStr, Color, Length)

global VisParam

% Screen Params:
Xc          = VisParam.scr_rect(3)/2;
Yc          = VisParam.scr_rect(4)/2;

% Stimulus Params:
Color       = num2str(Color);
windowStr   = num2str(windowStr);

% Generate Stimulus String:
PosVec  = [(Xc-(Length/2)), (Yc-(Length/2)), (Xc+(Length/2)), (Yc+(Length/2))];
POS     = num2str(PosVec);
StimStr = strcat('Screen(''FillRect'', [', windowStr,'], [', Color,'], [', POS,']);');

end