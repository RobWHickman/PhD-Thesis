function normSDF = NormalizedSpikeDensityFunction(spike_times_ms, max_time_ms)

%uses min/max feature scaling. May inflate changes for low firing rates. 
%%
% spike_times_ms = (randperm(10000,100));
% % spike_times_ms = 1:100:10000;
% max_time_ms = 10000;


spike_vec = zeros(1,max_time_ms);
spike_vec(spike_times_ms)=1;
% figure
% line([spike_times_ms' spike_times_ms'], [0 1])

sigma = 10;%.010; %Standard deviation of the kernel in s
edges=[-3*sigma:1:3*sigma]; %Time ranges form -3*st. dev. to 3*st. dev.
kernel = normpdf(edges,0,sigma); %Evaluate the Gaussian kernel
kernel = kernel*1; %Multiply by bin width so the probabilities sum to 1
s=conv(spike_vec,kernel); %Convolve spike data with the kernel
center = ceil(length(edges)/2); %Find the index of the kernel center
SDF=s(center:length(spike_vec)+center-1); %Trim out the relevant portion of the spike density

normSDF = (SDF-max(SDF))/(max(SDF)-min(SDF));

% 
% % 
% figure
% plot(normSDF)
% hold on
% g = gca;
% dy = diff(g.YLim);
% line([spike_times_ms' spike_times_ms'], [-.1*dy g.YLim(1)])

