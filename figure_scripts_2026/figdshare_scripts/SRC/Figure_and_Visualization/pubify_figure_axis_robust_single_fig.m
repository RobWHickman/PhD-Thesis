function pubify_figure_axis_robust_single_fig(fig_handle,changeMarker,fs1,fs2)

if nargin<1
    fig_handle = gca;
end
if nargin < 2
    changeMarker = 0;
end
if nargin < 3
    fs1 = 14;
end
if nargin < 4
    fs2 = 16;
end

ax = findall(fig_handle,'Type','Axes');
% ln = findall(gca,'Type','Line');
tx = findall(fig_handle,'Type','Text');
txb = findall(fig_handle,'Type','TextBox');
% ln = findall(gcf,'Type','Line');

if changeMarker
    ChangeMarkerSize(ax,4);
end

% set(ln,'LineWidth',2);

set(ax,'Box','Off');
set(ax,'LineWidth',3);
set(ax,'FontSize',fs1);


set(tx,'FontSize',fs2);

set(txb,'FontSize',12);

set(ax,'TickDir','out');
set(ax,'color','none')


% set(0,'DefaultAxesColor','none')




% set(ln,'LineWidth',1)