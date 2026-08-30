% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')
clear;ca;

%
d = DropboxDir;
dt = date;

monk='Uly';

RES = LoadMonkDataBDM(monk);
RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
RES=RES(RESix);
%%
ca
clearvars -except RES monk d dt

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
sigbit = bit;

sigOnly = 0;
wl=2;
testSit = 1:3;
nq=10;
iv_var = 'mb';% mb,nfr,absm,usabsm,vel,usvel,velav
dv_var = 'nfr';% mb,nfr,absm,usabsm,vel,usvel,velav
saveIt = 0;

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
sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;%%%% | psr<0.05&posSR;


% sigix = p<0.05&b<0 | p_bin<0.05&b_bin<0; %% negative correlation
% sigix = p<0.05 | p_bin<0.05;

% sigix = p_bin<0.05&p_bin~=0&b_bin>0;
sum(sigix)
%

% sum(p<0.05&p~=0&b>0)
% sum(p_bin<0.05&p_bin~=0&b_bin>0)
BIDsig.(bit)=sigix';
BIDS.(bit) = [r2',p',b'];
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
    sRES = RES(~nanix & sigix');
else
    sRES = RES(~nanix);
end
if strcmp(monk,'Vic')
    col = sitCols(3,:);
else
    col = sitCols(5,:);
end

fr=[];nfr=[];mb=[];vars.mb=[];vars.fr=[];cfr=[];vars.cb=[];vars.sits=[];pctr = 0;ctr=0;cellnum=[];
vars.nfr=[];vars.absm = [];vars.usabsm = [];vars.vel = [];vars.usvel = [];vars.velav = [];
all_olix=0;
for i = 1:length(sRES)
    nfrt=[];frt=[];mbt=[];cbt=[];sitt=[];p=[];r=[];evnts=[];nbitmat=[];
    evnts = sRES(i).event;
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
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    js = RES(i).joystick_rast.BidStartUp;
    %     mb = RES(iR).event.monkeybid;
    
    jsm = mode(js(:,1:200),2);
    jsnrm = js-jsm;
    
    velt =[];usvelt=[];velavt =[];absmt=[];usabsmt=[];
    for iJ = 1:length(jsnrm(:,1))
        absmt(iJ,1) = trapz(jsnrm(iJ,:));
        usabsmt(iJ,1) = trapz(abs(jsnrm(iJ,:)));
        velt(iJ,1) = trapz(diff(jsnrm(iJ,:)));
        usvelt(iJ,1) = trapz(abs(diff(jsnrm(iJ,:))));
        velavt(iJ,1) = mean(diff(jsnrm(iJ,:)));
        
%         mb(iJ) = double(RES(i).event.monkeybid(iJ));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mbt = double(evnts.monkeybid(wlix));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cbt = double(evnts.computerbid(wlix));
    %         frt = sRES(i).FR.(bit)(wlix);
    rst = sRES(i).rast.(bit)(wlix,:);
    cont = sRES(i).rast.FixationCrossUp(wlix,:);

    %     rst = zscore(RES(i).rast.(bit),0,[2]);
    %     rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);

    %     frt = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
    frt = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
    cont = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;

    sitt = evnts.situations(wlix);
    %         cont = sRES(i).FR_control.(bit)(wlix);


    cfr = [cfr;cont];
    fr = [fr;frt];
    if sum(cont==0)==length(cont)
        continue
    end
    %         nfrt = (frt-nanmean(cont))./nanstd(cont);
    nfrt = zscore(frt);
    %         cont =  zscore(cont);
    %         nfrt = (frt-(cont))./(cont+.00000001)*100;
%         nfrt = (frt-(cont));
%             nfrt= MinMaxFS(frt);
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
    vars.nfr = [vars.nfr;nfrt];
    vars.mb = [vars.mb;mbt];
    vars.cb = [vars.cb;cbt];
    vars.absm = [vars.absm;absmt];
    vars.usabsm = [vars.usabsm;usabsmt];
    vars.vel = [vars.vel;velt];
    vars.usvel = [vars.usvel;usvelt];
    vars.velav = [vars.velav;velavt];
    
    vars.sits = [vars.sits;sitt];
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

nfr = vars.(dv_var);
test_var = vars.(iv_var);

ix = ~isnan(nfr);

test_var = test_var(ix);
vars.cb = 100-vars.cb(ix);
nfr = nfr(ix);
cn = cellnum(ix);
vars.sits = vars.sits(ix);

% edgs = 0:20:100;
% [~,~,mb] = histcounts(mb,edgs);


% testSit = 1;
Sitix = ismember(vars.sits,testSit);
nfr = nfr(Sitix);
test_var=test_var(Sitix);
vars.cb=vars.cb(Sitix);
cn = cellnum(Sitix);

cellcnt = numel(unique(cn));

ocb=vars.cb;



fig = figure;
scatter(test_var,nfr);
[r,p] = corr(test_var,nfr,'type','Pearson');
disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
mdl=fitlm(test_var,nfr,'RobustOpts','on')
sum(~nanix)

ti = [monk,' | ',bit,' | sit ',num2str(testSit),' | p = ',num2str(p),' | r2 = ',num2str(r^2)];
savnam = strfix(ti);
title(ti)
if saveIt
    saveas(fig,savnam,'png')
end
%
%     fig = figure;
%     scatter(cb,nfr);
%     [r,p] = corr(cb,nfr,'type','Pearson')
%     disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
%     mdl=fitlm(cb,nfr,'RobustOpts','on')
%     sum(~nanix)
%

badix=[];mmb=[];sfr=[];mfr=[];
for i = 1:101
    mbix = test_var==i;
    nbids(i) = sum(mbix);
end
minbid = max(mean(nbids)-std(nbids),10);
minbid =5;
rtv(1) = min(test_var);rtv(2)=max(test_var);

for i = 1:99
    mbix = test_var>rtv(1)+((diff(rtv)/100)*i)&test_var<rtv(1)+((diff(rtv)/100)*(i+1));
    nbids(i) = sum(mbix);
    if nbids(i)<minbid
        continue
    end
    incbids(i)=1;


    mbnfr = nfr(mbix);
    %     olix = isoutlier(mbnfr,'median');
    %     mbnfr = mbnfr(~olix);
    mfr(i) = mean(mbnfr);%/nbids(i);
    sfr(i) = Sem(mbnfr);%/nbids(i);
    mmb(i) = i;
end
badix = isnan(mfr)| mmb==0;


% [r,p] = corr(mmb(~badix)',mfr(~badix)')
[r,p] = corr(mmb(~badix)',mfr(~badix)','type','Pearson');
disp(['p = ',num2str(p),' | r2 = ',num2str(r^2)])


disp('~~~~~~~~~~~~~~~~~~~~Weighted~~~~~~~~~~~~~~~~~~~~')
mdlw=fitlm(mmb(~badix)',mfr(~badix)','Weights',nbids(~badix))
%     figure;plot(mdlw);title('Weighted')
disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
mdlr=fitlm(mmb(~badix)',mfr(~badix)','RobustOpts','on')
%     figure;plot(mdlr);title('Robust')
% disp('~~~~~~~~~~~~~~~~~~~~Weighted and robust~~~~~~~~~~~~~~~~~~~~')
% mdl=fitlm(mmb(~badix)',mfr(~badix)','Weights',nbids(~badix),'RobustOpts','on')
% figure;plot(mdl);title('Weighted & Robust')

[pf,s] = polyfit(mmb(~badix),mfr(~badix),1);
[pv,d] = polyval(pf,mmb(~badix),s);

gFg = figure;
gAx = axes;

scatter(gAx,mmb(~badix)',mfr(~badix)')

hold on
x=1:100;
x=x(~badix);
for i=x
    line([i i],[mfr(i)-sfr(i) mfr(i)+sfr(i)])
end
ti = [bit,' | sit ',num2str(testSit),' | p = ',num2str(p),' | r2 = ',num2str(r^2)];
title(ti)
plot(gAx,x,mdlr.Fitted,'r')
plot(gAx,x,mdlw.Fitted,'m')

plot(gAx,x,pv,'k')

ti = ['Grouped | ',monk,' | ',bit,' | sit ',num2str(testSit),' | p = ',num2str(p),' | r2 = ',num2str(r^2)];
savnam = strfix(ti);
title(ti)
if saveIt
saveas(gFg,savnam,'emf')
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mmb=[];sfr=[];mfr=[];nbids=[];incbids=[];q=[];
nbg = 25;
%     for  i = 1:nbg
%         mbix = ismember(mb,(round((i-1)*(100/nbg))+1):round(i*(100/nbg)));
%         nbids(i) = sum(mbix);
%     end
%     zx = nbids==0;

minbid = 20; % min of 50 bids works for VIC %min 20 for Uly
bids_in_bin=[];

if strcmp(iv_var,'mb')
    edgs = (0:100/nbg:100)+.5;
else
    edgs = (rtv(1):range(rtv)/nbg:rtv(2))+.5;
end
[N,edgs,bn]=histcounts(test_var,edgs);
xax = (0:100/nbg:100)+((100/nbg)/2);
mfr=[];sfr=[];mmb=[];
for i = 1:length(N)
    mbix=[];
    mbix=bn==i;
    if N(i)<=minbid
        continue
    end
    mfr(i) = mean(nfr(mbix));%/nbids(i);
    sfr(i) = Sem(nfr(mbix));%/nbids(i);
    mmb(i) = i;
    nbids(i) = sum(mbix);
end
xaxix=[];
xaxix = N>minbid;
% % %     for i = 1:nbg
% % %         mbix=[];
% % %         %         mbix = ismember(mb,(round((i-1)*(100/nbg))+1):round(i*(100/nbg)));
% % %         l=numel((round((i-1)*(100/nbg))+1):round(i*(100/nbg)));
% % %         bids_in_bin(i,1:l)=(round((i-1)*(100/nbg))+1):round(i*(100/nbg));
% % %         mbix = ismember(mb,(round((i-1)*(100/nbg))+1):round(i*(100/nbg)));
% % %
% % %         nbids(i) = sum(mbix);
% % %         if nbids(i)<minbid
% % %             continue
% % %         end
% % %         incbids(i)=1;
% % %         mfr(i) = mean(nfr(mbix));%/nbids(i);
% % %         sfr(i) = Sem(nfr(mbix));%/nbids(i);
% % %         %     sfr(i) = ci(nfr(mbix));%/nbids(i);
% % %         mmb(i) = i;
% % %     end
%     col = CambridgeDark(3);
incbids=find(incbids);

cFg = figure;
cAx = axes;

badix = isnan(mfr)| mmb==0;
mmb = mmb(~badix);mfr = mfr(~badix);sfr=sfr(~badix);nbids=nbids(~badix);
% % %     for i=1:length(mmbb)
% % %         plot(cAx,mmbb(i),mmfr(i),'LineStyle','none','Marker','o','MarkerSize',4,'MarkerEdgeColor','none','MarkerFaceColor',col)
% % %         hold on
% % %     end
plot(cAx,xax(xaxix),mfr,'LineStyle','none','Marker','o','MarkerSize',8,'MarkerEdgeColor','none','MarkerFaceColor',col)

%     PlotWeightedMarkers(mmfr,nnbids,col,'o','none',mmbb,cAx)

dv = mfr';iv = mmb';
[r,p] = corr(iv,dv,'type','Pearson');
mdl = fitlm(dv,iv);
Reg_stats.p = mdl.Coefficients.pValue(2);
Reg_stats.r2 = mdl.Rsquared.Ordinary;
b=[];
b = mdl.Coefficients.Estimate(2);
Reg_stats.b = BetaNormalization(b,iv,dv);
disp(['p = ',num2str(p),' | r2 = ',num2str(r^2)])
title([r^2,p])

hold on
% % %     x=1:nbg;
x=1:max(bn);

x=x(~badix);


% p=flip(table2array(mdl.Coefficients(:,1)))
[pf,s] = polyfit(mmb,mfr,1);
[pv,d] = polyval(pf,mmb,s);

% % %     for i = x
% % %         line(cAx,[i i],[mfr(i)-sfr(i) mfr(i)+sfr(i)],'color',col)
% % %         %     line([x(i) x(i)],[pv(i)-(d(i)*2) pv(i)+(d(i)*2)])
% % %     end
xi = find(xaxix);
for i=1:sum(xaxix)
    line(cAx,[xax(xi(i)) xax(xi(i))],[mfr(i)-sfr(i) mfr(i)+sfr(i)],'color',col,'LineWidth',1)
end

hold on
plot(cAx,xax(xaxix),pv,'-','Color',col,'LineWidth',2)
cAx.XLim=[0 100];
hold on
disp('~~~~~~~~~~~~~~~~~~~~Weighted~~~~~~~~~~~~~~~~~~~~')
w = nbids;
% w(nbids>100)=100;
mdlw=fitlm(mmb',mfr','Weights',w)
% mdlw=fitlm(mmb(~badix)',mfr(~badix)','Weights',nbids(~badix))
%     plot(x,mdlw.Fitted,'m')
disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
mdlr=fitlm(mmb',mfr','RobustOpts','bisquare')
%     plot(x,mdlr.Fitted,'r')
ft='meta';
axis tight
ti = ['All 3 sits chunked | ',monk,' | ',bit,' | r2=',num2str(r^2),' | p=',num2str(p)];
yl = cAx.YLim(2)-(range(cAx.YLim)*.1);

title(cAx,ti)
All_p_r2(:,1)=r^2;
All_p_r2(:,2)=p;
%     t = annotation('textbox',5,yl,'string',num2str(All_p_r2));
ymx = max([mfr-sfr mfr+sfr])+(.02*range([mfr-sfr mfr+sfr]));
ymn = min([mfr-sfr mfr+sfr])-(.02*range([mfr-sfr mfr+sfr]));
% cAx.YLim = [-.32 .35]
cAx.YLim = [ymn ymx];
cAx.XLim = [0 100]


pubify_figure_axis_robust
%     WideFigs
savnam = strfix(ti);
if saveIt
saveas(cFg,savnam,ft)
end



% % % monk = 'Uly';
% % % d = DropboxDir;
% % %
% % % if strcmp(monk,'Vic')
% % %     fn = [d,'\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_29-Nov-2021\GettyBidRegressionWithClustersRobust\Vic_cells_sits_1  2  3.mat'];
% % % elseif strcmp(monk,'Uly')
% % %     fn = [d,'\Schultz_Lab\BDM_Data\Uly_Data\ANALYSIS_25-Nov-2021\GettyBidRegressionWithClustersRobust\Uly_cells_sits_1  2  3.mat'];
% % % end
% % % load(fn);
% % % %
% % %
% % %
% % % clear;ca;
