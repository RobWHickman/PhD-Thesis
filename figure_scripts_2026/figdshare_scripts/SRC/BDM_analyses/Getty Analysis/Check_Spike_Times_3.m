% csd = [0,cumsum([data.duration])];
durations_ms = GETTYANALYSIS_Get_RAD_Trial_Durations('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Uly_Data\20190801_M75\r075-0002.radDURATION',22000);
csd = [0;cumsum(durations_ms)];

st = [];clst=[];

for i= 1:length(data)

    st_tmp = data(i).neuron+csd(i);
    st = [st,st_tmp];
    
    clst_tmp = data(i).Clust1_SpikeTimesMs'+csd(i);
    clst = [clst,clst_tmp];
    
    clst_tmp = data(i).Clust2_SpikeTimesMs'+csd(i);
    clst = [clst,clst_tmp];
    
    clst_tmp = data(i).Clust3_SpikeTimesMs'+csd(i);
    clst = [clst,clst_tmp];
        
    clst_tmp = data(i).Clust4_SpikeTimesMs'+csd(i);
    clst = [clst,clst_tmp];
    
    clst_tmp = data(i).Clust4_SpikeTimesMs'+csd(i);
    clst = [clst,clst_tmp];
    
    clst_tmp = data(i).Clust5_SpikeTimesMs'+csd(i);
    clst = [clst,clst_tmp];
end
%%
Do = fopen('r075-0002-04.bin','r');
D = fread(Do,inf,'int16');
% D = fread(Do,inf,'int16','l');
D = int16(D);
fclose(Do);
    
spks = [];
figure

time = (1:length(D))/22;
% ix = length(time)-1000000:length(time);
% ix = length(time)/2:(length(time)/2)+1000000;
ix = 1:length(time);

spks = zeros(1,length(D));
spks(round(st*22))=-3500;
spks(spks==0)=nan;

spks2 = zeros(1,length(D));
spks2(round(clst*22))=-5000;
spks2(spks2==0)=nan;


% spks = spks(1:length(D));
plot(time(ix),D(ix))
hold on
plot(time(ix),spks(ix),'r.')
hold on
plot(time(ix),spks2(ix),'b.')