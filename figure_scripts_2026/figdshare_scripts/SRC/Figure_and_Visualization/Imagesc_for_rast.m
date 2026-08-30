function [] = Imagesc_for_rast(rast,scale,col)

if nargin < 2
%         scale = [0 max(max(rast))];
    scaleFactor = 1;
    scale = [min(min(rast))*scaleFactor (round(nanmean(max(rast)))/scaleFactor)+(.2*round(nanmean(max(rast))))];
end

if scale(2)==0
    scale(2)=.21;
end

if nargin < 3
    color = gray;
else
    color = SingleColorMap(col);
end

imagesc(rast,scale);
ax = gca;
colormap(ax,flipud(color))
ylabel('Trial count')
xticks([])
hold on
% line([length(rast(1,:))/2 length(rast(1,:))/2], [0 length(rast(:,1))],'LineStyle',':','color','r');
pubify_figure_axis_robust