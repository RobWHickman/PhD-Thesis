function [rast,bin_centers_ms] = TrialRaster(spike_times_ms,alignments,pre,post,bin_ms,supress_plot)

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

for iTx = 1:length(alignments)
    
    aligned_spikes_tmp = spike_times_ms>alignments(iTx)-pre & spike_times_ms<alignments(iTx)+post;
        
    if ~isempty(aligned_spikes_tmp)&& sum(sum(aligned_spikes_tmp))~=0
        ast = spike_times_ms(aligned_spikes_tmp)-double(alignments(iTx));%-pre; %this aligns the spike times so that 0 is now [pre] milliseconds before the event time
%         edges = 0:bin_ms:(pre+post)+1;
        edges = -pre:bin_ms:post;
        [binned_spikes,~,spike_bin] = histcounts(ast,edges);
        bs(iTx,:) = binned_spikes;
    else
        bs(iTx,:) = zeros(1,(pre+post)/bin_ms);
    end
end
bin_centers_ms = (((0:length(bs)-1)+.5)*bin_ms)-pre;
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

rast = bs;