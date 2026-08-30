dbdir = DropboxDir;
topdir = [dbdir,'Schultz_Lab\BDM_Data\Vicer_data\'];
% topdir = [dbdir,'Schultz_Lab\BDM_Data\Uly_Data\'];


% topdir = 'D:\Dropbox\Schultz_Lab\BDM_Data\Uly_Data\';

df = dir([topdir,'*M7*']);
filnams = {df.name};
[pth,fl,ext] = fileparts([topdir,filnams{1}]);

pth = [pth,'\'];


for iF = 67:length(filnams)
    fd = [pth,filnams{iF},'\'];
    dw = dir([fd,'*wavemark*']);
    %     if length(dw)>1
    for id = 1:length(dw)
        prt = dw(id).name(2:9);
        fn = ['w',prt,'.nba'];
        justopenfile_DH_for_JOFall([fd,fn])
    end
    %     end
end

% % % % % %  20190821