function [rast,bin_centers_ms] = TrialRaster(spike_times_ms,alignments,pre,post,bin_ms)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input: 
%spike_times_ms: the spike times in milliseconds
%alignments: event times in milliseconds
%pre: the amount of time bfore the event in milliseconds
%post: time after the event in milliseconds
%bin_ms: bin size in milliseconds

%Output:
%rast: rasterized data in array
%bin_centers_ms: the time of the center of each bin in ms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 2
    error('No event alignment times');
end
if nargin < 3
    pre = 2000;
end
if nargin < 4
    post = 3000;
end
if nargin <5
    bin_ms = 1;
end


for iTx = 1:length(alignments)
    
    aligned_spikes_tmp = spike_times_ms>alignments(iTx)-pre & spike_times_ms<alignments(iTx)+post;%index of aligned spike times as logical
        
    if ~isempty(aligned_spikes_tmp)&& sum(sum(aligned_spikes_tmp))~=0
        ast = spike_times_ms(aligned_spikes_tmp)-double(alignments(iTx));%this aligns the spike times so that 0 is now [pre] milliseconds before the event time
        edges = -pre:bin_ms:post;%bin edges
        [binned_spikes,~,spike_bin] = histcounts(ast,edges);%matlab function--see documentation
        bs(iTx,:) = binned_spikes;
    else
        bs(iTx,:) = zeros(1,(pre+post)/bin_ms);
    end
end

bin_centers_ms = (((0:length(bs)-1)+.5)*bin_ms)-pre;
xax = -pre+bin_ms/2:bin_ms:post-bin_ms/2;

rast = bs;