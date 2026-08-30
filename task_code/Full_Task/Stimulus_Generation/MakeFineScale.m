function [ScaleStr] = MakeFineScale(windowPtr, color, nLines, BarRect, Thickness)

Length  = BarRect(4)- BarRect(2);
nSegs   = nLines + 1;

DivLength = Length/(nSegs);

YDivs = (BarRect(2)+DivLength):DivLength:(BarRect(4)-DivLength); % Non-Inclusive of bounds.

windowPtr   = num2str(windowPtr);
color       = num2str(color);
Thickness   = num2str(Thickness);
X1  = num2str(BarRect(1) + 40);
X2  = num2str(BarRect(3) - 40);

if length(YDivs) >= 1
    Y1  = num2str(YDivs(1));
end
if length(YDivs) >= 2
    Y2  = num2str(YDivs(2));
end
if length(YDivs) >= 3
    Y3  = num2str(YDivs(3));
end
if length(YDivs) >= 4
    Y4  = num2str(YDivs(4));
end
if length(YDivs) >= 5
    Y5  = num2str(YDivs(5));
end
if length(YDivs) >= 6
    Y6  = num2str(YDivs(6));
end
if length(YDivs) >= 7
    Y7  = num2str(YDivs(7));
end
Y8 = num2str(YDivs(8));
Y9 = num2str(YDivs(9));
Y10 = num2str(YDivs(10));
Y11 = num2str(YDivs(11));
Y12 = num2str(YDivs(12));
Y13 = num2str(YDivs(13));
Y14 = num2str(YDivs(14));
Y15 = num2str(YDivs(15));
Y16 = num2str(YDivs(16));
Y17 = num2str(YDivs(17));
Y18 = num2str(YDivs(18));
Y19 = num2str(YDivs(19));
% Y20 = num2str(YDivs(20));


%ScaleStr = strcat('Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y1,'], [',X2,'], [',Y1,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y2,'], [',X2,'], [',Y2,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y3,'], [',X2,'], [',Y3,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y4,'], [',X2,'], [',Y4,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y5,'], [',X2,'], [',Y5,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y6,'], [',X2,'], [',Y6,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y7,'], [',X2,'], [',Y7,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y8,'], [',X2,'], [',Y8,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y9,'], [',X2,'], [',Y9,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y10,'], [',X2,'], [',Y10,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y11,'], [',X2,'], [',Y11,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y12,'], [',X2,'], [',Y12,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y13,'], [',X2,'], [',Y13,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y14,'], [',X2,'], [',Y14,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y15,'], [',X2,'], [',Y15,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y16,'], [',X2,'], [',Y16,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y17,'], [',X2,'], [',Y17,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y18,'], [',X2,'], [',Y18,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y19,'], [',X2,'], [',Y19,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y20,'], [',X2,'], [',Y20,'], [',Thickness,']);');
ScaleStr = strcat('Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y1,'], [',X2,'], [',Y1,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y2,'], [',X2,'], [',Y2,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y3,'], [',X2,'], [',Y3,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y4,'], [',X2,'], [',Y4,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y5,'], [',X2,'], [',Y5,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y6,'], [',X2,'], [',Y6,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y7,'], [',X2,'], [',Y7,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y8,'], [',X2,'], [',Y8,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y9,'], [',X2,'], [',Y9,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y10,'], [',X2,'], [',Y10,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y11,'], [',X2,'], [',Y11,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y12,'], [',X2,'], [',Y12,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y13,'], [',X2,'], [',Y13,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y14,'], [',X2,'], [',Y14,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y15,'], [',X2,'], [',Y15,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y16,'], [',X2,'], [',Y16,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y17,'], [',X2,'], [',Y17,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y18,'], [',X2,'], [',Y18,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y19,'], [',X2,'], [',Y19,'], [',Thickness,']);');
% Dims = [X1, X2, Y1, Y2, Y3, Y4, Y5, Y6, Y7];

end