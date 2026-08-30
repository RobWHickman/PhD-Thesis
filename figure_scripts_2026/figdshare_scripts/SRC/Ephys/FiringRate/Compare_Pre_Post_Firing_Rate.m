function [h,p,d,mPRE,mPOST,semPRE,semPOST] = Compare_Pre_Post_Firing_Rate(spike_times_ms,alignments_ms,time_pre,time_post)

for iA = 1:length(alignments_ms)
    pre_ix = spike_times_ms >= alignments_ms(iA)-time_pre & spike_times_ms <= alignments_ms(iA);
    post_ix = spike_times_ms >= alignments_ms(iA) & spike_times_ms <= alignments_ms(iA) + time_post;
    
%     sum_trial_pre_spikes = sum(spike_times_ms(pre_ix));
%     sum_trial_post_spikes = sum(spike_times_ms(post_ix));
    
    sum_trial_pre_spikes =  sum(pre_ix);
    sum_trial_post_spikes =  sum(post_ix);
    
    pre_spikes(iA) = sum_trial_pre_spikes;
    post_spikes(iA) = sum_trial_post_spikes;
    
end
%%
pre_spikes_FR_Hz = pre_spikes./(time_pre/1000);
post_spikes_FR_Hz = post_spikes./(time_post/1000);

mPRE = nanmean(pre_spikes_FR_Hz);
mPOST = nanmean(post_spikes_FR_Hz);

semPRE = std(pre_spikes_FR_Hz)/(sqrt(length(pre_spikes_FR_Hz)));
semPOST = std(post_spikes_FR_Hz)/(sqrt(length(post_spikes_FR_Hz)));
%% stats
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
xax_pre= (.5:(1/(numel(pre_spikes)-1)):1.5);

dm = [pre_spikes_FR_Hz',post_spikes_FR_Hz'];
Plot_Bars_SEM(dm)

xticks([1 2])
xticklabels({'Pre', 'Post'})
ylabel('Firing rate (Hz)')

% FigureTitle('Pre vs Post firing rate');
Tstr = (sprintf('%d s pre vs. %d s post \n Wilcoxan Sign-rank | p = %.5g \n Cohen''s D = %.5g',time_pre/1000,time_post/1000,p,d));
g=gca;
op = g.OuterPosition;
annotation('textbox', [op(1) op(2) op(3) op(4)-op(4)*.15], ...
            'String', (Tstr), ...
            'FontSize',12,...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center')


