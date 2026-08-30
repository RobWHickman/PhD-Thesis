function [rast] = Raster_binned_spikes(bin_times_ms,spikes_per_bin,alignments,pre,post,bin_ms,smooth_bin,supress_plot)

%bin_times_ms must be the same length as spikes_in_bin

if nargin < 3
   pre = 5000;
   post = 5000;
end
if nargin < 6 
    bin_ms = 14;
end
if nargin < 7
    smooth_bin = 0;
%     warning('DATA WILL BE SMOOTHED WITH 100 MS BIN - HANNING')
end
if nargin < 8
    supress_plot = 0;
end

for iTx = 1:length(alignments)
    aligned_times_tmp = bin_times_ms>alignments(iTx)-pre & bin_times_ms<alignments(iTx)+post;
    abt = bin_times_ms(aligned_times_tmp)-(alignments(iTx)-pre); %this aligns the spike times so that 0 is now [pre] milliseconds before the transient time
    ast = spikes_per_bin(aligned_times_tmp);
    
    if length(ast)~=floor((pre+post)/bin_ms)
        ast = nan_fill(ast,(pre+post)/bin_ms);
        ast = ast(1:(pre+post)/bin_ms);
    end
    
    
    %     obs = diff(abt);
    %     orig_bin_size = obs(1);
    %     pre = pre/orig_bin_size;
    %     post = post/orig_bin_size;
    %
    %     edges = 0:bin_ms/orig_bin_size:(pre+post)+1;
    %     binned_times(iTx,:) = histcounts(ast,edges);
    if smooth_bin>0
        ast = conv(ast,hanning(smooth_bin/bin_ms),'same')./nansum(hanning(smooth_bin/bin_ms));
    end
    binned_times(iTx,:) = ast;


end

bs = binned_times;


% xax = (1:length(binned_spikes))-(pre/bin_ms)
xax = -pre+bin_ms/2:bin_ms:post-bin_ms/2;

scaleFactor = 1;
if nansum(nansum(bs))>0
    scale = [min(min(bs))*scaleFactor (ceil(nanmean(max(bs)))/scaleFactor)+(.2*round(nanmean(max(bs))))];
else
    scale = [1 1.1];
end





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