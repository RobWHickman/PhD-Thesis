function Plot_Bars_SEM(data_matrix)

% data matrix must be formatted so that each column is a group 
mDM = nanmean(data_matrix);
% semDM =(nanstd(data_matrix))/(sqrt(length(data_matrix(:,1))));
semDM = Sem(data_matrix);
sz = size(data_matrix);
if sz(2)>2
    colo = lines(length(data_matrix(1,:)));
    ec = 'none';
else
    colo = [.7 .7 .7; 1 1 1];
    ec = 'k';
end
for iM = 1:length(data_matrix(1,:))
    
    col = colo(iM,:);
    bar(iM,mDM(iM),'FaceColor',col,'EdgeColor',ec)
    hold on
    line([iM iM],[mDM(iM)-semDM(iM) mDM(iM)+semDM(iM)],'color','k','LineWidth',1.5)
end
xticks(1:length(data_matrix(1,:)));
% yticks([])
xticklabels([])
% pubify_figure_axis_robust