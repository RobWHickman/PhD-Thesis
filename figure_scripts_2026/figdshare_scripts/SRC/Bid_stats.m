

bdcl = {RES.Mbid}';
sitcl = {RES.Sit}';

bd_ra = nan_fill_cell2mat(bdcl);
st_ra = nan_fill_cell2mat(sitcl);

for i=1:length(bd_ra(:,1))
    bdl{i,:} = bd_ra(i,st_ra(i,:)==1);
    bdm{i,:} = bd_ra(i,st_ra(i,:)==2);
    bdh{i,:} = bd_ra(i,st_ra(i,:)==3);
end


bdla = (nan_fill_cell2mat(bdl));
bdma = (nan_fill_cell2mat(bdm));
bdha = (nan_fill_cell2mat(bdh));
%%


[r,c] = size(bdma);
for i = 1:53 %54 has too few points
    tmp = [bdla(:,i),bdma(:,i),bdha(:,i)];
    [p(i),~,stats] = anova1(tmp,[],'off');
    mc = [];
    mc = multcompare(stats,'CType','bonferroni','Display','off');
    
    peas(1,i) = mc(1,6);%1 to 2
    peas(2,i) = mc(2,6);%1 to 3
    peas(3,i) = mc(3,6);%2 to 3
    
    
    ca
end
ns1 = find(peas(1,:)>0.05);
ns2 = find(peas(2,:)>0.05);
ns3 = find(peas(3,:)>0.05);

%%

figure
col = lines(3);
xax = 1:length(bdla);
plot_error_lines(bdla,'CI',xax,col(1,:))
hold on
xax = 1:length(bdma);
plot_error_lines(bdma,'CI',xax,col(2,:))
hold on
xax = 1:length(bdha);
plot_error_lines(bdha,'CI',xax,col(3,:))

g=gca;
mh = nanmean(nanmean(bdha));
mhx = repmat(mh,1,length(ns1));
plot(ns1,mhx*1.2,'LineStyle','none','Marker','o','MarkerEdgeColor','k')
mhx = repmat(mh,1,length(ns3));
plot(ns3,mhx*1.24,'LineStyle','none','Marker','x','MarkerEdgeColor','k')
yticks(g.YLim(1):.2:g.YLim(2));


pubify_figure_axis_robust
%%

for i = 1:42
    figure
    subplot(1,2,1)
    plot(bdla(i,:),'LineStyle','-','Marker','o','MarkerFaceColor',col(1,:))
    %         plot(bdla(i,:),'color',col(1,:))
    hold on
    plot(bdma(i,:),'LineStyle','-','Marker','o','MarkerFaceColor',col(2,:))
    %         plot(bdma(i,:),'color',col(2,:))
    hold on
    plot(bdha(i,:),'LineStyle','-','Marker','o','MarkerFaceColor',col(3,:))
    %         plot(bdha(i,:),'color',col(3,:))
    
    subplot(1,2,2)
    x_values = min(bdla(i,:)):max(bdla(i,:));
    pd = fitdist(bdla(i,:)','Normal');
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',.5,'Color',col(1,:))
    
    hold on
    x_values = min(bdma(i,:)):max(bdma(i,:));
    pd = fitdist(bdma(i,:)','Normal');
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',.5,'Color',col(2,:))
    hold on
    x_values = min(bdha(i,:)):max(bdha(i,:));
    pd = fitdist(bdha(i,:)','Normal');
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',.5,'Color',col(3,:))
%     waitforbuttonpress
WideFigs
end

pubify_figure_axis_robust
%%
figure

for i = [16:42]
    
    x_values = min(bdla(i,:)):max(bdla(i,:));
    pd = fitdist(bdla(i,:)','Normal');
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',.5,'Color',col(1,:))
    hold on
    
    x_values = min(bdma(i,:)):max(bdma(i,:));
    pd = fitdist(bdma(i,:)','Normal');
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',.5,'Color',col(2,:))
    hold on
    
    x_values = min(bdha(i,:)):max(bdha(i,:));
    pd = fitdist(bdha(i,:)','Normal');
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',.5,'Color',col(3,:))
    hold on
end

pubify_figure_axis_robust


%%


