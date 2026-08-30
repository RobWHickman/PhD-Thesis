db = DropboxDir;
pd = [db,'Schultz_Lab\BDM_Data\Vicer_data\'];
dpd = dir([pd,'*M7*']);
drnams = {dpd.name};
drpth = {dpd.folder};

for iD = 68:length(drnams)
    wmf = dir([drpth{iD},'\',drnams{iD},'\','*wavemark*']);
    matf = ['w',wmf.name(2:9),'.mat'];
    load([drpth{iD},'\',drnams{iD},'\',matf])
    
    fnsf = fieldnames(savefile.trial);
    cl = find(contains(fnsf,'SpikeTimesMs'));
    for iC = cl(1):2:cl(end)
        clst = {savefile.trial.(fnsf{iC})};
        csdur = [0,cumsum([savefile.trial.duration])];
        spks = [];
        for iTr = 1:length(clst)  
            ts = clst{iTr};
            ls = length(spks);
            lts = length(ts);
            spks(ls+1:ls+lts) = clst{iTr}+csdur(iTr);
        end
        NSix = FindNonStationarities(round(spks),csdur(end));
        if ~isempty(NSix)
            fbt = find(csdur<=NSix(1),1,'last');
            lbt = find(csdur>=NSix(2),1,'first');
            if lbt>length(savefile.trial)
                lbt = lbt-1;
            end
            gt = ones(length(clst),1);
            gt(fbt:lbt) = 0;
        else
            gt = ones(length(clst),1);
        end

        for iG = 1:length(gt)
            savefile.trial(iG).([fnsf{iC}(1:end-12),'good_trials']) = gt(iG);
        end
    end
    save([drpth{iD},'\',drnams{iD},'\',matf],'savefile')
end





