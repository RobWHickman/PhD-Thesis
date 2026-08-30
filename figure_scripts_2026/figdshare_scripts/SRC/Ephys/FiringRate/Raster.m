function [rast] = Raster(spike_times_ms,alignments,pre,post,bin_ms,supress_plot)

if nargin < 3
   pre = 5000;
   post = 5000;
end
if nargin <5 
    bin_ms = 100;
end
if nargin < 6
    supress_plot = 0;
end

if numel(alignments)<3
    warning('not enough trials')
    rast = [];
    return
end

for iTx = 1:length(alignments)
    aligned_spikes_tmp = spike_times_ms>alignments(iTx)-pre & spike_times_ms<alignments(iTx)+post;
    ast = spike_times_ms(aligned_spikes_tmp)-(alignments(iTx)-pre); %this aligns the spike times so that 0 is now [pre] milliseconds before the transient time
    edges = 0:bin_ms:(pre+post)+1;
    binned_spikes(iTx,:) = histcounts(ast,edges);
end

bs = binned_spikes;

% xax = (1:length(binned_spikes))-(pre/bin_ms)
xax = -pre+bin_ms/2:bin_ms:post-bin_ms/2;

scaleFactor = 1;
if sum(sum(bs))>0
    scale = [min(min(bs))*scaleFactor (ceil(nanmean(max(bs)))/scaleFactor)+(.2*ceil(nanmean(max(bs))))];
else
    scale = [1 1.1];
end

% for iBS = 1:length(bs(:,1))
%     pts = find(bs(iBS,:)>0);
%     if ~isempty(pts) && numel(pts)>2
% %         bs(iBS,pts)
%         line([xax(pts)' xax(pts)'],[iBS-1 iBS],'color','k','LineWidth',2)
%     elseif ~isempty(pts) && numel(pts)==2
%         line([xax(pts(1))' xax(pts(1))'],[iBS-1 iBS],'color','k','LineWidth',2)
%         hold on
%         line([xax(pts(2))' xax(pts(2))'],[iBS-1 iBS],'color','k','LineWidth',2)
%     end
% end
if ~supress_plot
    imagesc(xax,[],bs,scale)
    hold on
    colormap(flipud(gray))
    ylabel('Trial count')
    xticks([])
    %     line([0 0], [0 length(bs(:,1))],'LineStyle',':','LineWidth',2,'color','r');
    plot(0,length(bs(:,1))+.25,'LineStyle','none','Marker','^','MarkerFaceColor','r','MarkerEdgeColor','none')
    hold on
    plot(0,.75,'LineStyle','none','Marker','v','MarkerFaceColor','r','MarkerEdgeColor','none')
    pubify_figure_axis_robust
end
rast = bs;