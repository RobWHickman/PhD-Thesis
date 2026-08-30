function fr = FiringRateHannRaster(raster,size_ms,bin_ms)

if nargin<3 
    bin_ms=1;
end
if nargin <2 
    size_ms = 20;
end


hannFilter = hann(size_ms/bin_ms)';
hannFilter = hannFilter / sum(hannFilter); % normalize
for i = 1:length(raster(:,1))
    fr(i,:) = conv(raster(i,:), hannFilter, 'same')/(size_ms/bin_ms)*1000;
end
% fr = fr./sigma;
