function [rad_data] = GETTYANALYSIS_OpenRad(file_path,file_name,filter_data)
% Created by DFHill Aug 2019--Please comment changes


if nargin < 2
    [file_name,file_path] = uigetfile('D:\Dropbox\Schultz_Lab\BDM_Data\*.rad','Which file would you like to convert to .bin?');
end
if nargin < 3
    filter_data = 0;
end


Do = fopen([file_path,file_name],'r');
D = fread(Do,inf,'int16');
% D = fread(Do,inf,'int16');
D = int16(D);
fclose(Do);

Dnh = D(10001:end); %everything up to 10000 is header
sFreq = typecast(D(40:43),'double');

if filter_data
    filter_range = [300 3000];
    Dnh = SpikeFilter(Dnh,sFreq,filter_range); % defualts to elliptic filter    
    file_append = '_filtered';
else
    file_append = '';
end

% figure
% y = Dnh;
% % y = D(1:sFreq*60*5);
% x = (1:length(y))/sFreq;;
% plot(x,y);
% hold on
% g=gca;
% line([10000/sFreq/1000 10000/sFreq/1000],g.YLim,'color','r');
% disp(D(10000:30000));

rad_data = Dnh;

% pts = ginput(2);
% diff(pts(:,1))
