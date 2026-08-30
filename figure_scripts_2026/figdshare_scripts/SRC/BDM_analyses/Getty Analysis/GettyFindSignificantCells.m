function [LMH]=GettyFindSignificantCells(data_file_path_name,situations,bits,trials,win_lose_both)

[DS,pth] = FormatGettyDataStructureWithClusters(data_file_path_name);
slsh = strfind(pth,'\');
fldate = pth(slsh(end-1)+1:slsh(end-1)+8);

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
bin = 1;%10
pre = 1000;
post = 2000;
comp = 400;%400
cont_comp = 500;
offset = 20;%80
alpha = 0.001;%0.001
nq = 2;
quantMethod = 'linsp'; %quant linsp stdev
minNumTrials = 3;%3
normMethod = 'Zscore';%Zscore BGsubtract none
ExclSensoredBids = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bin = 20;
% pre = 1000;
% post= 2000;
% comp = 250;
% cont_comp = 800;
% offset = 100;

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
cwix = ~cellfun(@isempty,strfind(fn,'AverageWaveform'));
clust_wav_nams = fn(cwix);

gdbits = bits(cellfun(@isempty,strfind(bits,'FreeRewardUp')));%get all the bits except the free reward bit
for ig = 1:length(gdbits)
    LMH.(gdbits{ig})=[];
end
LMH.cluster=[];

ctr = 0;
for iC = 1:length(clust_nams)%for each cluster
    wv = DS(1).(clust_wav_nams{iC});
    goodix = [];
    cln = [clust_nams{iC}(1:end-12),'good_trials'];
    if isfield(DS,cln)
        gtc = [DS.(cln)];
    else
        for ic = 1:length(DS)
            gtc(ic) = 1;
        end
    end
    gix = ismember(gdix,find(gtc));
    goodix = gdix(gix);
    
    sit = situations;
    ctr = ctr+1;
    gdbits = bits(cellfun(@isempty,strfind(bits,'FreeRewardUp')));%get all the bits except the free reward bit
    fig = figure('Visible','off');
    for iB = [2]% 3 5] %1:length(gdbits)%for each relevant bit
        
%         if strcmp(gdbits{iB},'RewardTapUp')&&strcmp(win_lose_both,'lose')
%             continue
%         end
        
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
            continue
        end
        
        trial_rast = [];
        cont_trial_rast = [];
        for iGx = 1:length(gx)%for each trial defined by goodix.
            alignment = [];           
            alignment = [DS(gx(iGx)).(gdbits{iB})];
            if length(alignment)>1
                alignment = alignment(2);
            end
            cont_alignment = [DS(gx(iGx)).FixationCrossUp];
            spks_per_trial = [DS(gx(iGx)).(clust_nams{iC})];
            [trial_rast(iGx,:),bc] = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
            cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
        end
%         if isnan(alignment)
%             continue
%         end
%         if median(sum(trial_rast,2))<5 % if median spikes per trial is fewer than 5, don't bother 
%             continue
%         end                
        badix = sum(trial_rast,2)==0;
        trial_rast_gd = trial_rast(~badix,:);
        mb = mb(~badix);
        cb = cb(~badix);

        cont_trial_rast_gd =cont_trial_rast(~badix,:);
                
%         trz = Z_scores_control_data(trial_rast_gd,cont_trial_rast_gd,(pre-800)/bin:(pre)/bin);
% trz = (trial_rast_gd-nanmean(cont_trial_rast_gd(:,(pre-800)/bin:(pre)/bin),2));
% %         trz = MinMaxFS(trial_rast);
%         trz = zscore(trial_rast,0,2);
        trz = trial_rast_gd;


                
        %         FR_bt = nanmean(trz(:,(pre+100)/bin:(pre+comp)/bin),2);
        
        compix = round([((pre+offset)/bin):((pre+comp)/bin)]);
        d = nanmean(trial_rast(:,compix),2);
        c = nanmean(cont_trial_rast(:,((pre-800)/bin):((pre)/bin)),2);
        [p,h,SRstats] = signrank(d,c,'alpha',.01);
                
%         d_s = d-c;
        d_s = nanmean(trz(:,compix),2)/bin*1000;
        X = [ones(size(d_s)),d_s];
        [b,bint,r,rint,statss] = regress(mb',X);% r2 f-stat p-value variance
        b_n = BetaNormalization(b(2),d_s,mb');
       
        [mc_b,bint,r,rint,mc_stats] = regress(mb'-cb',X);% r2 f-stat p-value variance
        mc_b_n = BetaNormalization(mc_b(2),d_s,mb'-cb');
        
%         if statss(3)<.05
            figure
            subplot(3,1,3)
            Y = X(:,2);
            scatter(mb',Y)
            hold on
            p = polyfit(mb',Y,1);
            pv = polyval(p,mb');
            x = mb';
            plot(x,pv)
            disp([statss(3), statss(1)])
            subplot(3,1,1)
            PlotTrueRaster(trz)
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
            
            ca


%         end
            
%             if 1%strcmp(gdbits{iB},'FractalDisplayUp')% || strcmp(gdbits{iB},'BidStableUp')%BidStartUp WinLoseUp FractalDisplayUp FixationCrossUp
%                 x = bc; 
%                 lgb = length(gdbits);
%                 axes('Position',[((iB-1)/lgb)+.02 .35 (1/lgb)-.02 .5])
%                 Imagesc_for_rast(trz)
%                 title(sprintf('%s | r2 = %.2g | \n p = %.2g | b = %.1g',gdbits{iB},stats(1),stats(3),b_n));             
%                 if iB>1
%                     axis off
%                 end
%                 axes('Position',[((iB-1)/lgb)+.02 .05 (1/lgb)-.02 .28])
%                 plot(x,mean(trial_rast).*1000./bin)                                
%                 hold on
%                 g=gca;
%                 line([min(compix)*bin max(compix)*bin]-pre,[g.YLim(1)+.1 g.YLim(1)+0.1])                
%                 disp(h)  
%                 disp(p)                
%             end
            LMH(ctr).cluster = clust_nams{iC};
            LMH(ctr).(gdbits{iB}).SignRank_p = p;
            
            LMH(ctr).(gdbits{iB}).BidReg_b = b_n;
            LMH(ctr).(gdbits{iB}).BidReg_r2 = statss(1);
            LMH(ctr).(gdbits{iB}).BidReg_p = statss(3);    
            
            LMH(ctr).(gdbits{iB}).MCBidReg_b = mc_b_n;
            LMH(ctr).(gdbits{iB}).MCBidReg_r2 = mc_stats(1);
            LMH(ctr).(gdbits{iB}).MCBidReg_p = mc_stats(3);        
            
            LMH(ctr).(gdbits{iB}).rast = trial_rast;
            LMH(ctr).(gdbits{iB}).cont_rast = cont_trial_rast;
    end
    clc
%     lmh = {'L' 'M' 'H'};
%     ti = [fldate,' ',cln(1:6),' ',win_lose_both,' ',lmh{situations}];
%     FigureTitle(ti);
%     WideFigs
%     saveas(fig,[strfix(ti),'.png'])
%     ca
end

if ~exist('LMH')==1
    LMH = [];
end


% disp('bleh')




