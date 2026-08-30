function TrueRaster(spike_times_ms,alignments,pre,post,bin_ms,supress_plot)

% USE A SMALL BIN (<=50) FOR THIS TO WORK!

if nargin < 3
   pre = 1000;
   post = 1000;
end
if nargin <5 
    bin_ms = 50;
end
if nargin < 6
    supress_plot = 0;
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

[Rs,Cs] = size(bs);
binarast = bs>0
for iR = 1:Rs
    ticks = find(binarast(iR,:)>0);
    if ~isempty(ticks)
        if length(ticks)~=2
            line([ticks' ticks'],[iR-1 iR],'color','k')
        else
            for i = 1:2
                line([ticks(i) ticks(i)],[iR-1 iR],'color','k')
            end
        end
    end
end
    
