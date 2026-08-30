% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')
clear;ca;

%
d = DropboxDir;
dt = date;

monk='Uly';

RES = LoadMonkDataBDM(monk);
RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
RES=RES(RESix);


%%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%
%%
%%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%%

clearvars -except RES monk ts td savDir test_sit d dt
pre = 2000;
post = 2000;
num_msec = pre+post;

pop = 0;
bin = 1;
nq = 10;
test_sit = 1:3;
num_splits = 3; %number of splits for PETH traces
smeth = 'movmean';
%%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%%


%%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%%%%%
if strcmp(monk,'Uly')
    cc1=180;%%%%%%%%%%%%%%%%%%    CHANGE BACK   %%%%%%%%%%%%%%%%%
    cc2=340;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     cc1=180;
    %     cc2=340;
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%    CHANGED 01Feb2022   %%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     cc1=145;
    %     cc2=395;
end
% Vic alt win 140:230
%%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%%%%%


%%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%
bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardTapUp' 'BudgetTapUp'};
testBit = 'FractalDisplayUp';
sigbit = testBit;
%%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
col = CambridgeDark(3);

numBin = (pre+post)/bin;
x = (((1:numBin)-.5)*bin)-pre;


nanix=zeros(length(RES),1);
p=[];r=[];fr=[];zfr=[];
for i = 1:length(RES)
    if isnan(RES(i).rast.(sigbit))
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double(RES(i).event.monkeybid);
        cb = double(RES(i).event.computerbid);
        %         fr = RES(i).FR.(sigbit);
        sits = double(RES(i).event.situations);
        
        rst = double(RES(i).rast.(testBit));
        %         rst = zscore(RES(i).rast.(testBit),0,[2]);
        
        mid_sits = ismember(sits,test_sit);
        rst = rst(mid_sits,:);
        mb =  mb(mid_sits);
        
        if isempty(mb)
            continue
        end
        
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

sig_cells_p =  p(p<0.05&b>0 | p_bin<0.05&b_bin>0);

%%
ca
nspl = 10;


SigCtr = 0;ctr=0;
if pop
    sRES =RES;
else
    sRES = RES(sigix);
end


p=[];r=[];fr=[];zfr=[];
fr_tot1 = [];
fr_tot2 = [];
fr_dif_tot=[];
H=[];
lml=[];
mhm=[];
lhl=[];
lmm=[];
mhh=[];
lhh=[];
hdif=[];mdif=[];ldif=[];
MB = [];
SITS = [];
FR = [];
for i = 1:length(sRES)
    OLz = [1 2;2 3;1 3];
    fr_cell1 = [];
    fr_cell2 = [];
    fr_dif=[];
    cH = [];
    for iOL = 1:length(OLz(:,1))
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double(sRES(i).event.monkeybid);
        cb = double(sRES(i).event.computerbid);
        %         fr = RES(i).FR.(sigbit);
        sits = double(sRES(i).event.situations);
        
        rst = sRES(i).rast.(testBit);
        %                 rst = zscore(sRES(i).rast.(testBit),0,[2]);
        fr = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
        fr = zscore(fr);
        
        
        Oix = ismember(sits,OLz(iOL,:));
        mb=mb(Oix);
        rst = rst(Oix,:);
        sits = sits(Oix);
        stix1 = ismember(sits,OLz(iOL,1));
        stix2 = ismember(sits,OLz(iOL,2));
        olBids = round([min(mb(stix2)),max(mb(stix1))]./nspl).*nspl;
        
        if numel(olBids)<2 || numel(unique(olBids))<2
            continue
        end
        
        edgs = linspace(olBids(1),olBids(2),range(olBids)/nspl+1);
        edgs = sort(edgs);
        [~,~,bn] = histcounts(mb,edgs);
        
        for iB = 1:range(olBids)/nspl
            olix=[];fr1=[];fr2=[];
            olix = bn==iB;
            fr1(iB,1) = mean(fr(stix1&olix),'omitnan');
            fr2(iB,1) = mean(fr(stix2&olix),'omitnan');
            fld= num2str(iOL);
            un=[];du=[];
            if iOL==1
                un=[];du=[];
                un = mean(fr(stix1&olix),'omitnan');
                du = mean(fr(stix2&olix),'omitnan');;
                [un,du] = nan_fill(un,du);
                lml = [lml;un];
                lmm = [lmm;du];
                ldif = [ldif;du-un];
            elseif iOL ==2
                un=[];du=[];
                un = mean(fr(stix1&olix),'omitnan');
                du = mean(fr(stix2&olix),'omitnan');;
                [un,du] = nan_fill(un,du);
                mhm = [mhm;un];
                mhh = [mhh;du];
                mdif = [mdif;du-un];
            elseif iOL ==3
                un=[];du=[];
                un = mean(fr(stix1&olix),'omitnan');
                du = mean(fr(stix2&olix),'omitnan');;
                [un,du] = nan_fill(un,du);
                lhl = [lhl;un];
                lhh = [lhh;du];
                hdif = [hdif;du-un];
            end
        end
        
        if numel(fr1)>3 && numel(fr2)>3
            [p,h] = ranksum(fr1,fr2);
        else
            h=0;
        end
        
        
        cH = [cH;h];
        
        %         [fr1,fr2] = nan_fill(fr1,fr2);
        
        %         Plot_Bars_SEM([fr1,fr2])
        %         xticklabels([sum(~isnan(fr1)),sum(~isnan(fr2))])
        %         title(OLz(iOL,:))
        
        fr_cell1 = [fr_cell1;fr1];
        fr_cell2 = [fr_cell2;fr2];
        fr_dif = [fr_dif;fr2-fr1];
        %         p
        ca
        
        MB = [MB;mb];
        SITS = [SITS;sits];
        FR = [FR;fr];
    end
    if sum(cH)>0
        H=[H;1];
    else
        H=[H;0];
    end
    fr_tot1 = [fr_tot1;fr_cell1];
    fr_tot2 = [fr_tot2;fr_cell2];
    fr_dif_tot = [fr_dif_tot;fr_dif];
    ca
end

% l1 = numel(fr_tot1);
% l2 = numel(fr_tot2);
% [oix] = isoutlier([fr_tot1;fr_tot2]);
% fr_tot1 = fr_tot1(~oix(1:l1));
% fr_tot2 = fr_tot2(~oix(l1+1:end));

[p,h] = signrank(fr_tot1,fr_tot2);

[fr_tot1,fr_tot2] = nan_fill(fr_tot1,fr_tot2);

col = CB_reds(3);

figure
% Plot_Bars_SEM([fr_tot1,fr_tot2])
% boxplot([fr_tot1,fr_tot2])
Plot_Mean_SEM_All_Points([fr_tot1,fr_tot2])
% pubify_figure_axis_robust

xticklabels([sum(~isnan(fr_tot1)),sum(~isnan(fr_tot2))])
title(p)

p1 = signrank(lml,lmm);
p2 = signrank(mhm,mhh);
p3 = signrank(lhl,lhh);

% p1 = ranksum(lml,lmm);
% p2 = ranksum(mhm,mhh);
% p3 = ranksum(lhl,lhh); %% I dont think ranksum is the correct test here
%
%
% [lml,lmm] = nan_fill(lml,lmm);
% [mhm,mhh] = nan_fill(mhm,mhh);
% [lhl,lhh] = nan_fill(lhl,lhh);

figure
% boxplot([lml,lmm])
% Plot_Bars_SEM([lml,lmm])
subplot(1,3,1)
Plot_Mean_SEM_All_Points([lml,lmm],col(1:2,:))
xticklabels([sum(~isnan(lml)),sum(~isnan(lmm))])
g=gca;
title(['Sit 1:2 | p = ',num2str(p1)])
pubify_figure_axis_robust
g.XLim = [0.5 2.5];


% boxplot([mhm,mhh])
% Plot_Bars_SEM([mhm,mhh])
subplot(1,3,2)
Plot_Mean_SEM_All_Points([mhm,mhh],col(2:3,:))
xticklabels([sum(~isnan(mhm)),sum(~isnan(mhh))])
g=gca;
title(['Sit 2:3 | p = ',num2str(p2)])
pubify_figure_axis_robust
g.XLim = [0.5 2.5];


% boxplot([lhl,lhh])
% Plot_Bars_SEM([lhl,lhh])
subplot(1,3,3)
Plot_Mean_SEM_All_Points([lhl,lhh],col([1 3],:))
xticklabels([sum(~isnan(lhl)),sum(~isnan(lhh))])
g=gca;
title(['Sit 1:3 | p = ',num2str(p3)])
pubify_figure_axis_robust
g.XLim = [0.5 2.5];

%%
p1 = signrank(lmm-lml);
p2 = signrank(mhh-mhm);
p3 = signrank(lhh-lhl);

%
% [lml,lmm] = nan_fill(lml,lmm);
% [mhm,mhh] = nan_fill(mhm,mhh);
% [lhl,lhh] = nan_fill(lhl,lhh);

col = CB_reds(3);

figure
% boxplot([lml,lmm])
% Plot_Bars_SEM([lml,lmm])
lmh_dif=nan_fill_cell2mat({ldif,mdif,hdif});
Plot_Mean_SEM_All_Points(lmh_dif,col)
xticklabels([sum(~isnan(ldif)),sum(~isnan(mdif)),sum(~isnan(hdif))])
title(['Sit 1:2 | p = ',num2str(p1),'  Sit 2:3 | p = ',num2str(p2),'  Sit 1:3 | p = ',num2str(p3)])
pubify_figure_axis_robust

%
% figure
% boxplot([mhm,mhh])
% Plot_Bars_SEM([mhm,mhh])
% Plot_Mean_SEM_All_Points(mdif)
% xticklabels(sum(~isnan(mdif)))
% title(['Sit 2:3 | p = ',num2str(p2)])
% pubify_figure_axis_robust
%
% figure
% boxplot([lhl,lhh])
% Plot_Bars_SEM([lhl,lhh])
% Plot_Mean_SEM_All_Points(hdif)
% xticklabels(sum(~isnan(hdif)))
% title(['Sit 1:3 | p = ',num2str(p3)])
% pubify_figure_axis_robust

%%
bs = 50;
figure;
subplot(1,3,1);histogram(MB(SITS==1),bs)
subplot(1,3,2);histogram(MB(SITS==2),bs)
subplot(1,3,3);histogram(MB(SITS==3),bs)
title('BIDS')


figure;
subplot(1,3,1);histogram(FR(SITS==1),bs)
subplot(1,3,2);histogram(FR(SITS==2),bs)
subplot(1,3,3);histogram(FR(SITS==3),bs)
title('FR_SITS')

figure;
subplot(1,3,1);histogram(FR(MB>0&MB<=33),bs)
subplot(1,3,2);histogram(FR(MB>33&MB<=66),bs)
subplot(1,3,3);histogram(FR(MB>66&MB<=100),bs)
title('FR_BIDS')


mean(FR(MB>0&MB<=33))
mean(FR(MB>33&MB<=66))
mean(FR(MB>66&MB<=100))

mean(FR(SITS==1))
mean(FR(SITS==2))
mean(FR(SITS==3))

WideFigs
%%
% oops = [573 730 888];
% % nq=10;
%
%
% SigCtr = 0;ctr=0;
% if pop
%     sRES =RES;
% else
%     sRES = RES(sigix);
% end
%
%
% p=[];r=[];fr=[];zfr=[];
% fr_tot1 = [];
% fr_tot2 = [];
% H=[];
% for i = 1:length(sRES)
%
%     OLz = [1 2;2 3;1 3];
%     fr_cell1 = [];
%     fr_cell2 = [];
%     cH = [];
%     for iOL = 1:length(OLz(:,1))
%         mb=[];fr=[];frb=[];mmb=[];bix=[];
%         mb = sRES(i).event.monkeybid;
%         cb = sRES(i).event.computerbid;
%         %         fr = RES(i).FR.(sigbit);
%         sits = sRES(i).event.situations;
%
%         rst = sRES(i).rast.(testBit);
%         %         rst = zscore(RES(i).rast.(testBit),0,[2]);
%
%         Oix = ismember(sits,OLz(iOL,:));
%         mb=mb(Oix);
%         rst = rst(Oix,:);
%         sits = sits(Oix);
%         stix1 = ismember(sits,OLz(iOL,1));
%         stix2 = ismember(sits,OLz(iOL,2));
%         olBids = [min(mb(stix2)),max(mb(stix1))];
%
%         if numel(olBids)<2 || sum(stix1)<2
%             continue
%         end
%
%         frix1 = stix1 & mb>olBids(1) & mb<olBids(2);
%         frix2 = stix2 & mb>olBids(1) & mb<olBids(2);
%         if sum(frix1)<3 || sum(frix2)<3
%             continue
%         end
%
%         fr = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
%
%         fr = zscore(fr);
%
%         fr1 = fr(frix1);
%         fr2 = fr(frix2);
%
%         [p,h] = ranksum(fr1,fr2);
%
%         cH = [cH;h];
%
%         [fr1,fr2] = nan_fill(fr1,fr2);
%
% %         Plot_Bars_SEM([fr1,fr2])
% %         xticklabels([sum(~isnan(fr1)),sum(~isnan(fr2))])
% %         title(OLz(iOL,:))
%
%         fr_cell1 = [fr_cell1;fr1];
%         fr_cell2 = [fr_cell2;fr2];
% %         p
%         ca
%     end
%     if sum(cH)>0
%         H=[H;1];
%     else
%         H=[H;0];
%     end
%     fr_tot1 = [fr_tot1;fr_cell1];
%     fr_tot2 = [fr_tot2;fr_cell2];
%
%     ca
% end
%
% % l1 = numel(fr_tot1);
% % l2 = numel(fr_tot2);
% % [oix] = isoutlier([fr_tot1;fr_tot2]);
% % fr_tot1 = fr_tot1(~oix(1:l1));
% % fr_tot2 = fr_tot2(~oix(l1+1:end));
%
% [p,h] = ranksum(fr_tot1,fr_tot2);
%
% [fr_tot1,fr_tot2] = nan_fill(fr_tot1,fr_tot2);
%
% figure
% Plot_Bars_SEM([fr_tot1,fr_tot2])
% % boxplot([fr_tot1,fr_tot2])
%
% xticklabels([sum(~isnan(fr_tot1)),sum(~isnan(fr_tot2))])
% title(p)
