 function [h,p,d,burst_num_int1,burst_num_int2,mbf1,mbf2] =...
     Compare_Bursts_Intervals(spike_times_s,start_times_s,end_times_s,interval_size,stat_test)

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
%% define intervals from which to extract spikes
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

% figure
% line([EvS1 EvS1],[0 1],'color','b')
% hold on
% line([EvE1 EvE1],[0 1],'color','r')
% hold on
% line([EvS2 EvS2],[0 1],'color','g')
% hold on
% line([EvE2 EvE2],[0 1],'color','k')
%%
[burst_times, ~, burst_frequency, ~, ~] = ...
    Find_Bursts(spike_times_s);

burst_num_int1 = [];
bf1 = [];
burst_num_int2 = [];
bf2 = [];


for iTx = 1:num_ev
    Tx_interval1_ix = find(burst_times>EvS1(iTx) & burst_times<EvE1(iTx));
    ltmp = length(Tx_interval1_ix);
    lI1 = length(burst_num_int1);
    burst_num_int1(iTx) = numel(Tx_interval1_ix);
    lbI1 = length(bf1);
    bf1(lbI1+1:lbI1+ltmp) = burst_frequency(Tx_interval1_ix);
    mbf1(iTx) = nanmean(burst_frequency(Tx_interval1_ix));
    
    Tx_interval2_ix = find(burst_times>EvS2(iTx) & burst_times<EvE2(iTx));
    ltmp2 = length(Tx_interval2_ix);
    lI2 = length(burst_num_int2);
    burst_num_int2(iTx) = numel(Tx_interval2_ix);
    lbI2 = length(bf2);
    bf2(lbI2+1:lbI2+ltmp2) = burst_frequency(Tx_interval2_ix);
    mbf2(iTx) = nanmean(burst_frequency(Tx_interval2_ix));

end
%%
T1 = burst_num_int1';
T2 = burst_num_int2';

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
m_interval1_BST = mean(burst_num_int1);
m_interval2_BST = mean(burst_num_int2);

sd_interval1_BST = std(burst_num_int1);
sd_interval2_BST = std(burst_num_int2);

sem_interval1_BST = sd_interval1_BST/(sqrt(length(burst_num_int1)));
sem_interval2_BST = sd_interval2_BST/(sqrt(length(burst_num_int2)));

dm = [burst_num_int1',burst_num_int2'];
Plot_Bars_SEM(dm)
% Plot_Mean_SEM_All_Points(dm)


hold on

Wstr = (sprintf('Rising edge vs. cont burst number \n Wilcoxon sign-rank test | p = %.5g \n %s = %.5g',p,ef_sz,d));
g=gca;
op = g.OuterPosition;
annotation('textbox', [op(1) op(2) op(3) op(4)-op(4)*.15], ...
            'String', (Wstr), ...
            'FontSize',12,...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center')
xtl1 = sprintf('Rising-edge');
xtl2 = sprintf('Match pre-re');
xticklabels({xtl1,xtl2});
ylabel('Average Number of Bursts');
pubify_figure_axis_robust
