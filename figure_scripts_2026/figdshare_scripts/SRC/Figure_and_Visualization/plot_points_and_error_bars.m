function plot_points_and_error_bars(data,x_axis,col,data_mean,data_std)

if nargin < 4
    data_mean = nanmean(data);
    data_std = nanstd(data);
%     warning('Mean and std generated from 1st dim. of data')
end 

if nargin < 3
    col = [0 0 0];
end

if nargin < 2
    x_axis = 0:length(data(1,:))-1;
end

% data_sem = data_std/(sqrt(length(data)));
data_sem = Sem(data);

col2 = col+.3;
col2(col2>1)=1;
for i = 1:length(x_axis)
    line([x_axis(i) x_axis(i)],[data_mean(i)-data_sem(i) data_mean(i)+data_sem(i)],'color',col)
    line([x_axis(i)-.3 x_axis(i)+.3],[data_mean(i)+data_sem(i) data_mean(i)+data_sem(i)],'color',col)
    line([x_axis(i)-.3 x_axis(i)+.3],[data_mean(i)-data_sem(i) data_mean(i)-data_sem(i)],'color',col)
end
hold on
plot(x_axis,data_mean,'LineStyle','none','Marker','o','MarkerSize',8,'MarkerEdgeColor','none','MarkerFaceColor',col)


pubify_figure_axis_robust
% plot(x_axis,data_mean+data_sem,'color',col2,'LineWidth',1.5)
% hold on
% plot(x_axis,data_mean-data_sem,'color',col2,'LineWidth',1.5)
