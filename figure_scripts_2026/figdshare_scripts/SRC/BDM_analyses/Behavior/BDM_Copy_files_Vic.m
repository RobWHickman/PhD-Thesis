pd = 'C:\Users\Vicer-Modig\Desktop\MATisse\savefiles\';
pdNew = 'C:\Users\Vicer-Modig\Desktop\VicBx_All';
dn = ls([pd,'*Vicer*COMPACT*']);

for i=1:length(dn(:,1))
    filenum = [];dt = [];yrix = [];
    yrix = strfind(dn(i,:),'_20');
    dt = dn(i,yrix+1:yrix+10);
    dt_fls = ls([pd,'*',dt,'*COMPACT*']);
    for ifn = 1:length(dt_fls(:,1))
        yrix = strfind(dt_fls(ifn,:),'_20');
        filenum(ifn) = str2double(dt_fls(ifn,1:yrix-1));
        yrixx(ifn) = yrix;
    end
    [mx,~] = max(filenum);
    finam = ls([pd,'*',num2str(mx),'*',dt,'*COMPACT*']);
    if isempty(finam)
        error('no file name found');
    elseif length(finam(:,1))>1 
        for iF = 1:length(finam(:,1))
            yrix = [];
            yrix = strfind(finam(iF,:),'_20');
            tm(iF) = str2double(finam(iF,yrix+12:yrix+15));        
        end
        [~,mxtmix] = max(tm);
        finam = finam(mxtmix,:);
        warning('more than one file on specified day');
    end
    fl = ([pd,finam]);
    flNew = [pdNew,'\',finam];
    copyfile(fl,flNew,'f')
    newfis = ls(pdNew);
    if length(newfis(:,1))>200
        error('ya done goofed')
    end
end

%%
dn = ls([pd,'*Vicer*COMPACT*']);
% dn = ls([pdNew,'\*Vicer*COMPACT*']);

for i=1:length(dn(:,1))   
    yrix = [];
    yrix = strfind(dn(i,:),'_20');

        d8s{i} = dn(i,yrix+1:yrix+10);
end
unq_days = unique(categorical(d8s));

%%


%%
% 
% for i=1:length(dn)
%     filenum=[];
%     yrixx = [];
%     fn = ls([pd,dn(i).name,'\*COMPACT*']);
%     
%     for ifn = 1:length(fn(:,1))
%         yrix = strfind(fn(ifn,:),'_20');
%         filenum(ifn) = str2double(fn(ifn,1:yrix-1));
%         yrixx(ifn) = yrix;
%     end
%     mxyrix = max(yrixx);
%     
%     [mx,~] = max(filenum);
%     flnam = ls([pd,dn(i).name,'\',num2str(mx),'*COMPACT*']);
%     if length(flnam(:,1))>1
%         error('dumbass')
%     end
%     fl = ([pd,dn(i).name,'\',flnam]);
%     flNew = [pdNew,'\',flnam];
%     copyfile(fl,flNew,'f')
% end
% 
