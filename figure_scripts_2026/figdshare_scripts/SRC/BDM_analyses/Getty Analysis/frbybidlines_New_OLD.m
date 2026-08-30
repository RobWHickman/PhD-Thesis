ca;clear;
d = DropboxDir;
% load([d,'\Schultz_Lab\BDM_Data\Uly_Data\ANALYSIS_11-Nov-2021\GettyBidRegressionWithClustersRobust_10Hz\Uly_cells_sits_1  2  3.mat'])
load([d,'\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_11-Nov-2021\GettyBidRegressionWithClustersRobust_10Hz\Vic_cells_sits_1  2  3.mat'])
%%
% ca
pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];
% 
bin=1;

% cc1=180;
% cc2=340;
cc1=145;
cc2=395;

% % % Vic alt win 140:230

% ix = logical(ones(length(RES),1));
% ix(13)=0;
% RES=RES(ix);
%
bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
testBit = 'FractalDisplayUp';
sigbit = testBit;
nq=10;

nanix=zeros(length(RES),1);
p=[];r=[];
for i = 1:length(RES)
    if isnan(RES(i).(sigbit)) 
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = RES(i).(sigbit)(:,3);
        cb = RES(i).(sigbit)(:,7);
        fr = RES(i).(sigbit)(:,1); 
        rst = RES(i).rast.(testBit);
%         rst = zscore(RES(i).rast.(testBit),0,[2]);

        fr = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;

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
clearvars -except RES sigix bin cc1 cc2 testBit
ca
sw = 70;
meth  ='movmean';
pre = 2000;
npre = 500;
npost = 1000;

zsc =1;
wl=2;
nq=3;
testSit = 2;

% sRES = RES;
sRES = RES(sigix);
for iR = 1:length(sRES)
    
    mb = sRES(iR).(testBit)(:,3);
    cb = sRES(iR).(testBit)(:,7);
    sits = sRES(iR).(testBit)(:,5);
    rst = sRES(iR).rast.(testBit)(:,(pre-npre)/bin:(pre+npost)/bin);  
    crst = sRES(iR).rast.FixationCrossUp(:,(pre-npre)/bin:(pre+npost)/bin);  
    
    if numel(unique(sits))<3 && ~all(testSit==2)
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
%     fr = mean(rst(:,(npre+cc1)/bin:(npre+cc2)/bin),2)/bin*1000;

    
%     ca;plot(smoothdata(mean(crst),2,'gaussian',100))

%     if isempty(stmb) || all(unique(sits)==2)
%         continue
%     end

    edgs=linspace(min(stmb),max(stmb),nq+1);%***
%     edgs=linspace(min(mb),max(mb),nq+1);

%     edgs=linspace(min(stmb)+(std(stmb)*.5),max(stmb)-(std(stmb)*.5),nq+1);
%     edgs=linspace(min(stmb)-(std(stmb)*1),max(stmb)+(std(stmb)*1),nq+1);
%     edgs=linspace(0,100,nq+1);
%     edgs=quantile(stmb,nq+1,'method','approximate');
%     edgs=quantile(mb,nq+1,'method','approximate');

    [nbidsPerBin,~,bnix] = histcounts(stmb,edgs);
    
%     if zsc
% %         rst = Z_scores_control_data(rst,crst,npre-npre+1:npre);
%         rst = zscore(rst,0,2);
%     end
    for iBd = 1:nq
        ix = bnix==iBd;
        Traces(iBd,:,iR) = nanmean(rst(ix,:),1);%/bin*1000;
        cTraces(iBd,:,iR) = nanmean(crst(ix,:),1);%/bin*1000;
        trCtr(iR,iBd) = sum(ix);
%         trMb(iR,iBd) = mb(ix);
    end
    
end
col = CambridgeDark(nq);

figure
for iBd = 1:nq
     sitBdTrc(:,iBd,:) = nanmean(Traces(iBd,npre+cc1:npre+cc2,:));
    sitBdMb(:,iBd,:) = repmat(iBd,length(sitBdTrc(:,1)),1);
    trc(:,:) = Traces(iBd,:,:);
    strc = smoothdata(trc',2,meth,sw);
    if ~zsc
        strc = strc./bin*1000;
    end
    xax = (0:(npost+npre))- npre;
    [lnn]=plot_error_lines(strc,'none',xax,col(iBd,:));
    lns(iBd,:) = lnn(2,:);
    hold on
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

legend

if nq>2
    [anv.p,anv.tbl,anv.stats] = anova1(sitBdTrc);
    anv.mc = multcompare(anv.stats);
    title(['Anova | ',num2str(anv.p)])
else
    [p,h] = signrank(sitBdTrc(:,1),sitBdTrc(:,nq))
    title(['Wilcoxon | ',num2str(p)])
end
%% Sliding Window
ca;clearvars -except RES sigix
% ca
pre = 2000;
bin=1;
npre = 100;
npost = 700;
nbin = 100;

testSit = 1;
testBit = 'FractalDisplayUp';
% bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp',... 
% 'RewardTapUp' 'RewardEpochEndUp' 'BudgetTapUp'};
% 
sRES = RES;
% sRES = RES(sigix);
for iR = 1:length(sRES)
    mb = sRES(iR).(testBit)(:,3);
    sits = sRES(iR).(testBit)(:,5);
    rst = sRES(iR).rast.(testBit)(:,(pre-npre)/bin:(pre+npost)/bin);  
    crst = sRES(iR).rast.FixationCrossUp(:,(pre-npre)/bin:(pre+npost)/bin);
    %     rst(:,oops(testSit)-1:oops(testSit)+1) = zeros(length(rst(:,1)),3);%repmat(mean(mean(rast(:,1:50))),length(rast(:,1)),3);
    %     rst(:,oops(testSit)-2:oops(testSit)+2) = repmat(nanmean(rst(:,oops(testSit)-3:6:oops(testSit)+3),2),1,5);%repmat(mean(mean(rast(:,1:50))),length(rast(:,1)),3);
    
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
xax = (0:(npre+npost))-npre;
figure
plot_error_lines(smoothdata(r2,2,'gaussian',sw),xax)
figure
plot_error_lines(smoothdata(bta,2,'gaussian',sw),xax)

%%
%% Sit Trace
clearvars -except RES sigix bin cc1 cc2
testBit = 'FractalDisplayUp';
% ca
bin=1
zsc =1;
sw = 100;
pre = 2000;
npre = 200;
npost = 1000;

% cc1=145;
% cc2=395;
cc1=180;
cc2=340;

testSit = 1:3;

sRES = RES;
% sRES = RES(sigix);
for iR = 1:length(sRES)
    mb = sRES(iR).(testBit)(:,3);
    sits = sRES(iR).(testBit)(:,5);
    rst = sRES(iR).rast.(testBit)(:,(pre-npre)/bin:(pre+npost)/bin);  
    crst = sRES(iR).rast.FixationCrossUp(:,(pre-npre)/bin:(pre+npost)/bin);  
    for iS = 1:3    
        stix = ismember(sits,iS);
        stmb = mb(stix);
        sitrst = rst(stix,:);
%         crst = crst(stix,:);                
        %     if zsc
        %         rst = Z_scores_control_data(rst,crst,npre-npre+1:npre);
        % %         rst = zscore(rst,0,2);
        %     end
        Traces(iS,:,iR) = nanmean(sitrst,1);%/bin*1000;
        cTraces(iS,:,iR) = nanmean(crst,1);%/bin*1000;
    end
end
col = CambridgeLight(3);

figure
for iSt = 1:3
    trc = [];strc=[];
    if zsc        
        Traces = zscore(Traces,0,[1 2]);
    end
    sitBdTrc(:,iSt,:) = nanmean(Traces(iSt,npre+cc1:npre+cc2,:));
    trc(:,:) = Traces(iSt,:,:);
    strc = smoothdata(trc',2,'gaussian',sw);
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
% xticks([-npre:300:npost])
xlim([-npre npost]);
ylim([min(min(lns)) max(max(lns))]);

legend

Plot_Bars_SEM(sitBdTrc)
pubify_figure_axis_robust

[anv.p,anv.tbl,anv.stats] = anova1(sitBdTrc);
anv.mc = multcompare(anv.stats);
title(['Anova | ',num2str(anv.p)])
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



