function [CoverStr] = BCFracCover(Side, Lc, Rc)

global VisParam

% Default values:
Size = VisParam.scr_rect(3)/6;
s_WindowNumber = num2str(VisParam.scr_handle);

% Screen Params:
Yc = VisParam.scr_rect(4)/2;

% Set position:
switch Side
    case 'Left'
        POS = [(Lc - (0.5*Size)), (Yc - (0.5*Size)), (Lc + (0.5*Size)), (Yc + (0.5*Size))];
    case 'Right'
        POS = [(Rc - (0.5*Size)), (Yc - (0.5*Size)), (Rc + (0.5*Size)), (Yc + (0.5*Size))];
end

BorderWidth = 10;
BPOS                    = [(POS(1)-BorderWidth),(POS(2)-BorderWidth),(POS(3)+BorderWidth),(POS(4)+BorderWidth)];
s_FractalBorderColor    = num2str([0 0 0]);
s_FractalBorderPos      = num2str(BPOS);
CoverStr = strcat('Screen(''FillRect'', [', s_WindowNumber,'], [', s_FractalBorderColor,'], [', s_FractalBorderPos,']);');