function fr = FiringRateGaussRaster(raster,sigma,num_sigma,bin_ms)

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
for i = 1:length(raster(:,1))
    fr(i,:) = conv(raster(i,:), gaussFilter, 'same')/sigma*1000;
end
% fr = fr./sigma;
