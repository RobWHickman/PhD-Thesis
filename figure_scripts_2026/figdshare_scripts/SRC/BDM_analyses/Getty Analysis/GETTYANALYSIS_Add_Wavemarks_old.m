function GETTYANALYSIS_Add_Wavemarks_old(path_and_file_getty_data)

if nargin < 1
    [fl,pth] = uigetfile('D:\Dropbox\Schultz_Lab\Uly_Data\*.mat');
    path_and_file_getty_data = [pth,fl];
else
    [pth,fil,ext]=fileparts(path_and_file_getty_data);
    fl = [fil,ext];
    pth = [pth,'\'];
end



gd = load(path_and_file_getty_data);
f = fields(gd);
savefile = gd.(f{1});

wvm_files = ls([pth,'*wavemark*']);
[num_files,~] = size(wvm_files);

for iW = 1:length(num_files)
    wvix = strfind(wvm_files(iW,:),'wavemark');
    RADnam = [pth,'r',wvm_files(iW,2:12),'.rad'];
    bh = openRADheader_DH(RADnam,0);% this does not prompt the user to check the recording parameters. Switch to 1 to prompt
    sFreq =  bh.sampleRate;

    
    RADdur = [pth,'r',wvm_files(iW,2:9),'.radDURATION'];
    trial_durations_ms = GETTYANALYSIS_Get_RAD_Trial_Durations(RADdur,sFreq);
    
    RAD = ['r',wvm_files(iW,2:9),'-04.rad'];    
    rd = GETTYANALYSIS_OpenRad(pth,RAD);
    rd = double(rd);
    
    wvmf = load([pth,wvm_files(iW,:)]);
    wf = fields(wvmf);
    wvm = wvmf.(wf{1});
    
    
    uniq_codes = unique([wvm.codes]);
    uniq_codes = uniq_codes(uniq_codes~=0);% 0 should always be noise
    chan_nam =(['Channel_',num2str(iW)]);
    col = lines(length(uniq_codes));
    wav = [wvm.values];

    wav = double(wav);
    [~,scr] = pca(wav,'NumComponents',3);
    
    for iC = 1:length(uniq_codes)       
        cix = [wvm.codes(:,1)]==uniq_codes(iC);
        spks = wvm.times(cix,:)*1000;        
        Cells.(chan_nam)(iC).MonkeyID = bh.AnimalId;
        Cells.(chan_nam)(iC).dateRecorded = string(datetime(bh.year,bh.month,bh.day));
        cid = uniq_codes(iC);
        Cells.(chan_nam)(iC).clusterID = cid;        
        Cells.(chan_nam)(iC).gain = bh.totalGain;
        Cells.(chan_nam)(iC).sampleFreq = bh.sampleRate;
        Cells.(chan_nam)(iC).meanWaveform = plot_error_lines(wvm.values(cix,:),'STD');
        wv = plot_error_lines(wvm.values(cix,:),'STD');               
        Cells.(chan_nam)(iC).SpikeTimesMs = wvm.times(cix,:)*1000;   
        Cells.(chan_nam)(iC).BaselineFiringRate = BaselineFiringRate(spks);
                        
        [avg_waveform,spike_duration] = SpikeWidth(spks,rd,sFreq);            
        
        clust_fig = figure('Visible','off');
        subplot(2,3,1)
%         xax = (1:length(wvm.values(1,:)))/sFreq*1000;
%         plot_error_lines(wvm.values(cix,:),'STD',xax);
        xax = (1:length(avg_waveform))/sFreq*1000;
        plot(xax,avg_waveform);

        title('Waveform')
        xlabel('Msec')
        ylabel('mV')
        subplot(2,3,2)
        isi = diff(spks);
        edges = [0:1:200];
        histogram(isi,edges)
        title('ISI histogram')
        xlabel('Msec')
        ylabel('counts')
        subplot(2,3,3)
        bin=20;
        edges = [0:bin:length(spks)];
        hcs = histcounts(spks,edges);
        xc = xcorr(hcs,hcs,50);
        xc(51) = 0;
        xax = ((1:length(xc))-length(xc)/2)*bin;
        bar(xax,xc)
        title('Autocorrelogram')
        xlabel('Msec')
        ylabel('R')
        subplot(2,3,4)
        plot(scr(cix,1),scr(cix,2),'.','color','b')
        hold on
        plot(scr(~cix,1),scr(~cix,2),'.','color',[ .2 .2 .2])
        title('PCA')
        xlabel('PC1')
        ylabel('PC2')
        subplot(2,3,5)
        plot(scr(cix,1),scr(cix,3),'.','color','b')
        hold on
        plot(scr(~cix,1),scr(~cix,3),'.','color',[ .2 .2 .2])
        title('PCA')
        xlabel('PC1')
        ylabel('PC3')
        subplot(2,3,6)
        plot(scr(cix,3),scr(cix,2),'.','color','b')
        hold on
        plot(scr(~cix,3),scr(~cix,2),'.','color',[ .2 .2 .2])
        title('PCA')
        xlabel('PC3')
        ylabel('PC2')
        titnam = sprintf('%s M%d | %s | %s | cluster %d',fl,Cells.(chan_nam)(iC).MonkeyID,Cells.(chan_nam)(iC).dateRecorded,chan_nam,Cells.(chan_nam)(iC).clusterID);
        FigureTitle(titnam)
        MedFigs
        saveas(clust_fig,[pth,strfix(titnam)],'png')
        
        trial_durations_ms_0 = [0;cumsum(trial_durations_ms)];
        
%         nsix = FindNonStationarities(round(spks),trial_durations_ms_0(end));
        for iT = 2:length(trial_durations_ms_0-1)
            trlspks_tmp = [];
            trlspks_tmp = spks(spks>trial_durations_ms_0(iT-1)&spks<trial_durations_ms_0(iT));
            savefile.trial(iT-1).(['Clust',num2str(cid),'_SpikeTimesMs']) = trlspks_tmp-trial_durations_ms_0(iT-1);
%             savefile.trial(iT-1).(['Clust',num2str(cid),'_Waveform']) = wv;
            if iT==2
                savefile.trial(iT-1).(['Clust',num2str(cid),'_AverageWaveform']) = wv;
            end
            if iT==3
                savefile.trial(iT-1).(['Clust',num2str(cid),'_AverageWaveform']) = avg_waveform;
            end
            if iT==4
                savefile.trial(iT-1).(['Clust',num2str(cid),'_AverageWaveform']) = spike_duration;
            end
        end
    end
    ca   
    save([pth,fl],'savefile');
    save([pth,fil,'ClusterInfo'],'Cells');    
end








