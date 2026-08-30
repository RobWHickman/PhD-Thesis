function [FracStr, BorderStr] = MakeBDMFrac(Side, FractalID, TextureNumber, Lc, Rc, BorderColor, BorderWidth, varargin)

global VisParam ModigDir

% Default values:
Size = VisParam.scr_rect(3)/6;

% Screen Params:
Yc = VisParam.scr_rect(4)/2;
s_WindowNumber = num2str(VisParam.scr_handle);

% Specified dimensions:
if numel(varargin) == 1
    Size = varargin{1};
elseif numel(varargin) >= 2
    disp('Too many arguments passed to the ''MakeBCFrac'' function.');
end

% Set position:
switch Side
    case 'Left'
        POS = [(Lc - (0.5*Size)), (Yc - (0.5*Size)), (Lc + (0.5*Size)), (Yc + (0.5*Size))];
    case 'Right'
        POS = [(Rc - (0.5*Size)), (Yc - (0.5*Size)), (Rc + (0.5*Size)), (Yc + (0.5*Size))];
end

BPOS                    = [(POS(1)-BorderWidth),(POS(2)-BorderWidth),(POS(3)+BorderWidth),(POS(4)+BorderWidth)];

% Draw:
switch FractalID
    case 'B30'
        FracStr = drawImagesTK([ModigDir.Images,'\picture 056.jpg'], POS, TextureNumber);
    case 'B20'
        FracStr = drawImagesTK([ModigDir.Images,'\picture 053.jpg'], POS, TextureNumber);
    case 'B10'
        FracStr = drawImagesTK([ModigDir.Images,'\picture 051.jpg'], POS, TextureNumber);
    case 'RA1'
        FracStr = drawImagesTK([ModigDir.Images,'\RA1.jpg'], POS, TextureNumber);
    case 'RA2'
        FracStr = drawImagesTK([ModigDir.Images,'\RA2.jpg'], POS, TextureNumber);
    case 'RA3'
        FracStr = drawImagesTK([ModigDir.Images,'\RA3.jpg'], POS, TextureNumber);
    case 'RA4'
        FracStr = drawImagesTK([ModigDir.Images,'\RA4.jpg'], POS, TextureNumber);
    case 'RA5'
        FracStr = drawImagesTK([ModigDir.Images,'\RA5.jpg'], POS, TextureNumber);
    case 'RA6'
        FracStr = drawImagesTK([ModigDir.Images,'\RA6.jpg'], POS, TextureNumber);
    case 'RL1'
        FracStr = drawImagesTK([ModigDir.Images,'\RL1.jpg'], POS, TextureNumber);
    case 'RL2'
        FracStr = drawImagesTK([ModigDir.Images,'\RL2.jpg'], POS, TextureNumber);
    case 'RL3'
        FracStr = drawImagesTK([ModigDir.Images,'\RL3.jpg'], POS, TextureNumber);
    case 'RL4'
        FracStr = drawImagesTK([ModigDir.Images,'\RL4.jpg'], POS, TextureNumber);
    case 'RL5'
        FracStr = drawImagesTK([ModigDir.Images,'\RL5.jpg'], POS, TextureNumber);
    case 'RL6'
        FracStr = drawImagesTK([ModigDir.Images,'\RL6.jpg'], POS, TextureNumber);
    case 'NR'
        FracStr = drawImagesTK([ModigDir.Images,'\picture 063.jpg'], POS, TextureNumber);
end

s_FractalBorderColor    = num2str(BorderColor);
s_FractalBorderPos      = num2str(BPOS);
s_FractalBorderWidth    = num2str(BorderWidth);
BorderStr = strcat('Screen(''FrameRect'', [', s_WindowNumber,'], [', s_FractalBorderColor,'], [', s_FractalBorderPos,'], [', s_FractalBorderWidth,']);');