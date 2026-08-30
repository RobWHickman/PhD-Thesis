function [LMH]=GettyCompBidDifferencesWithClusters(data_file_path_name,situations,bits,trials,win_lose_both)

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
post=2000;
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
    for iFx = 2:length(fx)
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
            gi = ismember(double([DS(goodix).situation]),sit);
            mnmb = min(double([DS(goodix(gi)).ComputerBid]));
            mxmb = max(double([DS(goodix(gi)).ComputerBid]));
            
             cb = double([DS(goodix(gi)).ComputerBid])';
%             diff(cb)
            if mnmb < mean(cb)-(2*std(cb))
                mnmb = round(mean(cb)-(2*std(cb)));
            end
            
            if mxmb > mean(cb)+(2*std(cb))
                mxmb = round(mean(cb)+(2*std(cb)));
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
%%%%%%%%%%%%%%%%%%%%%%%%% This is to do comp bid - monk bid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
%             mnmb = min(double([DS(goodix(gi)).MonkeyBid])-double([DS(goodix(gi)).ComputerBid]));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             mxmb = max(double([DS(goodix(gi)).MonkeyBid])-double([DS(goodix(gi)).ComputerBid]));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            bid_third = (mxmb-mnmb)/3;
            bid_lmh = {mnmb:mnmb+bid_third, mnmb+bid_third+1:mnmb+(bid_third*2), mnmb+(bid_third*2)+1:mnmb+(bid_third*3)+1};           
            bid_lmh = cellfun(@round,bid_lmh,'UniformOutput',false);
%             bid_fourth = (mxmb-mnmb)/4;
%             bid_lmh = {mnmb:mnmb+bid_fourth-1, mnmb+bid_fourth:mnmb+(bid_fourth*2), mnmb+(bid_fourth*2)+1:mnmb+(bid_fourth*3)+1,...
%                 mnmb+(bid_fourth*3)+1:mnmb+(bid_fourth*4)};           
%             bid_lmh = cellfun(@round,bid_lmh,'UniformOutput',false);
% % 
%             bid_fifth = (mxmb-mnmb)/5;
%             bid_lmh = {mnmb:mnmb+bid_fifth-1, mnmb+bid_fifth:mnmb+(bid_fifth*2), mnmb+(bid_fifth*2)+1:mnmb+(bid_fifth*3)+1,...
%                 mnmb+(bid_fifth*3)+1:mnmb+(bid_fifth*4)+1, mnmb+(bid_fifth*4)+1:mnmb+(bid_fifth*5)};           
%             bid_lmh = cellfun(@round,bid_lmh,'UniformOutput',false);

            
            %             col = Reds_and_Blacks(length(bid_lmh));
            %             figure
            for iBid = 1:length(bid_lmh)
                
                gis = ismember([DS(goodix).situation],sit)...
                    &ismember([DS(goodix-1).Win],[wlb{:}])...
                    &ismember(double([DS(goodix-1).ComputerBid]),[bid_lmh{iBid}]);
                gx = goodix(gis);
                
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
                
                %                 FRrast = trial_rast./bin*1000;
                %                 cont_rast_FR = cont_trial_rast./bin*1000;
                
                FRrast = trial_rast;
                
                
                %                 zFRrast = Z_scores_DH(FRrast,[10:50]);
%                 zFRrast = zscore(FRrast,[],2);

                LMH(ctr).(gdbits{iB})(iBid,:) = nanmean(FRrast,1);
                hold on
                
            end
        end
    end
    ca
    
    
end

if ~exist('LMH')==1
    LMH = [];
end

% disp('bleh')




