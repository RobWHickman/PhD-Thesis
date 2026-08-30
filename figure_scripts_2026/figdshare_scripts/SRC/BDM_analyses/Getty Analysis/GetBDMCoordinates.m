function RES = GetBDMCoordinates(RES, monk)

d=DropboxDir;
if strcmp(monk,'Uly')
    fldr = [d,'Schultz_Lab\BDM_Data\Uly_Data\'];
else
    fldr = [d,'Schultz_Lab\BDM_Data\Vicer_Data\'];
end

fn = ls([fldr,'*coordinates.xlsx']);
coords = readtable([fldr,fn]);
cdts = table2array(coords(:,1));

days = {RES.day};
for i = 1:length(days)
    dt = datetime(days{i}(1:8),"InputFormat","uuuuMMdd");
%     dt = days{i}(1:8);
    dtix = cdts==dt;
    RES(i).ML = table2array([coords(dtix,2)]);
    RES(i).AP = table2array([coords(dtix,3)]);
    RES(i).DV = table2array([coords(dtix,5)]);
end

