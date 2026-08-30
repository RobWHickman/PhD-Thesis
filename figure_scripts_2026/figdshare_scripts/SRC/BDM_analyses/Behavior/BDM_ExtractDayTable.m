% Extract day-table

dbdir = DropboxDir;
% topdir = [dbdir,'Schultz_Lab\BDM_Data\Vicer_data\'];
% load('D:\Dropbox\Schultz_Lab\Vicer\VicBx_All\Vic_BDM_BxTable.mat');
% 
topdir = [dbdir,'Schultz_Lab\BDM_Data\Uly_Data\'];
load('D:\Dropbox\Schultz_Lab\Ulysses\UlyBx_All\Uly_BDM_BxTable.mat');



df = dir([topdir,'*M7*']);
filnams = {df.name};
[pth,fl,ext] = fileparts([topdir,filnams{1}]);

pth = [pth,'\'];


for iF = 1:length(filnams)
    fd = [pth,filnams{iF},'\'];
    dt = datetime(filnams{iF}(1:8),'Format','uuuuMMdd');
    dtix = (ismember([BDM.date],dt));
    dtTBL = BDM(dtix,:);
    filnam = [fd,'BX_',datestr(dt)];
    save(filnam,'dtTBL');
end
