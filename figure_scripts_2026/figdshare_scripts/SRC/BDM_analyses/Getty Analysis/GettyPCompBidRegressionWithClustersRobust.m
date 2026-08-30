function [LMH]=GettyPCompBidRegressionWithClustersRobust(data_file_path_name,situations,bits,trials,win_lose_both)


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
bin = 10;
nbin = 50;
pre = 1000;
post = 2000;
comp = 300;
cont_comp = 500; 
offset = 80;
corrcomp1 = 200; 
corrcomp2 = 400;

% % % Vicer
% % % 160:400 -> 34
% % % 140:420 -> 30 1 & 3 good. 2 not so good
% % % 140:400 -> all 3 significant
% % % 150:350 -> 

% % % Ulysses
% % % 200:450 -> 27 not all good
% % % 200:400 -> 28 all good**
% % % 170/180:400 -> 29 not so good on 1. good on others
% % % 200:400 -> best all round (I think)
% % % 200:380 -> best R2 for 3, worse for 1

alpha = .05;
corrp = .05;
minNumTrials = 10;
normMethod = 'BGsubtract';%Zscore BGsubtract none
ExclSensoredBids = 1;
mc_correct = 1;
wvlength = 1.8;
BLFR = 8;
mxBid = 100;
mnBid = 0;
pwl = -1;
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
ctr=0;
for iC = 1:length(clust_nams)%for each cluster
    wv = DS(1).(clust_wav_nams{iC});
    wvl = DS(3).(clust_wav_nams{iC});
    if wvl < wvlength
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
    if all(pwl>-1)
        wlix = ismember([DS.previous_win_lose],pwl);
    else
        wlix = ones(size(clix));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % Indexing % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gdix = gtc & goodix & clix & wlix;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if sum(gdix) < minNumTrials
        continue
    end
    
    sDS = DS(gdix);
    sit = [sDS.situation];
%     cb = double([sDS.previous_CB]); %if he keeps track of opponent strategy generally, he should be looking at this
cb = double([sDS.previous_CB_sameRV])-double([sDS.previous_MB_sameRV]); %if he keeps track of opponent strategy per fractal, he should be looking at this
    %     tj = double([sDS.]);
%     tw = double([sDS.]);
%     bs = double([sDS.]);

    
    
    
    gdbits = bits(~contains(bits,'FreeRewardUp'));%get all the bits except the free reward bit
    h=[];tp=[];
    for iB = 1:length(gdbits)
        trial_rast = [];cont_trial_rast = [];alignment = [];cont_alignment = [];
        for iGx = 1:length(sDS)%for each trial defined by goodix.
            alignment = [];cont_alignment=[];
            alignment = [sDS(iGx).(gdbits{iB})];
            cont_alignment = [sDS(iGx).TrialOnsetUp];
            if length(alignment)>1
                alignment = alignment(2);
            end            
            spks_per_trial = [sDS(iGx).(clust_nams{iC})];
            [trial_rast(iGx,:),bc] = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
            cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
        end
        % % % % % % % % % % % % % % % % % % % % % %         if iB==7
        % % % % % % % % % % % % % % % % % % % % % %             artix = [1070 1230 1385];
        % % % % % % % % % % % % % % % % % % % % % %             for iA = 1:length(artix)
        % % % % % % % % % % % % % % % % % % % % % %                 trial_rast(:,floor(artix(iA)/bin):round((artix(iA)+5)/bin))=0;
        % % % % % % % % % % % % % % % % % % % % % %             end
        % % % % % % % % % % % % % % % % % % % % % %         end
        
        
        %% Don't analyze cells with bad baseline (> 10 hz)
        
        baselineInstFR = nanmean(nanmean((cont_trial_rast(:,(pre-800)/bin:pre/bin)./bin)*1000));
        baselineFR = nanmean(sum(cont_trial_rast(:,(pre-800)/bin:pre/bin))./800*1000);
        
        if baselineFR > BLFR && baselineInstFR > BLFR
            continue
        end
        
        %% Normalize
        if strcmp(normMethod,'Zscore')
%             trial_rast = trial_rast+1; cont_trial_rast=cont_trial_rast+1;
%             trz = Z_scores_control_data(trial_rast,cont_trial_rast,(pre-cont_comp)/bin:pre/bin);
            trz = zscore(trial_rast,0,2);
%             ctrz = Z_scores_control_data(cont_trial_rast,cont_trial_rast,(pre-cont_comp)/bin:pre/bin);
            ctrz = zscore(cont_trial_rast,0,2);
        elseif strcmp(normMethod,'BGsubtract')
            trz = trial_rast-nanmean(cont_trial_rast((pre-cont_comp)/bin:pre/bin));
            ctrz = cont_trial_rast-nanmean(cont_trial_rast((pre-cont_comp)/bin:pre/bin));
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
%         if h(iB)==1
%             figure
%             subplot(5,1,1:3)
%             Imagesc_for_rast(trz)
%             title(gdbits{iB})
%             subplot(5,1,4:5)
%             plot(nanmean(trz))
%             g=gca;
%             title(tp(iB))
%             PIP_Plot([.7 .7 .25 .25],g)
%             Plot_Bars_SEM([frpo,frct])
%             PIP_Plot([.7 .3 .25 .25],g)
%             [~,c] = size(wv);
%             c=(1:c)/22;
%             plot(c,wv,'k')
%             box off
%             ca
%         end
    end
    if mc_correct
        hc = [];pc=[];
        if ~isempty(tp)
            [pc,hc] = HolmBonferroni(tp,alpha);
        end
        h = h & hc;
    end
    if sum(h)>0 
        ctr=ctr+1;
        for iB = 1:length(gdbits)
            LMH(ctr).(gdbits{iB})=nan;
            trial_rast = [];cont_trial_rast = [];alignment = [];cont_alignment = [];
            for iGx = 1:length(sDS)%for each trial defined by goodix.
                alignment = [];cont_alignment=[];
                alignment = [sDS(iGx).(gdbits{iB})];
                cont_alignment = [sDS(iGx).TrialOnsetUp];
                if length(alignment)>1
                    alignment = alignment(2);
                end                
                spks_per_trial = [sDS(iGx).(clust_nams{iC})];
                [trial_rast(iGx,:),bc] = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
                cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
            end
            %%
% % % % % % % % % % % % % % %             if iB==7
% % % % % % % % % % % % % % %                 artix = [1070 1228 1385];
% % % % % % % % % % % % % % %                 for iA = 1:length(artix)
% % % % % % % % % % % % % % %                     trial_rast(:,floor(artix(iA)/bin):round((artix(iA)+5)/bin))=0;
% % % % % % % % % % % % % % %                 end
% % % % % % % % % % % % % % %             end
% % % % % % % % % % % % % % %             
            %% Normalize
            if strcmp(normMethod,'Zscore')
%                 trial_rast = trial_rast+1; cont_trial_rast=cont_trial_rast+1;
%                 trz = Z_scores_control_data(trial_rast,cont_trial_rast,(pre-cont_comp)/bin:pre/bin);
                trz = zscore(trial_rast,0,2);
%                 ctrz = Z_scores_control_data(cont_trial_rast,cont_trial_rast,(pre-cont_comp)/bin:pre/bin);
                ctrz = zscore(cont_trial_rast,0,2);
            elseif strcmp(normMethod,'BGsubtract')
                trz = trial_rast-nanmean(cont_trial_rast((pre-cont_comp)/bin:pre/bin));
                ctrz = cont_trial_rast-nanmean(cont_trial_rast((pre-cont_comp)/bin:pre/bin));
            elseif strcmp(normMethod,'none')
                trz = trial_rast;
                ctrz = cont_trial_rast;
            end
            compix=(pre+corrcomp1)/bin:(pre+corrcomp2)/bin;
            
            
% % %             fr = nanmean(trz(:,compix),2); % % % % % % % % % % % % % % % % % % 
% % %             [r,p] = corr(mb',fr);% % % % % % % % % % % % % % % % % % % % % % %  
% % %             if p<corrp && r >0 % % % % % % % % % % % % % % % % % % % % % % % % 
                
            rp=[]; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            nbtrz = rebin(trz,nbin,bin);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [rws,cls]=size(nbtrz);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             
            for i= 1:cls%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [rp(2,i),rp(1,i)] = corr(cb',nbtrz(:,i));%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 mdl=fitlm(mb',nbtrz(:,i),'RobustOpts','on');%%%%%%%%%%%%%%%%%%%%%
%                 rp(2,i) = mdl.Coefficients.Estimate(2);%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 rp(1,i) = mdl.Coefficients.pValue(2);%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if rp(1,i)<corrp%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    rp(3,i) = 1;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                else%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    rp(3,i) = 0;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            sig = find(rp(3,:)>0);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            sigg = sig((sig*nbin)>=pre+corrcomp1&(sig*nbin)<=pre+corrcomp2);%%%%%%%
            corrected_p = HolmBonferroni(rp(1,(pre+corrcomp1)/nbin:(pre+corrcomp2)/nbin),corrp);
            corrected_p(isnan(corrected_p))=1;
            if 1% ~isempty(sigg)%&& all(rp(2,sigg)>0) %&& any(corrected_p<corrp) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
%                 disp(sigg*nbin)

                LMH(ctr).(gdbits{iB})=[];                
                
                [rws,cls] = size(trz);
                
                if 0% iB==3
                    figure
                    subplot(4,1,1)
                    [smb,smbix] = sort(cb');
                    strz = trz(smbix,:);
                    snbtrz = nbtrz(smbix,:);
                    ssnbtrz = smoothdata(nbtrz,2,'gaussian',11);
                    for i=1:length(strz(:,1))
                        sisnbtrz(i,:)=interp1(snbtrz(i,:),.1:.1:length(snbtrz(1,:)),'linear');
                    end
                    PlotTrueRaster(strz)
                    set(gca,'YDir','reverse')
                    for i = 1:length(smb)
                        text(cls,i-.5,num2str(smb(i)),'FontSize',5)
                    end
                    axis tight
%                     ShadedBox([min(compix) max(compix)])
                    subplot(4,1,2)
                    plot(smoothdata(sum(trial_rast),'gaussian',100/bin),'k')
                    ShadedBox([min(compix) max(compix)])
                    box off
                    PIP_Plot([.7 .7 .25 .25])
                    [~,c] = size(wv);
                    c=(1:c)/22;
                    plot(c,wv,'k')
                    box off
                    SkinnyFigs
                    FigureTitle(gdbits{iB});
                    subplot(4,1,3)
                    %                 tix = (1000/nbin)-1+find(rp(3,1000/nbin:1500/nbin)==1);
                    Y =  mean(nbtrz(:,sigg),2);
%                     Y =  mean(trz(:,compix),2);
                    scatter(cb',Y)
                    hold on
                    p = polyfit(cb',Y,1);
                    pv = polyval(p,cb');
                    x = cb';
                    plot(x,pv)
                    title(sigg*nbin)
                    subplot(4,1,4)
                    mxY = max(Y)+std(Y);
                    mnY = mean(Y);
                    imagesc(sisnbtrz,[mnY mxY]);colormap(turbo);
                    ca
                end
                %                 rix = ((sigg*nbin)-100)/bin:((sigg*nbin)+100)/bin;
                %                 compix = rix;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 compix = (((sigg*nbin)-nbin)/bin)+1:((sigg*nbin))/bin;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if strcmp(normMethod,'Zscore')
                    out = nanmean(trz(:,compix),2);
                    cont = nanmean(ctrz(:,compix),2);
                elseif strcmp(normMethod,'BGsubtract')
                    out = (nanmean(trz(:,compix),2)/bin)*1000;
                    cont = (nanmean(ctrz(:,(pre-cont_comp)/bin),2)/bin)*1000;
%                     out = nanmean(trz(:,compix),2);
%                     cont = nanmean(ctrz(:,(pre-cont_comp)/bin));

                else
                    out = (sum(trz(:,compix),2)/(range(compix)*bin))*1000;
                    cont = (sum(ctrz(:,(pre-cont_comp)/bin),2)/cont_comp)*1000;
                end     

                LMH(ctr).(gdbits{iB})(:,1) = out;
                LMH(ctr).(gdbits{iB})(:,2) = cont;
                LMH(ctr).(gdbits{iB})(:,3) = cb;
                %             LMH(ctr).(gdbits{iB})(:,4) = trz;
                LMH(ctr).(gdbits{iB})(:,5) = sit;                
            end
        end
    end
    ca    
end

if ~exist('LMH')==1
    LMH = [];
end

% disp('bleh')






%% %%%%%%%%%%%

% % % % if mbop<.05||ombp<.05
% % % %     figure
% % % %     subplot(2,1,1)
% % % %     scatter(mbo,fr)
% % % %     title(mbor)
% % % %     subplot(2,1,2)
% % % %     scatter(omb,fr)
% % % %     title(ombr)
% % % %     FigureTitle(gdbits{iB})
% % % %     ca
% % % % end