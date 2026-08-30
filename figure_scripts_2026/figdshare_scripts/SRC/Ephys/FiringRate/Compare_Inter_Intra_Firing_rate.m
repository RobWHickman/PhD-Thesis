function [h,p,d,Tx_intra_fr,Tx_inter_fr,m_intra_fr,m_inter_fr,sd_intra_fr,sd_inter_fr] = ...
    Compare_Inter_Intra_Firing_rate(spike_times_s,start_times_s,end_times_s,interval_size,stat_test)

%spike times in msec
%start and end times in msec

%spike_times_s:  spike times in seconds

%start_times_s:  event start times specified in seconds

%end_times_s:    event stop times specified in seconds; can also be
%                specified as [] to compare peri-event LV

%intervals_size: variable--can be specified as:
%                'All': compares the event interval [start_time:endtime] to all other time points [end_time+1:start_time]
%                'Match': makes the 'control' interval the same size as the event interval [start_time:endtime]
%                size in seconds:  makes both intervals the same size specified as a scalar value in seconds

%stat_test:      must be 'T-test' or 'Wilcoxon'(default)


if nargin < 5 
    stat_test = 'Wilcoxon';
end

if nargin < 4
    interval_size = 'All';
end

if nargin < 3 || isempty(end_times_s)
    warning('No end times: interval_size must be specified as a scalar value in seconds')
end
    
% spike_times_s = spike_times_ms/1000;
% start_end_times_s = start_end_times/1000;
%%
if strcmp(interval_size,'All')
    EvS1 = start_times_s;
    EvE1 = end_times_s;
    EvS2 = EvE1(1:end-1);
    EvE2 = EvS1;
    num_ev= length(EvS2);
elseif strcmp(interval_size,'Match')
    EvS1 = start_times_s;
    EvE1 = end_times_s;
    dif = EvE1-EvS1;
    EvS2 = EvS1-dif;
    EvE2 = EvS1;
    num_ev = length(EvS1);
    if EvE1-EvS1~=EvE2-EvS2
        error('The intervals were not the the same size.')
    end
else
    EvS1 = start_times_s;
    EvE1 = EvS1+interval_size;
    EvS2 = EvS1-interval_size;
    EvE2 = EvS1;
    num_ev = length(EvS1);
    if EvE1-EvS1~=EvE2-EvS2
        error('The intervals were not the the same size.')
    end
end
%%
% figure
% line([spike_times_s spike_times_s],[1 2],'color','k')
% line([EvS1 EvS1],[0 1],'color','b')
% hold on
% line([EvE1 EvE1],[0 1],'color','r')
% hold on
% line([EvS2 EvS2],[0 1],'color','g')
% hold on
% line([EvE2 EvE2],[0 1],'color','k')

% TxS = start_end_times_s(:,1);
% TxE = start_end_times_s(:,2);

Tx_inter_fr = [];
Tx_intra_fr = [];

for iTx = 1:num_ev
    Tx_intra_fr_ix = find(spike_times_s>EvS1(iTx) & spike_times_s<EvE1(iTx));
    Tx_intra_fr_ct = length(Tx_intra_fr_ix);
    Tx_intra_fr_tmp = Tx_intra_fr_ct/(EvE1(iTx)-EvS1(iTx));
    ltmp = length(Tx_intra_fr_tmp);
    lfr = length(Tx_intra_fr);
    Tx_intra_fr(lfr+1:lfr+ltmp) = Tx_intra_fr_tmp;
    
    Tx_inter_fr_ix = find(spike_times_s>EvS2(iTx) & spike_times_s<EvE2(iTx));
    Tx_inter_fr_ct = length(Tx_inter_fr_ix);
    Tx_inter_fr_tmp = Tx_inter_fr_ct/(EvE2(iTx)-EvS2(iTx));
    ltmp = length(Tx_inter_fr_tmp);
    lfr = length(Tx_inter_fr);
    Tx_inter_fr(lfr+1:lfr+ltmp) = Tx_inter_fr_tmp;
end
%%

T1 = Tx_intra_fr';
T2 = Tx_inter_fr';


if strcmp(stat_test,'T-test')
    [h,p]  = ttest(T1,T2); %signrank is for paired; ranksum is for unpaired or indepndent samples
    d = Cohens_D_Paired(T1,T2);
    ef_sz = 'Cohen''s D';
elseif  strcmp(stat_test,'Wilcoxon')
    [p,h]  = signrank(T1,T2); %signrank is for paired; ranksum is for unpaired or indepndent samples
    d = Cliffs_delta(T1,T2);
    ef_sz = 'Cliff''s Delta';
else
    error('%s is not an available statistical test for this function',stat_test)
end

%%
m_intra_fr = mean(Tx_intra_fr);
m_inter_fr = mean(Tx_inter_fr);

sd_intra_fr = std(Tx_intra_fr);
sd_inter_fr = std(Tx_inter_fr);

sem_intra_fr = sd_intra_fr/(sqrt(length(Tx_intra_fr)));
sem_inter_fr = sd_inter_fr/(sqrt(length(Tx_inter_fr)));


% intra_inter(:,1:2) = [m_intra_fr,m_inter_fr];
% b = bar([m_intra_fr,m_inter_fr]);
% b.FaceColor = [0 0 1];
% b.FaceAlpha = .75;
% b.EdgeColor = 'none';

dm = [Tx_intra_fr',Tx_inter_fr'];
Plot_Bars_SEM(dm)

hold on
% line([1 1],[m_intra_fr-sem_intra_fr m_intra_fr+sem_intra_fr])
% hold on
% line([2 2],[m_inter_fr-sem_inter_fr m_inter_fr+sem_inter_fr])
Tstr = (sprintf('Intra vs. Inter-event firing rate \n Wilcoxan Sign-rank | p = %.5g \n %s = %.5g',p,ef_sz,d));
g=gca;
op = g.OuterPosition;
annotation('textbox', [op(1) op(2) op(3) op(4)-op(4)*.15], ...
            'String', (Tstr), ...
            'FontSize',12,...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center')

xticklabels({'Intra-event firing rate','Inter-event firing rate'});
ylabel('Average firing rate (Hz)');
pubify_figure_axis_robust
