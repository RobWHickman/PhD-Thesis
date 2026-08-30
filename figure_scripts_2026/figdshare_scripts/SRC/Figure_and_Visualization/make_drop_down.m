fig = uifigure('Position', [(sz(3)/2)-150 (sz(4)/2)-200 300 350]);
    bits = uidropdown(fig,'Items',allBits,'Position',[50 300 200 20]);
    c = uicontrol;
    c.String = 'Use this bit';
    c.Callback = @UseBitButtonPushed;
    function plotButtonPushed(src,event)
        bar(randn(1,5));
    end