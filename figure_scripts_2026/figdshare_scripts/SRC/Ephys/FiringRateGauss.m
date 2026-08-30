function fr = FiringRateGauss(raster_vec,sigma,num_sigma,bin_ms)

if nargin<4 
    bin_ms=1;
end
if nargin <3 
    num_sigma = 4;
end
if nargin <2
    sigma = 25;
end

sigma = round(sigma/bin_ms);
gaussFilter = gausswin(num_sigma*sigma + 1)';
gaussFilter = gaussFilter / sum(gaussFilter); % normalize
fr = (conv(raster_vec, gaussFilter, 'same')./sigma)*1000;

