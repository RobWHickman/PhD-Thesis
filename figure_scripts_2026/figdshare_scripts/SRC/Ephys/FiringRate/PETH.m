function pth = PETH(spike_times_ms,alignments,wind,bin_ms)


for iTx = 1:length(alignments)
    aligned_spikes_tmp = spike_times_ms>alignments(iTx)-wind & spike_times_ms<alignments(iTx)+wind;
    ast = spike_times_ms(aligned_spikes_tmp)-(alignments(iTx)-wind); %this aligns the spike times so that 0 is now [wind] milliseconds before the transient time
    edges = 0:bin_ms:(wind*2)+1;
    binned_spikes(iTx,:) = histcounts(ast,edges);
end

bs = binned_spikes;

sbs = sum(bs);

xax = -wind+bin_ms/2:bin_ms:wind-bin_ms/2;

bar(xax,sbs,'FaceColor','k','EdgeColor','k')
xticks([min(xax) 0 max(xax)])
xt = {-wind, 0, wind};
xtck = cellfun(@num2str,xt,'UniformOutput',false);
xticklabels(xtck)
xlabel('Time (ms)')

ylabel('Count (spikes/bin)')
line([0 0], [0 max(sbs)],'LineStyle',':','color','r');

axis tight
pubify_figure_axis_robust


pth = sbs;