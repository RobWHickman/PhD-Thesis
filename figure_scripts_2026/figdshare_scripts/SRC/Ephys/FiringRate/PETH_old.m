function [rast] = PETH(spike_times_ms,alignments,wind,bin_ms)

if nargin < 3
   wind = 5000;
end
if nargin < 4 
    bin_ms = 50;
end



% edges = 0:bin_ms:max(time);
% Y = histcounts(spike_times_ms,edges);
% r = [];
for iTx = 1:length(alignments)
    aligned_spikes_tmp = spike_times_ms>alignments(iTx)-wind & spike_times_ms<alignments(iTx)+wind;
    ast = spike_times_ms(aligned_spikes_tmp)-(alignments(iTx)-wind); %this aligns the spike times so that 0 is now [wind] milliseconds before the transient time
    edges = 0:bin_ms:(wind*2)+1;
    binned_spikes(iTx,:) = histcounts(ast,edges);
end

% for iTx = 1:length(alignments)
%     if max(alignments(iTx)-wind>0) && max(alignments(iTx)+wind<max(edges))
%                 r(iTx,:) = Y(edges>(alignments(iTx))-wind & edges<(alignments(iTx))+wind);
% %         pre(iTx,:) = Y(find(edges>(alignments(iTx)-wind),1,'first'):find(edges<(alignments(iTx)),1,'last'))
% %         post(iTx,:) = Y(find(edges>(alignments(iTx)),1,'first'):find(edges<(alignments(iTx)+wind),1,'last'))
% 
%     end
% end
bs = binned_spikes;

sr = sum(bs);

% xax = (1/bin_ms:length(sr))*bin_ms;
xax = -wind+bin_ms/2:bin_ms:wind-bin_ms/2;
xchnk = wind/bin_ms;
% figure
subplot(6,1,1:5)
scaleFactor = 1;
scale = [min(min(bs))*scaleFactor max(max(bs))/scaleFactor];
imagesc(xax,[],bs,scale)
colormap(flipud(gray))
ylabel('Trial count')
xticks([])
line([0 0], [0 length(bs(:,1))],'LineStyle',':','color','r');

subplot(6,1,6)
bar(xax,sr,'FaceColor','k','EdgeColor','k')
xticks([min(xax) 0 max(xax)])
xt = {-wind, 0, wind};
xtck = cellfun(@num2str,xt,'UniformOutput',false);
xticklabels(xtck)
xlabel('Time (ms)')
ylabel('Count (spikes/bin)')
line([0 0], [0 max(sr)],'LineStyle',':','color','r');

axis tight
pubify_figure_axis_robust


rast = bs;
