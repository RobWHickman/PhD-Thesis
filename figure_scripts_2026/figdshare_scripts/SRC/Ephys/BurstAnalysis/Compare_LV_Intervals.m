 function [h,p,d,interval1_LV,interval2_LV,m_interval1_LV,m_interval2_LV,sd_interval1_LV,sd_interval2_LV] = ...
     Compare_LV_Intervals(spike_times_s,start_times_s,end_times_s,interval_size,stat_test)

%spike_times_s:  spike times in seconds

%start_times_s:  event start times specified in seconds

%end_times_s:    event stop times specified in seconds; can also be
%                specified as [] to compare peri-event LV

%intervals_size: variable--can be specified as:
%                'All': compares the event interval [start_time:endtime] to all other time points [end_time+1:start_time]
%                'Match': makes the 'control' interval the same size as the event interval [start_time:endtime]
%                size in seconds:  makes both intervals the same size specified as a scalar value in seconds

%stat_test:      must be 'T-test' or 'Wilcoxan'(default)


if nargin < 5 
    stat_test = 'Wilcoxan';
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
    EvE1 = EvS1+interval_size(2);
    EvS2 = EvS1-interval_size(1);
    EvE2 = EvS1;
    num_ev = length(EvS1);
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
interval2_LV = [];
interval1_LV = [];

for iTx = 1:num_ev
    Tx_interval1_ix = find(spike_times_s>EvS1(iTx) & spike_times_s<EvE1(iTx));
    dIV1 = diff(spike_times_s(Tx_interval1_ix));
    LV_IV1 = LocalVariance(dIV1);
    ltmp = length(LV_IV1);
    lI1 = length(interval1_LV);
    interval1_LV(lI1+1:lI1+ltmp) = LV_IV1;
    
    Tx_interval2_ix = find(spike_times_s>EvS2(iTx) & spike_times_s<EvE2(iTx));
    dIV2 = diff(spike_times_s(Tx_interval2_ix));
    LV_IV2 = LocalVariance(dIV2);
    ltmp2 = length(LV_IV2);
    lI2 = length(interval2_LV);
    interval2_LV(lI2+1:lI2+ltmp2) = LV_IV2;
end
%%
T1 = interval1_LV';
T2 = interval2_LV';


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
m_interval1_LV = nanmean(interval1_LV);
m_interval2_LV = nanmean(interval2_LV);

sd_interval1_LV = nanstd(interval1_LV);
sd_interval2_LV = nanstd(interval2_LV);

sem_rising_fr = sd_interval1_LV/(sqrt(length(interval1_LV)));
sem_ev_fr = sd_interval2_LV/(sqrt(length(interval2_LV)));

dm = [interval1_LV',interval2_LV'];
Plot_Bars_SEM(dm)

hold on

Wstr = (sprintf('Rising edge vs. ev firing rate \n Wilcoxan sign-rank test | p = %.5g \n %s = %.5g',p,ef_sz,d));
g=gca;
op = g.OuterPosition;
annotation('textbox', [op(1) op(2) op(3) op(4)-op(4)*.15], ...
            'String', (Wstr), ...
            'FontSize',12,...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center')
% xtl1 = sprintf('rising-edge');
% xtl2 = sprintf('match pre-re');
% xticklabels({xtl1,xtl2});
ylabel('Average Local Variance');
pubify_figure_axis_robust
