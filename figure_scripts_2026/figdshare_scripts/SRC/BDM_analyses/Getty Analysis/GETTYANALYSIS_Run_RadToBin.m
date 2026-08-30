mnth = '09';

pd = 'C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\';

month_names = dir([pd,'2020',mnth,'*']);


for i = 1:2%3:length(month_names)
    md = dir([pd,month_names(i).name,'\*04.rad']);
    [file_path,fn,ext] = fileparts([pd,month_names(i).name,'\',md(end).name]);
    file_name = [fn,ext];
    GETTYANALYSIS_RadToBin(file_path,file_name,1)
end