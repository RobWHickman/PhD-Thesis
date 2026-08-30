function [line_and_error,p] = plot_error_lines(data,error_bars,x_axis,col)

if nargin < 2
    error_bars = 'SEM';
end 

if nargin < 3
    inc=1;
    x_axis = 0:inc:length(data(1,:))-1;
end

if nargin < 4
    col = [0 0 0];
end

data = double(data);
% data_mean = mean(data);
data_mean = nanmean(data);
data_std = nanstd(data);


if strcmp(error_bars,'SEM')
    data_err_bar = Sem(data);
elseif strcmp(error_bars,'STD')
    data_err_bar = std(data);
elseif strcmp(error_bars,'CI')
    data_err_bar = ci(data);
elseif strcmp(error_bars,'none')
    data_err_bar = zeros(size(data_mean));;
else
    data_err_bar = Sem(data);
    warning('Error bar type not defined properly. Automatically set to SEM.')
end
    
col2 = col+.15;
col2(col2>1)=1;

p = plot(x_axis,data_mean,'color',col,'LineWidth',3);
hold on
if ~strcmp(error_bars,'none')
plot(x_axis,data_mean+data_err_bar,'color',col2,'LineWidth',1.5)
hold on
plot(x_axis,data_mean-data_err_bar,'color',col2,'LineWidth',1.5)
end

line_and_error(1,:) = data_mean+data_err_bar;
line_and_error(2,:) = data_mean;
line_and_error(3,:) = data_mean-data_err_bar;

