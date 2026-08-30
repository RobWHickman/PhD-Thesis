
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
clearvars -except RES monk
% ca
pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];
% 
bin=1;
sigOnly=0;

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
if sigOnly
    sRES = RES(sigix);
else
    sRES = RES;
end
p=[];r=[];abd=[];amb=[];aFR=[];FR=[];
for iR = 1:length(sRES)
    FR=[];bd=[];mb=[];
    bd = double(sRES(iR).event.total_bid_duration);
    mb = double(sRES(iR).event.monkeybid);

    
    rst = double(sRES(iR).rast.FractalDisplayUp);
    
    FR = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
    
    
    
    zFR = zscore(FR);
        
    abd = [abd;bd'];
    amb = [amb;mb];
    aFR = [aFR;FR];
    
    [r(iR),p(iR)] = corr(mb,bd');
    [rfr(iR),pfr(iR)] = corr(bd',zFR);

%     if p(iR)<.05
%         figure
%         scatter(mb,bd)
%         title(r(iR),p(iR))
%         ca
%     end
end
%%
ca
n=[];e=[];b=[];mFR=[];mMB = [];mBD=[];r_bd=[];p_bd=[];
nbin = 25;
[n,e,b] = histcounts(abd,nbin);
% [n,e,b] = histcounts(amb,nbin);

for i=1:nbin
    npb(i) = sum(b==i);
    mFR(i) = mean(aFR(b==i));
    mMB(i) = mean(amb(b==i));
    mBD(i) = mean(abd(b==i));    
    
    if ~isempty(amb(b==i))&& ~isempty(aFR(b==i))
        [r_bd(i),p_bd(i)] = corr(amb(b==i),aFR(b==i));
    end
end

figure
PlotWeightedMarkers(mFR,npb,'b','.','none',mMB)
xlabel('Mean bid');ylabel('mean FR')
% (y,weights,color,shape,lin,x,ax)

figure
PlotWeightedMarkers(mBD,npb,'b','.','none',mMB)
% scatter(mMB,mBD)
xlabel('Mean bid');ylabel('mean bid duration')

figure
PlotWeightedMarkers(mFR,npb,'b','.','none',mBD)
xlabel('Mean bid duration');ylabel('mean FR')
PlotSigAsterisks(mBD(p_bd<.05));

 figure;
 PlotWeightedMarkers(p_bd,npb,'b','.',':',mBD)
%  plot(mBD,p_bd)
hold on
 PlotWeightedMarkers(r_bd,npb,'r','.',':',mBD)
% plot(mBD,r_bd,'r')
PlotSigAsterisks(mBD(p_bd<.05));