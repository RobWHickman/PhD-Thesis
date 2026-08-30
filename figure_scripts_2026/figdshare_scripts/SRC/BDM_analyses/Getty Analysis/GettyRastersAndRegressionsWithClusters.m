function [LMH]=GettyRastersAndRegressionsWithClusters(data_file_path_name,situations,bits,trials,win_lose_both)
LMH = [];
% situation: can be any integer from 1 to number of situations
% bits: can be any number from 1 to number of bits
% trials: vector listing trials to be analyzed

if nargin < 1
    %     [fl,pth] = uigetfile('C:\Users\dfhil\Dropbox\Schultz_Lab\Uly_Data\*.mat');
    [fl,pth] = uigetfile('D:\Dropbox\Schultz_Lab\Uly_Data\*.mat');
    data_file_path_name = [pth,fl];
end
tic 
[DS,pth] = FormatGettyDataStructureWithClusters(data_file_path_name);
toc
situation_names = {'BDM Low ' 'BDM Mid ' 'BDM High ' 'Free Reward'};

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

bin = 10;
pre=1000;
post=2000;
cmpstrt = 100;
cmpstp = 350;
cont_comp = 800;

err_ix = ~cellfun(@isnan,{DS.ErrorUp});
good_trials = zeros(1,length(DS));
good_trials(trials) = 1;
good_trials(err_ix) = 0;

goodix = find(good_trials...%find the trials that were passed into fxn
    &ismember([DS.situation],situations)...%find situations passed into fxn
    &~err_ix... %get rid of the indexes of the error trials
    &ismember([DS.Win],[wlb{:}]));

gdix = goodix;

% [~,DS_sort_ix] = sort([DS.Situation]);
% DS = DS(DS_sort_ix);
fn = fieldnames(DS);
cix = ~cellfun(@isempty,strfind(fn,'SpikeTimesMs'));
clust_nams = fn(cix);

reg = 1;
if reg
    for iB = 1:length(bits)%for each relevant bit
        for iC = 1:length(clust_nams)%for each cluster
            goodix = [];
            gtc = [DS.([clust_nams{iC}(1:end-12),'good_trials'])];
            gix = ismember(gdix,find(gtc));
            goodix = gdix(gix);
            trial_rast = [];
            cont_trial_rast = [];
            for iGx = 1:length(goodix)%for each trial defined by goodix  
                spikes_per_trial = [];
                alignment = [DS(goodix(iGx)).(bits{iB})];
                if length(alignment) >1
                    alignment = alignment(1);
                end
                cont_alignment = double([DS(goodix(iGx)).FixationCrossUp]);                
                spks_per_trial = double([DS(goodix(iGx)).(clust_nams{iC})]);
                trial_rast(iGx,:) = TrialRaster(spks_per_trial,alignment,pre,post,bin);
                cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);              
            end
            
            
            lR = double([DS(goodix).situation])== 1;
            mR = double([DS(goodix).situation])== 2;
            hR = double([DS(goodix).situation])== 3;
            %
            ca
            fig = figure('visible','off');
%             fig = figure;
            if isempty(trial_rast)||length(trial_rast(:,1))<5
                continue
            end
            %         SubplotRowsCols(12,5,1:6,1:2)
            axes('Position',[.05 .5 .35 .4]);
            Imagesc_for_rast(trial_rast);
            %         SubplotRowsCols(12,5,7:9,1:2)
            axes('Position',[.05 .3 .35 .1]);
            Peri_Event_Firing_Rate(trial_rast,bin,pre,[0 0 0]);
            
            %         SubplotRowsCols(12,5,10:12,1:2)
            %         axes('Position',[.05 .1 .35 .1])
            %         Shuffle_PETH(spks,alignments,pre,post,bin)
            
            %         SubplotRowsCols(12,5,1:2,4)
            
            % axes('Position',[.125 .05 .2 .15]) %%%%%%%%%%%%%%%%%%%%%%%%%%
            % Need to put average waveform here %%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            
            axes('Position',[.625 .85 .15 .13])
            FRrast = trial_rast./bin*1000;
            cont_rast_FR = cont_trial_rast./bin*1000;
            ctrl = nanmean(cont_rast_FR(:,(pre-cont_comp)/bin:pre/bin),2);
            po = nanmean(FRrast(:,(pre+cmpstrt)/bin:(pre+cmpstp)/bin),2);
            [p,~,~] = signrank(ctrl,po);
            Plot_Bars_SEM([ctrl,po])
            title(sprintf('p = %.1g, Wilcoxan',p));
            pubify_figure_axis_robust
            xticklabels({'ctrl' sprintf('%g ms Post',cmpstp-cmpstrt)})
%             xtickangle(45)
            ylabel('Firing rate (Hz)')
            
            Wix = double([DS(goodix).Win])==1;
            Lix = double([DS(goodix).Win])==0;
            Bix = find(Wix+Lix==1);
            WLBix = {Wix Lix Bix};
            wlb_nam = {'win','lose','both'};
% % % %             
            for iW = 1:length(WLBix)
                
                %%%%%%%%%%%%%sanity check%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %             alignments = [DS(goodix_bit(WLBix{iW})).(bits{iB})];
                %             rast = Raster(spks,alignments,pre,post,bin,1); %make a raster of the bit of interest
                %             FRrast = rast./bin*1000;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 FRrast_wl = Z_scores_DH(FRrast(WLBix{iW},:),[1:(300/bin)]);%,(2500/bin):(2800/bin)]);
%                 contFRrast_wl = Z_scores_DH(cont_rast_FR(WLBix{iW},:),[1:(300/bin)]);
                FRrast_wl = FRrast(WLBix{iW},:);
                contFRrast_wl = cont_rast_FR(WLBix{iW},:);

                
                Mbids_by_bit = double([DS(goodix(WLBix{iW})).MonkeyBid])./100;
                Cbids_by_bit = double([DS(goodix(WLBix{iW})).ComputerBid])./100;
                Mbids_Cbids_by_bit = (double([DS(goodix(WLBix{iW})).MonkeyBid])-double([DS(goodix(WLBix{iW})).ComputerBid]))./100;
                Rliq_by_bit = double([DS(goodix(WLBix{iW})).RewardVolume]);
                Bliq_by_bit = double([DS(goodix(WLBix{iW})).BudgetVolume]);
                
                trial_no = goodix(WLBix{iW});
%                 
%                 plot(double([DS(goodix(WLBix{iW})).situation]),double([DS(goodix(WLBix{iW})).MonkeyBid]),'Marker','o','LineStyle','none')
%                 xlim([0 4])
                
                bl = {Mbids_by_bit Cbids_by_bit Mbids_Cbids_by_bit Rliq_by_bit Bliq_by_bit};
                bl_nam = {'MonkeyBid' 'ComputerBid' sprintf('MonkBid-\nCompBid') 'RewardLiq' 'BudgetLiq'};
                for ibB = 1:length(bl)
                    if ~isempty(bl{ibB}) 
                        %                     s = SubplotRowsCols(12,5,(ibB*2)+2-1:(ibB*2)+2,iW+2);
                        p(1) = ((iW/10)+(iW/20))-.05+.4;
                        p(2) =  1-.20-(ibB/10)-(ibB/20);
                        p(3) = .1;
                        p(4) = .1;
                        axes('Position',p)
                        
%                         zFRrast_wl = Z_scores_DH(FRrast_wl,[1:10,140:150]);
%                         zcontFRrast_wl = Z_scores_DH(contFRrast_wl,[1:10,140:150]);

                        data = nanmean(FRrast_wl(:,(pre+cmpstrt)/bin:(pre+cmpstp)/bin),2);
%                         po = pos - nanmean(zcontFRrast_wl(:,(pre-cont_comp)/bin:(pre)/bin),2);
                        ctrl = nanmean(contFRrast_wl(:,(pre-cont_comp)/bin:(pre)/bin),2);
                        
                        dmc = data-ctrl;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        data_nrm = (dmc-min(dmc))/(max(dmc)-min(dmc));
%                         data_nrm = Z_scores_DH(dmc);
                        data_nrm = dmc; %don't need normalization for regressions...but it makes it pretty

                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        po = data_nrm;
                        %                         po =  nanmean(zFRrast_wl(:,pre/bin:(pre+comp)/bin),2);
                        clear bids_by_bit
                        bids_by_bit = double(bl{ibB});
                        
                        col = trial_no;
                        if length(col)>10
                            scatter(bids_by_bit',po,[],col,'filled')
                        else
                            scatter(bids_by_bit',po)
                        end

%                         col = 1:length(trial_no);
%                         
                        [b,dev,stats] = glmfit(bids_by_bit',po);
                        hold on
                        pf = polyfit(bids_by_bit',po,1);
                        pv = polyval(pf,bids_by_bit');
                        plot(bids_by_bit',pv)
                        mpo = mean(po);
                        SStot = sum((po - mpo).^2);
                        SSreg = sum((pv - mpo).^2);
                        SSres = sum((po - pv).^2);
                        R2 = 1 - SSres/SStot;
                        [R2s,ps] = corr(bids_by_bit',po,'Type','Spearman');
%                         [R2p,pp] = corr(bids_by_bit',po,'Type','Pearson');
                        
                        title(sprintf('y = %.1g + %.1gx | p = %.1g \n R^2 = %.1g ',pf(2),pf(1),stats.p(2),R2s));
                        if ibB == 1
                            annotation('textbox',[p(1)+.0325,p(2)+p(4)+.04,.035,.02], 'string', wlb_nam{iW},'EdgeColor','none')
                        end
                        if iW == 1
                            annotation('textbox',[p(1)-.075,p(2)+.03,.03,.02], 'string', bl_nam{ibB},'EdgeColor','none')
                        end
                        
                    end
                end
            end
              
            FigureTitle([situation_names{situations},' | ',bits{iB},' | ',clust_nams{iC}]);
            FullScreenFigs
            savnam = strfix([situation_names{situations},' | ',bits{iB},' | ',clust_nams{iC}]);
            %             saveas(fig,[pth,savnam],'meta');
            npth = We_want_dir_funk([pth,'\Rasters_and_Regressions_',situation_names{situations},...
                '_trials',num2str(trials(1)),'-',num2str(trials(end)),'_',num2str(bin),'ms_bin','_',num2str(cmpstp-cmpstrt),'comp']);
            saveas(fig,[savnam],'png');
%             saveas(fig,[pth,savnam],'svg');
        end
        ca
    end
end



%% this is for checking differences between situations
if 0
if isequal(situations,[1:3])
    for iB = 1:length(bits)
        low_ix = find([DS.situation]==1);
        mid_ix = find([DS.situation]==2);
        high_ix = find([DS.situation]==3);
        
        lix = low_ix(ismember(low_ix,goodix));
        mix = mid_ix(ismember(mid_ix,goodix)); 
        hix = high_ix(ismember(high_ix,goodix));
        
        sit_cell = {lix mix hix};
        
        col = Reds_and_Blacks(3);
        figure
        for iC = 1:length(sit_cell)         
            
            cont_bit = [DS(goodix_sc(both_ix)).FixationCrossUp];
            alignments = [DS(goodix_sc).(bits{iB})];
            spks = [DS(goodix_sc).SpikeTimesMs];
            sits = [DS(goodix_sc).Situation];
            
            rast = Raster(spks,alignments,pre,post,bin,1); %make a raster of the bit of interest
            cont_rast = Raster(spks,cont_bit,pre,0,bin,1); %make a raster of a 'control' period (in this case 500 ms before fix cross)
            
            if ~isempty(rast)
                FRrast = rast./bin*1000;
                FR_rast_lmh(iC,:) = nanmean(FRrast);
                sFRrast = smoothdata(FRrast,2,'gaussian',9);
                xax = (1:length(sFRrast))/bin;
                plot_error_lines(sFRrast,xax,col(iC,:));
                
                
                cont_rast_FR = cont_rast./bin*1000;
                ctrl = nanmean(cont_rast_FR(:,(pre-cont_comp)/bin:pre/bin),2);
                po = nanmean(FRrast(:,pre/bin:(pre+comp)/bin),2);
                FRdif{:,iC} = po-ctrl;
            end
        end
        hold on
        g=gca;
        line([xax(pre/bin) xax(pre/bin)],g.YLim)
        legend_for_error_lines({'low' 'med' 'high'},col)
        title(bits{iB})
        FR_dif_m = nan_fill_cell2mat(FRdif);
        LMH = FR_dif_m;
        % % %         [p,tbl,stats] = anova1(FR_dif_m,{'low' 'mid' 'high'});
        % % %         c = multcompare(stats,'CType','hsd');
        disp(bits{iB});
        MedFigs
        
        %         waitforbuttonpress
        %         ca
    end
    
    % [sitsort,ssix] = sort([DS(goodix).Situation]);
    % alignments = alignments(ssix);
    
    % if sum(situations==[1:3])==3
    %
    % end
end
end



% % %     rnd = (rand(1,numel(sits)))*2;
% % %     fake_bids = (sits + rnd)/max(sits);
%     TrNumIncr = find(diff([DS(goodix_bit).TrialNumber])>0);
%     TrNumIncr = [TrNumIncr,max(TrNumIncr)+1];
%     bids_by_bit = [DS(goodix_bit(TrNumIncr)).CompBid];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%












