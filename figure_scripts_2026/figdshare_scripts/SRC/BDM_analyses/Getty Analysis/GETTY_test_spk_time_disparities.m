%     [file_name,file_path] = uigetfile('D:\Dropbox\Schultz_Lab\Uly_Data\*.rad','Which file would you like to convert to .bin?');
fi = 'D:\Dropbox\Schultz_Lab\Uly_Data\20190806_M75_ses0001-0003\r075-0002-04.rad';
fn = 'D:\Dropbox\Schultz_Lab\Uly_Data\20190806_M75_ses0001-0003\r075-0002.radDURATION';
load('D:\Dropbox\Schultz_Lab\Uly_Data\20190806_M75_ses0001-0003\w075-0002.mat')
    
sFreq = 22000;

Do = fopen([fn],'r');
rD = fread(Do,inf,'double');
rD = int16(rD);
fclose(Do);


Do = fopen([fi],'r');
[rate,samples] = RADheader_getRateAndSamples(Do); 
fclose(Do);
durations = samples/rate;
t_start = [0 cumsum(durations)];

Do = fopen([fi],'r');
D = fread(Do,inf,'int16');
D = int16(D);
fclose(Do);

Dnh = D(10000:end); %everything up to 10000 is header


Dint16 = int16(rD);

rdurs = double(Dint16(4:4:end))/2;
durs = [savefile.trial.duration]';


% difs = [diff([rdurs,durs],[],2)];
difs = [diff([durations'*1000,durs],[],2)];


sit = [savefile.trial.situation]';


all = [rdurs,durs,difs,sit];

for iT = 1:length(savefile.trial)
    savefile.trial(iT).difs = difs(iT);
end

gds = FormatGettyDataStructure;
spks = [gds.SpikeTimesMs]';
st = 25;
en = 27;
chnk = 22000*st*60:22000*en*60;

figure
y = Dnh(chnk);
% y = Dnh(1:int*22000);

ythresh = find(y<-5000);
ytf = find(diff(ythresh)>1);
tspks = (ythresh(ytf)/22);

x = (1:length(y))/sFreq*1000;
plot(x,y);
hold on
line([spks(spks>chnk(1)/22&spks<chnk(end)/22)-chnk(1)/22 spks(spks>chnk(1)/22&spks<chnk(end)/22)-chnk(1)/22], [-5000 -20000],'color','k');
hold on
line([tspks tspks],[-5000 -20000],'color','r')


