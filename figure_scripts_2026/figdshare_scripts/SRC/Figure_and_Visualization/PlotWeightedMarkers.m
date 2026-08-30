function PlotWeightedMarkers(y,weights,color,shape,lin,x,ax)

if nargin < 7
    ax=gca;
end
if nargin < 6
    x=1:length(y);
end
if nargin < 5
    lin='none';
end
if nargin < 4
    shape='.';
end
if nargin < 3
    color = 'k';
end
if nargin < 2
    weights = ones(length(y),1);
    warn('why are you using this function? This word ''weighted'', I do not think it means what you think it means');
end
if nargin < 1
    error('no data');
end
   %%
mxWt = 18;
mnWt = 3;%must be > 0;
if all(weights==0)
    scaledSize = weights+.1;
else
    scaledSize = ((MinMaxFS(weights)+eps).*(mxWt-mnWt))+mnWt;
end

scaledSize(isnan(scaledSize))= .1;

for i = 1:length(y)
    if ismember(shape,{'.','*','+','<','>','_','^','v','x','|'})
        plot(ax,x(i),y(i),'MarkerSize',scaledSize(i),'Marker',shape,'MarkerEdgeColor',color,'MarkerFaceColor','none')
    else
        plot(ax,x(i),y(i),'MarkerSize',scaledSize(i),'Marker',shape,'MarkerEdgeColor','none','MarkerFaceColor',color,'LineStyle',lin)
    end
    hold on
end

plot(ax,x,y,'LineStyle',lin,'Color',color)

g=ax;
mdWt = ((mxWt-mnWt)/2)+mnWt;
gyl = g.YLim(2);
rngy = range(g.YLim);
rngx = range(g.XLim);
btm = gyl-(rngy*.15);mid=gyl-(rngy*.1);top=gyl-(rngy*.05);
% x_multDot = .01;
% 
% if ismember(shape,{'.','*','+','<','>','_','^','v','x','|'})
%     plot(ax,g.XLim(2)-(rngx*x_multDot),top,'MarkerSize',mxWt,'Marker',shape,'MarkerEdgeColor',color,'MarkerFaceColor','none','LineStyle','none')
%     plot(ax,g.XLim(2)-(rngx*x_multDot),mid,'MarkerSize',mdWt,'Marker',shape,'MarkerEdgeColor',color,'MarkerFaceColor','none','LineStyle','none')
%     plot(ax,g.XLim(2)-(rngx*x_multDot),btm,'MarkerSize',mnWt,'Marker',shape,'MarkerEdgeColor',color,'MarkerFaceColor','none','LineStyle','none')
% else
%     plot(ax,g.XLim(2)-(rngx*x_multDot),top,'MarkerSize',mxWt,'Marker',shape,'MarkerEdgeColor','none','MarkerFaceColor',color,'LineStyle','none')
%     plot(ax,g.XLim(2)-(rngx*x_multDot),mid,'MarkerSize',mdWt,'Marker',shape,'MarkerEdgeColor','none','MarkerFaceColor',color,'LineStyle','none')
%     plot(ax,g.XLim(2)-(rngx*x_multDot),'MarkerSize',mnWt,'Marker',shape,'MarkerEdgeColor','none','MarkerFaceColor',color,'LineStyle','none')
% end

midWeight = min(weights)+(round(range(weights)/2));
% x_mult = .85;
x_multTxt = .01;

text(ax,g.XLim(2)+(rngx*x_multTxt),top+(rngy*.02),['n = ',num2str(max(weights))],'VerticalAlignment','middle')
text(ax,g.XLim(2)+(rngx*x_multTxt),mid+(rngy*.02),['n = ',num2str(midWeight)],'VerticalAlignment','middle')
text(ax,g.XLim(2)+(rngx*x_multTxt),btm+(rngy*.02),['n = ',num2str(min(weights))],'VerticalAlignment','middle')

        

