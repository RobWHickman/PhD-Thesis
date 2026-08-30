function [LMH]=GettyIdentifyDANeurons(data_file_path_name,situations,bits,trials,win_lose_both)

[DS,pth] = FormatGettyDataStructureWithClusters(data_file_path_name);

situation_names = {'BDM Low ' 'BDM Mid ' 'BDM HIgh ' 'Free Reward'};

if nargin < 1
    val = inputdlg('What situations would you like to analyze?','Situation',1,{'1:3'});
    situations = str2num(val{1});
end

if nargin < 2
    % important_bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
    %     'WinLoseUp' 'FreeRewardUp' 'RewardTapUp' 'BudgetTapUp'};
    allBits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
        'WinLoseUp' 'FreeRewardUp' 'RewardTapUp' 'BudgetTapUp' 'ErrorUp'};
    bit_ix = listdlg('ListString',allBits);
    bits = allBits(bit_ix);
end

if nargin < 3
    trials = 'all';
end
if ~isnumeric(trials) && strcmp(trials,'all')
    trials = 1:length([DS]);
end
%
if nargin < 4
    win_lose_both = 'both';
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bin = 10;%10
nbin = 50;
pre = 1000;
post = 2000;
comp = 300;%400
cont_comp = 500; %(Uly 400)
offset = 80;%80 (Uly 0)

alpha = 0.05;
minNumTrials = 1;%3 (Uly 1)
normMethod = 'BGsubtract';%Zscore BGsubtract none
ExclSensoredBids = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% first pass index
if strcmp(win_lose_both,'win'),wlb=1;elseif strcmp(win_lose_both,'lose'),wlb=0;else wlb=[1 0];end

goodix=[];
noErix = ~(isnan([DS.ErrorUp])|[DS.ErrorUp]~=0);
noFR =  [DS.situation]<4;
wl = ismember([DS.Win],[wlb]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
goodix = noErix & noFR & wl;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ExSB = [DS.MonkeyBid]<100 & [DS.MonkeyBid]>0;
if ExclSensoredBids
    goodix = goodix & ExSB;
else
    goodix = goodix;
end
%%
fn = fieldnames(DS);
cix = ~cellfun(@isempty,strfind(fn,'SpikeTimesMs'));
clust_nams = fn(cix);
cwix = ~cellfun(@isempty,strfind(fn,'AverageWaveform'));
clust_wav_nams = fn(cwix);
ctr=0;
for iC = 1:length(clust_nams)%for each cluster
    wv = DS(1).(clust_wav_nams{iC});
    gdix = [];
    %     gtc = [DS.([clust_nams{iC}(1:end-12),'good_trials'])];
    cln = [clust_nams{iC}(1:end-12),'good_trials'];
    if isfield(DS,cln)
        gtc = [DS.(cln)];
    else
        for ic = 1:length(DS)
            gtc(ic) = 1;
        end
    end
    
    clix = ones(1,length(DS));
    for iD = 1:length(DS)
        if isempty(DS(iD).(clust_nams{iC}))
            clix(iD) = 0;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % Indexing % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gdix = gtc & goodix & clix;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if sum(gdix) < 10
        continue
    end
    
    sDS = DS(gdix);
    
    mb = double([sDS.MonkeyBid]);
    sit = double([sDS.situation]);
    gdbits = bits(~contains(bits,'FreeRewardUp'));%get all the bits except the free reward bit
    h=[];
    for iB = 1:length(gdbits)
        trial_rast = [];cont_trial_rast = [];alignment = [];cont_alignment = [];
        for iGx = 1:length(sDS)%for each trial defined by goodix.
            alignment = [];cont_alignment=[];
            alignment = [sDS(iGx).(gdbits{iB})];
            cont_alignment = [sDS(iGx).FixationCrossUp];
            if length(alignment)>1
                alignment = alignment(2);
            end
            
            spks_per_trial = [sDS(iGx).(clust_nams{iC})];
            [trial_rast(iGx,:),bc] = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
            cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
        end
        %% Don't analyze cells with bad baseline (> 10 hz)
        baselineInstFR = nanmean(nanmean((cont_trial_rast(:,(pre-800)/bin:pre/bin)./bin)*1000));
        baselineFR = nanmean(sum(cont_trial_rast(:,(pre-800)/bin:pre/bin))./800*1000);
        
        if baselineFR > 10 && baselineInstFR > 10
            continue
        end
        
        %% Normalize
        if strcmp(normMethod,'Zscore')
            trz = Z_scores_control_data(trial_rast,cont_trial_rast,(pre-800)/bin:pre/bin);
            ctrz = Z_scores_control_data(cont_trial_rast,cont_trial_rast,(pre-800)/bin:pre/bin);
        elseif strcmp(normMethod,'BGsubtract')
            trz = trial_rast-nanmean(cont_trial_rast((pre-800)/bin:pre/bin));
            ctrz = cont_trial_rast-nanmean(cont_trial_rast((pre-800)/bin:pre/bin));
        elseif strcmp(normMethod,'none')
            trz = trial_rast;
            ctrz = cont_trial_rast;
        end
        
        %%
        frpo = nanmean(trz(:,(pre+offset)/bin:(pre+comp)/bin),2);
        frct = nanmean(ctrz(:,(pre-cont_comp)/bin:pre/bin),2);
        [p,h(iB)]=signrank(frpo,frct,'alpha',alpha);
%         [h(iB)]=ttest(frpo,frct,'alpha',alpha);
        if nanmean(frpo)<nanmean(frct)
            h(iB)=0;
        end
        
        compix = (pre+offset)/bin:(pre+comp)/bin;
        
        [rws,cls] = size(trz);
        
        if iC==1 && iB==3
        figure
        subplot(5,1,1:3)
        [smb,smbix] = sort(mb');
        ssit = sit(smbix);
        strz = trz(smbix,:);
        PlotTrueRaster(strz)
        set(gca,'YDir','reverse')
        grast = gca;
        for i = 1:length(smb)
            xmax = grast.XLim(2);
            text(xmax,i-.5,num2str(smb(i)),'FontSize',5)
            text(xmax+8,i-.5,num2str(ssit(i)),'FontSize',5)
        end
        axis tight
        ShadedBox([min(compix) max(compix)])
        subplot(5,1,4:5)
        plot(smoothdata(sum(trial_rast),'gaussian',100/bin),'k')
        g=gca;        
        ShadedBox([min(compix) max(compix)])
        box off
        PIP_Plot([.7 .7 .25 .25])
        [~,c] = size(wv);
        c=(1:c)/22;
        plot(c,wv,'k')
        box off
        PIP_Plot([.7 .3 .25 .25],g)
        Plot_Bars_SEM([frpo,frct])
        title(p)
        box off
        LongFigs
        FigureTitle(gdbits{iB});
        
        ca
        end
        sit = [sDS.situation];
        
        if strcmp(normMethod,'Zscore')
            out = nanmean(trz(:,compix),2);
            cont = nanmean(ctrz(:,compix),2);
        elseif strcmp(normMethod,'BGsubtract')
            out = (nanmean(trz(:,compix),2)/bin)*1000;
            cont = (nanmean(ctrz(:,(pre-800)/bin),2)/bin)*1000;
        else
            out = (sum(trz(:,compix),2)/range(compix))*1000;
            cont = (sum(ctrz(:,(pre-800)/bin),2)/800)*1000;
        end
        
        
%         LMH(ctr).(gdbits{iB})(:,1) = out;
%         LMH(ctr).(gdbits{iB})(:,2) = cont;
%         LMH(ctr).(gdbits{iB})(:,3) = mb;
%         %             LMH(ctr).(gdbits{iB})(:,4) = trz;
%         LMH(ctr).(gdbits{iB})(:,5) = sit;
    end
end


ca


if ~exist('LMH')==1
    LMH = [];
end

% disp('bleh')




