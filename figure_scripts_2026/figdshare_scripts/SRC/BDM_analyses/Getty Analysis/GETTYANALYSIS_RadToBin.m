function GETTYANALYSIS_RadToBin(file_path,file_name,filter_data)
% Created by DFHill Aug 2019--Please comment changes

plot_data = 0;
if nargin < 2
    [file_name,file_path] = uigetfile('D:\Dropbox\Schultz_Lab\BDM_Data\*.rad','Which file would you like to convert to .bin?');
    plot_data = 1;
end
if nargin < 3
    filter_data = 0;
end

if file_path==0
    warning('no file path')
    return
end

Do = fopen([file_path,'\',file_name],'r');
% D = fread(Do,inf,'int16');
D = fread(Do,inf,'int16','l');
D = int16(D);
fclose(Do);

Dnh = D(10000:end); %everything up to 10000 is header
sFreq = typecast(D(40:43),'double');

if filter_data
    filter_range = [300 3000];
    Dnh = SpikeFilter(Dnh,sFreq,filter_range); % defualts to elliptic filter    
    file_append = '_filtered';
else
    file_append = '';
end

if plot_data
    figure
    y = D;
    % y = D(1:sFreq*60*5);
    x = (1:length(y))/sFreq;
    plot(x,y);
    hold on
    g=gca;
    line([10000/sFreq/1000 10000/sFreq/1000],g.YLim,'color','r')
    disp(D(10000:30000));
    title([file_path,file_name])
end

% pts = ginput(2);
% diff(pts(:,1))

fileID = fopen([file_path,'\',file_name(1:end-4),file_append,'.bin'],'w');
fwrite(fileID,Dnh,'int16');
fclose(fileID);

% 
% Do = fopen('C:\Users\dfhil\Dropbox\Schultz_Lab\Uly_Data\20180718_M75_ses0001-0004\r075-0003-04.bin','r');
% D = fread(Do,'int16');
% fclose(Do);
