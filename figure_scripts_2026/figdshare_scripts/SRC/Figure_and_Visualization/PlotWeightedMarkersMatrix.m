function PlotWeightedMarkersMatrix(X,weights,color,shape,lin,x)

if nargin < 6
    x=1:length(X(1,:));
end
if nargin < 5
    lin='none';
end
if nargin < 4
    shape='.';
end
if nargin < 3
    color = lines(3);
end
if nargin < 2
    weights = ones(length(X(1,:)),1);
    warn('why are you using this function? This word ''weighted'', I do not think it means what you think it means');
end
if nargin < 1
    error('no data');
end
   %%
mxWt = 18;
mnWt = 3;%must be > 0;
scaledSize = ((MinMaxFS(weights)+eps).*(mxWt-mnWt))+mnWt;

for i = 1:length(X(:,1))
    cl = color(i,:);
    for ii = 1:length(X(1,:))
        if ismember(shape,{'.','*','+','<','>','_','^','v','x','|'})
            plot(x(ii),X(i,ii),'MarkerSize',scaledSize(i,ii),'Marker',shape,'MarkerEdgeColor',cl,'MarkerFaceColor','none')
        else
            plot(x(ii),X(i,ii),'MarkerSize',scaledSize(i,ii),'Marker',shape,'MarkerEdgeColor','none','MarkerFaceColor',cl,'LineStyle',lin)
        end
        hold on
    end
    plot(x,X(i,:),'LineStyle',lin,'Color',cl)
end

g=gca;
mdWt = ((mxWt-mnWt)/2)+mnWt;
gyl = g.YLim(2);
btm = gyl*.83;mid=gyl*.9;top=gyl*.98;

cll = 'k';
if ismember(shape,{'.','*','+','<','>','_','^','v','x','|'})
    plot(g.XLim(2)*.82,top,'MarkerSize',mxWt,'Marker',shape,'MarkerEdgeColor',cll,'MarkerFaceColor','none','LineStyle','none')
    plot(g.XLim(2)*.82,mid,'MarkerSize',mdWt,'Marker',shape,'MarkerEdgeColor',cll,'MarkerFaceColor','none','LineStyle','none')
    plot(g.XLim(2)*.82,btm,'MarkerSize',mnWt,'Marker',shape,'MarkerEdgeColor',cll,'MarkerFaceColor','none','LineStyle','none')
else
    plot(g.XLim(2)*.82,top,'MarkerSize',mxWt,'Marker',shape,'MarkerEdgeColor','none','MarkerFaceColor',cll,'LineStyle','none')
    plot(g.XLim(2)*.82,mid,'MarkerSize',mdWt,'Marker',shape,'MarkerEdgeColor','none','MarkerFaceColor',cll,'LineStyle','none')
    plot(g.XLim(2)*.82,btm,'MarkerSize',mnWt,'Marker',shape,'MarkerEdgeColor','none','MarkerFaceColor',cll,'LineStyle','none')
end

midWeight = min(min(weights))+(round((max(max(weights))-min(min(weights)))/2));
text(g.XLim(2)*.85,top+(gyl*.02),['n = ',num2str(max(max(weights)))],'VerticalAlignment','middle')
text(g.XLim(2)*.85,mid+(gyl*.02),['n = ',num2str(midWeight)],'VerticalAlignment','middle')
text(g.XLim(2)*.85,btm+(gyl*.02),['n = ',num2str(min(min(weights)))],'VerticalAlignment','middle')

        

