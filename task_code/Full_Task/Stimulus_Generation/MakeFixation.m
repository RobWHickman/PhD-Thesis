function [FixationStr] = MakeFixation(Type, windowStr, Color, varargin)

global VisParam

% Default values:
Length = 80; Width = 20;

% Screen Params:
Xc = VisParam.scr_rect(3)/2;
Yc = VisParam.scr_rect(4)/2;

% Specified dimensions:
if numel(varargin) == 1
    Length = varargin{1};
elseif numel(varargin) == 2
    Length = varargin{1};
    Width  = varargin{2};
elseif numel(varargin) >= 3
    disp('Too many arguments passed to the ''MakeFixation'' function.');
end

Color = num2str(Color);
windowStr = num2str(windowStr);

% Generate Fixation String:

switch Type
    case 'Cross'
        HPOS = [(Xc-(Length/2)), (Yc-(Width/2)), (Xc+(Length/2)), (Yc+(Width/2))];
        VPOS = [(Xc-(Width/2)), (Yc-(Length/2)), (Xc+(Width/2)), (Yc+(Length/2))];
        HPOS = num2str(HPOS);
        VPOS = num2str(VPOS);
        FixationStr = strcat('Screen(''FillRect'', [', windowStr,'], [', Color,'], [', HPOS,']); Screen(''FillRect'', [', windowStr,'], [', Color,'], [', VPOS,']);');
    case 'Square'
        POS  = [(Xc-(Length/2)), (Yc-(Length/2)), (Xc+(Length/2)), (Yc+(Length/2))];
        POS  = num2str(POS);
        FixationStr = strcat('Screen(''FillRect'', [', windowStr,'], [', Color,'], [', POS,']);');
    case 'Oval'
        POS  = [(Xc-(Length/2)), (Yc-(Length/2)), (Xc+(Length/2)), (Yc+(Length/2))];
        POS  = num2str(POS);
        FixationStr = strcat('Screen(''FillOval'', [', windowStr,'], [', Color,'], [', POS,']);');
end

end