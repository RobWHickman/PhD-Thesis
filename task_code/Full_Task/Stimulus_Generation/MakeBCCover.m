function [CoverStr] = MakeBCCover(Side, windowStr, Color)

global VisParam

% Screen params:
Xc = VisParam.scr_rect(3)/2;

switch Side
    case 'Left'
        POS = [0, 0, Xc, VisParam.scr_rect(4)];
    case 'Right'
        POS = [Xc, 0, VisParam.scr_rect(3), VisParam.scr_rect(4)];
    case 'Centre'
        POS = [Xc - 40, 0, Xc+40, VisParam.scr_rect(4)];
end

Color       = num2str(Color);
POS         = num2str(POS);
windowStr   = num2str(windowStr);

CoverStr    = strcat('Screen(''FillRect'', [', windowStr,'], [', Color,'], [', POS,']);');

end