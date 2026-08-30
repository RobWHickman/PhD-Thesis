pd = 'D:\GoogleDrive\VICER_BX_ONLY_2020\';
pdNew = 'D:\Dropbox\Schultz_Lab\Vicer\AllCompactBx';
dn = ls([pd,'*Vicer*COMPACT*']);

for i=1:length(dn)
    yrix = strfind(dn(i,:),'_2020');
    


for i=1:length(dn)
    filenum=[];
    yrixx = [];
    fn = ls([pd,dn(i).name,'\*COMPACT*']);
    
    for ifn = 1:length(fn(:,1))
        yrix = strfind(fn(ifn,:),'_20');
        filenum(ifn) = str2double(fn(ifn,1:yrix-1));
        yrixx(ifn) = yrix;
    end
    mxyrix = max(yrixx);
    
    [mx,~] = max(filenum);
    flnam = ls([pd,dn(i).name,'\',num2str(mx),'*COMPACT*']);
    if length(flnam(:,1))>1
        error('dumbass')
    end
    fl = ([pd,dn(i).name,'\',flnam]);
    flNew = [pdNew,'\',flnam];
    copyfile(fl,flNew,'f')
end
%%
% 
% pd = 'C:\Users\dfhil\Dropbox\Schultz_Lab\Vicer\VicBx_All\VicBx_All\';
% nd = 'C:\Users\dfhil\Dropbox\Schultz_Lab\Vicer\VicBx_All\VicBx_All_trunc\';
% 
% fn = ls([pd,'*COMPACT*']);
% 
% for i = 1:length(fn(:,1))
%     fl = ([pd,fn(i,:)]);
%     flNew = [nd,fn(i,5:end)];
%     copyfile(fl,flNew,'f')
% end
