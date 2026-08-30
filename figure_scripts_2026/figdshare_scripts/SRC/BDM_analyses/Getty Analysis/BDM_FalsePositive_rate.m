clear;
monk = 'Vic';
RES = LoadMonkDataBDM(monk);

nShuf = 100;

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
sigbit = bit;

sigOnly = 1;
wl=2;
testSit = 3;
nq=10;

saveIt = 1;

pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];

bin=1;

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


for iR = 1:length(RES)
    mb = RES(iR).event.monkeybid;
    tn = RES(iR).event.trialnums;
    
    rst = RES(iR).rast.FractalDisplayUp;
    
    
    [~,ix] =sort(tn);
    stn = tn(ix);
    srst = rst(ix,:);
    smb = mb(ix);
    
    fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
    sfr = sum(srst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
    
    nc = [smb(3:end);0;0];
    rc = randi(length(mb),length(mb),1);
    rmb = mb(rc);
    
    [r(iR,1),p(iR,1)]=corr(mb,fr);
    [r(iR,2),p(iR,2)]=corr(smb,sfr);
    [r(iR,3),p(iR,3)]=corr(nc,sfr);
    [r(iR,4),p(iR,4)]=corr(rmb,sfr);
    
    %     [rr(iR,iSh),pr(iR,iSh)]=corr(rmb,sfr);
    
    
    %     scatter(smb,sfr,'k')
    %     hold on
    %     scatter(nc,sfr,'r')
    %
    %     clf
    
end

sum(p(:,1)<.05)
sum(p(:,2)<.05)
sum(p(:,3)<.05)
sum(p(:,4)<.05)
%%
for iSh = 1:nShuf
    for iR = 1:length(RES)
        mb = RES(iR).event.monkeybid;
        tn = RES(iR).event.trialnums;
        
        rst = RES(iR).rast.FractalDisplayUp;
        
        
        [~,ix] =sort(tn);
        stn = tn(ix);
        srst = rst(ix,:);
        smb = mb(ix);
        
        fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
        sfr = sum(srst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
        
        rc = randi(length(mb),length(mb),1);
        rmb = mb(rc);
        
        [rr(iR,iSh),pr(iR,iSh)]=corr(rmb,fr);
        
        
        mnmb = min(mb);mxmb=max(mb);
        edgs = linspace(mnmb,mxmb,nq+1);
        %         edgs=linspace(min(mb)-(std(mb)*1),max(mb)+(std(mb)*1),nq+1);
        %         edgs=quantile(mb,nq+1);
        edgs(1)=0; edgs(end)=100;
        [~,~,bix] = histcounts(rmb,edgs);
        frb = nan(1,nq);
        ubix = unique(bix);
        for ib = 1:length(ubix)
            iBfr = ubix(ib);
            frb(iBfr) = nanmean(fr(bix==iBfr));
            mbb(iBfr) = nanmean(rmb(bix==iBfr));
        end
        bds = mbb;
        badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);
        X = [ones(length(bds),1),bds'];
        [bb,~,~,~,stats_bin] = regress(frb',X);
        p_bin(iR,iSh) = stats_bin(3);
        r2_bin(iR) = stats_bin(1);
        b_bin(iR,iSh)=BetaNormalization(bb(2),mbb,frb);
        
    end
    iSh
end
for i=1:length(pr(1,:))
    fpc(i) = sum(pr(:,i)<.05 & rr(:,i)>0 | p_bin(:,i)<.05 & b_bin(:,i)>0);
    
end

upper_limit_false_positives_shuf_bids = mean(fpc)+std(fpc)
%%
for iSh = 1:nShuf
    for iR = 1:length(RES)
        mb = RES(iR).event.monkeybid;
        tn = RES(iR).event.trialnums;
        
        rst = RES(iR).rast.FractalDisplayUp;
        
        
        [~,ix] =sort(tn);
        stn = tn(ix);
        srst = rst(ix,:);
        smb = mb(ix);
        
        fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
        sfr = sum(srst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
        
%         rc = randi(length(mb),length(mb),1);
        rmb = randi(100,length(mb),1);
        
        [rr(iR,iSh),pr(iR,iSh)]=corr(rmb,fr);
        
        
        mnmb = min(mb);mxmb=max(mb);
        edgs = linspace(mnmb,mxmb,nq+1);
        %         edgs=linspace(min(mb)-(std(mb)*1),max(mb)+(std(mb)*1),nq+1);
        %         edgs=quantile(mb,nq+1);
        edgs(1)=0; edgs(end)=100;
        [~,~,bix] = histcounts(rmb,edgs);
        frb = nan(1,nq);
        ubix = unique(bix);
        for ib = 1:length(ubix)
            iBfr = ubix(ib);
            frb(iBfr) = nanmean(fr(bix==iBfr));
            mbb(iBfr) = nanmean(rmb(bix==iBfr));
        end
        bds = mbb;
        badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);
        X = [ones(length(bds),1),bds'];
        [bb,~,~,~,stats_bin] = regress(frb',X);
        p_bin(iR,iSh) = stats_bin(3);
        r2_bin(iR) = stats_bin(1);
        b_bin(iR)=BetaNormalization(bb(2),mbb,frb);
        
    end
    iSh
end
for i=1:length(pr(1,:))
    fpc(i) = sum(pr(:,i)<.05 & rr(:,i)>0 | p_bin(:,i)<.05 & b_bin(:,i)>0);    
end

upper_limit_false_positives_rand_bids = mean(fpc)+(std(fpc)*2)