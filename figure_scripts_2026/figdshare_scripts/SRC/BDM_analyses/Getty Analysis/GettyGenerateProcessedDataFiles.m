function [LMH]=GettyBidRegressionWithClustersRobust(data_file_path_name,situations,bits,trials,win_lose_both)


[DS,pth] = FormatGettyDataStructureWithClusters(data_file_path_name);

if ~isempty(strfind(pth,'Vic'))
    monk='Vic';
else
    monk='Uly';
end


situation_names = {'BDM Low ' 'BDM Mid ' 'BDM HIgh ' 'Free Reward'};

if nargin < 1
    val = inputdlg('What situations would you like to analyze?','Situation',1,{'1:3'});
    situations = str2num(val{1});
end

if nargin < 2
    important_bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
        'WinLoseUp' 'FreeRewardUp' 'RewardEpochEndUp' 'BudgetTapUp'};
    %     allBits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
    %         'WinLoseUp' 'FreeRewardUp' 'RewardEpochEndUp' 'BudgetTapUp' 'ErrorUp'};
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
comp = 200;
cont_comp = 500;
offset = 40; %60 V40

alpha = .05;
minNumTrials = 30;
normMethod = 'none';%Zscore BGsubtract BGdivide none
ExclSensoredBids = 1;
mc_correct = 0;
wvlength = 1.8;
BLFR = [0 10];
mxBid = 100;
mnBid = 0;

numSig = 1;
frwEv = 2; % 0 = frw; 1 = just evnt; 2 is both
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

ExSB = [DS.MonkeyBid]<mxBid & [DS.MonkeyBid]>mnBid;
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
ctr=0;badWV=0;badBLFR=0;bad=0;badNumTr=0;
for iC = 1:length(clust_nams)%for each cluster
    wv = DS(1).(clust_wav_nams{iC});
    wvl = DS(3).(clust_wav_nams{iC});
    if wvl < wvlength
        badWV = 1;
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
    clix = zeros(1,length(DS));
    for iD = 1:length(DS)
        trial_spikes =[];
        trial_spikes = double([DS(iD).(clust_nams{iC})]);
        if ~isempty(trial_spikes)
            clix(iD) = 1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % Indexing % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gdix = gtc & goodix & clix;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if sum(gdix) < minNumTrials
        badNumTr = 1;
    end
    
    sDS = DS(gdix);
    sits = [sDS.situation];
    mb = double([sDS.MonkeyBid]);
    cb = double([sDS.ComputerBid]);
    pcbsrv = double([sDS.previous_CB_sameRV]);
    pcb = double([sDS.previous_CB]);
    sb = double([sDS.starting_bid]);
    pwl = double([sDS.previous_win_lose_sameRV]);
    ptl = double([sDS.previous_total_liquid]);
    tn = double([sDS.TrialNumber]);
    mtch = double([sDS.matchy]);
    %% Deliberation time
    
    bs_time=[];be_time=[];        
    bs_time = double([sDS.BidStartUp]);
    frac_up = double([sDS.FractalDisplayUp]);
    if any(isnan(bs_time))
        bs_time = frac_up+1212;
    end    
    be_time= double([sDS.BidStableUp]);
    tot_bid_time = be_time-bs_time;
    
    %% Free reward response
    if frwEv ~=1
        load([pth,'FreeReward.mat'])
        frw = FRW.response;
    end
    %%
    gdbits = bits(~contains(bits,'FreeRewardUp'));%get all the bits except the free reward bit
    h=0;tp=[];a=[];
    if ~badNumTr
        for iB = 1:length(gdbits)
            trial_rast = [];cont_trial_rast = [];alignment = [];cont_alignment = [];joystick_rast=[];
            for iGx = 1:length(sDS)%for each trial defined by goodix.
                alignment = [];cont_alignment=[];
                alignment = double([sDS(iGx).(gdbits{iB})]);
                %             cont_alignment = [sDS(iGx).TrialOnsetUp];
                cont_alignment = double([sDS(iGx).FixationCrossUp]);
                if length(alignment)>1
                    alignment = alignment(2);
                end
                a(iGx,iB)=alignment;
                if strcmp((gdbits{iB}),'BidStartUp') && isnan(alignment)
                    alignment = a(iGx,iB-1)+1212; % this bit is missing sometimes.
                end
                if isnan(alignment)
                    al = double([sDS.(gdbits{iB})]);
                    alignment = round(mean(al(al>0),'omitnan')); %catchall for missing bits. Takes the mean.
                end
                % % %                 js_trace = [sDS(iGx).JoyStick];
                
                spks_per_trial = [sDS(iGx).(clust_nams{iC})];
                [trial_rast(iGx,:),bc] = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
                cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
            end
            %             if strcmp(gdbits{iB},'BidStartUp')
            %                 figure;
            %                 %             PlotTracesStacked(joystick_rast)
            %                 PlotTracesOverlapped(joystick_rast,pre)
            %                 g=gca;
            %                 line([pre pre],[g.YLim(1) g.YLim(2)]);
            %                 title(gdbits{iB});
            %                 disp(max(double([sDS.BidStableUp])-double([sDS.BidStartUp])));
            %                 ca
            % %             end
            [~,mxix] = max(nanmean(trial_rast(:,pre/bin:(pre+500)/bin)));
            mxix=(mxix*bin)+pre;
            if strcmp(gdbits{iB},'RewardEpochEndUp') && strcmp(monk,'Vic')
                artifact = double([sDS.RewardEpochEndDwn])-double([sDS.RewardEpochEndUp]);
                artifact = artifact+pre;
                ofst  = 2;
                otr = trial_rast;
                [trial_rast,tart] = RemoveRasterArtifact(trial_rast,artifact,ofst);
            end
            
            %% Don't analyze cells with bad baseline (> 10 hz)
            
            baselineInstFR = nanmean(nanmean((cont_trial_rast(:,(pre-800)/bin:pre/bin)./bin)*1000));
            baselineFR = nanmean(sum(cont_trial_rast(:,(pre-800)/bin:pre/bin),2)./800*1000);
            
            if baselineFR < BLFR(1) && baselineInstFR < BLFR(1) ||...
                    baselineFR > BLFR(2) && baselineInstFR > BLFR(2)
                badBLFR = 1;
                continue
            end
            if baselineFR == 0 && baselineInstFR == 0
                badBLFR = 1;
            end
            %%
            %         trial_rast = FiringRateGaussRaster(trial_rast,sigma,nsigma,bin);
            %         cont_trial_rast = FiringRateGaussRaster(cont_trial_rast,sigma,nsigma,bin);
            %% Normalize
            if strcmp(normMethod,'Zscore')
                %             trial_rast = trial_rast+1; cont_trial_rast=cont_trial_rast+1;
                trz = Z_scores_control_data(trial_rast,cont_trial_rast,(pre-cont_comp)/bin:pre/bin);
                %             trz = zscore(trial_rast,0,2);
                ctrz = Z_scores_control_data(cont_trial_rast,cont_trial_rast,(pre-cont_comp)/bin:pre/bin);
                %             ctrz = zscore(cont_trial_rast,0,2);
            elseif strcmp(normMethod,'BGsubtract')
                trz = trial_rast-mean(cont_trial_rast(:,(pre-cont_comp)/bin:pre/bin),2);
                ctrz = cont_trial_rast-mean(cont_trial_rast(:,(pre-cont_comp)/bin:pre/bin),2);
            elseif strcmp(normMethod,'BGdivide')
                trz = trial_rast./nanmean(cont_trial_rast(:,(pre-cont_comp)/bin:pre/bin),2);
                ctrz = cont_trial_rast./nanmean(cont_trial_rast(:,(pre-cont_comp)/bin:pre/bin),2);
            elseif strcmp(normMethod,'none')
                trz = trial_rast;
                ctrz = cont_trial_rast;
            end
            
            
            %%
            frpo = nanmean(trz(:,(pre+offset)/bin:(pre+comp)/bin),2);
            frct = nanmean(ctrz(:,(pre-cont_comp)/bin:pre/bin),2);
            [tp(iB),h(iB)]=signrank(frpo,frct,'alpha',alpha,'tail','right');
            %
            %         [h(iB),tp(iB)]=ttest(frpo,frct,'alpha',alpha,'tail','right');
            h(isnan(h))=0;
            
            if sum(sum(trz,2)>1)<minNumTrials
                h(iB) = 0;
            end
        end
        if mc_correct
            hc = [];pc=[];
            if ~isempty(tp)
                [pc,hc] = Bonferroni(tp,alpha);
            end
            h = h & hc;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    InclInAnal =  ~bad && frwEv == 0  && frw ||...
        ~bad && frwEv == 2 && sum(h)>=numSig || ~bad && frwEv == 2 && frw ||...
        ~bad && frwEv == 1 && sum(h)>=numSig;
    
    ctr=ctr+1;a=[];
    
        
    for iB = 1:length(gdbits)
        LMH(ctr).event.monkeybid = nan; LMH(ctr).event.situations = nan; LMH(ctr).event.trialnums = nan;
        LMH(ctr).event.computerbid = nan; LMH(ctr).event.previouscomputerbid = nan; LMH(ctr).event.startingbid = nan;
        LMH(ctr).event.previouswinlose = nan; LMH(ctr).event.previoustotalliquid = nan; LMH(ctr).event.total_bid_duration = nan;
        LMH(ctr).event.match = nan;
        
        LMH(ctr).FR.(gdbits{iB}) = nan; LMH(ctr).FR_late.(gdbits{iB}) = nan; LMH(ctr).FR_control.(gdbits{iB}) = nan;
        LMH(ctr).rast.(gdbits{iB}) = nan;LMH(ctr).control_rast.(gdbits{iB})=nan;LMH(ctr).joystick_rast.(gdbits{iB}) = nan;
        LMH(ctr).waveform_length = nan;LMH(ctr).baseline_firing_rate = nan;LMH(ctr).cluster = nan;LMH(ctr).date = nan;LMH(ctr).session = nan;

        
        trial_rast = [];cont_trial_rast = [];alignment = [];cont_alignment = [];
        if ~badNumTr
            for iGx = 1:length(sDS)%for each trial defined by goodix.
                alignment = [];cont_alignment=[];
                alignment = double([sDS(iGx).(gdbits{iB})]);
                %                 cont_alignment = [sDS(iGx).TrialOnsetUp];
                cont_alignment = double([sDS(iGx).FixationCrossUp]);
                if length(alignment)>1
                    alignment = alignment(2);
                end
                a(iGx,iB)=alignment;
                if strcmp((gdbits{iB}),'BidStartUp') && isnan(alignment)
                    alignment = a(iGx,iB-1)+1212;
                end
                if isnan(alignment)
                    al = double([sDS.(gdbits{iB})]);
                    alignment = round(mean(al(al>0),'omitnan'));
                end
                js_trace = [sDS(iGx).JoyStick];
                spks_per_trial = [sDS(iGx).(clust_nams{iC})];
                [trial_rast(iGx,:),bc] = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
                cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
                joystick_rast(iGx,:) = PeriEventTraceSingleTrial(js_trace,alignment,pre,5000,100);
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if strcmp(gdbits{iB},'RewardEpochEndUp') && strcmp(monk,'Vic')
                artifact = double([sDS.RewardEpochEndDwn])-double([sDS.RewardEpochEndUp]);
                artifact = artifact+pre;
                ofst  = 2;
                [trial_rast] = RemoveRasterArtifact(trial_rast,artifact,ofst);
                ca
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% Normalize
            if strcmp(normMethod,'Zscore')
                %                 trial_rast = trial_rast+1; cont_trial_rast=cont_trial_rast+1;
                trz = Z_scores_control_data(trial_rast,cont_trial_rast,(pre-cont_comp)/bin:pre/bin);
                %                 trz = zscore(trial_rast,0,2);
                ctrz = Z_scores_control_data(cont_trial_rast,cont_trial_rast,(pre-cont_comp)/bin:pre/bin);
                %                 ctrz = zscore(cont_trial_rast,0,2);
            elseif strcmp(normMethod,'BGsubtract')
                trz = trial_rast-nanmean(cont_trial_rast(:,(pre-cont_comp)/bin:pre/bin),2);
                ctrz = cont_trial_rast-nanmean(cont_trial_rast(:,(pre-cont_comp)/bin:pre/bin),2);
            elseif strcmp(normMethod,'BGdivide')
                trz = trial_rast./(nanmean(cont_trial_rast(:,(pre-cont_comp)/bin:pre/bin),2)+eps);
                ctrz = cont_trial_rast./(nanmean(cont_trial_rast(:,(pre-cont_comp)/bin:pre/bin),2)+eps);
            elseif strcmp(normMethod,'none')
                trz = trial_rast;
                ctrz = cont_trial_rast;
            end
            %%
            [rws,cls] = size(trz);
            
            mbrv = [mb',sits'];
            [smb,smbix] = sortrows(mbrv,1);
            
            scb = cb(smbix);
            stn = tn(smbix);
            spcb = pcb(smbix);
            spcbsrv = pcbsrv(smbix);
            ssb = sb(smbix);
            spwl=pwl(smbix);
            sptl = ptl(smbix);
            smtch = mtch(smbix);
            stot_bid_time = tot_bid_time(smbix);
            strz = trz(smbix,:);
            cstrz = ctrz(smbix,:);
            sjs_rast = joystick_rast(smbix,:);
            sctrz = ctrz(smbix,:);
        
        %%
        LMH(ctr).event.monkeybid = smb(:,1);
        LMH(ctr).rast.(gdbits{iB}) = strz;
        LMH(ctr).control_rast.(gdbits{iB}) = cstrz;
        LMH(ctr).joystick_rast.(gdbits{iB}) = sjs_rast;
        LMH(ctr).event.situations = smb(:,2);
        LMH(ctr).event.trialnums = stn';
        LMH(ctr).event.computerbid = scb';
        LMH(ctr).event.previous_computerbid = spcb';
        LMH(ctr).event.previouscomputerbid_same_RV = spcbsrv';
        LMH(ctr).event.startingbid = ssb';
        LMH(ctr).event.previouswinlose = spwl';
        LMH(ctr).event.previoustotalliquid = sptl';
        LMH(ctr).event.total_bid_duration = stot_bid_time';
        LMH(ctr).event.match = smtch';
        LMH(ctr).waveform_length = wvl;
        LMH(ctr).baseline_firing_rate = baselineFR;
        LMH(ctr).cluster = cln;
        LMH(ctr).date = sDS(1).date;
        LMH(ctr).session = sDS(1).session_number;
        end
    end
    if any(h) || frw
        isResponsive = 1;
    else
        isResponsive = 0;
    end
    if badWV || badBLFR
        isDA = 0;
    else
        isDA = 1;
    end
    if badNumTr
        numTrGood = 0;
    else
        numTrGood = 1;
    end
    LMH(ctr).isResponsive = isResponsive;
    LMH(ctr).isDA = isDA;
    LMH(ctr).numTrGood = numTrGood;
    ca
end

if ~exist('LMH')==1
    LMH = [];
end