function [BCBarStr, PosVec] = MakeBCBar(Side, windowStr, Color, Lc, Rc, varargin)

global VisParam

% Default values:
Length = 0.5*(VisParam.scr_rect(4));
Width = VisParam.scr_rect(3)/6;
Thickness = 5;

% Screen Params:
Xc = VisParam.scr_rect(3)/2;
Yc = VisParam.scr_rect(4)/2;
% Lc = VisParam.scr_rect(3)/4;
% Rc = 3*Lc;


% Specified dimensions:
if numel(varargin) == 1
    Length = varargin{1};
elseif numel(varargin) == 2
    Length = varargin{1};
    Width  = varargin{2};
elseif numel(varargin) == 3
    Length = varargin{1};
    Width  = varargin{2};
    Thickness = varargin{3};
elseif numel(varargin) >= 4
    disp('Too many arguments passed to the ''MakeBCBar'' function.');
end

% Draw:
Top = Yc - (0.5*(Length));
Base= Top + Length;

windowStr = num2str(windowStr);
Color = num2str(Color);
Thickness = num2str(Thickness);

switch Side
    case 'Left'
        POS = [(Lc -(0.5*Width)), Top, (Lc+(0.5*Width)), Base];
    case 'Right'
        POS = [(Rc -(0.5*Width)), Top, (Rc+(0.5*Width)), Base];
end

PosVec = POS;
POS = num2str(POS);
BCBarStr = strcat('Screen(''FrameRect'', [', windowStr,'], [', Color,'], [', POS,'], [', Thickness,']);');

end