function [BDMBarStr, BDMBorderStr, PosVec] = MakeBDMBar2(Side, windowStr, Color, Lc, Rc, Height, Width, BorderColor, BorderWidth, BaseDistance)

global VisParam TO

% Screen Params:
Base= VisParam.scr_rect(4) - BaseDistance;
Top = Base - Height;

windowStr = num2str(windowStr);
Color = num2str(Color);

switch Side
    case 'Left'
        POS = [(Lc -(0.5*Width)), Top, (Lc+(0.5*Width)), Base];
    case 'Right'
        POS = [(Rc -(0.5*Width)), Top, (Rc+(0.5*Width)), Base];
end

PosVec  = POS;


BPOS    = [POS(1) - BorderWidth, POS(2) - (5*BorderWidth), POS(3) + BorderWidth + TO.Stimuli.BDM.D_CBidEdge, POS(4) + (5*BorderWidth)];


POS     = num2str(POS);
BPOS    = num2str(BPOS);
BColor  = num2str(BorderColor);
% String for Bar:
BDMBarStr    = strcat('Screen(''FillRect'', [', windowStr,'], [', Color,'], [', POS,']);');

% String for Border:
BDMBorderStr = strcat('Screen(''FillRect'', [', windowStr,'], [', BColor,'], [', BPOS,']);');

end