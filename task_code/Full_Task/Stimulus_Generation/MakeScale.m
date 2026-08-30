function [ScaleStr] = MakeScale(windowPtr, color, nLines, BarRect, Thickness)

Length  = BarRect(4)- BarRect(2);
nSegs   = nLines + 1;

DivLength = Length/(nSegs);

YDivs = (BarRect(2)+DivLength):DivLength:(BarRect(4)-DivLength); % Non-Inclusive of bounds.

windowPtr   = num2str(windowPtr);
color       = num2str(color);
Thickness   = num2str(Thickness);
X1  = num2str(BarRect(1) + 2);
X2  = num2str(BarRect(3) - 2);

ScaleStr = [];
for k = 1:length(YDivs)
    Y{k} = num2str(YDivs(k));
    ScaleStr = [ScaleStr 'Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y{k},'], [',X2,'], [',Y{k},'], [',Thickness,']);'];
end


% if length(YDivs) >= 1
%     Y1  = num2str(YDivs(1));
% end
% if length(YDivs) >= 2
% Y2  = num2str(YDivs(2));
% end
% if length(YDivs) >= 3
% Y3  = num2str(YDivs(3));
% end
% if length(YDivs) >= 4
% Y4  = num2str(YDivs(4));
% end
% if length(YDivs) >= 5
% Y5  = num2str(YDivs(5));
% end
% if length(YDivs) >= 6
% Y6  = num2str(YDivs(6));
% end
% if length(YDivs) >= 7
% Y7  = num2str(YDivs(7));
% end

%ScaleStr = strcat('Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y1,'], [',X2,'], [',Y1,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y2,'], [',X2,'], [',Y2,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y3,'], [',X2,'], [',Y3,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y4,'], [',X2,'], [',Y4,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y5,'], [',X2,'], [',Y5,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y6,'], [',X2,'], [',Y6,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y7,'], [',X2,'], [',Y7,'], [',Thickness,']);');
% ScaleStr = strcat('Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y1,'], [',X2,'], [',Y1,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y2,'], [',X2,'], [',Y2,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y3,'], [',X2,'], [',Y3,'], [',Thickness,']); Screen(''DrawLine'', [', windowPtr,'], [',color,'], [',X1,'], [',Y4,'], [',X2,'], [',Y4,'], [',Thickness,']);');
% Dims = [X1, X2, Y1, Y2, Y3, Y4, Y5, Y6, Y7];

end