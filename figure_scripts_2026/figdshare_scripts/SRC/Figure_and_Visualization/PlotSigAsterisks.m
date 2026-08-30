function PlotSigAsterisks(xpoints,topbottom)

if nargin<2
    topbottom = 'top';    
end

if strcmp(topbottom,'top')
    tb = .02;
else
    tb = .98;
end

g=gca;
y_p = g.YLim(2)-(range(g.YLim)*tb);
plot(xpoints,y_p,'*k')

    
