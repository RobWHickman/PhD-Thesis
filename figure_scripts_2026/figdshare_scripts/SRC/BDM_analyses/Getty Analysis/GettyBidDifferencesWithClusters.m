function [LMH]=GettyBidDifferencesWithClusters(data_file_path_name,situations,bits,trials,win_lose_both)

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
comp = 400;%400
cont_comp = 500;
offset = 80;%80
alpha = 0.001;%0.001
nq = 2;
quantMethod = 'linsp'; %quant linsp stdev
minNumTrials = 3;%3
normMethod = 'Zscore';%Zscore BGsubtract none
ExclSensoredBids = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    
    for ig = 1:length(gdbits)
        fr_trial_rast = [];
        fr_cont_trial_rast = [];
        
        for iFx = 1:sum(fx)
            
            if ismember(gdbits{ig},{'RewardEpochEndUp','BudgetTapUp'})
                continue
            end
            
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
        
        %         if ismember(gdbits{ig},{'FractalDisplayUp'})
        %         X = [ones(length(frpo),1),frpo];
        %         y = mb(ffx);
        %         [b,~,~,~,stats] = regress(y,X); % r2 f p-val var
        %         end
        
        [~,h(ig)] = signrank(frpo,frcnt,'alpha',alpha); % outputs: [p,h,stats]= signrank();
        
%         if h(ig) > 0 && strcmp('FractalDisplayUp',gdbits{ig})
%             figure;
%             subplot(5,1,1:3)
%             Imagesc_for_rast(freerew_rast_FR)
%             %         title(frp)
%             subplot(5,1,4:5)
%             xax = ((0-(pre/bin):post/bin)+.5)*bin;
%             xax = xax(1:150);
%             plot(xax,nanmean(freerew_rast_FR))
%             waitforbuttonpress
%             ca
%         end
    end    
    
       
    
    if sum(h)>0 %& stats(3)<.05 %%%%%%%%%%%%%%%%%%%%%
               
        %         figure
        %         Imagesc_for_rast(freerew_rast_FR)
        
        ctr = ctr+1;
        gdbits = bits(cellfun(@isempty,strfind(bits,'FreeRewardUp')));%get all the bits except the free reward bit
        for iB = 1:length(gdbits)%for each relevant bit
            
            si = ismember(double([DS.situation]),situations);
            if sum(si)<1
                continue
            end
            gi = fx&si;
            
            mb=[];cb=[];
            mb = double([DS.MonkeyBid])';           
            cb = double([DS.ComputerBid])';
            
            mnmb = min(mb(gi));
            mxmb = max(mb(gi));
                       
            
            if mnmb < mean(mb)-(2*std(mb))
                mnmb = round(mean(mb)-(2*std(mb)));
            end
            
            if mxmb > mean(mb)+(2*std(mb))
                mxmb = round(mean(mb)+(2*std(mb)));
            end
            
%             if ExclSensoredBids
%                 nsbix = mb>0&mb<100;
%                 gii = nsbix'&gi;
%             end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        
            %             figure
            %             PlotPDF(mb)      
            edgs = [];bn=[];bid_lmh=[];
            if strcmp(quantMethod,'quant')
%                 edgs = quantile(mb(gi'&mb<100),[.333 .666]);%nq-1;%,'Method','approximate');
                edgs = quantile(mb(gi'&mb<100),nq-1);%,'Method','approximate');
                if nq ==2 
                    edgs =median(mb(gi'&mb<100));
                end
                edgs = [0,edgs];
                edgs(end+1)= 100;
            elseif strcmp(quantMethod,'linsp')
                edgs = linspace(mnmb,mxmb,nq+1);
                edgs(1)=0;
            elseif strcmp(quantMethod,'stdev')
                smb = std(mb(gi'&mb<100));
%                 mmb = median(mb(gi'&mb<100));
                mmb= mean(mb(gi'&mb<100));
%                 edgs = [mmb-(smb*2),mmb-(smb*1),mmb,mmb+(smb*1),mmb+(smb*2)];
                edgs = [mmb-(smb*1),mmb+(smb*1)];
                edgs=[0,edgs,100];  
                edgs(edgs>100)=100; edgs(edgs<0)=0;                
            end                
            
            [~,~,bn] = histcounts(mb,edgs);
            if strcmp(quantMethod,'stdev') && edgs(3)==100
                bn = bn+1;
            end

            bid_lmh = bn;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            for iBid = 1:max(bn)%1:length(bid_lmh)%
                
                gx = gi...
                    &ismember([DS.Win],[wlb{:}])...
                    &[bid_lmh==iBid]';

%                     &ismember(double([DS.MonkeyBid]),[bid_lmh{iBid}]);
                
                if sum(gx)<minNumTrials
                    FRrast = nan(1,(pre+post)/bin);
                    LMH(ctr).(gdbits{iB})(iBid,:) = nanmean(FRrast,1);
                    continue
                end
                trial_rast = [];
                cont_trial_rast = [];
                
                fgx = find(gx);
                for iGx = 1:length(fgx)%for each trial defined by goodix.
                    alignment = [];
                    alignment = [DS(fgx(iGx)).(gdbits{iB})];
                    if length(alignment)>1
                        alignment = alignment(2);
                    end
                    cont_alignment = [DS(fgx(iGx)).FixationCrossUp];
                    spks_per_trial = [DS(fgx(iGx)).(clust_nams{iC})];
                    trial_rast(iGx,:) = TrialRaster(spks_per_trial,alignment,pre,post,bin);%generate a single-trial raster
                    cont_trial_rast(iGx,:) = TrialRaster(spks_per_trial,cont_alignment,pre,post,bin);%generate a single-trial control raster
                end
                                
                if strcmp(normMethod,'Zscore')
                    FRrast = trial_rast;
                    zFRrast = Z_scores_control_data(FRrast,cont_trial_rast,[((pre-1000)/bin)+1:(pre/bin)-1]);
                    out = nanmean(zFRrast,1);
                elseif strcmp(normMethod,'BGsubtract')
                    FRrast = trial_rast;
                    bgFRrast = FRrast-nanmean(cont_trial_rast([((pre-900)/bin)+1:(pre/bin)-1]));
                    out = nanmean(bgFRrast,1)./bin*1000;
                elseif strcmp(normMethod,'none')
                    FRrast = trial_rast;
                    out = nanmean(FRrast,1)./bin*1000;
                end
               
                LMH(ctr).(gdbits{iB})(iBid,:) = out;               
            end
        end
    end
    ca
    
end

if ~exist('LMH')==1
    LMH = [];
end

% disp('bleh')




