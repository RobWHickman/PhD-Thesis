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
% ca
pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];
% 
bin=1;

if strcmp(monk,'Uly')
    cc1=180;
    cc2=340;
%     cc1=180;
%     cc2=340;
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%    CHANGED 01Feb2022   %%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         cc1=145;
%         cc2=395;
end
% cc1=80;
% cc2=500;

% % % Vic alt win 140:230

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
testBit = 'FractalDisplayUp';
sigbit = testBit;
nq=10;

nanix=zeros(length(RES),1);
p=[];r=[];
for i = 1:length(RES)
    if isnan(RES(i).rast.(sigbit)) 
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double(RES(i).event.monkeybid);
        cb = double(RES(i).event.computerbid);
%         fr = RES(i).FR.(sigbit); 
        rst = RES(i).rast.(testBit);
%         rst = zscore(RES(i).rast.(testBit),0,[2]);

        fr = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
%         fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;

        if strcmp(testBit,'RewardTapUp')
            fr = fr(mb>cb,:);
            mb = mb(mb>cb);
        end
        X = [ones(length(mb),1),mb];
        [bta,~,~,~,stats] = regress(fr,X);
        p(i) = stats(3);
        r2(i) = stats(1);
        b(i)=BetaNormalization(bta(2),mb,fr);
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

sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;
% sigix = p<0.05 | p_bin<0.05;

sum(sigix)


%% 
clearvars -except RES sigix bin cc1 cc2 testBit monk
ca
sw = 80;
meth  ='movmean';% movmean gaussian
pre = 2000;
post = 2000;
npre = 500;
npost = 1000;

pop = 0;
zsc = 1;
bgs = 0;
zsd = [2];
wl = 2;
quant = 0;
%%%%%%%%%%%%%%%%%%
testSit = 3;
%%%%%%%%%%%%%%%%%%
if numel(testSit)>1
    nq=5;
else
    nq=3;
end
saveIt=0;
ctr=0;

if pop
    sRES = RES;
else
    sRES = RES(sigix);
end
for iR = 1:length(sRES)
    rst=[];mb=[];wsix=[];stix=[];
    mb = double(sRES(iR).event.monkeybid);
%     mb = sRES(iR).event.previouscomputerbid_same_RV;

    cb = sRES(iR).event.computerbid;
    
    sits = sRES(iR).event.situations;
    rst = sRES(iR).rast.(testBit)(:,(pre-npre)/bin:(pre+npost)/bin);  
    % crst = sRES(iR).rast.FixationCrossUp(:,(pre-npre)/bin:(pre+npost)/bin);
    crst = sRES(iR).rast.FixationCrossUp;
       
    if numel(unique(sits))<3 && all(testSit~=2)
        continue
    end
    
    if wl==0
        wlix = mb<cb;
        if strcmp(testBit,'RewardTapUp')
            error('No reward in lost trial');
        end
    elseif wl==1 || strcmp(testBit,'RewardTapUp')
        wlix = mb>cb;
    else
        wlix = ones(size(mb));
    end
    wlix = logical(wlix);
    stix = ismember(sits,testSit);
    
    wsix = wlix&stix;
    stmb = mb(wsix);
    stcb = cb(wsix);
    rst = rst(wsix,:);
    crst = crst(wsix,:);
    
    %         if isempty(stmb) || all(unique(sits)==2)
    %             continue
    %         end
    
    edgs=[];
    edgs=linspace(min(stmb),max(stmb),nq+1);%***U
    if quant
        edgs=[];
        q = linspace(0,100,nq+1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        edgs = quantile(stmb,q(2:end-1)/100);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        edgs = [0,edgs,101];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
    [nbidsPerBin,~,bnix] = histcounts(stmb,edgs);
%     [nbidsPerBin,~,bnix] = histcountsEvenBins(stmb,nq);
    
        if bgs
            rst=rst-mean(crst(:,[1:pre-100,pre+500:pre+1000]),2);
%             rst = Z_scores_control_data(rst,crst,[1:pre-100]);% %[1:pre]
%             rst = zscore(rst,0,2);
        end
        ctr=ctr+1;
        

    for iBd = 1:nq
        ix = bnix==iBd;       
%         if length(rst(ix,1))<3
%             Traces(iBd,:,iR)=nan(1,length(rst(1,:)));
%             continue
%         end            
        Traces(ctr,:,iBd) = nanmean(rst(ix,:),1);%/bin*1000;
        cTraces(ctr,:,iBd) = nanmean(crst(ix,:),1);%/bin*1000;
        trCtr(ctr,iBd) = sum(ix);
        trMb(ctr,iBd) = median(mb(ix));
    end
end
col = CambridgeDark(nq);


if pop, ti='Pop';else,ti=['n = ',num2str(sum(sigix))];end

trcFig=figure;
for iBd = 1:nq%     
    if zsc
        Traces = zscore(Traces,0,zsd);
    end
    
    sitBdTrc(:,iBd) = mean(Traces(:,npre+cc1:npre+cc2,iBd),2,'omitnan');
    sitBdMb(:,:,iBd) = repmat(iBd,length(sitBdTrc(:,1)),1);
%     TRC(:,:) = Traces(iBd,npre+cc1:npre+cc2,:);
%     sitBdTrc(:,iBd) = WeightedMean(TRC,trCtr(:,iBd)');
    trc = Traces(:,:,iBd);
    strc = smoothdata(trc,2,meth,sw);
%     strc=trc;

    if ~zsc
        strc = strc./bin*1000;
    end
    xax = (0:(npost+npre))- npre;
%     [lnn]=plot_error_lines(strc,'SEM',xax,col(iBd,:));
%     lns(iBd,:) = lnn(2,:);
    mtrc = WeightedMean(strc,trCtr(:,iBd));
    
    plot(xax,mtrc,'Color',col(iBd,:),'LineWidth',2)    
    lns(iBd,:) = mtrc;

    hold on
    smooth_trace(iBd,:,:)=strc';
%     smooth_trace(iBd,:,:)=trc;

end
g=gca;
ShadedBox([cc1 cc2],g.YLim)
pubify_figure_axis_robust
% xticks([-npre:300:npost])
xlim([-npre npost]);
yl = [min(min(lns)) max(max(lns))];
if yl(2)==0
    yl(2)=.1;
end
ylim(yl);
% xlim([-200,700]);

% legend
title(ti)
WideFigSmall
nam = sprintf('Traces_pop%d_zsc%d_wl%d_sits%d%d%d.emf',pop,zsc,wl,testSit(:));
if saveIt
saveas(trcFig,nam,'meta')
end
% 
if nq>2
%     [anv.p,anv.tbl,anv.stats] = anova1(sitBdTrc);
    [anv.p,tbl,anv.stats] = kruskalwallis(sitBdTrc);
    nam = sprintf('AnovaKW_pop%d_zsc%d_wl%d_sits%d%d%d.emf',pop,zsc,wl,testSit(:));
    if saveIt
    saveas(gcf,nam)
    end
    anv.mc = multcompare(anv.stats);
    title(['Anova | ',num2str(anv.p)])
    nam = sprintf('AnovaKW_MC_pop%d_zsc%d_wl%d_sits%d%d%d.emf',pop,zsc,wl,testSit(:));
    if saveIt       
    saveas(gcf,nam)
    end
else
    [p,h] = signrank(sitBdTrc(:,1),sitBdTrc(:,nq));
    title(['Wilcoxon | ',num2str(p)])
end


coFig=figure;
mx = max(max(max(smooth_trace)));
mn = min(min(min(smooth_trace)));

% for i= 1:length(sRES)
%     [~,pt(i)] = max(max(smooth_trace(:,npre:npre+400,i)));
% end
% xax=xax/1000;
for i = 1:nq
    sp=nq+1-i;
    subplot(nq,1,sp)
%     subplot(3,2,sp)

    mmb = trMb(:,i);
    
    [~,sx]=sort(mmb);
%     [~,sx]=sort(pt);

    tc(:,:) = smooth_trace(i,:,sx);
    l = min(size(tc));
    if zsc
        imagesc(xax,[1:l],tc',[-.2 .4]);%[-.2 .3]
%         imagesc(xax,[1:length(sRES)],tc',[-2 10]);%[mn+((mx-mn)/6) mx/3])
    else
        imagesc(xax,[1:l],tc',[mn mx/6])
    end
%     xlim([-npre npost])
    set(gca,'YDir','normal')
    
    pubify_figure_axis_robust    
    if i>1
        set(gca,'XTick',[])
    end
%     colorbar
    
end
FigureTitle(ti)
LongFig
% ht = colormap('hot');
% flrht = flipud(fliplr(ht));
% BlueRed = [flrht(end-(256/2):end,:);ht(21:end,:)];
% cmap = yellowblue;
cmap = GenerateColorMap([0 0 0;.25 .25 1;1 1 0]);
cmap(cmap<0)=0;
colormap(cmap);
nam = sprintf('Colormap_pop%d_zsc%d_wl%d_sits%d%d%d',pop,zsc,wl,testSit(:));
nam = [nam,'.emf'];
if saveIt
exportgraphics(coFig,nam,'ContentType','vector')
end
%% Sliding Window
clearvars -except RES sigix bin cc1 cc2 testBit monk
% ca
pre = 2000;
bin=1;
npre = 200;
npost = 700;
nbin = 50;

testSit = 1:3;
testBit = 'FractalDisplayUp';
% bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp',... 
% 'RewardTapUp' 'RewardEpochEndUp' 'BudgetTapUp'};
% 
sRES = RES;
% sRES = RES(sigix);
for iR = 1:length(sRES)
  mb = sRES(iR).event.monkeybid;
    cb = sRES(iR).event.computerbid;
      pcb = sRES(iR).event.previouscomputerbid_same_RV;
        sit = sRES(iR).event.situations;
        wl = sRES(iR).event.previouswinlose;
        tl = sRES(iR).event.previoustotalliquid;
        sb = sRES(iR).event.startingbid;
    sits = sRES(iR).event.situations;
    rst = sRES(iR).rast.(testBit)(:,(pre-npre)/bin:(pre+npost)/bin);  
    crst = sRES(iR).rast.FixationCrossUp(:,(pre-npre)/bin:(pre+npost)/bin);  
    
%     if numel(unique(sits))<3 && ~all(testSit==2)
%         continue
%     end

    stix = ismember(sits,testSit);
    stmb = mb(stix);

%     sitRst = rebin(rst(stix,:),nbin,1);
    sitRst = rst(stix,:);
    if isempty(sitRst)
        continue
    end
    X = [ones(size(stmb)),stmb];
%     X = [ones(size(stmb)),stmb,pcb(stix),sit(stix),wl(stix),tl(stix),sb(stix)];

    for ii = 1:length(sitRst(1,:))-nbin
%         if 1%zsc
%             sitRst = zscore(sitRst);%,0,[2]);
%         end        
        fr=[];
        fr = nanmean(sitRst(:,ii:ii+nbin),2);
        [b,bint,r,rint,stats]= regress(fr,X); %stats=[r2 F p var];
        r2(iR,ii) = stats(1);
        bta(iR,ii) = BetaNormalization(b(2),stmb,fr);
    end
end
sw = round(50/nbin);
xax = (1:length(r2(1,:)))-npre;
figure
plot_error_lines(smoothdata(r2,2,'movmean',sw),'SEM',xax)
figure
plot_error_lines(smoothdata(bta,2,'movmean',sw),'SEM',xax)

%%
%%
%% Sit Trace
clearvars -except RES sigix bin cc1 cc2 testBit monk
ca
sw = 80;
meth  ='movmean';% movmean gaussian
pre = 2000;
post = 2000;
npre = 200;
npost = 700;

pop=0;
zsc =1;
zsd = [2];
wl=2;
testSit = 1:3;
if numel(testSit)>1
    nq=5;
else
    nq=3;
end
saveIt=0;


ctr=0;

if pop
    sRES = RES;
else
    sRES = RES(sigix);
end
for iR = 1:length(sRES)
    mb = sRES(iR).event.monkeybid;
    cb = sRES(iR).event.computerbid;
    sits = sRES(iR).event.situations;
    rst = sRES(iR).rast.(testBit)(:,(pre-npre)/bin:(pre+npost)/bin);  
    crst = sRES(iR).rast.FixationCrossUp;  
    
%     if zsc
%         rst = Z_scores_control_data(rst,crst,[1:pre]);
%         %         rst = zscore(rst,0,2);
%     end
    for iS = 1:3    
         
    if wl==0
        wlix = mb<cb;
        if strcmp(testBit,'RewardTapUp')
            error('No reward in lost trial');
        end
    elseif wl==1 || strcmp(testBit,'RewardTapUp')
        wlix = mb>cb;
    else
        wlix = ones(size(mb));
    end
    wlix = logical(wlix);
    stix = ismember(sits,iS);
    
    wsix = wlix&stix;
    stmb = mb(wsix);
    stcb = cb(wsix);
    sitrst = rst(wsix,:);
%     crst = crst(wsix,:);

%         crst = crst(stix,:);                

        Traces(iS,:,iR) = nanmean(sitrst,1);%/bin*1000;
        cTraces(iS,:,iR) = nanmean(crst,1);%/bin*1000;
    end
end
col = CambridgeLight(3);

figure
for iSt = 1:3
    trc = [];strc=[];
    if zsc        
        Traces = zscore(Traces,0,[2]);
    end
    sitBdTrc(:,iSt,:) = nanmean(Traces(iSt,npre+cc1:npre+cc2,:));
    trc(:,:) = Traces(iSt,:,:);
    strc = smoothdata(trc',2,'movmean',sw);
    if ~zsc
        strc = strc./bin*1000;
    end
    xax = (0:(npost+npre))- npre;
    [lnn]=plot_error_lines(strc,'none',xax,col(iSt,:));
    lns(iSt,:) = lnn(2,:);
    hold on
end
g=gca;
ShadedBox([cc1 cc2],g.YLim)
pubify_figure_axis_robust
WideFigSmall
% xticks([-npre:300:npost])
xlim([-npre npost]);
ylim([min(min(lns)) max(max(lns))]);
if pop, ti='Pop';else,ti=['n = ',num2str(sum(sigix))];end
title(ti)
% legend

figure
% Plot_Bars_SEM(sitBdTrc)
boxplot(sitBdTrc)
pubify_figure_axis_robust


% [anv.p,anv.tbl,anv.stats] = anova1(sitBdTrc);
  [anv.p,tbl,anv.stats] = kruskalwallis(sitBdTrc)

anv.mc = multcompare(anv.stats);
title(['Anova | ',num2str(anv.p)])

%% comp bid

clearvars -except RES sigix bin cc1 cc2 testBit monk
ca
sw = 100;
meth  ='movmean';% movmean gaussian
pre = 2000;
post = 2000;
npre = 500;
npost = 1000;

zsc =1;
wl=2;
nq=5;
testSit = 1:3;

ctr=0;
sRES = RES;
% sRES = RES(sigix);
for iR = 1:length(sRES)
    rst=[];mb=[];wsix=[];stix=[];
    mb = sRES(iR).event.monkeybid;
        
    cb = sRES(iR).event.computerbid;

    sits = sRES(iR).event.situations;
    rst = sRES(iR).rast.(testBit)(:,(pre-npre)/bin:(pre+npost)/bin);  
    % crst = sRES(iR).rast.FixationCrossUp(:,(pre-npre)/bin:(pre+npost)/bin);
    crst = sRES(iR).rast.FixationCrossUp;
       
    if numel(unique(sits))<3 && all(testSit~=2)
        continue
    end
    
    if wl==0
        wlix = mb<cb;
        if strcmp(testBit,'RewardTapUp')
            error('No reward in lost trial');
        end
    elseif wl==1 || strcmp(testBit,'RewardTapUp')
        wlix = mb>cb;
    else
        wlix = ones(size(mb));
    end
    wlix = logical(wlix);
    stix = ismember(sits,testSit);
    
    wsix = wlix&stix;
    stmb = mb(wsix);
    stcb = cb(wsix);
    rst = rst(wsix,:);
    crst = crst(wsix,:);
    
%         if isempty(stmb) || all(unique(sits)==2)
%             continue
%         end
    
    edgs=[];
    edgs=linspace(min(stcb),max(stcb),nq+1);%***U
%     edgs=linspace(min(mb),max(mb),nq+1);%***V

%     edgs=linspace(min(stmb)+(std(stmb)*1),max(stmb)-(std(stmb)*1),nq+1);
%     edgs=linspace(min(stmb)-(std(stmb)*1),max(stmb)+(std(stmb)*1),nq+1);
%     edgs=linspace(0,100,nq+1);
%     edgs=quantile(stmb,nq+1,'method','approximate');
%     edgs=quantile(mb,nq+1,'method','approximate');

      [nbidsPerBin,~,bnix] = histcounts(stcb,edgs);
%     if zsc
%         rst = Z_scores_control_data(rst,crst,[1:pre]);% %[1:pre]
% %         rst = zscore(rst,0,2);
%     end
        ctr=ctr+1;
        

    for iBd = 1:nq
        ix = bnix==iBd;       
%         if length(rst(ix,1))<3
%             Traces(iBd,:,iR)=nan(1,length(rst(1,:)));
%             continue
%         end            
        Traces(iBd,:,ctr) = nanmean(rst(ix,:),1);%/bin*1000;
        cTraces(iBd,:,ctr) = nanmean(crst(ix,:),1);%/bin*1000;
        trCtr(ctr,iBd) = sum(ix);
        trMb(ctr,iBd) = median(mb(ix));
    end
end
col = CambridgeDark(nq);

figure
for iBd = 1:nq%     
    if zsc
        Traces = zscore(Traces,0,[2]);
    end

%         sitBdTrc(:,iBd,:) = nanmean(Traces(iBd,npre+cc1:npre+cc2,:));
%         sitBdMb(:,iBd,:) = repmat(iBd,length(sitBdTrc(:,1)),1);
    TRC(:,:) = Traces(iBd,npre+cc1:npre+cc2,:);
    sitBdTrc(:,iBd) = WeightedMean(TRC,trCtr(:,iBd)');
    trc(:,:) = Traces(iBd,:,:);
    strc = smoothdata(trc',2,meth,sw);
    if ~zsc
        strc = strc./bin*1000;
    end
    xax = (0:(npost+npre))- npre;
%     [lnn]=plot_error_lines(strc,'SEM',xax,col(iBd,:));
%     lns(iBd,:) = lnn(2,:);
    mtrc = WeightedMean(strc,trCtr(:,iBd));
    plot(xax,mtrc,'Color',col(iBd,:),'LineWidth',2)    
    lns(iBd,:) = mtrc;

    hold on
    smooth_trace(iBd,:,:)=strc';
end
g=gca;
ShadedBox([cc1 cc2],g.YLim)
pubify_figure_axis_robust
% xticks([-npre:300:npost])
xlim([-npre npost]);
yl = [min(min(lns)) max(max(lns))];
if yl(2)==0
    yl(2)=.1;
end
ylim(yl);
xlim([-200,700]);

legend
% 
if nq>2
%     [anv.p,anv.tbl,anv.stats] = anova1(sitBdTrc);
    [anv.p,tbl,anv.stats] = kruskalwallis(sitBdTrc);
    anv.mc = multcompare(anv.stats);
    title(['Anova | ',num2str(anv.p)])
else
    [p,h] = signrank(sitBdTrc(:,1),sitBdTrc(:,nq));
    title(['Wilcoxon | ',num2str(p)])
end


figure;
for i = 1:nq
subplot(nq,1,i)
mmb = trMb(:,i);
[~,sx]=sort(mmb);
tc(:,:) = smooth_trace(i,:,sx);

if zsc
imagesc(xax,[1:length(sRES)],tc',[0.02 .4])
else
imagesc(xax,[1:length(sRES)],tc',[3 20])
end

pubify_figure_axis_robust
title(i)

end
colormap('turbo');
%%
%%
%%
%%

[~,numBin,~] = size(fr);
bin = num_msec/numBin;
% zfr = Z_scores_DH(fr);%,[((pre-990)/bin):((pre)/bin)]);
% zfr = Z_scores_control_data(fr,ctd,[((pre-500)/bin):((pre)/bin)]);
zfr = zscore(fr,0,2);%
% zfr = fr;%-nanmean(ctd(:,((pre-990)/bin):((pre)/bin)),2);
% % 
szfr = smoothdata(zfr,2,'gaussian',15);
% szfr = smoothdata(zfr,2,'movmean',7);
% szfr = zfr;

x = (((1:numBin)-.5)*bin)-pre;
% 
% ix1 = find(x>=100,1,'first');
% ix2 = find(x<=250,1,'last');
% 
ix1 = round((pre+200)/bin);%100
ix2 = round((pre+500)/bin);%400

tix1 = (ix1*bin)-pre;
tix2 = (ix2*bin)-pre;


figure
col = lines(numQuants);
y1 = min(min(nanmean(szfr)))-.01;
y2 = max(max(nanmean(szfr)));
xptch = [tix1 tix2 tix2 tix1];
yptch = [y1   y1   y2   y2];
patch(xptch,yptch,'b','FaceColor','k','FaceAlpha',.075,'EdgeColor','none');
hold on
for i= 1:numQuants
% plot_error_lines(szfr(:,:,i),'SEM',x,col(i,:));
plot(x,nanmean(szfr(:,:,i)),'color',col(i,:),'LineWidth',2);

mzfr(i,:) = nanmean(szfr(:,(pre/bin):ix2,i));
hold on
end
legend
g=gca;
g.YLim = [min(min(mzfr))-.01 max(max(mzfr))+.01];
g.XLim = [-150 650];
pubify_figure_axis
%% ANOVA
mfr=[];
mfr(:,1:numQuants) = mean(zfr(:,ix1:ix2,:),2);
% [p,tbl,stats] = anova1(mfr);
% multcompare(stats,'CType','hsd')
% % 
% % [h,p,ci,stats] = ttest(mfr(:,1),mfr(:,2))
% [p,h,stats] = signrank(mfr(:,1),mfr(:,2))
% [p,h,stats] = ranksum(mfr(:,1),mfr(:,2))
% 

[p,tbl,stats] = kruskalwallis(mfr)
multcompare(stats,'CType','bonferroni')

% [p,tbl,stats] =friedman(mfr,1,'on')
% figure
% multcompare(stats,'CType','hsd')

%%
figure
for i= 1:numQuants
% plot(x,ctd(:,:,i),'color',col(i,:))
plot(x,nanmean(ctd(:,:,i)),'color',col(i,:),'LineWidth',2);

hold on
end
pubify_figure_axis

%% f
lmh = {'low' 'mid' 'high'};
for ii=1:numQuants
figure
imagesc(zfr(:,:,ii))
title(lmh{ii})
colorbar
g=gca;
g.CLim = [0 1];
end
% hold on
% 
% g=gca;
% line([((pre-500)/bin) ((pre-200)/bin)],[g.YLim(2)-.5 g.YLim(2)-.5],'color','r','linewidth',2)



%%
%     edgs=linspace(min(mb),max(mb),nq+1);%***V

%     edgs=linspace(min(stmb)+(std(stmb)*1),max(stmb)-(std(stmb)*1),nq+1);
%     edgs=linspace(min(stmb)-(std(stmb)*1),max(stmb)+(std(stmb)*1),nq+1);
%     edgs=linspace(0,100,nq+1);
%     edgs=quantile(stmb,nq+1,'method','approximate');
%     edgs=quantile(mb,nq+1,'method','approximate');