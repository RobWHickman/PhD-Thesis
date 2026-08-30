db = DropboxDir;
pd = [db,'Schultz_Lab\BDM_Data\Vicer_data\'];
dpd = dir([pd,'*M7*']);
drnams = {dpd.name};
drpth = {dpd.folder};

for id = 1:length(drnams)
    dtstr{id} = drnams{id}(1:8);
end

dt = datetime(dtstr,'Format','uuuuMMdd');
badix = dt<datetime('20200714','Format','uuuuMMdd');

dnfix = drnams(badix);
dn  =  drnams(~badix);
%%
for i = 1:length(dn)
    wvf = ls([drpth{i},'\',dn{i},'\*wavemark*']);
    sf = ls([drpth{i},'\',dn{i},'\*',wvf(2:9),'.mat']);
    psf = [drpth{i},'\',dn{i},'\',sf];
    
    load(psf)
    ff=[];
    dff=[];
    ts=[];fc=[];fr=[];bs=[];wl=[];bg=[];
    for iT = 1:length(savefile.trial)
        if ~isempty(savefile.trial(iT).bit(3).upat)&& ~isempty(savefile.trial(iT).bit(4).upat)&&...
                savefile.trial(iT).bit(4).upat>0&& isempty(savefile.trial(iT).bit(14).upat>0)&&...
                ~isempty(savefile.trial(iT).bit(6).upat)&& ~isempty(savefile.trial(iT).bit(8).upat)
            ts(iT) = double(savefile.trial(iT).bit(1).upat);
            fc(iT) = double(savefile.trial(iT).bit(2).upat);
            fr(iT) = double(savefile.trial(iT).bit(3).upat);
            bs(iT) = double(savefile.trial(iT).bit(4).upat);
            wl(iT) = double(savefile.trial(iT).bit(6).upat);
%             wl(iT) = double(savefile.trial(iT).bit(7).upat);
            bg(iT) = double(savefile.trial(iT).bit(8).upat);

        end
    end
    
    ff = [ts;fc;fr;bs;wl;bg]';
    z = ff(:,1)==0;
    dff = diff(ff(~z,:),[],2);
% %     figure;
%     subplot(3,1,1)
%     plot(ff(~z,4))
%     subplot(3,1,2)
%     plot(dff(:,1))
%     %     ylim([1190 1250])
%     ylim([1000 1060])    
%     subplot(3,1,3)
%     plot(dff(:,3))
%     
%     waitforbuttonpress;
    mff(i,:) = mean(ff(~z,:));
    sff (i,:) = std(ff(~z,:));
    
    mdff(i,:) = mean(dff);
    sdff(i,:) = std(dff);
    
    
end

%%
clear i iT savefile psf wvf sf
fr_bd = mean(mdff(:,3));

for i = 1:length(dnfix)
    wvf = ls([drpth{i},'\',dnfix{i},'\*wavemark*']);
    sf = ls([drpth{i},'\',dnfix{i},'\*',wvf(2:9),'.mat']);
    psf = [drpth{i},'\',dnfix{i},'\',sf];
    
    load(psf)
    
     for iT = 1:length(savefile.trial)
        if  ismember(savefile.trial(iT).situation,[1:3]) && isempty(savefile.trial(iT).bit(14).upat>0) &&...
                ~isempty(savefile.trial(iT).bit(3).upat) && isempty(savefile.trial(iT).bit(4).upat)
            
            savefile.trial(iT).bit(4).upat = savefile.trial(iT).bit(3).upat+fr_bd;
            savefile.trial(iT).bit(4).downat = savefile.trial(iT).bit(3).downat+fr_bd;
        end
     end
     
     save(psf,'savefile')
    clear savefile

end
    