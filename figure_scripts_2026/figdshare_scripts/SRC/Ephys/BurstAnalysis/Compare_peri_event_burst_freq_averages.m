function [bst_frq_1,bst_frq_2,bst_frq_c,p] = Compare_peri_event_burst_freq_averages(spike_times_ms,alignment1,alignment2,bin_ms,windw_s,stat_test)
if nargin < 6; stat_test = 'Wilcoxan'; end
if nargin < 5; windw_s = 2; end
if nargin < 4; bin_ms = 500; end
if nargin < 3; error('No alignment times'); end
%%
windw_ms = 1000*(windw_s);
pre = windw_ms/2;
post = windw_ms/2;
% 







[burst_times, spikes_in_burst, bst_freq,num_spikes_per_burst, burst_starts, burst_ends] = ...
    Find_Bursts(spike_times_ms/1000);
burst_times = burst_times*1000;

alignmentc = [alignment2+4000,alignment2+2000,alignment1-4000,alignment1-2000];

%%
for iA = 1:length(alignment1)
    bsts_ix1 = find(burst_times>alignment1(iA)-pre&burst_times<alignment1(iA)+post);
    bsts_ix2 = find(burst_times>alignment2(iA)-pre&burst_times<alignment2(iA)+post);
    
    bst_frq_1(iA) = nanmean(bst_freq(bsts_ix1));
    bst_frq_2(iA) = nanmean(bst_freq(bsts_ix2));
    
    for iC = 1:length(alignmentc(1,:))
        bsts_ixc = find(burst_times>alignmentc(iA,iC)-pre&burst_times<alignmentc(iA,iC)+post);
        bst_frq_c4(iC,iA) = nanmean(bst_freq(bsts_ixc));
    end
end
bst_frq_c = nanmean(bst_frq_c4);

[p,~] = ttest(bst_frq_1,bst_frq_2);

disp('nope')

% Imagesc_for_rast(burst_rast)

%%
% 
% 
% if nargin < 6; stat_test = 'Wilcoxan'; end
% if nargin < 5; windw_s = 2; end
% if nargin < 4; bin_ms = 500; end
% if nargin < 3; error('No alignment times'); end
% %%
% windw_ms = 1000*(windw_s);
% pre = windw_ms/2;
% post = windw_ms/2;
% 
% 
% edges = 0:bin_ms:max(spike_times_ms);
% histcounts(spike_times_ms,edges)
% 
% [burst_times, spikes_in_burst, bst_freq,num_spikes_per_burst, burst_starts, burst_ends] = ...
%     Find_Bursts(spike_times_ms/1000);
% 
% 
% burst_times_ms = burst_times*1000;
% 
% %%
% for iA = 1:length(alignment1)
%     bf_ix1 = find(burst_times_ms>alignment1(iA)-pre&burst_times_ms<alignment1(iA)+post);
%     bf_ix2 = find(burst_times_ms>alignment2(iA)-pre&burst_times_ms<alignment2(iA)+post);
% 
%     mbf1(iA) = nanmean(bst_freq(bf_ix1));
%     mbf2(iA) = nanmean(bst_freq(bf_ix2));
%     
%     
% end
% 
% 
% [h,p] = ttest(mbf1,mbf2);
% 
% 
% disp('nope')

% Imagesc_for_rast(burst_rast)