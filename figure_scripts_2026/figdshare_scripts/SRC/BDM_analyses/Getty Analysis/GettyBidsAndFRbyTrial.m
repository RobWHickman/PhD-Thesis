function [LMH]=GettyBidsAndFRbyTrial(data_file_path_name,situations,bits,trials,win_lose_both)

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

% uniqsit = unique([DS.Situation]);
% for iS = 1:numel(uniqsit)
%     DS_sit.(sit_nams{uniqsit(iS)}) = DS([DS.Situation]==uniqsit(iS));
% end

bin = 10;
pre = 1000;
post= 2000;
comp = 300;
cont_comp = 800;

err_ix = ~cellfun(@isnan,{DS.ErrorUp});
good_trials = zeros(1,length(DS));
good_trials(trials) = 1;
good_trials(err_ix) = 0;

goodix = find(good_trials...%find the trials that were passed into fxn
    &ismember([DS.situation],situations));%...%find situations passed into fxn
%     &ismember([DS.Win],[wlb{:}]));
gdix = goodix;


% [~,DS_sort_ix] = sort([DS.Situation]);
% DS = DS(DS_sort_ix);
fn = fieldnames(DS);
cix = ~cellfun(@isempty,strfind(fn,'SpikeTimesMs'));
clust_nams = fn(cix);

ctr = 0;
for iC = 1:length(clust_nams)%for each cluster
    goodix = [];
    gtc = [DS.([clust_nams{iC}(1:end-12),'good_trials'])];
    gix = ismember(gdix,find(gtc));
    goodix = gdix(gix);
    %     frix = [DS(goodix).situation]==4;
    frix = [DS(goodix).situation]<4;
    fx = goodix(frix);
    fr_trial_rast = [];
    prefr = 1000;%was 1000
    
    fr_trial_rast = [];
    fr_cont_trial_rast = [];
    for iFx = 1:length(fx)
        %         alignments = [DS(fx(iFx)).FreeRewardUp];
        alignments = [DS(fx(iFx)).FixationCrossUp];
%         alignments = [DS(fx(iFx)).FractalDisplayUp];

        cont_alignments = [DS(fx(iFx)).FixationCrossUp];%was FreeRewardUp
        spks_per_trial = [DS(fx(iFx)).(clust_nams{iC})];
        lfr = size(fr_trial_rast);
        lfx = numel(alignments);
        fr_trial_rast(lfr+1:lfr+lfx,:) = TrialRaster(spks_per_trial,alignments,prefr,post,bin);%generate a single-trial raster
        fr_cont_trial_rast(lfr+1:lfr+lfx,:) = TrialRaster(spks_per_trial,cont_alignments,prefr,post,bin);%generate a single-trial control raster
    end
    if isempty(fr_trial_rast)
        continue
    end
%     freerew_rast_FR = fr_trial_rast./bin*1000;
%     fr_cont_rast_FR = fr_cont_trial_rast./bin*1000;
    frpo = nanmean(fr_trial_rast(:,(prefr+100)/bin:(prefr/bin)+(comp/bin)),2);%added 100 ms because responses are usually delayed. Monk needs time to detect stimulus.
    frcnt = nanmean(fr_cont_trial_rast(:,(prefr/bin)-(cont_comp/bin):prefr/bin),2);
%     
%     freerew_rast_FR = Z_scores_control_data(fr_trial_rast,fr_cont_trial_rast,(prefr/bin)-(cont_comp/bin):prefr/bin);
%     frpo = nanmean(freerew_rast_FR(:,(prefr+100)/bin:(prefr/bin)+(500/bin)),2);%added 100 ms because responses are usually delayed. Monk needs time to detect stimulus.

%     
     
% figure
% subplot(8,1,1:5)
% Imagesc_for_rast(fr_trial_rast)
% subplot(8,1,6:8)
% Peri_Event_Firing_Rate(fr_trial_rast,bin,pre)
% 
%     
    [frp,~,sts] = signrank(frpo,frcnt,'method','approximate');

% FigureTitle([num2str(frp),' | ',num2str(sts.zval)])
%     waitforbuttonpress
    
    if frp < 0.001 && sts.zval > 0  %%%%%%%%%%%%%%%%%%%%%
        %         sit=1:3;

        sit = situations;
        ctr = ctr+1;
        gdbits = bits(cellfun(@isempty,strfind(bits,'FreeRewardUp')));%get all the bits except the free reward bit
        for iB = 1:length(gdbits)%for each relevant bit
            
            if strcmp(gdbits{iB},'RewardTapUp')&&strcmp(win_lose_both,'lose')
                continue
            end
            
            
            gisx = ismember([DS(goodix).situation],sit)...
                &ismember([DS(goodix).Win],[wlb{:}]);
           
            gx = goodix(gisx);
            mb = double([DS(gx).MonkeyBid]);
            cb = double([DS(gx).ComputerBid]);
            mbmcb = mb-cb;
            if strcmp(win_lose_both,'both')
                win = [DS(gx).Win];
            end
            if sum(sit)==6 %only for all sits
                frac_val = [DS(gx).situation];
            end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % This takes only the bids that fall within 2 sd of mean bid % % % %           
% 
%             gis = ismember([DS(goodix).situation],sit)...
%                 &ismember([DS(goodix).Win],[wlb{:}])...
%                 &([DS(goodix).MonkeyBid]>mean(mb)-(std(mb)*2)&[DS(goodix).MonkeyBid]<mean(mb)+(std(mb)*2)); 
%             
%             gx = goodix(gis);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            mnmb = min(double([DS(gx).MonkeyBid]));
            mxmb = max(double([DS(gx).MonkeyBid]));
            
            if isempty(gx)
                FRrast = nan(1,(pre+post)/bin);
                LMH(ctr).(gdbits{iB})(iBid,:) = nanmean(FRrast,1);                
                continue
            end
            
            trial_rast = [];
            cont_trial_rast = [];            
            for iGx = 1:length(gx)%for each trial defined by goodix.
                alignment = [];
                alignment = [DS(gx(iGx)).(gdbits{iB})];
                cont_alignment = [DS(gx(iGx)).FixationCrossUp];
                spks_per_trial = [DS(gx(iGx)).(clust_nams{iC})];
                trial_rast(iGx,:) = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
                cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
            end
            
            if isnan(alignment)
                continue
            end
           
%             trz = zscore(trial_rast,[],2);
%             trzc = zscore(cont_trial_rast,[],2);

            trz = Z_scores_control_data(trial_rast,cont_trial_rast,(pre-800)/bin:(pre)/bin);
%             trz_fs = MinMaxFS(trz);
%             
            FR_bt = nanmean(trz(:,(pre+100)/bin:(pre+comp)/bin),2);
%             FR_cbt = nanmean(trzc(:,(pre-500)/bin:(pre)/bin),2);
%             FR_bt = nanmean(trial_rast(:,(pre+100)/bin:(pre+comp)/bin),2);
%             FR_cbt = nanmean(cont_trial_rast(:,(pre-800)/bin:(pre)/bin),2);
%             FR_bt = (FR_bt-min(FR_bt))/(max(FR_bt)-min(FR_bt));
%             FR_by_trial = zscore(FR_bt-FR_cbt);
%             MB_by_trial = zscore(mb/100);
%             FR_by_trial = MinMaxFS(FR_bt-FR_cbt);
            
            FR_by_trial = FR_bt;
%             FR_by_trial = (FR_by_trial-min(FR_by_trial))/(max(FR_by_trial)-min(FR_by_trial));

            MB_by_trial = mb;
            CB_by_trial = cb;
            MmCB_by_trial = mbmcb;

%             
%             figure
% %             plot(smoothdata(FR_by_trial,'gaussian',5))
%             plot(FR_by_trial)
%             hold on
% %             plot(smoothdata(MB_by_trial,'gaussian',5))
%             plot(MB_by_trial)

%             [r,p]= corr(FR_by_trial,MB_by_trial','Type','Spearman')
%             [r,p]= corr(FR_by_trial,MB_by_trial','Type','Pearson');
%             X = [MB_by_trial',ones(length(MB_by_trial'),1)]
%             [b,bint,r,rint,stats] = regress(FR_by_trial,X) 
% 
%             figure
%             scatter(MB_by_trial',FR_by_trial)
%             [b,dev,stats] = glmfit(MB_by_trial',FR_by_trial);
%             pf = polyfit(MB_by_trial',FR_by_trial,1);
%             pv = polyval(pf,MB_by_trial');
%             hold on
%             plot(MB_by_trial',pv)
%             
%              mpo = mean(FR_by_trial);
%              SStot = sum((FR_by_trial - mpo).^2);
%              SSreg = sum((pv - mpo).^2);
%              SSres = sum((FR_by_trial - pv).^2);
%              R2 = 1 - SSres/SStot;
%             title(sprintf('y = %.1g + %.1gx | p = %.1g \n R^2 = %.1g ',pf(2),pf(1),stats.p(2),r));
           
            LMH(ctr).(gdbits{iB}).FR = trial_rast;
            LMH(ctr).(gdbits{iB}).cont_FR = cont_trial_rast;
            LMH(ctr).(gdbits{iB}).mFR = FR_by_trial; 
            LMH(ctr).(gdbits{iB}).Win = win;
            LMH(ctr).(gdbits{iB}).Frac_val = frac_val;
            LMH(ctr).(gdbits{iB}).MBid = MB_by_trial';
            LMH(ctr).(gdbits{iB}).CBid = CB_by_trial';
            LMH(ctr).(gdbits{iB}).MmCBid = MmCB_by_trial';

        end
    end
    ca
    
    
end

if ~exist('LMH')==1
    LMH = [];
end

% disp('bleh')




