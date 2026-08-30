function [LMH]=GettyBidSDF(data_file_path_name,situations,bits,trials,win_lose_both)
LMH = [];
% situation: can be any integer from 1 to number of situations
% bits: can be any number from 1 to number of bits
% trials: vector listing trials to be analyzed

if nargin < 1
        [fl,pth] = uigetfile('C:\Users\dfhil\Dropbox\Schultz_Lab\Uly_Data\*.mat');
%     [fl,pth] = uigetfile('D:\Dropbox\Schultz_Lab\Uly_Data\*.mat');
    data_file_path_name = [pth,fl];
end
[DS,pth] = FormatGettyDataStructureWithClusters(data_file_path_name);

situation_names = {'BDM Low ' 'BDM Mid ' 'BDM HIgh ' 'Free Reward'};

if nargin < 2
    val = inputdlg('What situations would you like to analyze?','Situation',1,{'1:3'});
    situations = str2num(val{1});
end

if nargin < 3
    %     allBits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
    %         'WinLoseUp' 'FreeRewardUp' 'RewardTapUp' 'BudgetTapUp'};
    allBits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
        'WinLoseUp' 'FreeRewardUp' 'RewardTapUp' 'BudgetTapUp' 'ErrorUp'};
    bit_ix = listdlg('ListString',allBits);
    bits = allBits(bit_ix);
end

if nargin < 4
    trials = 'all';
end
if ~isnumeric(trials) && strcmp(trials,'all')
    trials = 1:length([DS]);
end
%
if nargin < 5
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

bin = 1;
pre=200;
post=500;
comp = 300;
cont_comp = 300;

err_ix = ~cellfun(@isnan,{DS.ErrorUp});
good_trials = zeros(1,length(DS));
good_trials(trials) = 1;
good_trials(err_ix) = 0;

goodix = find(good_trials...%find the trials that were passed into fxn
    &ismember([DS.situation],situations)...%find situations passed into fxn
    &ismember([DS.Win],[wlb{:}]));
%     &~err_ix... %get rid of the indexes of the error trials


% [~,DS_sort_ix] = sort([DS.Situation]);
% DS = DS(DS_sort_ix);
fn = fieldnames(DS);
cix = ~cellfun(@isempty,strfind(fn,'Clust'));
clust_nams = fn(cix);

sit = 1:3;
gdbits = bits(~(strcmp(bits,'FreeRewardUp')));
for iB = 1:length(gdbits)%for each relevant bit
    for iC = 1:2:length(clust_nams)%for each cluster (indexed by every other because waveform is in 2,4,6...)
        for iGx = 10:length(goodix)%for each trial defined by goodix
            alignment = double([DS(goodix(iGx)).(gdbits{iB})]);
            cont_alignment = double([DS(goodix(iGx)).FixationCrossUp]);
            spks_per_trial = double([DS(goodix(iGx)).(clust_nams{iC})]);
            tr = TrialRaster(spks_per_trial,alignment,pre,post,bin);
            c_tr = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);
            trial_rast(iGx,:) = SpikeDensityFunction(tr);
            cont_trial_rast(iGx,:) = SpikeDensityFunction(c_tr);
            
        end
        
        gi = ismember(double([DS(goodix).situation]),sit);
        mnmb = min(double([DS(goodix(gi)).MonkeyBid]));
        mxmb = max(double([DS(goodix(gi)).MonkeyBid]));
        bid_third = (mxmb-mnmb)/3;
        bid_lmh = {mnmb:mnmb+bid_third-1, mnmb+bid_third:mnmb+(bid_third*2), mnmb+(bid_third*2)+1:mnmb+(bid_third*3)+1};
        bid_lmh = cellfun(@round,bid_lmh,'UniformOutput',false);

        
        lB = ismember(double([DS(goodix).MonkeyBid]),[bid_lmh{1}]);
        mB = ismember(double([DS(goodix).MonkeyBid]),[bid_lmh{2}]);
        hB = ismember(double([DS(goodix).MonkeyBid]),[bid_lmh{3}]);
        lmh = {lB mB hB};
        
        fig = figure('visible','off');
%         fig = figure;
        col = CambridgeDark(3);
        scaleFactor = 2;
        sc = [min(min(trial_rast))*scaleFactor (round(nanmean(max(trial_rast)))/scaleFactor)+(.2*round(nanmean(max(trial_rast))))];
        subplot(12,1,1:3)
        Imagesc_for_rast(trial_rast(lB,:),sc,col(1,:));
        subplot(12,1,4:6)
        Imagesc_for_rast(trial_rast(mB,:),sc,col(2,:));
        subplot(12,1,7:9)
        Imagesc_for_rast(trial_rast(hB,:),sc,col(3,:));
        subplot(12,1,10:12)
        strial_rast = smoothdata(trial_rast,2,'gaussian',5);
        if ~sum(sum(trial_rast))==0
            for iBid = 1:3
                [fr,~] = Peri_Event_Firing_Rate(strial_rast([lmh{iBid}],:),bin,pre,col(iBid,:));
                if ~isempty(fr)&& length(fr)==(pre+post+1)/bin
                    FR(iBid,:) = fr;
%                     SEM(iBid,:) = sem;
                    hold on
                end
                mxfr = max(max(FR+(.3*max(max(FR)))));
                mnfr = min(min(FR));
                h = mxfr+(.05*mxfr);
                l = mnfr-(.05*mxfr);
                g=gca;
                if h==0
                    h=.1;
                end
                g.YLim = [l h];
            end
        end
        FigureTitle([situation_names{situations},' | ',gdbits{iB},' | ',clust_nams{iC}]);
        LongFigs
        savnam = strfix(['MonkBidSDF_',situation_names{situations},' | ',gdbits{iB},' | ',clust_nams{iC}]);
%         rmdir([pth,'MonkBidRasters']);
        savpth = We_want_dir_funk([pth,'MonkBidRasters\']);
        saveas(fig,[savpth,savnam],'meta');
        saveas(fig,[savpth,savnam],'png');
        saveas(fig,[savpth,savnam],'svg');
        
        
    end
    ca
end
