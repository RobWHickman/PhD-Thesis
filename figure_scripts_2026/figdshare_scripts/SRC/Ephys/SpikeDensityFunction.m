function SDF = SpikeDensityFunction(spike_times_ms, kernel_size, max_time_ms)

% data must be binned by 1 ms for this to work!!!

% spike_times_ms = (randperm(10000,100));
% spike_times_ms = 1:100:10000;
% max_time_ms = 10000;
if nargin < 2
    kernel_size = 10;
end

if nargin < 3
    max_time_ms = length(spike_times_ms);
end


spike_vec = zeros(1,max_time_ms);
spike_vec(spike_times_ms)=1;
% figure
% line([spike_times_ms' spike_times_ms'], [0 1])

sigma = kernel_size;%.010; %Standard deviation of the kernel in s
edges=[-3*sigma:1:3*sigma]; %Time ranges form -3*st. dev. to 3*st. dev.
kernel = normpdf(edges,0,sigma); %Evaluate the Gaussian kernel
kernel = kernel*1; %Multiply by bin width so the probabilities sum to 1
s=conv(spike_vec,kernel); %Convolve spike data with the kernel
center = ceil(length(edges)/2); %Find the index of the kernel center
SDF=s(center:length(spike_vec)+center-1); %Trim out the relevant portion of the spike density

% % 
% figure
% plot(SDF)
% hold on
% g = gca;
% dy = diff(g.YLim);
% line([spike_times_ms' spike_times_ms'], [-.1*dy g.YLim(1)])
% 
