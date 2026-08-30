function rbdata = rebin(binned_data,new_bin_size,old_bin_size)

if nargin < 3 
    old_bin_size=1; % if old bin not specified, number of bins will be decreased by the number columns/new_bin_size
end

rbdata=[];chnk = (new_bin_size/old_bin_size);
for iB = 1:length(binned_data(1,:))/chnk
    ix = ((iB-1)*chnk)+1:iB*chnk;
    rbdata(:,iB)=sum(binned_data(:,ix),2);
end
    
    
