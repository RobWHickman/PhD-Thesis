% Code used to generate figure 4a-e

%%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%
clear;ca;

monk='Uly';% Change this to 'Uly' or 'Vic' to analyze data from monkey U or monkey V, respectively. 

RES = LoadMonkDataBDM(monk); %this will need to be modifed to reflect the location of the data on the user's computer
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
    cc1=180;%%%%%%%%%%%%%%%%%%   
    cc2=340;%%%%%%%%%%%%%%%%%%
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%
end
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
        sits = double(RES(i).event.situations);
        
        rst = double(RES(i).rast.(testBit));
        
        mid_sits = ismember(sits,test_sit);
        rst = rst(mid_sits,:);
        mb =  mb(mid_sits);
        
        if isempty(mb)
            continue
        end
        
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

sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;

sum(sigix)

sig_cells_p =  p(p<0.05&b>0 | p_bin<0.05&b_bin>0);

%% average firing per bid chunk
ca
nspl = 10;

SigCtr = 0;ctr=0;
if pop
    sRES =RES;
else
    sRES = RES(sigix);
end


p=[];r=[];fr=[];zfr=[];fr_tot1 = [];fr_tot2 = [];fr_dif_tot=[];H=[];lml=[];
mhm=[];lhl=[];lmm=[];mhh=[];lhh=[];lN=[];mN=[];hN=[];hdif=[];mdif=[];ldif=[];
MB = [];SITS = [];FR = [];
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
        olBids = round([min([mb(stix2);mb(stix1)]),max([mb(stix1);mb(stix2)])]./nspl).*nspl;
        
        if numel(olBids)<2 || numel(unique(olBids))<2
            continue
        end
        if olBids(1)==0;olBids(1)=1;end
        if olBids(2)==100;olBids(2)=99;end
        edgs = floor(linspace(olBids(1),olBids(2),range(olBids)/nspl))+.5;
        edgs = sort(edgs);
        [~,~,bn] = histcounts(mb,edgs);
                
        for iB = 1:range(olBids)/nspl
            olix=[];fr1=[];fr2=[];n1=[];n2=[];
            olix = bn==iB;
            fr1(iB,1) = mean(fr(stix1&olix),'omitnan');
            fr2(iB,1) = mean(fr(stix2&olix),'omitnan');
            n1 = sum(stix1&olix);
            n2 = sum(stix2&olix);           
            fld= num2str(iOL);
            un=NaN;du=NaN;
            un = mean(fr(stix1&olix),'omitnan');
            du = mean(fr(stix2&olix),'omitnan');
            if isnan(un) || isnan(du)
                continue
            end
            if iOL==1               
                lml = [lml;un];
                lmm = [lmm;du];
                ldif = [ldif;du-un];
                lN = [lN;n1,n2];
            elseif iOL ==2
                mhm = [mhm;un];
                mhh = [mhh;du];
                mdif = [mdif;du-un];
                mN = [mN;n1,n2];
            elseif iOL ==3
                lhl = [lhl;un];
                lhh = [lhh;du];
                hdif = [hdif;du-un];
                hN = [hN;n1,n2];
            end
        end

        if numel(fr1)>3 && numel(fr2)>3
            [p,h] = ranksum(fr1,fr2);
        else
            h=0;
        end
             
        
        cH = [cH;h];
        
         
        fr_cell1 = [fr_cell1;fr1];
        fr_cell2 = [fr_cell2;fr2];
        fr_dif = [fr_dif;fr2-fr1];
        
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

p1 = signrank(lml,lmm);
p2 = signrank(mhm,mhh);
p3 = signrank(lhl,lhh);


figure
subplot(1,3,1)
Plot_Mean_SEM_All_Points([lml,lmm],col(1:2,:))
xticklabels([sum(~isnan(lml)),sum(~isnan(lmm))])
g=gca;
title(['Sit 1:2 | p = ',num2str(p1)])
pubify_figure_axis_robust
g.XLim = [0.5 2.5];


subplot(1,3,2)
Plot_Mean_SEM_All_Points([mhm,mhh],col(2:3,:))
xticklabels([sum(~isnan(mhm)),sum(~isnan(mhh))])
g=gca;
title(['Sit 2:3 | p = ',num2str(p2)])
pubify_figure_axis_robust
g.XLim = [0.5 2.5];


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


col = CB_reds(3);

figure
lmh_dif=nan_fill_cell2mat({ldif,mdif,hdif});
Plot_Mean_SEM_All_Points(lmh_dif,col)
xticklabels([sum(~isnan(ldif)),sum(~isnan(mdif)),sum(~isnan(hdif))])
title([monk,' | Sit 1:2 | p = ',num2str(p1),'  Sit 2:3 | p = ',num2str(p2),'  Sit 1:3 | p = ',num2str(p3)])
pubify_figure_axis_robust


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
ca
nspl = 5;
pop=0;

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
lN=[];mN=[];hN=[];
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
        olBids = round([min([mb(stix2);mb(stix1)]),max([mb(stix1);mb(stix2)])]./nspl).*nspl;
        
        if numel(olBids)<2 || numel(unique(olBids))<2
            continue
        end
        if olBids(1)==0;olBids(1)=1;end
        if olBids(2)==100;olBids(2)=99;end
        edgs = floor(linspace(olBids(1),olBids(2),range(olBids)/nspl))+.5;
        edgs = sort(edgs);
        [~,~,bn] = histcounts(mb,edgs);
        cellrst1=[];cellrst2=[]; bdrst1=[];bdrst2=[];
        mcellrst1=[];mcellrst2=[]; mbdrst1=[];mbdrst2=[];

        MB1=[];MB2=[];
        for iB = 1:range(olBids)/nspl
            olix=[];fr1=[];fr2=[];n1=[];n2=[];
            olix = bn==iB;
            if sum(stix1&olix)==0 || sum(stix2&olix)==0
                continue
            end

            bdrst1 = rst(stix1&olix,:);
            bdrst2 = rst(stix2&olix,:);
            cellrst1 = [cellrst1;bdrst1];
            cellrst2 = [cellrst2;bdrst2];
            mbdrst1 = mean(rst(stix1&olix,:),1,'omitnan');
            mbdrst2 = mean(rst(stix2&olix,:),1,'omitnan');
            mcellrst1 = [mcellrst1;mbdrst1];
            mcellrst2 = [mcellrst2;mbdrst2];
                       
            
            MB1 = [MB1;mb(stix1&olix)];
            MB2 = [MB2;mb(stix2&olix)];

            n1 = sum(stix1&olix);
            n2 = sum(stix2&olix);
            fld= num2str(iOL);
            
        end
        if isempty(cellrst1)||isempty(cellrst2)
            continue
        end
        if abs(diff([length(cellrst1(:,1)),length(cellrst2(:,1))]))>3
            continue
        end
        
        % test if fr is different between rew. mags. 
        fr1 = mean(cellrst1(:,pre+cc1:pre+cc2),2);
        fr2 = mean(cellrst2(:,pre+cc1:pre+cc2),2);
        h=[];p=[];
        [fr1,fr2]=nan_fill(fr1,fr2);
        [p,h] = signrank(fr1,fr2);
        
        % test if bid dist is different between rew. mags. 
        [MB1nn,MB2nn] = nan_fill(MB1,MB2);
        [bds_p,bds_h] = signrank(MB1nn,MB2nn);
        
        MBall = [MB1nn;MB2nn];
        FRall = [fr1;fr2];
        [rc,pc] = corr(MBall,FRall,'rows','complete');
        
        if  numel(fr1)>9  %&& ~bds_h
            figure
            subplot(2,1,1)
            scl = [0 100];
            imagesc(MB1,scl)
            mp = colormap('hot');
            fmp = flipud(mp);
            colormap(fmp)
            set(gca,'Ydir','normal')
            
            subplot(2,1,2)
            imagesc(MB2,scl)
            colormap(fmp)
            set(gca,'Ydir','normal')
            
            
            figure
            rix = [1500:3000];
            pree = 500;
            subplot(8,1,1:3)
            PlotTrueRaster(cellrst1(:,rix),[0 0 .5])
            xticklabels([])
            axis tight
            cmp = OLz(iOL,:);
            FigureTitle([num2str(cmp),' | ',num2str(p)])
            
            
            subplot(8,1,4:6)
            PlotTrueRaster(cellrst2(:,rix),[.5 0 0])
            xticklabels([])
            axis tight
            
            
            xax = (1:length(rix))-pree;
            subplot(8,1,7:8)
            cr1s = smoothdata(mean(smoothdata(cellrst1(:,rix),2,'movmean',100),'omitnan'),2,'movmean',30)*1000;
            cr2s = smoothdata(mean(smoothdata(cellrst2(:,rix),2,'movmean',100),'omitnan'),2,'movmean',30)*1000;
%             cr1s = mean(smoothdata(cellrst1(:,rix),2,'movmean',50),'omitnan')*1000;
%             cr2s = mean(smoothdata(cellrst2(:,rix),2,'movmean',50),'omitnan')*1000;
%             cr1s = mean(cellrst1(:,rix),'omitnan')*1000;
%             cr2s = mean(cellrst2(:,rix),'omitnan')*1000;

            plot(xax,cr1s,'Color',[0 0 .5])
            hold on
            plot(xax,cr2s,'Color',[.5 0 0])
            
            pubify_figure_axis_robust
            
           
            
            % pseudo-raster of perfectly matched bids
            
            if 0
            rix = [1500:3000];
            pree =500;
            figure;
            scl = [min(min(mcellrst1(:,rix))) max(max(mcellrst1(:,rix)))];
            subplot(8,1,1:3);imagesc(mcellrst1(:,rix),scl)
            scl = [min(min(mcellrst2(:,rix))) max(max(mcellrst2(:,rix)))];
            subplot(8,1,4:6);imagesc(mcellrst2(:,rix),scl)
            xax = (1:length(rix))-pree;
            subplot(8,1,7:8)
            plot(xax,smoothdata(mean(smoothdata(mcellrst1(:,rix),2,'movmean',100),'omitnan'),2,'movmean',30),'Color',[0 0 .5])
            hold on
            plot(xax,smoothdata(mean(smoothdata(mcellrst2(:,rix),2,'movmean',100),'omitnan'),2,'movmean',30),'Color',[.5 0 0])
            end
            
            
            mfr1=[];mfr2=[];mrst1=nan(100,4000);mrst2=nan(100,4000);
            for iB = 1:101
                if any(MB1==iB-1) && any(MB2==iB-1)
                    
                    mfr1(iB) = mean(fr1(MB1==iB-1),'omitnan');
                    mfr2(iB) = mean(fr2(MB2==iB-1),'omitnan');
                    mrst1(iB,:) = mean(cellrst1(MB1==iB-1,:),'omitnan');
                    mrst2(iB,:) = mean(cellrst2(MB2==iB-1,:),'omitnan');
                end
            end
                        
            mrst1nn = mrst1(~isnan(mrst1(:,1)),:);
            mrst2nn = mrst2(~isnan(mrst2(:,1)),:);
            if 0 %length(mrst1nn(:,1))>5
            rix = [1500:3000];
            pree =500;
            figure;
            scl = [-.1 .5];
            subplot(8,1,1:3);imagesc(mrst1nn(:,rix),scl)
            subplot(8,1,4:6);imagesc(mrst2nn(:,rix),scl)
            colormap('bone')
            xax = (1:length(rix))-pree;
            subplot(8,1,7:8)
            plot(xax,smoothdata(mean(smoothdata(mrst1nn(:,rix),2,'movmean',100),'omitnan'),2,'movmean',30),'Color',[0 0 .5])
            hold on
            plot(xax,smoothdata(mean(smoothdata(mrst2nn(:,rix),2,'movmean',100),'omitnan'),2,'movmean',30),'Color',[.5 0 0])
            end
            
            ca
        end
        
        % test if fr/bid dist. is different between rew. mags. for
        % perfectly matched bids
        
        
        [umb1] = unique(MB1);
        [umb2] = unique(MB2);
        pm = ismember(umb1,umb2);
        pm1 = umb1(pm);
        pm2 = umb2(ismember(umb2,pm1));
        
        pmix1 = ismember(MB1,pm1);
        pmix2 = ismember(MB2,pm1);
        
        MBpm1 = MB1(pmix1);
        MBpm2 = MB2(pmix2);
        
        if sum(pmix1)<5 || sum(pmix2)<5
            continue
        end
        
        fr1 = mean(cellrst1(pmix1,pre+cc1:pre+cc2),2);
        fr2 = mean(cellrst2(pmix2,pre+cc1:pre+cc2),2);
        hm=[];p=[];
        
        hm=[];p=[];
        [fr1,fr2]=nan_fill(fr1,fr2);        
        [p,hm] = signrank(fr1,fr2);
              
        [MB1nn,MB2nn] = nan_fill(MB1(pmix1),MB2(pmix2));
        [bds_p,bds_h] = signrank(MB1nn,MB2nn);
        
  
        if  h && ~bds_h
            figure
            subplot(8,1,1:3)
            PlotTrueRaster(cellrst1(pmix1,:),[0 0 .5])
            axis tight
            title(p)
            subplot(8,1,4:6)
            PlotTrueRaster(cellrst2(pmix2,:),[.5 0 0])
            axis tight
            
            
            subplot(8,1,7:8)
            plot(mean(smoothdata(cellrst1(pmix1,:),2,'movmean',80),'omitnan'))
            hold on
            plot(mean(smoothdata(cellrst2(pmix2,:),2,'movmean',80),'omitnan'))
            
            ca
        end
        
        
    end
end