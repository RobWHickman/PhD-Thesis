function [LMH]=GettyBidRegressionWithClusters(data_file_path_name,situations,bits,trials,win_lose_both)

[DS,pth] = FormatGettyDataStructureWithClusters(data_file_path_name);

situation_names = {'BDM Low ' 'BDM Mid ' 'BDM HIgh ' 'Free Reward'};

if nargin < 1
    val = inputdlg('What situations would you like to analyze?','Situation',1,{'1:3'});
    situations = str2num(val{1});
end

if nargin < 2
    % important_bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
    %     'WinLoseUp' 'FreeRewardUp' 'RewardTapUp' 'BudgetTapUp'};
    allBits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
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
nbin = 10;
pre = 1000;
post = 2000;
comp = 400;%400
cont_comp = 500;
offset = 100;%80

alpha = 0.001;%0.0001
minNumTrials = 1;%3
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
    trial_rast = [];
    cont_trial_rast = [];
    for iGx = 1:length(sDS)%for each trial defined by goodix.
        alignment = [];
        %         alignment = [DS(gx(iGx)).(gdbits{iB})];
        alignment = [sDS.FractalDisplayUp];
        cont_alignment = [sDS(iGx).FixationCrossUp];
        if length(alignment)>1
            alignment = alignment(2);
        end
        
        spks_per_trial = [sDS(iGx).(clust_nams{iC})];
        [trial_rast(iGx,:),bc] = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
        cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
    end
    %%
    baselineInstFR = nanmean(nanmean((cont_trial_rast(:,(pre-800)/bin:pre/bin)./bin)*1000));
    baselineFR = nanmean(sum(cont_trial_rast(:,(pre-800)/bin:pre/bin))./800*1000);
    
    if baselineFR > 10 && baselineInstFR > 10
        badBL=1;
        continue
    end
    
    trz = trial_rast;
    compix = round([((pre+offset)/bin):((pre+comp)/bin)]);
    d = nanmean(trial_rast(:,compix),2);
    c = nanmean(cont_trial_rast(:,((pre-800)/bin):((pre)/bin)),2);
    [p,h,SRstats] = signrank(d,c,'alpha',.01);
    
    %     d_s = d-c;
    d_s = nanmean(trz(:,compix),2)/bin*1000;
    X = [ones(size(d_s)),d_s];
    [b,bint,r,rint,statss] = regress(mb',X);% r2 f-stat p-value variance
    b_n = BetaNormalization(b(2),d_s,mb');
    
    %     [mc_b,bint,r,rint,mc_stats] = regress(mb'-cb',X);% r2 f-stat p-value variance
    %     mc_b_n = BetaNormalization(mc_b(2),d_s,mb'-cb');
    
    [rws,cls]=size(trz);
    figure
    disp([statss(3), statss(1)])
    subplot(3,1,1)
    [smb,smbix] = sort(mb');
    strz = trz(smbix,:);
    PlotTrueRaster(strz)
    set(gca,'YDir','reverse')
    for i = 1:length(smb)
        text(cls,i-.5,num2str(smb(i)),'FontSize',5)
    end
    axis tight
    ShadedBox([min(compix) max(compix)])
    subplot(3,1,2)
    plot(smoothdata(sum(trial_rast),'gaussian',100/bin),'k')
    ShadedBox([min(compix) max(compix)])
    box off
    PIP_Plot([.7 .7 .25 .25])
    [~,c] = size(wv);
    c=(1:c)/22;
    plot(c,wv,'k')
    box off
    SkinnyFigs
    %             FigureTitle(gdbits{iB});
    
    %%
    rp=[];
    nbtrz = rebin(trz,nbin,bin);
    [rws,cls]=size(nbtrz);
    
    for i= 1:cls
        [rp(2,i),rp(1,i)] = corr(mb',nbtrz(:,i));
        if rp(1,i)<.05
            rp(3,i) = 1;
        else
            rp(3,i) = 0;
        end
    end
    if sum(rp(3,1000/nbin:1500/nbin))>0
        subplot(3,1,3)
        tix = (1000/nbin)-1+find(rp(3,1000/nbin:1500/nbin)==1);
        Y =  mean(nbtrz(:,tix),2);
        scatter(mb',Y)
        hold on
        p = polyfit(mb',Y,1);
        pv = polyval(p,mb');
        x = mb';
        plot(x,pv)
        title(num2str(tix*nbin))
        ca
    end
    ca
    
    %%
    gdbits = bits(cellfun(@isempty,strfind(bits,'FreeRewardUp')));%get all the bits except the free reward bit
    
    si = ismember(double([DS.situation]),situations);
    
end

if ~exist('LMH')==1
    LMH = [];
end

% disp('bleh')




