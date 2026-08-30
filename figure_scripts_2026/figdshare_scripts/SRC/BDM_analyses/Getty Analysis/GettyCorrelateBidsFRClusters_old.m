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
bin = 20;%20
pre = 1000;
post = 2000;
comp = 300;
cont_comp = 500;
offset = 60;%60
alpha = 0.001;%0.001
nq = 5;
quantMethod = 'linsp'; %quant linsp stdev
minNumTrials = 5;%5
normMethod = 'Zscore';%Zscore BGsubtract none
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

good_trials = [DS.ErrorUp]==0;

goodix = good_trials...%find the trials that were passed into fxn
    & ismember([DS.situation],[1:3]);%...%find situations passed into fxn
%     & [DS.MonkeyBid]<100 & [DS.MonkeyBid]>0 ...
%     &ismember([DS.Win],[wlb{:}]));
gdix = goodix;

fn = fieldnames(DS);
cix = ~cellfun(@isempty,strfind(fn,'SpikeTimesMs'));
clust_nams = fn(cix);
mb = double([DS.MonkeyBid])';
% figure
% hist(mb(goodix&mb'<100))
% ca
ctr = 0;
for iC = 1:length(clust_nams)%for each cluster
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
    goodix = gdix&gtc;
    fx = goodix & [DS.situation]<4;
    
    fr_trial_rast = [];
    prefr = 1000;%was 1000
    
    fr_trial_rast = [];
    fr_cont_trial_rast = [];
    ffx = find(fx);
    gdbits = bits(cellfun(@isempty,strfind(bits,'FreeRewardUp')));%get all the bits except the free reward bit
    h = 0;
    ctr = ctr+1;
    for ig = 1:length(gdbits)
        fr_trial_rast = [];
        fr_cont_trial_rast = [];
        
        for iFx = 1:sum(fx)
            
            %             if ismember(gdbits{ig},{'RewardEpochEndUp','BudgetTapUp'})
            %                 continue
            %             end
            
            alignments = [DS(ffx(iFx)).(gdbits{ig})];
            %             alignments = [DS(ffx(iFx)).FixationCrossUp];
            %
            if length(alignments)>1
                alignments = alignments(2);
            end
            
            cont_alignments = [DS(ffx(iFx)).FixationCrossUp];%was FreeRewardUp
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
        %         freerew_rast_FR = fr_trial_rast./bin*1000;
        %         fr_cont_rast_FR = fr_cont_trial_rast./bin*1000;
        freerew_rast_FR = fr_trial_rast;
        fr_cont_rast_FR = fr_cont_trial_rast;
        
        frpo = nanmean(freerew_rast_FR(:,(prefr+offset)/bin:(prefr/bin)+(comp/bin)),2);%added 100 ms because responses are usually delayed. Monk needs time to detect stimulus.
        frcnt = nanmean(fr_cont_rast_FR(:,(prefr/bin)-(cont_comp/bin):prefr/bin),2);
        
        if sum(frpo)>0
            X = [ones(length(frpo),1),frpo];
            y = mb(ffx);
            [b(ig),bint(ig),~,~,stats(ig)] = regress(y,X); % r2 f p-val var
            [~,h(ig)] = signrank(frpo,frcnt,'alpha',alpha); % outputs: [p,h,stats]= signrank();
        end
    end
    if sum(h)>0
            %     figure;
            %     subplot(5,1,1:3)
            %     Imagesc_for_rast(freerew_rast_FR)
            %     title(frp)
            %     subplot(5,1,4:5)
            %     plot(nanmean(freerew_rast_FR))
            %     waitforbuttonpress
            %     ca
            if stats(3)<0.01
                LMH(ctr).(gdbits{ig}).b = b;
                LMH(ctr).(gdbits{ig}).bint = bint;
                LMH(ctr).(gdbits{ig}).stats = stats;
            else 
                LMH(ctr).(gdbits{ig}).b = nan;
                LMH(ctr).(gdbits{ig}).bint = nan;
                LMH(ctr).(gdbits{ig}).stats = nan;
            end
        end
    end
end
ca

if ~exist('LMH')==1
    LMH = [];
end

% disp('bleh')




