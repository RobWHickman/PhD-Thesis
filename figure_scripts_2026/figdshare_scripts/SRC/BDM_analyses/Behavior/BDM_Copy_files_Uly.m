
pd = 'D:\GoogleDrive\Ulysses_Recordings\Modig\';
pdNew = 'D:\Dropbox\Schultz_Lab\Ulysses\AllCompactBx';
dn = dir([pd,'*U']);


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

