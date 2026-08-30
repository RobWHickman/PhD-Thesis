function ShadedBox(xvals,yvals,color)
% xvals must contain only 2 values for beginning and end of box
if nargin<3
    color = [0 0 0];
end
if nargin<2
    g=gca;
    yvals = g.YLim;
end

color = 1-((1-color)*.1);

x1 = xvals(1);
x2 = xvals(2);

y1 = yvals(1);
y2 = yvals(2);

xptch = [x1 x2 x2 x1];
yptch = [y1 y1 y2 y2];
p = patch(xptch,yptch,'b','FaceColor',color,'EdgeColor','none');
set(gca,'children',flipud(get(gca,'children')))
% uistack(p,'bottom');