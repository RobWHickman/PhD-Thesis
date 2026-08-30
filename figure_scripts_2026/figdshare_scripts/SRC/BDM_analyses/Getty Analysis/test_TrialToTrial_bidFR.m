ca;clear;
monk= 'Vic';
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
clearvars -except RES monk
% ca
pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];
%
bin=1;
sigOnly=1;

if strcmp(monk,'Uly')
    cc1=180;
    cc2=340;
    %     cc1=180;
    %     cc2=340;
elseif strcmp(monk,'Vic')
    %     cc1=100;%%%%%%%%%%%%%%%%%%    CHANGED 01Feb2022   %%%%%%%%%%%
    %     cc2=500;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
sigOnly=1;
if sigOnly
    sRES = RES(sigix);
else
    sRES = RES;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
swFR = 1;
bgs = 1;
zscr = 1;
smth = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p=[];r=[];abd=[];amb=[];aFR=[];FR=[];XC=[];ctr=0;
if exist('fg')
    clf
else
    fg=figure;
end
for iR = 1:length(sRES)
    FR=[];bd=[];mb=[];rst=[];xc=[];
    bd = double(sRES(iR).event.total_bid_duration);
    mb = double(sRES(iR).event.monkeybid);
    tn = double(sRES(iR).event.trialnums);
    st = double(sRES(iR).event.situations);
    
        [~,tn_ix] = sort(tn);
%     [~,tn_ix] = sortrows([st,tn],[1 2]);
    
    bds = bd(tn_ix)';
    mbs = mb(tn_ix)/100;
    tns = tn(tn_ix);
    sts = st(tn_ix);
    %     [sts,mbs,tns]
    
    rst = double(sRES(iR).rast.FractalDisplayUp);
    crst = double(sRES(iR).rast.FixationCrossUp);
    
    if swFR
        swRst=[];swcRst=[];
        for j = 1:width(rst)-100
            swRst(:,j) = (sum(rst(:,j:j+100),2,'omitnan')./100).*1000;
            swcRst(:,j) = (sum(crst(:,j:j+100),2,'omitnan')./100).*1000;

        end
        rst = swRst;
        crst = swcRst;

        % figure
        % imagesc(swRst)
        % colorbar
        % ca
    end
    if bgs
        rst = rst-mean(crst(:,pre-1000+1:pre),2,'omitnan');
    end
    
    %
    FR=[];
    %        FR = mean(rst(:,pre+cc1:pre+cc2),2);
    FR = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2,'omitnan')/bin*1000;
    
    if zscr
        FR = zscore(FR);
    end
    
    rsts = rst(tn_ix,:);
    FRs = FR(tn_ix);
    
    FRs_fs = MinMaxFS(FRs);
    mbs_fs = MinMaxFS(mbs);
    %     FRs_fs = FRs;
    %     mbs_fs = mbs;
    
    
    %     X = mbs/100;
    %     y = FRs;
    X = mbs_fs;
    y = FRs_fs;
    
    if smth > 0
        X = smoothdata(X,'gaussian',smth);
        y = smoothdata(y,'gaussian',smth);
    end
    
    X=X-mean(X);
    y=y-mean(y);
    
    intSz = .01;
    
    Xint=interp1(1:length(X),X,1:intSz:length(X),'spline');
    yint=interp1(1:length(y),y,1:intSz:length(y),'spline');

    
    xaxInt = 1:intSz:length(X);
    xax = 1:length(X);

    %     xax = tns;
    [r,p] = corr(X,y);
    [rint,pint] = corr(Xint',yint')
    
    bls = CB_blues(5);
    rds = CB_reds(3);
    bl = bls(3,:);
    rd= rds(3,:);
    

        if  (rint>.5 || r>.5) && (p<.05 || pint<.05)
            plot(xaxInt,yint,'color',rd)
            hold on;
            plot(xaxInt,Xint,'color',bl)
            plot(xax,y,'. ','color',rd)
            hold on;
            plot(xax,X,'. ','color',bl)
            title([r,p])
            clf
        end
    
    for iS=1:3
        %     ctr=ctr+1;
        stmb = mbs(sts==iS);
        stfr = FRs(sts==iS);
        stmbn = mbs_fs(sts==iS);
        stfrn = FRs_fs(sts==iS);
        if smth > 0
            stmb = smoothdata(stmb,'gaussian',smth);
            stfr = smoothdata(stfr,'gaussian',smth);
        end
        [xc(1,:),lags] = xcorr(stfr,stmb,20,'coeff');
        nxc = MinMaxFS(xc);
        if ~isempty(xc) && sum(xc)~=0
            XC = [XC;xc];
        end
    end
    
    %     [xc(iR,:),lags] = xcorr(y,X,20);
    %     [XC(iR,:),lags] = xcorr(FRs,mbs,20);
    
    %     plot(lags,xc)
    %     clf
    %
    abd = [abd;bd];
    amb = [amb;mb];
    aFR = [aFR;FR];
    
end

ca
badix = isnan(sum(XC,2))|sum(XC,2)==0;
XC = XC(~badix,:);
XC = zscore(XC,[],2);
figure
plot(lags,mean(XC,'omitnan'))
hold on
plot(lags,mean(XC,'omitnan')+Sem(XC))
plot(lags,mean(XC,'omitnan')-Sem(XC))

figure
imagesc(lags,1:height(XC),XC)
colormap(bone)
colorbar
hold on
g=gca;
line([0 0], g.YLim,'color','k')


l0=find(lags==0);

nlags = 3;
XCnlags = mean(XC(:,l0-nlags:l0-1),2,'omitnan');
XCplags = mean(XC(:,l0+1:l0+nlags),2,'omitnan');

figure
Plot_Mean_SEM_All_Points([XCnlags-XCplags])

figure
Plot_Points_Connecting_Lines(XCnlags,XCplags)
pSR = signrank(XCnlags-XCplags);
title(pSR)





