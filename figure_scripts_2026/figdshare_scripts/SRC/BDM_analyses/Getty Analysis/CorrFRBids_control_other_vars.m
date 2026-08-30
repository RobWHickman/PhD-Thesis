% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')
ca;clear;
monk= 'Uly';
% d = DropboxDir;
% if strcmp(monk,'Uly')
% load([d,'\Schultz_Lab\BDM_Data\Uly_Data\ANALYSIS_25-Nov-2021\GettyBidRegressionWithClustersRobust\Uly_cells_sits_1  2  3.mat'])
% elseif strcmp(monk,'Vic')
% load([d,'\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_29-Nov-2021\GettyBidRegressionWithClustersRobust\Vic_cells_sits_1  2  3.mat'])
% end

RES = LoadMonkDataBDM(monk);
RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
RES=RES(RESix);
%%
clearvars -except monk RES
bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
sigbit = 'FractalDisplayUp';

sigOnly = 1;
wl=2;
testSit = 1:3;
nq=10;

pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];
% 
bin=1;

if strcmp(monk,'Uly')
    cc1=180;
    cc2=340;
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    CHANGED on 01Feb2022   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     cc1=145;
%     cc2=395;
end

nanix=zeros(length(RES),1);
p=[];r=[];
for i = 1:length(RES)
    if isnan(RES(i).rast.(sigbit)) 
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double(RES(i).event.monkeybid);
        cb = double(RES(i).event.computerbid);
        pcb = double(RES(i).event.previouscomputerbid_same_RV);
        sits = double(RES(i).event.situations);
        wltr = double(RES(i).event.previouswinlose);
        tl = double(RES(i).event.previoustotalliquid);
        sb = double(RES(i).event.startingbid);

%         fr = RES(i).(bit)(:,1);
        rst = RES(i).rast.(sigbit);
%         rst = zscore(RES(i).rast.(bit),0,[2]);
%         rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);

        fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
        

        if strcmp(sigbit,'RewardTapUp')
            fr = fr(mb>cb,:);
            mb = mb(mb>cb);
        end
        X = [ones(length(mb),1),mb];
%         X = [ones(length(mb),1),mb,sit];
%         X = [ones(length(mb),1),mb,sit,sb,pcb,wltr,tl];

        [bta,~,~,~,stats] = regress(fr,X);
        p(i) = stats(3);
        r2(i) = stats(1);
        b(i)=BetaNormalization(bta(2),mb,fr);
%         if p(i)<.05 && b(i)<0
%             QuickRasterPeth(rst)
%             figure;scatter(mb,fr)
%             ca
%         end
        
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
        p_bin(i) = stats_bin(3);
        r2_bin(i) = stats_bin(1);
        b_bin(i)=BetaNormalization(bb(2),mbb,frb);
        %terc
        X = [ones(length(bix),1),bix];
        [bt,~,~,~,stats_terc] = regress(fr,X);
        p_terc(i) = stats_terc(3);
        r2_terc(i) = stats_terc(1);
        b_terc(i) = BetaNormalization(bt(2),bix,fr);
    end
end
% sigix = p<0.05&p~=0&b>0 | p_bin<0.05&p_bin~=0&b_bin>0;

% sigix = p<0.05&b>0;
% sigix =  p_bin<0.05&b_bin>0;
sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;


% sigix = p<0.05&b<0 | p_bin<0.05&b_bin<0; %% negative correlation
% sigix = p<0.05 | p_bin<0.05;

% sigix = p_bin<0.05&p_bin~=0&b_bin>0;
sum(sigix)

% sum(p<0.05&p~=0&b>0)
% sum(p_bin<0.05&p_bin~=0&b_bin>0)
BIDsig.(sigbit)=sigix';
BIDS.(sigbit) = [r2',p',b'];
BIDS_bin = [r2_bin',p_bin',b_bin'];
BIDS_terc = [r2_terc',p_terc',b_terc'];
%
% sigcells(:,iB) = ~nanix;

% for iB = 1:length(bits)
% nanix=zeros(length(RES),1);
% for i = 1:length(RES)
%     if isnan(RES(i).(bits{iB}))
%         nanix(i,1) = 1;
%     end
% end
% sigcells(:,iB) = ~nanix;
% end

if sigOnly
    RES = RES(~nanix & sigix');
else
    RES = RES(~nanix);
end
fr=[];cfr=[];nfr=[];mb=[];cb=[];pcb=[];sb=[];tl=[];sits=[];pctr = 0;ctr=0;cellnum=[];
all_olix=0;
for i = 1:length(RES)
    nfrt=[];frt=[];mbt=[];cbt=[];pcbt=[];sbt=[];tlt=[];sitt=[];p=[];r=[];evnts=[];nbitmat=[];
    evnts = RES(i).event;
    if wl==0
        wlix = [evnts.monkeybid]<[evnts.computerbid];
        if strcmp(bit,'RewardTapUp')
             error('No reward in lost trial');
        end
    elseif wl==1 || strcmp(bit,'RewardTapUp')
        wlix = [evnts.monkeybid]>[evnts.computerbid];
    else 
        wlix = ones(size([evnts.monkeybid]));
    end
    wlix = logical(wlix);
    sbt = double(evnts.startingbid(wlix));
    mbt = double(evnts.monkeybid(wlix));        
    cbt = double(evnts.computerbid(wlix));
    pcbt = double(evnts.previouscomputerbid_same_RV(wlix))*100;
%     pcbt = evnts.previous_computerbid(wlix)*100;

    tlt = double(evnts.previoustotalliquid(wlix));
    rst = RES(i).rast.(bit)(wlix,:);
    crst = RES(i).rast.FixationCrossUp(wlix,:);
    %     rst = zscore(RES(i).rast.(testBit),0,[2]);
    %     rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);
    
    %     frt = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
    frt = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
    
    sitt = double(evnts.situations(wlix));
    cont = mean(crst(:,1:pre),2,'omitnan');
    
    
   
    cfr = [cfr;cont];
    fr = [fr;frt];
    if sum(cont==0)==length(cont)
        continue
    end
%         nfrt = (frt-nanmean(cont))./nanstd(cont);
    nfrt = zscore(frt);
    %     cont =  zscore(cont);
    %     nfrt = (frt-(cont))./(cont+.00000001)*100;
    %     nfrt = (frt-(cont));
%         nfrt= MinMaxFS(frt);
%         nfrt =frt;
%     
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% Remove Outlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     olix = isoutlier(nfrt,'grubbs');
%     if sum(olix)>0
%         all_olix = all_olix+1;
%     end
%     nfrt = nfrt(~olix);
%     mbt = mbt(~olix);
%     sitt = sitt(~olix);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nfr = [nfr;nfrt];
    mb = [mb;mbt];
    cb = [cb;cbt];
    pcb = [pcb;pcbt];
    sb = [sb;sbt];
    tl = [tl;tlt];
    sits = [sits;sitt];
    ctr=ctr+1;
    cctr = repmat(ctr,size(sitt));
    cellnum = [cellnum;cctr];
end

% if wl==1
%     winix = mb>cb;
% elseif wl==0
%     winix = mb<cb;
% else
%     winix = ones(size(mb));
% end
% 
% if strcmp(bit,'RewardTapUp')
%     rewix = mb>cb;
% else
%     rewix = ones(size(mb));
% end

% ix = ~isnan(nfr)&winix&rewix;
ix = ~isnan(nfr);

mb = mb(ix);
tl = tl(ix);
cb = 100-cb(ix);
pcb = 100-pcb(ix);
nfr = nfr(ix);
cn = cellnum(ix);
sits = sits(ix);


Sitix = ismember(sits,testSit);
nfr = nfr(Sitix);
mb=mb(Sitix);
cb=cb(Sitix); 
pcb=pcb(Sitix); 
tl = tl(Sitix);
cn = cellnum(Sitix);

cellcnt = numel(unique(cn));
%% regression model
% edgs = 0:100/3:100;
% edgs = [0 47 79 100];
% [~,~,nmb] = histcounts(mb,edgs);  
nmb=mb;

bs = sb.*100;

X=[];nb=[];
X = [nmb bs pcb tl];

mdl = fitlm(X,nfr);

for i =1:length(X(1,:))
    nb(1,i) = BetaNormalization(mdl.Coefficients.Estimate(i+1),X(:,i),nfr);
    nb(2,i) = mdl.Coefficients.tStat(i+1);
    nb(3,i) = mdl.Coefficients.pValue(i+1);
end
tnb = array2table(nb);
tnb.Properties.VariableNames =  {'monk_bid' 'bid_start' 'prv_cmp_bid' 'tot_liq'};
tnb.Properties.RowNames = {'beta', 't-stat', 'p-value'};

[r,p] = partialcorr([nfr,X],'Rows','complete');
r2 = r.^2;

% control for mb
[pr2_r,pr2_p] = partialcorr([nfr,X(:,2:end)],X(:,1),'Rows','complete');
pr2_SitsOnly_mbcont(1,:) = pr2_r(1,2:end).^2;
pr2_SitsOnly_mbcont(2,:) = pr2_p(1,2:end);

% control for sits
[pr2_r,pr2_p] = partialcorr([nfr,X(:,[1,3:end])],X(:,2),'Rows','complete');
pr2_MbOnly_sitscont(1,:) = pr2_r(1,2:end).^2;
pr2_MbOnly_sitscont(2,:) = pr2_p(1,2:end);


%% totol liquid
ca
edgs = 0:10:round(max(tl));
[~,~,bn] = histcounts(tl,edgs);

b=[];r2=[];p=[];n=[];

for i = 1:max(bn)
    bnix = bn==i;
    if sum(bnix)<10
        continue
    end
    frbn = nfr(bnix);
    mbbn = mb(bnix);
    X = [ones(length(mbbn),1) mbbn];
    [bt,bint,r,rint,stats] = regress(frbn,X);
    b(i) = BetaNormalization(bt(2),mbbn,frbn);
    r2(i) = stats(1);
    p(i)=stats(3);
    n(i) = sum(bnix);

end    

fig = figure;
% ms = round(n/5);
% ms(ms==0)=1;

hold on
pubify_figure_axis_robust_single_fig(fig)

PlotWeightedMarkers(b,n,'b','o','--')
PlotWeightedMarkers(r2,n,'r','o','--')


g=gca;
if ~isempty(find(p<.05))
    plot(find(p<.05),g.YLim(2)+(range(g.YLim)*.05),'k* ')
end
% pubify_figure_axis_robust
title(['total liquid | ',bit])
% g.YLim = [(min([min(b),min(r2)])) (max([max(b),max(r2)]))];


% figure 
% scatter(bn,nfr)


%% Rew. Mag.
b=[];r2=[];p=[];n=[];

for i = 1:3
    bnix=[];
    bnix = sits==i;
    frbn = nfr(bnix);
    mbbn = mb(bnix);
    X = [ones(length(mbbn),1) mbbn];
    [bt,bint,r,rint,stats] = regress(frbn,X);
    b(i) = BetaNormalization(bt(2),mbbn,frbn);
    r2(i) = stats(1);
    p(i)=stats(3);
    n(i) = sum(bnix);
end    
p
fig = figure;
PlotWeightedMarkers(b,n,'b','o','--')
hold on
PlotWeightedMarkers(r2,n,'r','o','--')
g=gca;
if ~isempty(find(p<.05))
plot(find(p<.05),g.YLim(2)+(range(g.YLim)*.05),'k* ')
end
pubify_figure_axis_robust_single_fig(fig)

xlim([0.5 3.5])
title(['Reward mag. | ',bit])
%


%% bid start

bs = sb.*100;
edgs = 0:5:round(max(bs));
[~,~,bn] = histcounts(bs,edgs);

b=[];r2=[];p=[];n=[];

for i = 1:max(bn)
    bnix = bn==i;
    frbn = nfr(bnix);
    mbbn = mb(bnix);
    X = [ones(length(mbbn),1) mbbn];
    [bt,bint,r,rint,stats] = regress(frbn,X);
    b(i) = BetaNormalization(bt(2),mbbn,frbn);
    r2(i) = stats(1);
    p(i)=stats(3);
    n(i) = sum(bnix);
end    
p


fig = figure;
PlotWeightedMarkers(b,n,'b','o','--')
hold on
PlotWeightedMarkers(r2,n,'r','o','--')
pubify_figure_axis_robust_single_fig(fig)
    
g=gca;
if ~isempty(find(p<.05))
    plot(find(p<.05),g.YLim(2)+(range(g.YLim)*.05),'k* ')
end
% pubify_figure_axis_robust
title(['Starting bid | ',bit])
% g.YLim = [-0.1 .4];

%% Prev. Comp Bid. 
% nbin = 20;
% edgs = 0:100/nbin:100;
% [~,~,mbn] = histcounts(mb,edgs);
% 
% for i = 1:max(mbn)
%     mbnix = mbn==i;
%     mbb(i) = mean(mb(mbnix));
%     frb(i) = mean(fr(mbnix));
% end

edgs = 0:5:round(max(pcb));
[~,~,bn] = histcounts(pcb,edgs);

b=[];r2=[];p=[];n=[];

for i = 1:max(bn)
    bnix = bn==i;
    frbn = nfr(bnix);
    mbbn = mb(bnix);
    X = [ones(length(mbbn),1) mbbn];
    [bt,bint,r,rint,stats] = regress(frbn,X);
    b(i) = BetaNormalization(bt(2),mbbn,frbn);
    r2(i) = stats(1);
    p(i)=stats(3);
    n(i) = sum(bnix);
%     scatter(mbbn,frbn)
%     title(r2(1),p(i))
% ca
end    

fig = figure;
PlotWeightedMarkers(b,n,'b','o','--')
hold on
PlotWeightedMarkers(r2,n,'r','o','--')
pubify_figure_axis_robust_single_fig(fig)    
g=gca;
if ~isempty(find(p<.05))
    plot(find(p<.05),g.YLim(2)+(range(g.YLim)*.05),'k* ')
end
% pubify_figure_axis_robust
title(['Prev. comp. bid | ',bit])
g.YLim = [-0.1 .4];
%%
%% Does FR vary by fractal within bid chunks?
% this is not a good analysis. Inherently biased for two reasons: 1) the
% number (n) of high bids is higher for higher reward mag. 2) While rew.
% mag. is always ordinal between days, bids might not be perfectly ordinal
% between days (need a way to calibrate bids between days--might not be
% possible though). 

edgs = 0:100/30:100;
% edgs= [0 47 79 100];
[~,~,bn] = histcounts(mb,edgs);

b=[];r2=[];p=[];n=[];nf=[];frv=[];anv_p=[];

for i = 1:max(bn)
    frg = [];
    bnix = bn==i;
    frbn = nfr(bnix);
    stbn = sits(bnix);
%     X = [ones(length(stbn),1) stbn];
%     [bt,bint,r,rint,stats] = regress(frbn,X);

    X = [stbn];
    mdl = fitlm(frbn,X);

    b(i) = BetaNormalization(mdl.Coefficients.Estimate(2),stbn,frbn);
    r2(i) = mdl.Rsquared.Ordinary;
    p(i)=mdl.Coefficients.pValue(2);
    n(i) = sum(bnix);
    frv(1,i) = mean(nfr(bnix&sits==1));
    nf(1,i) = numel(nfr(bnix&sits==1));
    frv(2,i) = mean(nfr(bnix&sits==2));
    nf(2,i) = numel(nfr(bnix&sits==2));
    frv(3,i) = mean(nfr(bnix&sits==3));
    nf(3,i) = numel(nfr(bnix&sits==3));
%     frg = nan_fill_cell2mat({nfr(bnix&sits==1),nfr(bnix&sits==2),nfr(bnix&sits==3)});
%     [anv_p(i),~,stats] = anova1(frg,[],'off');
%     multcompare(stats)
%     scatter(mbbn,frbn)
%     title(r2(1),p(i))
 
end    
fig = figure;
PlotWeightedMarkers(b,n,'b','o','--')
hold on
PlotWeightedMarkers(r2,n,'r','o','--')
pubify_figure_axis_robust_single_fig(fig)    
g=gca;

if ~isempty(find(p<.05))
    plot(find(p<.05),g.YLim(2)+(range(g.YLim)*.05),'k* ')
end
% pubify_figure_axis_robust
title(['Rew. Val. regression by bid chunk | ',bit])
% g.YLim = [-0.1 .4];


fig = figure;
col = lines(3);
PlotWeightedMarkersMatrix(frv,nf,col,'o','--')
pubify_figure_axis_robust_single_fig(fig)
g=gca;
if ~isempty(find(p<.05))
    plot(find(p<.05),g.YLim(2)+(range(g.YLim)*.05),'k* ')
end
% pubify_figure_axis_robust
title(['Rew. Val. regression by bid chunk | ',bit])
% g.YLim = [-0.1 .4];
%% prev. result

tilefigs
