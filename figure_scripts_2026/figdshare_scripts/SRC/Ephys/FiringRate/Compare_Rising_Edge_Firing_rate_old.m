function [h,p,Tx_intra_fr,Tx_inter_fr] = Compare_Rising_Edge_Firing_rate(spike_times_s,start_end_times_s)

%spike times in msec
%start and end times in msec
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
TxS = start_end_times_s(:,1);
TxE = start_end_times_s(:,3);

Tx_inter_fr = []; 
Tx_intra_fr = [];

for iTx = 1:length(TxS)-1
    Tx_intra_fr_ix = find(spike_times_s>TxS(iTx) & spike_times_s<TxE(iTx));
    Tx_intra_fr_ct = length(Tx_intra_fr_ix);
    Tx_intra_fr_tmp = Tx_intra_fr_ct/(TxE(iTx)-TxS(iTx));
    ltmp = length(Tx_intra_fr_tmp);
    lfr = length(Tx_intra_fr);
    Tx_intra_fr(lfr+1:lfr+ltmp) = Tx_intra_fr_tmp;
    
    Tx_inter_fr_ix = find(spike_times_s>TxE(iTx) & spike_times_s<TxS(iTx+1));
    Tx_inter_fr_ct = length(Tx_inter_fr_ix);
    Tx_inter_fr_tmp = Tx_inter_fr_ct/(TxS(iTx+1)-TxE(iTx));
    ltmp = length(Tx_inter_fr_tmp);
    lfr = length(Tx_inter_fr);
    Tx_inter_fr(lfr+1:lfr+ltmp) = Tx_inter_fr_tmp;
end
%%
T1 = Tx_intra_fr';
T2 = Tx_inter_fr';

[h,p]  = ttest(T1,T2);
%%
m_intra_fr = mean(Tx_intra_fr);
m_inter_fr = mean(Tx_inter_fr);

sd_intra_fr = std(Tx_intra_fr);
sd_inter_fr = std(Tx_inter_fr);

sem_intra_fr = sd_intra_fr/(sqrt(length(Tx_intra_fr)));
sem_inter_fr = sd_inter_fr/(sqrt(length(Tx_inter_fr)));

intra_inter(:,1:2) = [m_intra_fr,m_inter_fr];
b = bar(intra_inter);
b.FaceColor = [0 0 1];
b.FaceAlpha = .75;
b.EdgeColor = 'none';


hold on
line([1 1],[m_intra_fr-sem_intra_fr m_intra_fr+sem_intra_fr])
hold on
line([2 2],[m_inter_fr-sem_inter_fr m_inter_fr+sem_inter_fr])
Tstr = (sprintf('Rising Edge vs. Everything else firing rate \n Student''s t-test | p = %.3d',p));
g=gca;
op = g.OuterPosition;
annotation('textbox', [op(1) op(2) op(3) op(4)-op(4)*.15], ...
            'String', (Tstr), ...
            'FontSize',12,...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center')

xticklabels({'Rising Edge firing rate','Everything else firing rate'});
ylabel('Average firing rate (Hz)');
pubify_figure_axis_robust
