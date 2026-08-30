function [BkgStr] = MakeBkg(windowStr, Color)

windowStr   = num2str(windowStr);
Color       = num2str(Color);

BkgStr = strcat('Screen(''FillRect'', [', windowStr,'], [', Color,']);');

end