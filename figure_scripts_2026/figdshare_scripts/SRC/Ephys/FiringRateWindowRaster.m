function fr = FiringRateWindowRaster(raster,window_type,size_ms,bin_ms)

if nargin<4 
    bin_ms=1;
end
if nargin <3 
    size_ms = 20;
end
if nargin <2 
    window_type = 'hamming';
end


switch window_type
    case 'barthannwin'
        Filter = barthannwin(size_ms/bin_ms)';
    case 'bartlett'
        Filter = bartlett(size_ms/bin_ms)';
    case 'blackman'
        Filter = blackman(size_ms/bin_ms)';
    case 'blackmanharris'
        Filter = blackmanharris(size_ms/bin_ms)';
    case 'bohmanwin'
        Filter = bohmanwin(size_ms/bin_ms)';
    case 'chebwin'
        Filter = chebwin(size_ms/bin_ms)';
    case 'flattopwin'
        Filter = flattopwin(size_ms/bin_ms)';
    case 'gausswin'
        Filter = gausswin(size_ms/bin_ms)';
    case 'hamming'
        Filter = hamming(size_ms/bin_ms)';
    case 'hann'
        Filter = hann(size_ms/bin_ms)';
    case 'kaiser'
        Filter = kaiser(size_ms/bin_ms)';
    case 'nuttallwin'
        Filter = nuttallwin(size_ms/bin_ms)';
    case 'parzenwin'
        Filter = parzenwin(size_ms/bin_ms)';
    case 'rectwin'
        Filter = rectwin(size_ms/bin_ms)';
    case 'taylorwin'
        Filter = taylorwin(size_ms/bin_ms)';
    case 'triang'
        Filter = triang(size_ms/bin_ms)';
    case 'tukeywin'
        Filter = tukeywin(size_ms/bin_ms)';
    case 'laplace'
        t=1:1:size_ms;
        Filter = (1-exp(-t)).*exp(-t/size_ms);
%         Filter = [flip(f),f]
end


Filter = Filter / sum(Filter); % normalize
fr=[];
for i = 1:length(raster(:,1))
    fr(i,:) = conv(raster(i,:), Filter, 'same')/(size_ms/bin_ms)*1000;
end
% fr = fr./sigma;