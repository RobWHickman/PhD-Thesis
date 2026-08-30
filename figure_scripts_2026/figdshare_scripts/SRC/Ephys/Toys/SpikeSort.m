function SpikeSort
% Created by DFHill Aug 2019--Please comment changes


[file_name,file_path] = uigetfile('D:\Dropbox\Schultz_Lab\BDM_Data\*.rad','Which file would you like to convert to .bin?');

Do = fopen([file_path,file_name],'r');
D = fread(Do,inf,'int16');
% D = fread(Do,inf,'int16');
D = int16(D);
fclose(Do);

Dnh = D(10000:end); %everything up to 10000 is header
sFreq = typecast(D(40:43),'double');

if 0
    filter_range = [300 3000];
    Dnh = SpikeFilter(Dnh,sFreq,filter_range); % defualts to elliptic filter    
    file_append = '_filtered';
end

figure
y = Dnh;
% y = D(1:sFreq*60*5);
x = (1:length(y))/sFreq/1000;
plot(x,y);
hold on
g=gca;
line([10000/sFreq/1000 10000/sFreq/1000],g.YLim,'color','r')
disp(D(10000:30000));

dd = double(Dnh);

[~,thresh] = ginput(1)

th = find(Dnh<thresh);
spike_bits = th(diff(th)>1);


prechnk = 44;
postchnk = 66;

frst = find(spike_bits>(80),1,'first');
for iS = frst:length(spike_bits)
    wav(iS,:) = dd(spike_bits(iS)-prechnk:spike_bits(iS)+postchnk);    
end

    
[coeff,score,latent,tsquared] = pca(wav,'NumComponents',3);

figure

scatter3(score(:,1),score(:,2),score(:,3),'marker','.');




