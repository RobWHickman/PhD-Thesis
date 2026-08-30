function [LMH]=GettyFindFreeRewardResponses(data_file_path_name,situations,bits,trials,win_lose_both)


[DS,pth] = FormatGettyDataStructureWithClusters(data_file_path_name);

situation_names = {'BDM Low ' 'BDM Mid ' 'BDM HIgh ' 'Free Reward'};

if nargin < 1
    val = inputdlg('What situations would you like to analyze?','Situation',1,{'1:3'});
    situations = str2num(val{1});
end

if nargin < 2
    important_bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
        'WinLoseUp' 'FreeRewardUp' 'RewardTapUp' 'BudgetTapUp'};
    %     allBits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
    %         'WinLoseUp' 'FreeRewardUp' 'RewardTapUp' 'BudgetTapUp' 'ErrorUp'};
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
bin = 1;
pre = 2000;
post = 2000;
comp = 250;

minNumTrials = 10;
wvlength = 1.5;
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

%%
fn = fieldnames(DS);
cix = ~cellfun(@isempty,strfind(fn,'SpikeTimesMs'));
clust_nams = fn(cix);
cwix = ~cellfun(@isempty,strfind(fn,'AverageWaveform'));
clust_wav_nams = fn(cwix);
ctr=0;badWV=0;badBLFR=0;bad=0;badNumTr=0;
for iC = 1:length(clust_nams)%for each cluster
    wv = DS(1).(clust_wav_nams{iC});
    wvl = DS(3).(clust_wav_nams{iC});
    if wvl < wvlength
        badWV = 1;
        continue
    end
    
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
    
  
    sDS = DS(gdix);
    sit = [sDS.situation];
    mb = double([sDS.MonkeyBid]);
    %% test free rew
    frix = double([DS.FreeRewardUp])>0;
    th=[];sh=[];
    trial_rast = [];cont_trial_rast = [];alignment = [];cont_alignment = [];
    for iGx = 1:length(DS)%for each trial defined by goodix.
        alignment = [];cont_alignment=[];
        alignment = double([DS(iGx).FreeRewardUp]);
        alignment2 = double([DS(iGx).FixationCrossUp]);
        cont_alignment = double([DS(iGx).FixationCrossUp]);
        
        if length(alignment)>1
            alignment = alignment(2);
        end
        if length(alignment2)>1
            alignment2 = alignment2(2);
        end
        spks_per_trial = [];
        spks_per_trial = DS(iGx).(clust_nams{iC});
        [trial_rast(iGx,:),bc] = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
        [trial_rast2(iGx,:),bc] = TrialRaster(spks_per_trial,alignment2,pre,post,bin);%generate a single-trial raster
%         cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
    end
    %     str = smoothdata(trial_rast,2,'gaussian',3);
    if sum(sum(trial_rast))==0
        tr = trial_rast2;
    else
        tr = trial_rast;
    end
    str = tr(~sum(trial_rast,2)==0,:);
    if ~isempty(str)
        rr =nanmean(str(:,ceil((pre)/bin):floor((pre+comp)/bin)),2);
        ctl = nanmean(str(:,ceil((pre-comp)/bin):floor((pre)/bin)),2);
        
        if  nanmean(rr)>nanmean(ctl)
            [sp,sh] = signrank(rr,ctl);
            [th,tp] = ttest(rr,ctl);
            th(isnan(th))=0;sh(isnan(sh))=0;
            
            if th==0 && sh==0
                %                 if mean(rr) > mean(ctl)+(1.5*std(ctl))
                %                     th=1;
                %                 end
                figure
                QuickRasterPeth(trial_rast)
                answer = questdlg('Is there a FR response?', ...
                    'Free Reward', ...
                    'Yes','No','No');
                switch answer
                    case 'Yes'
                        th = 1;
                    case 'No'
                        th = 0;
                end
            end
        else
            th=0;sh=0;
        end
    else
        th=0;sh=0;
    end
    ca
    frw = th|sh;
    FRW.response=frw;
    FRW.raster = str;
    FRW.bin = bin;
    FRW.pre = pre;
    save([pth,'FreeReward.mat'],'FRW');
end
LMH=[];
end