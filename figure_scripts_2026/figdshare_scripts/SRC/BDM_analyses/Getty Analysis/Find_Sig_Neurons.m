% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')
clear;ca;

%
d = DropboxDir;
dt = date;

monk='Vic';

RES = LoadMonkDataBDM(monk);
nnix = isnan([RES.waveform_length]);

RES = RES(~nnix);

ngt = sum([RES.numTrGood]);

RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
numDA = sum(RESix);
numnDA = ngt-numDA;
% RES=RES(RESix);
%% FR at fractal and monkey bids
% test 1: is FR from any bid tercile greater than FR from lower tercile
% test 2: does FR have significant correlation with bids?
% test 3: does FR have significant correlation with binned bids?
ca
clearvars -except RES monk d dt RESix

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
sigbit = bit;

sigOnly = 0;
wl=2;
testSit = 1:3;


saveIt = 1;

pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];

bin=1;

% sitCols = [232/255 156/255 18/255;
% 0 114/255 206/255;
% 192/255 0 0;];
% sitCols = CB_reds(3);
sitCols = CB_blues(5);


if strcmp(monk,'Uly')
    cc1=180;
    cc2=340;
    %     cc1=180;
    %     cc2=340;
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    CHANGED on 01Feb2022   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     cc1=145;
    %     cc2=395;
end
nq=10;
nanix=zeros(length(RES),1);
p=[];r=[];n2=0;H=zeros(size(RES));
for i = 1:length(RES)
    if isnan(RES(i).rast.(bit))
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double(RES(i).event.monkeybid);
        cb = double(RES(i).event.computerbid);
        pcb = double(RES(i).event.previouscomputerbid_same_RV);
        sit = double(RES(i).event.situations);
        wltr = double(RES(i).event.previouswinlose);
        tl = double(RES(i).event.previoustotalliquid);
        sb = double(RES(i).event.startingbid);
        
        rst = RES(i).rast.(bit);
%         rst = zscore(RES(i).rast.(bit),0,[2]);
        %         rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);
        
        fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
        
        if strcmp(bit,'RewardTapUp')
            fr = fr(mb>cb,:);
            mb = mb(mb>cb);
        end
        if any(ismember(sit,[1,3]))
            fr_low = fr(sit==1);
            fr_mid = fr(sit==2);
            fr_high = fr(sit==3);
            
            %             [p,h] = ranksum(fr_low,fr_high);
            %             [p2,h2] = ranksum(fr_mid,fr_high);
            %             [p3,h3] = ranksum(fr_low,fr_mid);
            %
            gt = median(fr_high)>median(fr_low);
            gt2 = median(fr_high)>median(fr_mid);
            gt3 = median(fr_mid)>median(fr_low);
            
            %             bf_p = Bonferroni([p,p2,p3],0.05);
            %             bf_p =[p,p2,p3];
            %             H(i)=any(([gt,gt2,gt3])&(bf_p<0.05));
            
            p = kruskalwallis(nan_fill_cell2mat({fr_low,fr_mid,fr_high}),{'l','m','h'},'off');
            H(i)=p<0.05&any([gt,gt2,gt3]);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        X=[];p=[];r2=[];b=[];bta=[];stats=[];
        X = [ones(length(mb),1) mb];
        [bta,~,~,~,stats] = regress(fr,X);
        p = stats(3);
        r2 = stats(1);
        b=BetaNormalization(bta(2),mb,fr);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        X=[];p_bin=[];r2_bin=[];b_bin=[];bb=[];stats_bin=[];;
        
        mnmb = min(mb);mxmb=max(mb);
        edgs = linspace(mnmb,mxmb,nq+1);
        %         edgs=linspace(min(mb)-(std(mb)*1),max(mb)+(std(mb)*1),nq+1);
        %         edgs=quantile(mb,nq+1);
        edgs(1)=0; edgs(end)=100;
        [~,~,bix] = histcounts(mb,edgs);
        frb = nan(1,nq);
        ubix = unique(bix);
        for ib = 1:length(ubix)
            iBfr = ubix(ib);
            frb(iBfr) = nanmean(fr(bix==iBfr));
            mbb(iBfr) = nanmean(mb(bix==iBfr));
        end
        bds = mbb;
        badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);
        X = [ones(length(bds),1),bds'];
        [bb,~,~,~,stats_bin] = regress(frb',X);
        p_bin = stats_bin(3);
        r2_bin= stats_bin(1);
        b_bin =BetaNormalization(bb(2),mbb,frb);
        if (p<0.05&b>0) || (p_bin<0.05&b_bin>0)
            H(i)=1;
        end
        
        
    end
end
sum(H)
%%
%% Num neurons that correlate with bids
% test 1: does FR have significant correlation with bids?
% test 2: does FR have significant correlation with binned bids?
ca
clearvars -except RES monk H d dt RESix

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
sigbit = bit;

sigOnly = 0;
wl=2;
testSit = 1:3;


saveIt = 1;

pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];

bin=1;

% sitCols = [232/255 156/255 18/255;
% 0 114/255 206/255;
% 192/255 0 0;];
% sitCols = CB_reds(3);
sitCols = CB_blues(5);


if strcmp(monk,'Uly')
    cc1=180;
    cc2=340;
    %     cc1=180;
    %     cc2=340;
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    CHANGED on 01Feb2022   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     cc1=145;
    %     cc2=395;
end
nq=10;
nanix=zeros(length(RES),1);
p=[];r=[];n2=0;Hb=zeros(size(RES));
for i = 1:length(RES)
    if isnan(RES(i).rast.(bit))
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double(RES(i).event.monkeybid);
        cb = double(RES(i).event.computerbid);
        pcb = double(RES(i).event.previouscomputerbid_same_RV);
        sit = double(RES(i).event.situations);
        wltr = double(RES(i).event.previouswinlose);
        tl = double(RES(i).event.previoustotalliquid);
        sb = double(RES(i).event.startingbid);
        
        rst = RES(i).rast.(bit);
%         rst = zscore(RES(i).rast.(bit),0,[2]);
        %         rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);
        
        fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
        
        if strcmp(bit,'RewardTapUp')
            fr = fr(mb>cb,:);
            mb = mb(mb>cb);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        X=[];p=[];r2=[];b=[];bta=[];stats=[];
        X = [ones(length(mb),1) mb];
        [bta,~,~,~,stats] = regress(fr,X);
        p = stats(3);
        r2 = stats(1);
        b=BetaNormalization(bta(2),mb,fr);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        X=[];p_bin=[];r2_bin=[];b_bin=[];bb=[];stats_bin=[];;
        
        mnmb = min(mb);mxmb=max(mb);
        edgs = linspace(mnmb,mxmb,nq+1);
        %         edgs=linspace(min(mb)-(std(mb)*1),max(mb)+(std(mb)*1),nq+1);
        %         edgs=quantile(mb,nq+1);
        edgs(1)=0; edgs(end)=100;
        [~,~,bix] = histcounts(mb,edgs);
        frb = nan(1,nq);
        ubix = unique(bix);
        for ib = 1:length(ubix)
            iBfr = ubix(ib);
            frb(iBfr) = nanmean(fr(bix==iBfr));
            mbb(iBfr) = nanmean(mb(bix==iBfr));
        end
        bds = mbb;
        badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);
        X = [ones(length(bds),1),bds'];
        [bb,~,~,~,stats_bin] = regress(frb',X);
        p_bin = stats_bin(3);
        r2_bin= stats_bin(1);
        b_bin =BetaNormalization(bb(2),mbb,frb);
        %terc
        if (p<0.05&b>0) || (p_bin<0.05&b_bin>0)
%             np = Bonferroni(p,p_bin);
%             if np<0.05
                Hb(i)=1;
%             end
        end
        
        
    end
end
sum(Hb)
%%
ca
clearvars -except RES monk d dt H Hb RESix

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'WinLoseUp';
sigbit = bit;

sigOnly = 0;
wl=1;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
testSit = 1:3;
nq=10;

saveIt = 1;

pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];

bin=1;

% sitCols = [232/255 156/255 18/255;
% 0 114/255 206/255;
% 192/255 0 0;];
% sitCols = CB_reds(3);
sitCols = CB_blues(5);


if strcmp(monk,'Uly')
    cc1=180;
    cc2=340;
    %     cc1=180;
    %     cc2=340;
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    CHANGED on 01Feb2022   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     cc1=145;
    %     cc2=395;
end

nanix=zeros(length(RES),1);
p=[];r=[];n2=0;
for i = 1:length(RES)
    if isnan(RES(i).rast.(bit))
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double(RES(i).event.monkeybid);
        cb = 100-double(RES(i).event.computerbid);
        pcb = double(RES(i).event.previouscomputerbid_same_RV);
        sit = double(RES(i).event.situations);
        wltr = double(RES(i).event.previouswinlose);
        tl = double(RES(i).event.previoustotalliquid);
        sb = double(RES(i).event.startingbid);
        
        rst = RES(i).rast.(bit);
        %         rst = zscore(RES(i).rast.(bit),0,[2]);
        %         rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);
        
        fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
        
        if strcmp(bit,'RewardTapUp')
            fr = fr(mb>cb,:);
            mb = mb(mb>cb);
        end
        X = [ones(length(mb),1),cb];
        %         X = [ones(length(mb),1),mb,sit];
        %         X = [ones(length(mb),1),mb,sit,sb,pcb,wltr,tl];
        
        [bta,~,~,~,stats] = regress(fr,X);
        p(i) = stats(3);
        r2(i) = stats(1);
        b(i)=BetaNormalization(bta(2),cb,fr);
        %         if p(i)<.05 && b(i)<0
        %             QuickRasterPeth(rst)
        %             figure;scatter(mb,fr)
        %             ca
        %         end
        
        mnmb = 0;mxmb=100;
        edgs = linspace(mnmb,mxmb,nq+1);
        %         edgs=linspace(min(mb)-(std(mb)*1),max(mb)+(std(mb)*1),nq+1);
        %         edgs=quantile(mb,nq+1);
        edgs(1)=0; edgs(end)=100;
        [~,~,bix] = histcounts(cb,edgs);
        frb = nan(1,nq);
        ubix = unique(bix);
        for ib = 1:length(ubix)
            iBfr = ubix(ib);
            frb(iBfr) = nanmean(fr(bix==iBfr));
            mbb(iBfr) = nanmean(cb(bix==iBfr));
        end
        bds = mbb;
        badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);
        X = [ones(length(bds),1),bds'];
        [bb,~,~,~,stats_bin] = regress(frb',X);
        %         [~,wID] = lastwarn();warning('off', wID)
        p_bin(i) = stats_bin(3);
        r2_bin(i) = stats_bin(1);
        b_bin(i)=BetaNormalization(bb(2),mbb,frb);
    end
end
% sigix = p<0.05&p~=0&b>0 | p_bin<0.05&p_bin~=0&b_bin>0;
% 
% for i = 1:length(p)
% if p(i)<0.05&b(i)>0 | p_bin(i)<0.05&b_bin(i)>0
%     np_wl(i) = Bonferroni(p(i),p_bin(i))
% else
%     np_wl(i)=1;
% end
% end
%     


sigix = p<0.05&b>0;
% sigix =  p_bin<0.05&b_bin>0;
% sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;%%%% | psr<0.05&posSR;


% sigix = p<0.05&b<0 | p_bin<0.05&b_bin<0; %% negative correlation
% sigix = p<0.05 | p_bin<0.05;

% sigix = p_bin<0.05&p_bin~=0&b_bin>0;
sum(sigix)
% sigix = p<0.05&p~=0&b>0 | p_bin<0.05&p_bin~=0&b_bin>0;

%%
disp(' ')
disp('.....................................................................')
disp(monk)
disp('.....................................................................')

sum(H);% total number of neurons with graded response to fractal
disp(['All Fractal responsive = ',num2str(sum(H))])
sum(Hb);% total number of neurons with graded response to fractal
disp(['All Bid responsive = ',num2str(sum(Hb))])
sum(sigix);% total number of neurons with graded response to winlose
disp(['All WinLose responsive = ',num2str(sum(sigix))])
all_sig=H|Hb|sigix;
tot_sig = sum(all_sig);% total number of neurons with ANY graded reward response
disp(['Total number neurons with graded response to reward = ', num2str(tot_sig)])
proportion_sig = tot_sig/numel(all_sig);
disp(['Proportion of significant neurons = ',num2str(proportion_sig)])

disp('.....................................................................')

DA_frac_rsp = sum(H&RESix);% total number of neurons with graded response to fractal
disp(['DA Fractal responsive = ',num2str(DA_frac_rsp)])
DA_bid_rsp = sum(Hb&RESix);% total number of neurons with graded response to fractal
disp(['DA Bid responsive = ',num2str(DA_bid_rsp)])
DA_wl_rsp = sum(sigix&RESix);% total number of neurons with graded response to winlose
disp(['DA WinLose responsive = ',num2str(DA_wl_rsp)])
all_DA_sig=H|Hb|sigix;
tot_sig = sum(all_DA_sig&RESix);% total number of neurons with ANY graded reward response
disp(['Total DA neurons with graded response to reward = ', num2str(tot_sig)])
proportion_sig = tot_sig/sum(RESix);
disp(['Proportion significant DA neurons = ',num2str(proportion_sig)])

disp('.....................................................................')
disp('.....................................................................')
disp(' ')

%%
RT = struct2table(RES);
Sig_Index = RT(:,8:16);

Sig_Index.AllFracResponsive = H';
Sig_Index.AllBidResponsive = Hb';
Sig_Index.AllWinloseResponsive = sigix';
Sig_Index.AllSigResponsive = all_sig';

Sig_Index.DAFracResponsive = H'&RESix';
Sig_Index.DABidResponsive = Hb'&RESix';
Sig_Index.DAWinloseResponsive = sigix'&RESix';
Sig_Index.DASigResponsive = all_sig'&RESix';
% 
% 
% sum([Sig_Index.AllFracResponsive]) 
% sum([Sig_Index.AllBidResponsive]) 
% sum([Sig_Index.AllWinloseResponsive])
% sum([Sig_Index.AllSigResponsive])
% 
% sum([Sig_Index.DAFracResponsive]) 
% sum([Sig_Index.DABidResponsive]) 
% sum([Sig_Index.DAWinloseResponsive]) 
% sum([Sig_Index.DASigResponsive]) 

% save([monk,'_Sig_Index'],"Sig_Index");
