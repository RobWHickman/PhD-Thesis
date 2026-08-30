function FR = Firing_Rate(spike_times_ms,max_time_ms,bin)
%currently, this code only works with a large bin size because smaller bins
%overestimate firing rate. 
if nargin<3
    bin = 200;
elseif bin < 200
   error('window cannot be less than 200.') %this was chosen somewhat empirically--firing rates rarely exceed 200 Hz. 
end
%%
mtvec = zeros(1,round(max_time_ms));
spkvec = mtvec;
spks = spike_times_ms; %in seconds?
newspks = round(spks);
spkvec(newspks)=1;

spkvec(round(max_time_ms))=0;
%%
% FR = 1000*conv(spkvec,hanning(windw),'same')./sum(hanning(windw));

% edges = 0:windw:max_time_ms;
% binned_spikes = histcounts(spks,edges);
% bs_ms = binned_spikes;
% rv = interp1(1:windw:round(max_time_ms),bs_ms,1:max_time_ms);
% rv = smoothdata(rv,'gaussian',windw);

rv = 1000*conv(spkvec,hanning(bin),'same')./sum(hanning(bin));

FR = rv;
% figure;
% plot(FR);