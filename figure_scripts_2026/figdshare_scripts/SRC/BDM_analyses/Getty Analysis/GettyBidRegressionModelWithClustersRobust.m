function [LMH]=GettyBidRegressionModelWithClustersRobust(data_file_path_name,situations,bits,trials,win_lose_both)


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
sigma = 20;
nsigma = 4;
pre = 2000;
post = 2000;
comp = 200;
cont_comp = 500;
offset = 40; %60 V40
corrcomp1 = [180];%180
corrcomp2 = [340];%340
% corrcomp1 = [180 380];%180
% corrcomp2 = [340 860];%340
numComp=numel(corrcomp1);


alpha = .05;
corrp = .05;
minNumTrials = 10;
normMethod = 'none';%Zscore BGsubtract BGdivide none
ExclSensoredBids = 1;
mc_correct = 0;
wvlength = 1.8;
BLFR = 8;
mxBid = 100;
mnBid = 0;
quantMethod = 'linsp';
nq=3;

pop = 0;
numSig = 1;
frwEv = 2; % 0 = frw; 1 = just evnt; 2 is both
% % % Vicer
% % % 145:395 -> 43

% % % Ulysses
% % % 180:340 -> 32 all 3 sig
% % % 205:365 -> 31 1 not sig, 2 sig, 3 sig with r2 of .927
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
        continue
    end
    
    sDS = DS(gdix);
    sit = [sDS.situation];
    mb = double([sDS.MonkeyBid]);
    tn = double([sDS.TrialNumber]);

    %% Free reward response
    if frwEv ~=1
        load([pth,'FreeReward.mat'])
        frw = FRW.response;
    end
    %%
    gdbits = bits(~contains(bits,'FreeRewardUp'));%get all the bits except the free reward bit
    h=[];tp=[];a=[];
    if frwEv==1 || frwEv==2
        for iB = 1:length(gdbits)
            trial_rast = [];cont_trial_rast = [];alignment = [];cont_alignment = [];
            for iGx = 1:length(sDS)%for each trial defined by goodix.
                alignment = [];cont_alignment=[];
                alignment = double([sDS(iGx).(gdbits{iB})]);
                %             cont_alignment = [sDS(iGx).TrialOnsetUp];
                cont_alignment = double([sDS(iGx).FixationCrossUp]);
                if length(alignment)>1
                    alignment = alignment(2);
                end
                a(iGx,iB)=alignment;
                if iB==3 && isnan(alignment)
                    alignment = a(iGx,iB-1)+1212;
                end
                spks_per_trial = [sDS(iGx).(clust_nams{iC})];
                [trial_rast(iGx,:),bc] = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
                cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
            end
            [~,mxix] = max(nanmean(trial_rast(:,pre/bin:(pre+500)/bin)));
            mxix=(mxix*bin)+pre;
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
                badBLFR = 1;
                continue
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
            %%
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
    if badWV || badBLFR || badNumTr;
        bad = 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if  ~bad && frwEv == 0  && frw ||...
            ~bad && frwEv == 2 && sum(h)>=numSig || ~bad && frwEv == 2 && frw ||...
            ~bad && frwEv == 1 && sum(h)>=numSig

        ctr=ctr+1;a=[];
        
        for iB = 1:length(gdbits)
            LMH(ctr).(gdbits{iB})=nan;LMH(ctr).rast.(gdbits{iB})=nan;
            LMH(ctr).br2p.(gdbits{iB})=nan;LMH(ctr).br2p_bin.(gdbits{iB})=nan;LMH(ctr).br2p_frac.(gdbits{iB})=nan;
            trial_rast = [];cont_trial_rast = [];alignment = [];cont_alignment = [];
            
            for iGx = 1:length(sDS)%for each trial defined by goodix.
                alignment = [];cont_alignment=[];
                alignment = double([sDS(iGx).(gdbits{iB})]);
                
                %                 cont_alignment = [sDS(iGx).TrialOnsetUp];
                cont_alignment = double([sDS(iGx).FixationCrossUp]);
                if length(alignment)>1
                    alignment = alignment(2);
                end
                a(iGx,iB)=alignment;
                if iB==3 && isnan(alignment)
                    alignment = a(iGx,iB-1)+1212;
                end
                spks_per_trial = [sDS(iGx).(clust_nams{iC})];
                [trial_rast(iGx,:),bc] = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
                cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
            end
            %%
            %             trial_rast = FiringRateGaussRaster(trial_rast,sigma,nsigma,bin);
            %             cont_trial_rast = FiringRateGaussRaster(cont_trial_rast,sigma,nsigma,bin);
            
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
            rp=[]; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             numComp = (corrcomp2-corrcomp1)/nbin;
            stats=[];p=[];b=[];r2=[];i=[];
            for i = 1:numComp%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %% define region for comparisons
                % compix = (pre+corrcomp1+(nbin*(i-1)))/bin:(pre+corrcomp1+(nbin*i))/bin;
                compix=(pre+corrcomp1(i))/bin:(pre+corrcomp2(i))/bin;
                %% corr bid with fr
                fr =[];
                fr = nanmean(trz(:,compix),2); % % % % % % % % % % % % % % % % % %                
                [rho,pc] = corr(mb',fr);% % % % % % % % % % % % % % % % % % % % % % %
                
                X = [ones(length(mb),1),mb'];
                [b_,~,~,~,stats] = regress(fr,X);
                            
                
                tbl = struct2table(sDS);
                midix = tbl.reward_value==2;
                liltbl = tbl(midix,:);
%                 [xc,lg] = xcorr(mb',liltbl.MonkeyBid,30);
%                 mbs = [mb',liltbl.MonkeyBid];
%                 [~,mxxc] = max(xc);
%                 matchix = lg(mxxc)+1;
%                 
%                 
%                 ltfr = fr(matchix:end);
                
                
                liltbl.fr = fr(midix);
                lmb = double(liltbl.monkey_bid);
                omb = double(liltbl.MonkeyBid);
                if sum(fr)==0
                    p(i)=1;
                    b(i)=0;
                else
%                     liltbl = liltbl(~isnan(liltbl.previous_win_lose_sameRV),:);
%                     mdlstr  = 'fr ~ 1 + monkey_bid + reward_value + starting_bid + previous_CB_sameRV + previous_win_lose_sameRV + total_liquid';
                    mdlstr  = 'fr ~ 1 +  monkey_bid + starting_bid + previous_CB_sameRV + previous_win_lose_sameRV ';
%                     mdlstr  = 'fr ~ 1 +  monkey_bid ';

                    % mdl = fitlme(liltbl,mdlstr);
                    mdl = fitlm(liltbl,mdlstr);
%                     mdl = fitlm(liltbl,mdlstr,'RobustOpts','bisquare');

%                     p(i) = min(mdl.Coefficients.pValue(2),mdl.Coefficients.pValue(3));
                    p(i) = mdl.Coefficients.pValue(2);                    
                    r2(i) = mdl.Rsquared.Adjusted;
                    b(i)=mdl.Coefficients.Estimate(2);
                    if strcmp(gdbits{iB},'FractalDisplayUp') & p<.05 & b>0 
                        disp('sig')
                    end
                    if strcmp(gdbits{iB},'FractalDisplayUp') & stats(3)<.05 & b_(2)>0
                        disp('sig')
                    end
                end
                %% split bids into chunks & correlate binned bids w/ fr
                mnmb = min(mb);
                mxmb = max(mb);
                if mnmb < mean(mb)-(2*std(mb))
                    mnmb = round(mean(mb)-(2*std(mb)));
                end
                if mxmb > mean(mb)+(2*std(mb))
                    mxmb = round(mean(mb)+(2*std(mb)));
                end
                
                edgs = [];bn=[];bid_lmh=[];
                if strcmp(quantMethod,'quant')
                    %                 edgs = quantile(mb(gi'&mb<100),[.333 .666]);%nq-1;%,'Method','approximate');
                    edgs = quantile(mb(gi'&mb<100),nq-1);%,'Method','approximate');
                    if nq ==2
                        edgs =median(mb(gi'&mb<100));
                    end
                    edgs = [0,edgs];
                    edgs(end+1)= 100;
                elseif strcmp(quantMethod,'linsp')
                    %                 df = max(mb)-min(mb);
                    %                 ejs = round(min(mb):df/(nq-1):max(mb));
                    edgs = linspace(mnmb,mxmb,nq+1);
                    edgs(1)=0; edgs(end)=100;
                elseif strcmp(quantMethod,'stdev')
                    smb = std(mb(gi'&mb<100));
                    %                 mmb = median(mb(gi'&mb<100));
                    mmb= mean(mb(gi'&mb<100));
                    %                 edgs = [mmb-(smb*2),mmb-(smb*1),mmb,mmb+(smb*1),mmb+(smb*2)];
                    edgs = [mmb-(smb*1),mmb+(smb*1)];
                    edgs=[0,edgs,100];
                    edgs(edgs>100)=100; edgs(edgs<0)=0;
                end
                
                [~,~,bix] = histcounts(mb,edgs);
                
                if strcmp(quantMethod,'stdev') && edgs(3)==100
                    bn = bn+1;
                end
                
                frb = nan(1,nq);
                for iBfr = unique(bix)
                    frb(iBfr) = nanmean(fr(bix==iBfr));
                    mbb(iBfr) = nanmean(mb(bix==iBfr));
                end
                bds = mbb;
                %             oix = isoutlier(frb)|isnan(frb);
                %             bds = bds(~oix);frb = frb(~oix);
                badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);
%                 [r2_bin,p_bin] = corr(bds',frb','type','Pearson');% % % % % % % % % % % % % % % % % % % % % % %                
                X = [ones(length(bds),1),bds'];
                [bb,~,~,~,stats_bin] = regress(frb',X);
                p_bin(i) = stats_bin(3);
                r2_bin(i) = stats_bin(1);
                b_bin(i) = bb(2);
                
                %% frac regression
                sits = double([sDS.situation]);
%                 [r2_frac,p_frac] = corr(sits',fr);% % % % % % % % % % % % % % % % % % % % % % %
                X = [ones(length(sits),1),sits'];
                [bf,~,~,~,stats] = regress(fr,X);
                p_frac(i) = stats(3);
                r2_frac(i) = stats(1);
                b_frac(i) = bf(2);
            end
            
            p(isnan(p))=1;
%             p(p==0)=1;

            corrected_p = HolmSidak(p,corrp);
            corrected_p(isnan(corrected_p))=1;
%             cp = corrected_p;  
            cp = p;

            corrected_p_bin = HolmSidak(p_bin,corrp);
            corrected_p_bin(isnan(corrected_p_bin))=1;
%             cp_bin = corrected_p_bin;
            cp_bin = p_bin;

            
            corrected_p_frac = HolmSidak(p_frac,corrp);
            corrected_p_frac(isnan(corrected_p_frac))=1;
            cp_frac = corrected_p_frac;
            
            %%
            if  any(cp<corrp & b>0) ;%|| any(cp_bin<corrp & b_bin>0) ||  pop               
                
                LMH(ctr).(gdbits{iB})=[];
                [rws,cls] = size(trz);
                
                mbrv = [mb',sits'];
                [smb,smbix] = sortrows(mbrv,1);
                
                stn = tn(smbix);
                strz = trz(smbix,:);
                sctrz = ctrz(smbix,:);
                
                i=[];out=[];
                for i = 1:numComp
                    compix=(pre+corrcomp1(i))/bin:(pre+corrcomp2(i))/bin;
                    if strcmp(normMethod,'Zscore')
                        out(:,i) = nanmean(strz(:,compix),2);
                        cont = nanmean(sctrz(:,(pre-cont_comp)/bin:pre/bin),2);
                    elseif strcmp(normMethod,'BGsubtract')
                        out = (sum(strz(:,compix),2)/(range(compix)*bin))*1000;
                        cont = (sum(sctrz(:,(pre-cont_comp)/bin:pre/bin),2)/cont_comp)*1000;
%                         out(:,i) = (nanmean(strz(:,compix),2)/bin)*1000;
%                         cont = (nanmean(sctrz(:,(pre-cont_comp)/bin:pre/bin),2)/bin)*1000;
                    elseif strcmp(normMethod,'none')
%                         out = (sum(strz(:,compix),2)/(range(compix)*bin))*1000;
%                         cont = (sum(sctrz(:,(pre-cont_comp)/bin:pre/bin),2)/cont_comp)*1000;
                        out(:,i) = (mean(strz(:,compix),2))/bin*1000;
                        cont = (mean(sctrz(:,(pre-cont_comp)/bin:pre/bin),2))/bin*1000;
                    end
                end
                LMH(ctr).(gdbits{iB})(:,1) = out(:,1); % early response
                if numComp>1
                    LMH(ctr).(gdbits{iB})(:,4) = out(:,2); % late response
                end                
                LMH(ctr).(gdbits{iB})(:,2) = cont;
                LMH(ctr).(gdbits{iB})(:,3) = smb(:,1);
                LMH(ctr).rast.(gdbits{iB}) = strz;
                LMH(ctr).(gdbits{iB})(:,5) = smb(:,2);
                LMH(ctr).(gdbits{iB})(:,6) = stn;
                LMH(ctr).br2p.(gdbits{iB}) = [b;r2;p];
                LMH(ctr).br2p_bin.(gdbits{iB}) = [b_bin;r2_bin;p_bin];
                LMH(ctr).br2p_frac.(gdbits{iB}) = [b_bin;r2_bin;p_bin];

%                 params = struct(bin sigma nsigma pre post comp cont_comp offset corrcomp1 corrcomp2 numComp,...
%                     alpha corrp minNumTrials normMethod ExclSensoredBids mc_correct wvlength BLFR mxBid mnBid,...
%                      quantMethod nq pop numSig frwEv 
                
            end
        end
    end
    ca
end

if ~exist('LMH')==1
    LMH = [];
end

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

%%
% % % % % % % % %             if iB==7
% % % % % % % % %                 artix = [1070 1228 1385];
% % % % % % % % %                 for iA = 1:length(artix)
% % % % % % % % %                     trial_rast(:,floor(artix(iA)/bin):round((artix(iA)+5)/bin))=0;
% % % % % % % % %                 end
% % % % % % % % %             end
% % % % % % % % %
