function BDM = LoadMonkBxDataBDM(monk)

d = DropboxDir;% comment out if including the full path below.

if strcmp(monk,'Vic')
    load([d,'Schultz_Lab\Vicer\VicBx_All\Vic_BDM_BxTable.mat'])% this will need to modified to reflect the user's path to the behavioral data
elseif strcmp(monk,'Uly')
    load([d,'Schultz_Lab\Ulysses\UlyBx_All\Uly_BDM_BxTable.mat'])% this will need to modified to reflect the user's path to the behavioral data
end

