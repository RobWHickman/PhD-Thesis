function [DrawStr, PosVec] = MakeBDMDBar(windowStr, Color, Height, BasePos, nDivs, Spacing)

windowStr   = num2str(windowStr);
Color       = num2str(Color);

Top         = BasePos(2); % TOP has a lower value than Bottom.
Bottom      = BasePos(4);

DrawPoint   = Bottom;
DrawStr     = [];

for k = 1:nDivs
    PosVec(k,:) = [BasePos(1), DrawPoint-Height, BasePos(3), DrawPoint];
    VecStr      = num2str(PosVec(k,:));
    DrawPoint   = DrawPoint-Height-Spacing;
    NewStr      = strcat('Screen(''FillRect'', [', windowStr,'], [', Color,'], [', VecStr,']);');
    DrawStr     = [DrawStr NewStr];
end

end