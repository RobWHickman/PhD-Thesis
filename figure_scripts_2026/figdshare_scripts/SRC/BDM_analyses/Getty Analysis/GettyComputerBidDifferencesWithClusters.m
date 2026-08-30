function [LMH]=GettyComputerBidDifferencesWithClusters(data_file_path_name,situations,bits,trials,win_lose_both)

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

bin = 20;
pre=1000;
post=2000;
comp = 300;
cont_comp = comp;

err_ix = ~cellfun(@isnan,{DS.ErrorUp});
good_trials = zeros(1,length(DS));
good_trials(trials) = 1;
good_trials(err_ix) = 0;

goodix = find(good_trials...%find the trials that were passed into fxn
    &ismember([DS.situation],situations));%...%find situations passed into fxn
%     &ismember([DS.Win],[wlb{:}]));


% [~,DS_sort_ix] = sort([DS.Situation]);
% DS = DS(DS_sort_ix);
fn = fieldnames(DS);
cix = ~cellfun(@isempty,strfind(fn,'Clust'));
clust_nams = fn(cix);
 
ctr = 0;
for iC = 1:length(clust_nams)%for each cluster
    frix = [DS(goodix).situation]==4;
    fx = goodix(frix);
    fr_trial_rast = [];
    for iFx = 1:length(fx)
        alignments = [DS(fx(iFx)).FreeRewardUp];
        cont_alignments = [DS(fx(iFx)).FreeRewardUp];
        spks_per_trial = [DS(fx(iFx)).(clust_nams{iC})];
        lfr = size(fr_trial_rast);
        lfx = numel(alignments);
        fr_trial_rast(lfr+1:lfr+lfx,:) = TrialRaster(spks_per_trial,alignments,pre,post,bin);%generate a single-trial raster
        fr_cont_trial_rast(lfr+1:lfr+lfx,:) = TrialRaster(spks_per_trial,cont_alignments,pre,post,bin);%generate a single-trial control raster
    end
    if isempty(fr_trial_rast)
        continue
    end
    freerew_rast_FR = fr_trial_rast./bin*1000;
    fr_cont_rast_FR = fr_cont_trial_rast./bin*1000;
    frpo = nanmean(freerew_rast_FR(:,pre/bin:(pre/bin)+(500/bin)),2);
    frcnt = nanmean(fr_cont_rast_FR(:,(pre/bin)-(800/bin):pre/bin),2);
    
    frp = signrank(frpo,frcnt);
    
    if frp < 0.001    
        sit=1:3;
        ctr = ctr+1;
        gdbits = bits(cellfun(@isempty,strfind(bits,'FreeRewardUp')));%get all the bits except the free reward bit
        for iB = 1:length(gdbits)%for each relevant bit     
            
            if strcmp(gdbits{iB},'RewardTapUp')&&strcmp(win_lose_both,'lose')
                continue
            end
            gi = ismember([DS(goodix).situation],sit);
            mncb = min(double([DS(goodix(gi)).ComputerBid]));
            mxcb = max(double([DS(goodix(gi)).ComputerBid]));

            bid_third = (mxcb-mncb)/3;
            bid_lmh = {mncb:mncb+bid_third-1, mncb+bid_third:mncb+(bid_third*2), mncb+(bid_third*2)+1:mncb+(bid_third*3)+1};         
            bid_lmh = cellfun(@round,bid_lmh,'UniformOutput',false);

            for iBid = 1:length(bid_lmh)
                gis = ismember([DS(goodix).situation],sit)...
                    &ismember([DS(goodix).Win],[wlb{:}])...
                    &ismember(double([DS(goodix).ComputerBid]),[bid_lmh{iBid}]);
                gx = goodix(gis);
               
                if isempty(gx)
                    FRrast = nan(1,150);
                    LMH(ctr).(gdbits{iB})(iBid,:) = nanmean(FRrast,1);
                    continue
                end
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
                
                FRrast = trial_rast./bin*1000;                
                cont_rast_FR = cont_trial_rast./bin*1000;

                zFRrast = Z_scores_DH(trial_rast,(pre-200)/bin:(pre/bin));
                z_cont_rast = Z_scores_DH(cont_trial_rast);
                
                ctrl = nanmean(z_cont_rast(:,(pre-comp)/bin:pre/bin),2);
                po = nanmean(zFRrast(:,pre/bin:(pre+comp)/bin),2);
                
                for i = 0
                if 0
                low_ix = [DS(gx).situation]==1;
                mid_ix = [DS(gx).situation]==2;
                high_ix = [DS(gx).situation]==3;
                
                lix = low_ix;
                mix = mid_ix;
                hix = high_ix;
                
                sit_cell = {lix mix hix};
                
                col = Reds_and_Blacks(3);
%                 fig  = figure;%('visible','off');
                for iSC = 1:length(sit_cell)
                    
                    sitFRrast = zFRrast(sit_cell{iSC},:);
                    sit_cont_rast = z_cont_rast(sit_cell{iSC},:);
                    %                 sitFRrast = FRrast(sit_cell{iSC},:);
                    %                 sit_cont_rast = cont_rast_FR(sit_cell{iSC},:);
                    
                    FR_rast_lmh(iSC,:) = nanmean(sitFRrast,1);
                    %                 sFRrast = smoothdata(sitFRrast,2,'gaussian',7);
                    sFRrast = sitFRrast;
                    xax = (1:length(FR_rast_lmh(iSC,:)))*bin;
                    if ~(sum(isnan(FR_rast_lmh(iSC,:)))==length(FR_rast_lmh(iSC,:)))
                        plot_error_lines(sFRrast,'SEM',xax,col(iSC,:));
                    end
                    ctrl = nanmean(sit_cont_rast(:,(pre-cont_comp)/bin:pre/bin),2);
                    po = nanmean(sitFRrast(:,pre/bin:(pre+comp)/bin),2);
                    FRdif{:,iSC} = po-ctrl;
                    hold on
                end
                end
                end
%                 xax = (1:length(FRrast(1,:)))*bin;
%                 plot_error_lines(FRrast,'SEM',xax,col(iBid,:));

%                 hold on
%                 g=gca;
%                 line([xax(pre/bin) xax(pre/bin)],g.YLim)
%                 legend_for_error_lines({'low' 'med' 'high'},col)
%                 FR_dif_m = nan_fill_cell2mat(FRdif);
%                 LMHdif = FR_dif_m;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %             [p,tbl,stats] = anova1(FR_dif_m,{'low' 'mid' 'high'},'off');
                %             c = multcompare(stats,'CType','hsd','Display','off');
                %             titnam = sprintf('%s | %s \n Anova p = %.1g | MultComp L:M p = %.1g; L:H p = %.1g; M:H p = %.1g',gdbits{iB},clust_nams{iC},p,c(1,6),c(2,6),c(3,6));
                %             FigureTitle(titnam)
                %             sp = strfind(titnam,'SpikeTimesMs');
                %             savnam = strfix(titnam(1:sp-1));
                %             disp(gdbits{iB});
                %             MedFigs
                %             nd = We_want_dir_funk([pth,'situation_figs/']);
                %             saveas(fig,[nd,savnam],'png');
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                nmz = nanmean(zFRrast);
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

disp('bleh')




