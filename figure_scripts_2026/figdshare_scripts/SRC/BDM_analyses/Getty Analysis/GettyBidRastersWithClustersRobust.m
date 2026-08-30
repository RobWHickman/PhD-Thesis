function [LMH]=GettyBidRastersWithClustersRobust(data_file_path_name,situations,bits,trials,win_lose_both)


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
bin = 10;
nbin = 50;
sigma = 20;
nsigma = 4;
pre = 2000;
post = 2000;
comp = 200;
cont_comp = 500; 
offset = 40; %60 V40
corrcomp1 = 200; 
corrcomp2 = 400;

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
pop = 1;
numSig = 1;

% % % Vicer
% % % 160:400 -> 34
% % % 140:420 -> 30 1 & 3 good. 2 not so good
% % % 140:400 -> 31 all 3 significant ***
% % % 150:350 -> 
% % % 120:400 -> 36

% % % Ulysses
% % % 200:450 -> 27 not all good
% % % 200:400 -> 28 all good**
% % % 180:420 -> 31 ***
% % % 170/180:400 -> 29 not so good on 1. good on others
% % % 200:400 -> best all round (I think)
% % % 200:380 -> best R2 for 3, worse for 1
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
    
    if sum(gdix) < minNumTrials
        badNumTr = 1;
        continue
    end
    
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
        cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster                
    end
    %     str = smoothdata(trial_rast,2,'gaussian',3);
    if sum(sum(trial_rast))==0
        tr = trial_rast2;        
    else 
        tr = trial_rast;
    end
    nbtr = rebin(tr,nbin,bin);
    str = nbtr(~sum(trial_rast,2)==0,:);
    if ~isempty(str)
        rr =nanmean(str(:,ceil((pre)/nbin):floor((pre+comp)/nbin)),2);
        ctl = nanmean(str(:,ceil((pre-comp)/nbin):floor((pre)/nbin)),2);
        
        if  nanmean(rr)>nanmean(ctl)
            [sp,sh] = signrank(rr,ctl);
            [th,tp] = ttest(rr,ctl);
            th(isnan(th))=0;sh(isnan(sh))=0;
            
            if th==0 && sh==0
                if mean(rr) > mean(ctl)+(1.5*std(ctl))
                    th=1;
                end
                
%                 figure
%                 subplot(5,1,1:3)
%                 imagesc(str)
%                 title(tp,sp)
%                 subplot(5,1,4:5)
%                 plot(nanmean(str))
%                 ca
%                 answer = questdlg('Is there a FR response?', ...
%                     'Free Reward', ...
%                     'Yes','No','No');
%                 switch answer
%                     case 'Yes'
%                         th = 1;
%                     case 'No'
%                         th = 0;
%                 end
            end
        else
            th=0;sh=0;
        end
    else
        th=0;sh=0;
    end
    ca
    %%
    gdbits = bits(~contains(bits,'FreeRewardUp'));%get all the bits except the free reward bit
    h=[];tp=[];a=[];
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
            trz = trial_rast-nanmean(cont_trial_rast(:,(pre-cont_comp)/bin:pre/bin),2);
            ctrz = cont_trial_rast-nanmean(cont_trial_rast(:,(pre-cont_comp)/bin:pre/bin),2);
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
    end
    if mc_correct
        hc = [];pc=[];
        if ~isempty(tp)
            [pc,hc] = Bonferroni(tp,alpha);
        end
        h = h & hc;
    end
    if badWV || badBLFR || badNumTr;

        bad = 1;
    end
    if   ~bad && sum(h)>=numSig  || ~bad && any([th,sh]) %  
        ctr=ctr+1;a=[];
        for iB = 1:length(gdbits)
            LMH(ctr).(gdbits{iB})=nan;
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
            % % % % % % % % % % % % % % %             if iB==7
            % % % % % % % % % % % % % % %                 artix = [1070 1228 1385];
            % % % % % % % % % % % % % % %                 for iA = 1:length(artix)
            % % % % % % % % % % % % % % %                     trial_rast(:,floor(artix(iA)/bin):round((artix(iA)+5)/bin))=0;
            % % % % % % % % % % % % % % %                 end
            % % % % % % % % % % % % % % %             end
            % % % % % % % % % % % % % % %            
            %%
            trial_rast = (FiringRateGaussRaster(trial_rast,sigma,nsigma,bin))./sigma;
            cont_trial_rast = (FiringRateGaussRaster(cont_trial_rast,sigma,nsigma,bin))./sigma;

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
            compix=(pre+corrcomp1)/bin:(pre+corrcomp2)/bin;
             %%                   
%             strz = smoothdata(trz,2,'gaussian',10);
            fr = nanmean(trz(:,compix),2); % % % % % % % % % % % % % % % % % % 
            p=[];
            [r,p] = corr(mb',fr);% % % % % % % % % % % % % % % % % % % % % % %
            nq=10;
%             q=quantile(mb,nq-1);
%             ejs = [0,q,100];
            df = max(mb)-min(mb);
            ejs = round(min(mb):df/(nq-1):max(mb));
%             linspace(min(mb),max(mb),nq+1);
%             ejs = 0:100/nq:100;
            [~,~,bix] = histcounts(mb,ejs);
            frb = nan(1,nq);
            for i = unique(bix)
                frb(i) = nanmean(fr(bix==i));
            end
            bds = 1:nq;
            %             oix = isoutlier(frb)|isnan(frb);
            %             bds = bds(~oix);frb = frb(~oix);
            badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);
            [rb,pb] = corr(bds',frb');% % % % % % % % % % % % % % % % % % % % % % %
            %             [brob,stats] = robustfit(bds',frb');
            %%
%             nq2 = 3;
%             %             q=quantile(mb,nq-1);
%             %             ejs = [0,q,100];
%             df2 = max(mb)-min(mb);
%             ejs2 = round(min(mb):df2/3:max(mb));
%             %             linspace(min(mb),max(mb),nq+1);
%             %             ejs = 0:100/nq:100;
%             [~,~,bix2] = histcounts(mb,ejs2);
%             frb = nan(1,nq2);
%             
%             bds2 = 1:nq2;                           
%             low = fr(bix2==1);
%             high= fr(bix2==3);
%             if isempty(low) || isempty(high)
%                 continue
%             end
%             if numel(low)~=numel(high)
%                 [low,high] = nan_fill(low,high);
%             end
%             [srp,srh]= signrank(low,high);
            %%
            if 0%iB==2
                figure
                scatter(bds,frb)
                hold on
                pf = polyfit(bds,frb,1);
                pv = polyval(pf,bds);
                x = bds;
                plot(x,pv)
                hold on
                plot(x,brob(1)+brob(2)*x)
                title(p,stats.p(2))
%                  ca
            end
            %%
%             if  p<corrp && r >0 || pb<corrp || pop % % % % % % % % % % % % % % % % % % % % % % % % % 
                
            rp=[]; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            nbtrz = rebin(trz,nbin,bin);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [rws,cls]=size(nbtrz);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             
            for i= 1:cls%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [rp(2,i),rp(1,i)] = corr(mb',nbtrz(:,i));%%%%%%%%%%%%%%%%%%%%%%%%%%
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

            if ~isempty(sigg)&& all(rp(2,sigg)>0) || pb<corrp && rb >0 || pop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
%                 disp(sigg*nbin)

                LMH(ctr).(gdbits{iB})=[];                
                
                [rws,cls] = size(trz);
                
                %                 if iB==3 && sum(sum(trz))>0
                %                     disp('good')
                %                 end
                sits = double([sDS.situation]);
                [rws,cls] = size(trz);
                mbst = [mb',sits'];
                [smb,smbix] = sortrows(mbst, [1,2]);
                strz = trz(smbix,:);
                sst = sits(smbix);



                if 0% iB==2 %|| iB ==3
                    figure
                    %                     snbtrz = nbtrz(smbix,:);
                    %                     ssnbtrz = smoothdata(nbtrz,2,'gaussian',11);
                    %                     for i=1:length(strz(:,1))
                    %                         sisnbtrz(i,:)=interp1(snbtrz(i,:),.1:.1:length(snbtrz(1,:)),'linear');
                    %                     end
                    %                     PlotTrueRaster(strz)
                    subplot(3,1,1)
                    
                    imagesc(strz);colormap(jet)
                    set(gca,'YDir','reverse')
                    for i = 1:length(smb)
                        text(cls,i-.5,num2str(smb(i)),'FontSize',5)
                    end
                    axis tight
                    %                     ShadedBox([min(compix) max(compix)])
                    subplot(3,1,2)
                    plot(smoothdata(sum(trial_rast),'gaussian',100/bin),'k')
                    title(num2str(double(h)))
                    ShadedBox([min(compix) max(compix)])
                    box off
                    PIP_Plot([.7 .7 .25 .25])
                    [~,c] = size(wv);
                    c=(1:c)/22;
                    plot(c,wv,'k')
                    box off
                    SkinnyFigs
                    FigureTitle(gdbits{iB});
                    subplot(3,1,3)
                    %                 tix = (1000/nbin)-1+find(rp(3,1000/nbin:1500/nbin)==1);
                    %                     Y =  mean(nbtrz(:,sigg),2);
                    Y =  mean(trz(:,compix),2);
                    scatter(mb',Y)
                    hold on
                    pf = polyfit(mb',Y,1);
                    pv = polyval(pf,mb');
                    x = mb';
                    plot(x,pv)
                    [r,p] = corr(mb',fr);% % % % % % % % % % % % % % % % % % % % % % %
                    title(p)
                    %                     title(sigg*nbin)
                    %                     subplot(4,1,4)
                    %                     mxY = max(Y)+std(Y);
                    %                     mnY = mean(Y);
                    %                     imagesc(sisnbtrz,[mnY mxY]);colormap(turbo);
                    ca
                end
                
                
                out = strz;
                cont = ctrz;
                
                
                LMH(ctr).(gdbits{iB}) = out;
                LMH(ctr).cluster = cln(1:7);
                LMH(ctr).situations = sst;
                LMH(ctr).monkey_bids = smb;

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