function [LMH]=GettyDoesFRCorrelateWithPastCost(data_file_path_name,situations,bits,trials,win_lose_both)

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
cont_comp = 300;

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
    freerew_rast_FR = fr_trial_rast./bin*1000;
    fr_cont_rast_FR = fr_cont_trial_rast./bin*1000;
    frpo = nanmean(freerew_rast_FR(:,(prefr+100)/bin:(prefr/bin)+(comp/bin)),2);%added 100 ms because responses are usually delayed. Monk needs time to detect stimulus.
    frcnt = nanmean(fr_cont_rast_FR(:,(prefr/bin)-(cont_comp/bin):prefr/bin),2);
    
    frp = signrank(frpo,frcnt);
    
    if frp < 0.05   %%%%%%%%%%%%%%%%%%%%%
        %         sit=1:3;
        sit = situations;
        ctr = ctr+1;
        gdbits = bits(cellfun(@isempty,strfind(bits,'FreeRewardUp')));%get all the bits except the free reward bit
        for iB = 1:length(gdbits)%for each relevant bit
            
            if strcmp(gdbits{iB},'RewardTapUp')&&strcmp(win_lose_both,'lose')
                continue
            end
            
            
            gis = ismember([DS(goodix).situation],sit)...
                &ismember([DS(goodix).Win],[wlb{:}]);
           
            gx = goodix(gis);
            
            mb = double([DS(gx).MonkeyBid]);
            cb = double([DS(gx).ComputerBid]);

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
           
            %% FR
            FR_bt = nanmean(trial_rast(:,(pre+100)/bin:(pre+comp)/bin),2);
            FR_cbt = nanmean(cont_trial_rast(:,(pre-500)/bin:(pre)/bin),2);

            FR_by_trial = FR_bt-FR_cbt;
            FR_by_trial = zscore(FR_by_trial);
            
            FR_by_trial = FR_by_trial(4:end);
            
            %% prev cost           
            for i = 1:length(cb)
                if i==1||i==2||i==3
                    continue
                end
                pc(i-3) = ((cb(i-3)*.3)+(cb(i-2)*.6)+(cb(i-1)*.9))/(.3+.6+.9);
%                 pc(i-3) = cb(i-1);

            end            
            previous_cost = zscore(pc/100);
%             previous_cost = (pc-min(pc))/(max(pc)-min(pc))
            
            %%
            figure
            plot(FR_by_trial)
            hold on
            plot(previous_cost)

            [r,p]= corr(FR_by_trial,previous_cost','Type','Spearman')
            [r,p]= corr(FR_by_trial,previous_cost','Type','Pearson');
%             X = [ones(length(previous_cost'),1),previous_cost'];
            X = [ones(length(previous_cost'),1),mb(4:end)',previous_cost'];
            [b,bint,r,rint,stats] = regress(FR_by_trial,X) 

            figure
            scatter(previous_cost',FR_by_trial)
            [b,dev,stats] = glmfit(previous_cost',FR_by_trial);
            pf = polyfit(previous_cost',FR_by_trial,1);
            pv = polyval(pf,previous_cost');
            hold on
            plot(previous_cost',pv)
            
             mpo = mean(FR_by_trial);
             SStot = sum((FR_by_trial - mpo).^2);
             SSreg = sum((pv - mpo).^2);
             SSres = sum((FR_by_trial - pv).^2);
             R2 = 1 - SSres/SStot;
            title(sprintf('y = %.1g + %.1gx | p = %.1g \n R^2 = %.1g ',pf(2),pf(1),stats.p(2),r));
          
            
            LMH(ctr).(gdbits{iB})(iBid,:) = nanmean(FRrast,1);
            hold on
            
            
        end
    end
    ca
    
    
end

if ~exist('LMH')==1
    LMH = [];
end

% disp('bleh')




