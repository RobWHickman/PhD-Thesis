% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')
clear;

monk = 'Vic';
RES = LoadMonkDataBDM(monk);
RES = RES.RES;
%%
bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
sigbit = bit;

sigOnly = 0;
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
    if isnan(RES(i).rast.(bit)) 
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = RES(i).event.monkeybid;
        cb = RES(i).event.computerbid;
        pcb = RES(i).event.previouscomputerbid_same_RV;
        sit = RES(i).event.situations;
        wltr = RES(i).event.previouswinlose;
        tl = RES(i).event.previoustotalliquid;
        sb = RES(i).event.startingbid;

%         fr = RES(i).(bit)(:,1);
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
sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;


% sigix = p<0.05&b<0 | p_bin<0.05&b_bin<0; %% negative correlation
% sigix = p<0.05 | p_bin<0.05;

% sigix = p_bin<0.05&p_bin~=0&b_bin>0;
sum(sigix)

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
%%
fr=[];cfr=[];nfr=[];mb=[];cb=[];sits=[];pctr = 0;ctr=0;cellnum=[];
all_olix=0;p=[];r=[];b=[];
for i = 1:length(sRES)
    nfrt=[];frt=[];mbt=[];cbt=[];sitt=[];evnts=[];nbitmat=[];
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

    mbt = evnts.monkeybid(wlix);
    cbt = evnts.computerbid(wlix);
    frt = sRES(i).FR.(bit)(wlix);
    rst = sRES(i).rast.(bit)(wlix,:);
    js_rst = sRES(i).joystick_rast.BidStartUp(wlix,:);
    %     rst = zscore(RES(i).rast.(testBit),0,[2]);
    %     rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);
    
    %     frt = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
    frt = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;    
    
    sitt = evnts.situations(wlix);
    cont = sRES(i).FR_control.(bit)(wlix);
    
    frr = FiringRateGaussRaster(rst);
    
    zjs_rst = zscore(js_rst,[],2);
    
    cnst = ones(size(mbt));
    jsAbs = trapz(zjs_rst(:,pre:pre+3500),2);
    js_dif = diff(zjs_rst,1,2);
    js_vel = mean(js_dif(:,pre:pre+3500),2);
    js_def = zjs_rst;
    
    
    
%     [r(1,i),p(1,i)] = corr(mbt,frt);
%     [r(2,i),p(2,i)] = corr(jsAbs,frt);
%     [r(3,i),p(3,i)] = corr(js_vel,frt);

bt=[];
[bt,~,~,~,stats] = regress(frt,[cnst mbt]);
b(1,i) = BetaNormalization(bt(2),mbt,frt);
r(1,i) = stats(1);
p(1,i) = stats(3);bt=[];
[bt,~,~,~,stats] = regress(frt,[cnst jsAbs]);
b(2,i) =  BetaNormalization(bt(2),jsAbs,frt);
r(2,i) = stats(1);
p(2,i) = stats(3);bt=[];
[bt,~,~,~,stats] = regress(frt,[cnst js_vel]);
b(3,i) = BetaNormalization(bt(2),js_vel,frt);
r(3,i) = stats(1);
p(3,i) = stats(3);bt=[];

    if 0% p(i)<0.05
    figure; subplot(2,1,1);
    imagesc(js_dif)
%     PlotTracesStacked(js_rst)
    g=gca;
    subplot(2,1,2);
    imagesc(frr);
%     PlotTracesStacked(frr)
    xlim(g.XLim);
    ca
    end
    
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
cb = 100-cb(ix);
nfr = nfr(ix);
cn = cellnum(ix);
sits = sits(ix);


Sitix = ismember(sits,testSit);
nfr = nfr(Sitix);
mb=mb(Sitix);
cb=cb(Sitix); 
cn = cellnum(Sitix);

cellcnt = numel(unique(cn));

ocb=cb;
% cb = 100-ocb;

% fig = figure;
% scatter(mb,nfr);
% [r,p] = corr(mb,nfr,'type','Pearson')
% disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
% mdl=fitlm(mb,nfr,'RobustOpts','on')
% sum(~nanix)
% savnam = [bit,'_pop_sit_',num2str(testSit),'_p',strrep(num2str(p),'.','-')];
% saveas(fig,savnam,'png')
%%
figure;
x = 1:length(p);
plot(x,r(1,:),'k:');
hold on

plot(x(p(1,:)<0.05),r(1,p(1,:)<0.05),'k* ');

plot(r(2,:),'r:');
plot(x(p(2,:)<0.05),r(2,p(2,:)<0.05),'r* ');

plot(r(3,:),'b:');
plot(x(p(3,:)<0.05),r(3,p(3,:)<0.05),'b* ');

rsig = r;
rsig(p>.05)=nan;

figure;Plot_Mean_SEM_All_Points(rsig')

[anvp,anvtbl,anvstats] = anova1(rsig')
multcompare(anvstats)
%%
figure;
x = 1:length(p);
plot(x,b(1,:),'k:');
hold on

plot(x(p(1,:)<0.05),b(1,p(1,:)<0.05),'k* ');

plot(b(2,:),'r:');
plot(x(p(2,:)<0.05),b(2,p(2,:)<0.05),'r* ');

plot(b(3,:),'b:');
plot(x(p(3,:)<0.05),b(3,p(3,:)<0.05),'b* ');

bsig = b;
bsig(p>.05)=nan;


figure;Plot_Mean_SEM_All_Points(bsig')

[anvp,anvtbl,anvstats] = anova1(abs(bsig)')
multcompare(anvstats)
