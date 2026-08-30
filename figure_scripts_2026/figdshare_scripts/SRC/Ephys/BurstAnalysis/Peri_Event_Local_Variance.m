function [LV_rast] = Peri_Event_Local_Variance(spike_times_ms,alignments,bin_ms,windw_s,stat_test)

if nargin < 5; stat_test = 'Wilcoxan'; end
if nargin < 4; windw_s = 20; end
if nargin < 3; bin_ms = 500; end
if nargin < 2; error('No alignment times'); end

windw_ms = 1000*(windw_s);
pre = windw_ms/2;
post = windw_ms/2;

% spike_times_ms = PD.VTA_cluster.ampD_15_CI(1).TimeInSec*1000;
% alignments = PD.Precision_TxEvALL_intan_time(:,1);

%%
for iA = 1:length(alignments)
    al_spks_ix = spike_times_ms>alignments(iA)-pre&spike_times_ms<alignments(iA)+post;
%     st = spike_times_ms(al_spks_ix);
    st = spike_times_ms(al_spks_ix)-alignments(iA)+pre;
    for iB = 1:windw_ms/bin_ms
%         st_bin = find(spike_times_ms> alignments(iA)-pre+(bin_ms*(iB-1)+1)&spike_times_ms< alignments(iA)-pre+(bin_ms*(iB)));
        st_bin = st>(bin_ms*(iB-1)+1)&st<(bin_ms*(iB));

        isi = diff(st(st_bin));
        LV_rast(iA,iB) = LocalVariance(isi);
    end
    edges = 0:bin_ms:windw_ms;
    bs(iA,:) = histcounts(st,edges);
end
