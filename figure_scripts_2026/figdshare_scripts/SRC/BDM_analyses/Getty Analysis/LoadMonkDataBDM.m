function RES = LoadMonkDataBDM(monk)

d = DropboxDir; %comment this line out and insert paths for data below.
if strcmp(monk,'Vic')
    fn = [d,'Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_18-Aug-2022\GettyGenerateProcessedDataFiles\Vic_cells_sits_1  2  3.mat'];
elseif strcmp(monk,'Uly')
    fn = [d,'Schultz_Lab\BDM_Data\Uly_Data\ANALYSIS_18-Aug-2022\GettyGenerateProcessedDataFiles\Uly_cells_sits_1  2  3.mat'];
end

R = load(fn);
RES = R.RES;
RES = GetBDMCoordinates(RES,monk);