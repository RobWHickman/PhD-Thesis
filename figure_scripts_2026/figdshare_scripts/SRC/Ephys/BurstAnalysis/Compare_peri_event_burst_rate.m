function [bst_rt_1,bst_rt_2,bst_rt_c,p] = Compare_peri_event_burst_rate(spike_times_ms,alignment1,alignment2,bin_ms,windw_s,stat_test)

if nargin < 6; stat_test = 'Wilcoxan'; end
if nargin < 5; windw_s = 2; end
if nargin < 4; bin_ms = 500; end
if nargin < 3; error('No alignment times'); end
%%
windw_ms = 1000*(windw_s);
pre = windw_ms/2;
post = windw_ms/2;
% pre = 0*1000;
% post = 1*1000;

% windw_ms = (pre+post);
% windw_s = windw_s/1000;

 
[burst_times, spikes_in_burst, bst_freq,num_spikes_per_burst, burst_starts, burst_ends] = ...
    Find_Bursts(spike_times_ms/1000);

burst_times = burst_times*1000;

%%
alignmentc = [alignment2+4000,alignment2+2000,alignment1-4000,alignment1-2000];

for iA = 1:length(alignment1)
    bsts_ix1 = find(burst_times>alignment1(iA)-pre&burst_times<alignment1(iA)+post);
    bsts_ix2 = find(burst_times>alignment2(iA)-pre&burst_times<alignment2(iA)+post);
    
    bst_rt_1(iA)=numel(bsts_ix1)/windw_s;
    bst_rt_2(iA)=numel(bsts_ix2)/windw_s;
    
    for iC = 1:length(alignmentc(1,:))
        bsts_ixc = find(burst_times>alignmentc(iA,iC)-pre&burst_times<alignmentc(iA,iC)+post);
        bst_rt_c4(iC,iA) = numel(bsts_ixc)/windw_s;
    end
end
bst_rt_c = nanmean(bst_rt_c4);

[p,~] = signrank(bst_rt_1,bst_rt_2);

disp('nope')

% Imagesc_for_rast(burst_rast)