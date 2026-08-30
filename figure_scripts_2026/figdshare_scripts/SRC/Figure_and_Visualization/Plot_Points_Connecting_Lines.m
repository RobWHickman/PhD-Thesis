function Plot_Points_Connecting_Lines(var1,var2)
%%
v1(:,1) = var1;
v2(:,1) = var2;

% g = axes;
xax=ones(length(v1),1);
plot(xax,v1,'o k')
hold on
plot(xax+1,v2,'o k')
line([1 2], [v1 v2],'color','k');
% g.XLim = [0.5 2.5];

