function plot_error_lines_zscore(data,x_axis,col)

data = zscore(data,[],2);
data_mean = nanmean(data);
data_std = nanstd(data);

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

plot(x_axis,data_mean,'color',col,'LineWidth',3)
hold on
plot(x_axis,data_mean+data_sem,'color',col2,'LineWidth',1.5)
hold on
plot(x_axis,data_mean-data_sem,'color',col2,'LineWidth',1.5)
