%%need to make this a fxn that can be used for any SMRX stuff...later

cedpath = 'C:\CEDMATLAB\CEDS64ML';
CEDS64LoadLib( cedpath );

db = DropboxDir;

pd = [db,'Schultz_Lab\BDM_Data\Vicer_data\'];
% pd = [db,'Schultz_Lab\BDM_Data\Uly_Data\'];

dpd = dir([pd,'*_M7*']);
pdn = {dpd.name};
for iPd = 16%:length(pdn)
    fn = ls([pd,pdn{iPd},'\*.smrx']);
    for iFn = 1:length(fn(:,1))
        smrx_fname = [pd,pdn{iPd},'\',fn(iFn,:)];        
        S = SMRX_to_Wavemark(smrx_fname,500);        
        save_name = [smrx_fname(1:end-5),'-wavemark.mat'];
        save(save_name,'S');               
    end
end 