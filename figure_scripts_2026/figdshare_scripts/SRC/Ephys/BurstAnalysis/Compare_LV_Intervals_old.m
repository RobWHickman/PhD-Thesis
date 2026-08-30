 function [h,p,d,interval1_LV,interval2_LV,m_interval1_LV,m_interval2_LV,sd_interval1_LV,sd_interval2_LV] = Compare_LV_Intervals(spike_times_s,start_end_times_s,stat_test)

%spike times in msec
%start and end times in msec
%test should be 'T-test' or 'Wilcoxan'
if nargin < 3 
    stat_test = 'Wilcoxan';
end

if nargin < 2
    tx_dir = uigetdir(pwd,'Go to the directory containing the mat file with the transients');
    cd(tx_dir);
    transients = WCCV_MAT_Read_transient_files;%transients in sec
    start_end_times_s(:,1:2) = transients(:,1:2)*1000;
end
if nargin < 1
    [spike_file,spike_dir,~] = uigetfile(pwd,'Select the CI file with the spike times you''d like to analyze');
    cd(spike_dir);
    load(spike_file)
    if length(CI)>1
        ui_cluster= inputdlg(['Which cluster would you like to cut? ', num2str(length(CI)),' total'],'cluster number');
        ui_ix = str2double(ui_cluster{1});
    else
        ui_ix = 1;
    end
    spike_times_s = CI(ui_ix).TimeInSec*1000;
end

    
% spike_times_s = spike_times_ms/1000;
% start_end_times_s = start_end_times/1000;
%%
EvS = start_end_times_s(:,1);
EvE = start_end_times_s(:,3);

interval2_LV = [];
interval1_LV = [];

for iTx = 1:length(EvS)-1
    Tx_interval1_ix = find(spike_times_s>EvS(iTx) & spike_times_s<EvE(iTx));
    dIV1 = diff(spike_times_s(Tx_interval1_ix));
    LV_IV1 = LocalVariance(dIV1);
    ltmp = length(LV_IV1);
    lfr = length(interval1_LV);
    interval1_LV(lfr+1:lfr+ltmp) = LV_IV1;
    
    Tx_interval2_ix = find(spike_times_s>EvE(iTx) & spike_times_s<EvS(iTx+1));
    dIV2 = diff(spike_times_s(Tx_interval2_ix));
    LV_IV2 = LocalVariance(dIV2);
    ltmp2 = length(LV_IV2);
    lfr2 = length(interval2_LV);
    interval2_LV(lfr2+1:lfr2+ltmp2) = LV_IV2;
end
%%
T1 = interval1_LV';
T2 = interval2_LV';

if strcmp(stat_test,'T-test')
    [h,p]  = ttest(T1,T2); %signrank is for paired; ranksum is for unpaired or indepndent samples
elseif  strcmp(stat_test,'Wicloxan')
    [p,h]  = signrank(T1,T2); %signrank is for paired; ranksum is for unpaired or indepndent samples
else
    error('%s is not an available statistical test for this function',stat_test)
end

d = Cohens_D_Paired(T1,T2);
%%
m_interval1_LV = mean(interval1_LV);
m_interval2_LV = mean(interval2_LV);

sd_interval1_LV = std(interval1_LV);
sd_interval2_LV = std(interval2_LV);

sem_rising_fr = sd_interval1_LV/(sqrt(length(interval1_LV)));
sem_ev_fr = sd_interval2_LV/(sqrt(length(interval2_LV)));

dm = [interval1_LV',interval2_LV'];
Plot_Bars_SEM(dm)

hold on

Wstr = (sprintf('Rising edge vs. ev firing rate \n Wilcoxan sign-rank test | p = %.5g \n Cohen''s D = %.5g',p,d));
g=gca;
op = g.OuterPosition;
annotation('textbox', [op(1) op(2) op(3) op(4)-op(4)*.15], ...
            'String', (Wstr), ...
            'FontSize',12,...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center')
xtl1 = sprintf('rising-edge');
xtl2 = sprintf('everything else');
xticklabels({xtl1,xtl2});
ylabel('Average Local Variance');
pubify_figure_axis_robust
