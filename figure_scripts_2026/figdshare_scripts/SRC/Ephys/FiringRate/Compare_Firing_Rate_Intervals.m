function [h,p,d,mint1,mint2,semint1,semint2] = Compare_Firing_Rate_Intervals...
    (spike_times_s,start_times_s,end_times_s,interval_size,stat_test,annotation_on)
%spike_times_s:  spike times in seconds

%start_times_s:  event start times specified in seconds

%end_times_s:    event stop times specified in seconds; can also be
%                specified as [] to compare peri-event LV

%intervals_size: variable--can be specified as:
%                'All': compares the event interval [start_time:endtime] to all other time points [end_time+1:start_time]
%                'Match': makes the 'control' interval the same size as the event interval [start_time:endtime]
%                size in seconds:  makes intervals the size designated by a vector of 2 values: [pre post]

%stat_test:      must be 'T-test' or 'Wilcoxan'(default)


if nargin < 6 
    annotation_on = 0;
end

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
elseif strcmp(interval_size,'Peri')
    peri_time = 2;
    EvS1 = start_times_s-(peri_time/2);
    EvE1 = start_times_s+(peri_time/2);
    EvS2 = EvS1-peri_time;
    EvE2 = EvS1;
    num_ev = length(EvS1);
    if EvE1-EvS1~=EvE2-EvS2
        error('The intervals were not the the same size.')
    end
else
    EvS2 = start_times_s; %this is start 2 because it represents be the post-event time
    EvE2 = EvS2+interval_size(2);
    EvS1 = EvS2-interval_size(1);% pre start time
    EvE1 = EvS2;
    num_ev = length(EvS1);
%     if EvE1-EvS1~=EvE2-EvS2
%         error('The intervals were not the the same size.')
%     end
end
% 
% figure
% line([spike_times_s spike_times_s],[1 2],'color','k')
% line([EvS1 EvS1],[0 1],'color','b')
% hold on
% line([EvE1 EvE1],[0 1],'color','r')
% hold on
% line([EvS2 EvS2],[0 1],'color','g')
% hold on
% line([EvE2 EvE2],[0 1],'color','k')

%%
for iA = 1:num_ev
    int1 = spike_times_s >= EvS1(iA) & spike_times_s <= EvE1(iA); 
    int2 = spike_times_s >= EvS2(iA) & spike_times_s <= EvE2(iA);
     
    int1_spikes(iA,1) = sum(int1);
    int2_spikes(iA,1) = sum(int2);
end
%%
int1_spikes_FR_Hz = int1_spikes./(EvE1-EvS1);
itn2_spikes_FR_Hz = int2_spikes./(EvE2-EvS2);

T1 = int1_spikes_FR_Hz;
T2 = itn2_spikes_FR_Hz;

mint1 = mean(int1_spikes_FR_Hz);
mint2 = mean(itn2_spikes_FR_Hz);

semint1 = std(int1_spikes_FR_Hz)/(sqrt(length(int1_spikes_FR_Hz)));
semint2 = std(itn2_spikes_FR_Hz)/(sqrt(length(itn2_spikes_FR_Hz)));
%% stats
if strcmp(stat_test,'T-test')
    [h,p]  = ttest(T1,T2); %signrank is for paired; ranksum is for unpaired or indepndent samples
    d = Cohens_D_Paired(T1,T2);
    tst = 'Student''s T-test';
    ef_sz = 'Cohen''s D';
elseif  strcmp(stat_test,'Wilcoxon')
    [p,h]  = signrank(T1,T2); %signrank is for paired; ranksum is for unpaired or indepndent samples
    d = Cliffs_delta(T1,T2);
    tst = 'Wilcoxon Sign rank';
    ef_sz = 'Cliff''s Delta';
else
    error('%s is not an available statistical test for this function',stat_test)
end


%%
xax_pre = (.5:(1/(numel(int1_spikes)-1)):1.5);

dm = [T1,T2];
Plot_Bars_SEM(dm)

xticks([1 2])
xticklabels([])
ylabel('Firing rate (Hz)')

if annotation_on
% FigureTitle('Pre vs Post firing rate');
Tstr = (sprintf('pre vs. post \n %s | p = %.5g \n %s = %.5g',tst,p,ef_sz,d));
g=gca;
op = g.OuterPosition;
annotation('textbox', [op(1) op(2) op(3) op(4)-op(4)*.15], ...
            'String', (Tstr), ...
            'FontSize',12,...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center')
%         disp('fuck')
end
        
        


