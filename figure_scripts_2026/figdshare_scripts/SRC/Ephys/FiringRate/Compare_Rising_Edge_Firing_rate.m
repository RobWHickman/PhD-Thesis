function [h,p,d,Tx_rising_fr,Tx_ev_fr,m_rising_fr,m_ev_fr,sd_rising_fr,sd_ev_fr] = Compare_Rising_Edge_Firing_rate(spike_times_s,start_end_times_s)

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

Tx_ev_fr = [];
Tx_rising_fr = [];

for iTx = 1:length(TxS)-1
    Tx_rising_fr_ix = find(spike_times_s>TxS(iTx) & spike_times_s<TxE(iTx));
    Tx_rising_LV_ct = length(Tx_rising_fr_ix);
    Tx_rising_fr_tmp = Tx_rising_LV_ct/(TxE(iTx)-TxS(iTx));
    ltmp = length(Tx_rising_fr_tmp);
    lfr = length(Tx_rising_fr);
    Tx_rising_fr(lfr+1:lfr+ltmp) = Tx_rising_fr_tmp;
    
    Tx_ev_fr_ix = find(spike_times_s>TxE(iTx) & spike_times_s<TxS(iTx+1));
    Tx_ev_fr_ct = length(Tx_ev_fr_ix);
    Tx_ev_fr_tmp = Tx_ev_fr_ct/(TxS(iTx+1)-TxE(iTx));
    ltmp = length(Tx_ev_fr_tmp);
    lfr = length(Tx_ev_fr);
    Tx_ev_fr(lfr+1:lfr+ltmp) = Tx_ev_fr_tmp;
end
%%
T1 = Tx_rising_fr';
T2 = Tx_ev_fr';


[h,p]  = signrank(T1,T2);
d = Cohens_D_Paired(T1,T2);
%%
m_rising_fr = mean(Tx_rising_fr);
m_ev_fr = mean(Tx_ev_fr);

sd_rising_fr = std(Tx_rising_fr);
sd_ev_fr = std(Tx_ev_fr);

sem_rising_fr = sd_rising_fr/(sqrt(length(Tx_rising_fr)));
sem_ev_fr = sd_ev_fr/(sqrt(length(Tx_ev_fr)));

% rising_ev(:,1:2) = [m_rising_fr,m_ev_fr];
% b = bar([m_rising_fr,m_ev_fr]);
% b.FaceColor = [0 0 1];
% b.FaceAlpha = .75;
% b.EdgeColor = 'none';

dm = [Tx_rising_fr',Tx_ev_fr'];
Plot_Bars_SEM(dm)

hold on
% line([1 1],[m_rising_fr-sem_rising_fr m_rising_fr+sem_rising_fr])
% hold on
% line([2 2],[m_ev_fr-sem_ev_fr m_ev_fr+sem_ev_fr])
Tstr = (sprintf('Rising edge vs. ev firing rate \n Wilcoxan Sign-rank | p = %.5g \n Cohen''s D = %.5g',p,d));
g=gca;
op = g.OuterPosition;
annotation('textbox', [op(1) op(2) op(3) op(4)-op(4)*.15], ...
            'String', (Tstr), ...
            'FontSize',12,...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center')

xticklabels({'rising-event firing rate','ev-event firing rate'});
ylabel('Average firing rate (Hz)');
pubify_figure_axis_robust
