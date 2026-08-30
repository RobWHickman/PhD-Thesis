function [LMH]=GettyCorrelateBidsFRClusters(data_file_path_name,situations,bits,trials,win_lose_both)

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
wlb_nam_cell = {'win','lose','both'};
wlb_num_cell = {[1],[0],[1,0]};
wlb_ix = strcmp([wlb_nam_cell],win_lose_both);
wlb = wlb_num_cell(wlb_ix);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bin = 10;%10
pre = 1000;
post = 2000;
comp = 300;%400
cont_comp = 500; %(Uly 400)
offset = 80;%80 (Uly 0)
corrcomp1 = 250;
corrcomp2 = 450; 

alpha = .001;
minNumTrials = 1;%3 (Uly 1)
normMethod = 'Zscore';%Zscore BGsubtract none
ExclSensoredBids = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% ULY %%%%%%%%%% ULY %%%%%%%%%%%% ULY %%%%%%%%%%%% ULY %%%%%%%%%%%%
% % % bin = 10;
% % % pre = 1000;
% % % post = 2000;
% % % comp = 300;
% % % cont_comp = 500;
% % % offset = 80;
% % % corrcomp1 = 200; %100 w zscr
% % % corrcomp2 = 400; %500 w zscr %600 better for second fractal but not sure about it
% % %
% % % alpha = 0.001;
% % % minNumTrials = 1;
% % % normMethod = 'Zscore';%Zscore BGsubtract none %%%%!!!none and BGsubtract work!!!%%%%
% % % ExclSensoredBids = 1;
%%%%%%%%%% ULY %%%%%%%%%% ULY %%%%%%%%%%%% ULY %%%%%%%%%%%% ULY %%%%%%%%%%%%

%%%%%%%%%% VIC %%%%%%%%%% VIC %%%%%%%%%%%% VIC %%%%%%%%%%%% VIC %%%%%%%%%%%%
% % % bin = 10;
% % % pre = 1000;
% % % post = 2000;
% % % comp = 400;
% % % cont_comp = 500;
% % % offset = 80;
% % % corrcomp1 = 300;
% % % corrcomp2 = 400;
% % %
% % % alpha = 0.001;
% % % minNumTrials = 1;
% % % normMethod = 'none';%Zscore BGsubtract none %%%%!!!all 3 work!!!%%%%
% % % ExclSensoredBids = 1;
%%%%%%%%%% VIC %%%%%%%%%% VIC %%%%%%%%%%%% VIC %%%%%%%%%%%% VIC %%%%%%%%%%%%



good_trials = [DS.ErrorUp]==0;

goodix = good_trials...%find the trials that were passed into fxn
    & ismember([DS.situation],[1:3]);%...%find situations passed into fxn

%     &ismember([DS.Win],[wlb{:}]));

ExSB = [DS.MonkeyBid]<100 & [DS.MonkeyBid]>0;
if ExclSensoredBids
    gdix = goodix & ExSB;
else
    gdix = goodix;
end

fn = fieldnames(DS);
cix = ~cellfun(@isempty,strfind(fn,'SpikeTimesMs'));
clust_nams = fn(cix);
cwix = ~cellfun(@isempty,strfind(fn,'AverageWaveform'));
clust_wav_nams = fn(cwix);


mb = double([DS.MonkeyBid])';
% figure
% hist(mb(goodix&mb'<100))
% ca
ctr = 0;
% if sum(~ismember([DS.RewardVolume],[0 20 45 70]))>0
%     disp('crap')
%     LMH = [];
%     return
% end

for iC = 1:length(clust_nams)%for each cluster
    wv = DS(1).(clust_wav_nams{iC});
    badBL=0;
    
    goodix = [];
    %     gtc = [DS.([clust_nams{iC}(1:end-12),'good_trials'])];
    cln = [clust_nams{iC}(1:end-12),'good_trials'];
    if isfield(DS,cln)
        gtc = [DS.(cln)];
    else
        for ic = 1:length(DS)
            gtc(ic) = 1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Eliminate trials where cell didn't fire %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clix = ones(1,length(DS));
    for iD = 1:length(DS)
        if isempty(DS(iD).(clust_nams{iC}))
            clix(iD) = 0;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    goodix = gdix&gtc&clix;
    fx = goodix & [DS.situation]<4;
    hfx=fx;
%     hfx = goodix & [DS.situation]==3;

    
    if sum(fx)<10
       continue
    end
    
    fr_trial_rast = [];
    prefr = 1000;%was 1000
    
    fr_trial_rast = [];
    fr_cont_trial_rast = [];
    ffx = find(hfx);
    gdbits = bits(cellfun(@isempty,strfind(bits,'FreeRewardUp')));%get all the bits except the free reward bit
    h = 0;
    
    for ig = 1:length(gdbits)
        fr_trial_rast = [];
        fr_cont_trial_rast = [];
        
        for iFx = 1:sum(hfx)
            
%             if ismember(gdbits{ig},{'RewardEpochEndUp','BudgetTapUp'})
%                 continue
%             end
            alignments=[];cont_alignments=[];
            alignments = [DS(ffx(iFx)).(gdbits{ig})];
            
            if length(alignments)>1
                alignments = alignments(2);
            end
            
            cont_alignments = [DS(ffx(iFx)).FixationCrossUp];
            spks_per_trial = [DS(ffx(iFx)).(clust_nams{iC})];
            %             lfr = size(fr_trial_rast);
            %             lfx = numel(alignments);
            %             fr_trial_rast(lfr+1:lfr+lfx,:) = TrialRaster(spks_per_trial,alignments,prefr,post,bin);%generate a single-trial raster
            %             fr_cont_trial_rast(lfr+1:lfr+lfx,:) = TrialRaster(spks_per_trial,cont_alignments,prefr,post,bin);%generate a single-trial control raster
            tmp = TrialRaster(spks_per_trial,alignments,prefr,post,bin);%generate a single-trial raster
            tmp_cnt = TrialRaster(spks_per_trial,cont_alignments,prefr,post,bin);%generate a single-trial control raster
            
            fr_trial_rast = [fr_trial_rast;tmp];
            fr_cont_trial_rast = [fr_cont_trial_rast;tmp];
            
        end
        if isempty(fr_trial_rast)
            continue
        end
        %                 freerew_rast_FR = fr_trial_rast./bin*1000;
        %                 fr_cont_rast_FR = fr_cont_trial_rast./bin*1000;
        freerew_rast_FR = fr_trial_rast;
        fr_cont_rast_FR = fr_cont_trial_rast;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        baselineInstFR = nanmean(nanmean((fr_cont_rast_FR(:,(pre-800)/bin:pre/bin)./bin)*1000));
        baselineFR = nanmean(sum(fr_cont_rast_FR(:,(pre-800)/bin:pre/bin))./800*1000);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if baselineFR > 10 && baselineInstFR > 10
%             figure
%             PlotTrueRaster(fr_cont_rast_FR)
%             title(baselineInstFR)
            badBL=1;
            ca
        end
        freerew_rast_FR = fr_trial_rast-nanmean(fr_cont_trial_rast((pre-cont_comp)/bin:pre/bin));
        fr_cont_rast_FR = fr_cont_trial_rast-nanmean(fr_cont_trial_rast((pre-cont_comp)/bin:pre/bin));
%         freerew_rast_FR = zscore(fr_trial_rast);
%         fr_cont_rast_FR = zscore(fr_cont_trial_rast);



        frpo = nanmean(freerew_rast_FR(:,(prefr+offset)/bin:(prefr/bin)+(comp/bin)),2);%added 100 ms because responses are usually delayed. Monk needs time to detect stimulus.
        frcnt = nanmean(fr_cont_rast_FR(:,(prefr/bin)-(cont_comp/bin):prefr/bin),2);
        
%         [~,h(ig)] = signrank(frpo,frcnt,'alpha',alpha); % outputs: [p,h,stats]= signrank();
        [h(ig)] = ttest(frpo,frcnt,'alpha',alpha); % outputs: [h,p]= ttest();                

        rws = length(frpo);
        
%         if h(ig)==1
%             figure
%             subplot(5,1,1:4)          
%             Imagesc_for_rast(freerew_rast_FR)
%             PIP_Plot
%             Plot_Bars_SEM([frpo,frcnt])
%             subplot(5,1,5)
%             plot(nanmean(freerew_rast_FR))
%             FigureTitle(gdbits{ig})
%             ca
%         end
        if nanmean(frpo)<nanmean(frcnt) || badBL
            h(ig)=0;
        end
    end
        
    if sum(h)>0 && ~badBL%& reg %%%%%%%%%%%%%%%%%%%%%
        ctr = ctr+1;
        gdbits = bits(cellfun(@isempty,strfind(bits,'FreeRewardUp')));%get all the bits except the free reward bit
        for iB = 1:length(gdbits)%for each relevant bit
            
            si = ismember(double([DS.situation]),situations);
            if sum(si)<1
                continue
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Eliminate trials where cell didn't fire %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            clix = ones(1,length(DS));
            for iD = 1:length(DS)
                if isempty(DS(iD).(clust_nams{iC}))
                    clix(iD) = 0;
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            gi = fx&si&clix;
            
            mb=[];cb=[];
            mb = double([DS.MonkeyBid])';
            cb = double([DS.ComputerBid])';
            
            mbNorm(fx) = MinMaxFS(mb(fx));
            
            gx = gi & ismember([DS.Win],[wlb{:}]);
            
            
            if sum(gx)<minNumTrials
                FRrast = nan(1,(pre+post)/bin);
                LMH(ctr).(gdbits{iB}) = nanmean(FRrast,1);
                continue
            end
            trial_rast = [];
            cont_trial_rast = [];
            
            fgx = find(gx);
            for iGx = 1:length(fgx)%for each trial defined by goodix.
                alignment = [];cont_alignment=[];
                alignment = [DS(fgx(iGx)).(gdbits{iB})];
                if length(alignment)>1
                    alignment = alignment(2);
                end
                cont_alignment = [DS(fgx(iGx)).FixationCrossUp];
                spks_per_trial = [DS(fgx(iGx)).(clust_nams{iC})];
                mbb(iGx) = [DS(fgx(iGx)).MonkeyBid];
                trial_rast(iGx,:) = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
                cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
            end
            
            [rws,cls] = size(trial_rast);
            if 0 %iB==2
                trz=trial_rast;
                compix=(pre+corrcomp1)/bin:(pre+corrcomp2)/bin;
                mbgx = mb(gx)';
                
                figure
                subplot(3,1,3)
                Y = nanmean(trz(:,compix),2);
                scatter(mbgx,Y)
                hold on
                p = polyfit(mbgx,Y,1);
                pv = polyval(p,mbgx);
                x = mbgx;
                plot(x,pv)
                [r,p] = corr(mbgx',Y);
                title(['r = ',num2str(r),' | p = ',num2str(p)]);
                %             disp([statss(3), statss(1)])
                subplot(3,1,1)
                [~,mbsx] = sort(mbgx);
                mbs=mbgx(mbsx);
                trzs = trz(mbsx,:);
                PlotTrueRaster(trzs)
                set(gca,'YDir','reverse')
                for i = 1:length(mbs)
                    text(cls,i-.5,num2str(mbs(i)),'FontSize',8)
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
                % c=[(1:c)/22;(1:c)/22;(1:c)/22];
                plot(c,wv,'k')
                box off
                %             g=gca;
                %             chnk = range(g.YLim)/51;
                %             line([min(compix) max(compix)],[g.YLim(1)+chnk g.YLim(1)+chnk],'LineWidth',5,'alpha',.5)
                SkinnyFigs
                FigureTitle(gdbits{iB});
                if badBL
                    disp('badBL')
                end
                
                ca
            end
            
            compix=(pre+corrcomp1)/bin:(pre+corrcomp2)/bin;
            
            if strcmp(normMethod,'Zscore')
                FRrast = trial_rast;
                cont_rast_FR = cont_trial_rast;
%                 zFRrast = Z_scores_control_data(FRrast,cont_trial_rast,((pre-cont_comp)/bin):(pre/bin));
                zFRrastCont = Z_scores_control_data(cont_rast_FR,cont_rast_FR,((pre-cont_comp)/bin):(pre/bin));
                zFRrast = zscore(FRrast,0,2);
                out = nanmean(zFRrast(:,compix),2);
                cont = nanmean(zFRrastCont(:,(pre-cont_comp)/bin:(pre)/bin),2);
            elseif strcmp(normMethod,'BGsubtract')
                FRrast = trial_rast;
                cont_rast_FR = cont_trial_rast;
                bgFRrast = (FRrast-(nanmean(cont_trial_rast(:,((pre-cont_comp)/bin):(pre/bin)),2)));%./nanmean(cont_trial_rast(:,[((pre-cont_comp)/bin)+1:(pre/bin)-1]),2);
                out = (sum(bgFRrast(:,compix),2)./range(compix*bin)).*1000;
                cont = (sum(cont_rast_FR(:,(pre-cont_comp)/bin:(pre/bin)),2)./(cont_comp)).*1000;
            elseif strcmp(normMethod,'none')
                FRrast = trial_rast;
                cont_rast_FR = cont_trial_rast;
                out = (sum(FRrast(:,compix),2)./range(compix*bin)).*1000;
                cont = (sum(cont_rast_FR(:,((pre-cont_comp)/bin):(pre/bin)),2)./(cont_comp)).*1000;
            end
            
            sit = [DS.situation];
            
            LMH(ctr).(gdbits{iB})(:,1) = out;
            LMH(ctr).(gdbits{iB})(:,2) = cont;
            LMH(ctr).(gdbits{iB})(:,3) = mb(fgx);
            LMH(ctr).(gdbits{iB})(:,4) = mbNorm(fgx);
            LMH(ctr).(gdbits{iB})(:,5) = sit(fgx);
            
        end
    end
    ca
    
end

if ~exist('LMH')==1
    LMH = [];
end

% disp('bleh')




