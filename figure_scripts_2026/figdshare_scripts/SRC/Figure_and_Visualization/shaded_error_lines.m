function shaded_error_lines(data,x_axis,col,data_mean,data_std)

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


data_sem = Sem(data);

int_fac = 5;
nldm = (numel(data_mean));
chnk = nldm/nldm/int_fac;
numpts = chnk:chnk:nldm;

int_data = interp1(data_mean,numpts);
int_data_sem = interp1(data_sem,numpts);
x_axis = numpts-1;

% [r,c] = size(data);
% data_sem0 = data_std./(sqrt(r));


col2 = col+.15;
col2(col2>1)=1;
%%

plot(x_axis+.5,int_data,'color',col,'LineWidth',1.5)
hold on
% plot(x_axis,data_mean+data_sem,'color',col2,'LineWidth',1.5)
% hold on
% plot(x_axis,data_mean-data_sem,'color',col2,'LineWidth',1.5)

ecol = col;
ecol(:,4)=.05;
ecol2=col;
ecol2(:,4)=.5;

% shd_rng = ((data_mean)+data_sem)-((data_mean)-data_sem);

for i = 1:length(x_axis)
    for it = 1:10
    line([x_axis(i)+(it*.1)-.1 x_axis(i)+(it*.1)-.1],[int_data(i)-int_data_sem(i) int_data(i)+int_data_sem(i)],'color',ecol,'LineWidth',.76);
    hold on 
    end
end
hold on
plot(x_axis+.5,int_data+int_data_sem,'color',col2,'LineWidth',1)
hold on
plot(x_axis+.5,int_data-int_data_sem,'color',col2,'LineWidth',1)
FlatFigs

