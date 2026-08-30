clear;

monk='Vic';
RES = LoadMonkDataBDM(monk);
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

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
testBit = 'FractalDisplayUp';
sigbit = testBit;
nq=10;

% DAix = [RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
Respix=[RES.isResponsive]&[RES.numTrGood];
% DAix = ~[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];

Respix = logical(Respix);
sRES = RES(Respix);
% DAix = logical(DAix);
% sRES = RES(DAix);



% figure;
nanix=zeros(length(sRES),1);
p=[];r=[];p_bin = [];b_bin=[];b=[];
for i = 1:length(sRES)
    if isnan(sRES(i).rast.(sigbit)) 
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double([sRES(i).event.monkeybid]);
        cb = double([sRES(i).event.computerbid]);
        sit = double([sRES(i).event.situations]);
%         fr = RES(i).FR.(sigbit); 
        rst = sRES(i).rast.(testBit);
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

        
%         if p(i)<0.05&b(i)>0 | p_bin(i)<0.05&b_bin(i)>0
%             fxRst = RES(i).rast.FixationCrossUp;
%             frcRst = RES(i).rast.FractalDisplayUp;
%             subplot(2,2,1)
%             PlotTrueRaster(fxRst)
%             subplot(2,2,3)
%             plot(smoothdata(mean(fxRst),2,'gaussian',80))
%             subplot(2,2,2)
%             PlotTrueRaster(frcRst)
%             subplot(2,2,4)
%             plot(smoothdata(mean(frcRst),2,'gaussian',80))
% 
%             clf
%         end
    end
end
sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;
% sigix = p<0.05 | p_bin<0.05;
%%

% figure;
cbtestBit = 'WinLoseUp';
nanix=zeros(length(sRES),1);
p=[];r=[];p_bin = [];b_bin=[];b=[];
for i = 1:length(sRES)
    if isnan(sRES(i).rast.(sigbit)) 
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double([sRES(i).event.monkeybid]);
        cb = 100-double([sRES(i).event.computerbid]);
        sit = double([sRES(i).event.situations]);
%         fr = RES(i).FR.(sigbit); 
        rst = sRES(i).rast.(cbtestBit);
%         rst = zscore(RES(i).rast.(testBit),0,[2]);

        fr = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
%         fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;

        if strcmp(cbtestBit,'RewardTapUp')
            fr = fr(mb>cb,:);
            cb = cb(mb>cb);
        end
        X = [ones(length(cb),1),cb];
        [bta,~,~,~,stats] = regress(fr,X);
        p(i) = stats(3);
        r2(i) = stats(1);
        b(i)=BetaNormalization(bta(2),cb,fr);
        
        mnmb = min(cb);mxmb=max(cb);
        edgs = linspace(mnmb,mxmb,nq+1);
%         edgs=linspace(min(mb)-(std(mb)*1),max(mb)+(std(mb)*1),nq+1);
%         edgs=quantile(mb,nq+1);
        edgs(1)=0; edgs(end)=100;
        [~,~,bix] = histcounts(cb,edgs);
        frb = nan(1,nq);
        ubix = unique(bix);
        for ib = 1:length(ubix)
            iBfr = ubix(ib);
            frb(iBfr) = nanmean(fr(bix==iBfr));
            cbb(iBfr) = nanmean(cb(bix==iBfr));
        end
        bds = cbb;
        badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);
        X = [ones(length(bds),1),bds'];
        [bb,~,~,~,stats_bin] = regress(frb',X);
        p_bin(i) = stats_bin(3);
        r2_bin(i) = stats_bin(1);
        b_bin(i)=BetaNormalization(bb(2),cbb,frb);

        
%         if p(i)<0.05&b(i)>0 | p_bin(i)<0.05&b_bin(i)>0
%             fxRst = RES(i).rast.FixationCrossUp;
%             frcRst = RES(i).rast.FractalDisplayUp;
%             subplot(2,2,1)
%             PlotTrueRaster(fxRst)
%             subplot(2,2,3)
%             plot(smoothdata(mean(fxRst),2,'gaussian',80))
%             subplot(2,2,2)
%             PlotTrueRaster(frcRst)
%             subplot(2,2,4)
%             plot(smoothdata(mean(frcRst),2,'gaussian',80))
% 
%             clf
%         end
    end
end
sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;
% sigix = p<0.05 | p_bin<0.05;
sum(sigix)


%%
sum(sigix)



DAcells = [sRES.isDA]&[sRES.isResponsive]&[sRES.numTrGood];
DAcells = DAcells';
sum(sigix'&DAcells)

SignificantCorrelation.logical = sigix';
SignificantCorrelation.p = p;
SignificantCorrelation.p_bin = p_bin;
SignificantCorrelation.r2 = r2;
SignificantCorrelation.r2_bin = r2_bin;
SignificantCorrelation.b = b;
SignificantCorrelation.b_bin = b_bin;
%%

cnts = 0;

for iR = 1:length(sRES)
    B=[];nB=[];mb=[];tn=[];sit=[];
    r = double(sRES(iR).rast.(testBit));
    mb = double(sRES(iR).event.monkeybid);
    tn = double(sRES(iR).event.trialnums);
    sit = double([sRES(iR).event.situations]);

    data1{iR,1} = mb/100;
    trialNum{iR,1} = tn;
    rewardLevel{iR,1} = sit;
    dateSess{iR,1} = sRES(iR).day;
%     dateSess{iR,2} = 

%     tic
    ctr=0;numComp =0;
    for i = 2000+cc1
        for ii = cc2-cc1
            ctr = ctr+1;
            fr=[];
            if i+ii>3000
                continue
            end
            if cnts 
                fr = nanmean(r(:,i:i+ii),2);
            else
                fr = sum(r(:,i:i+ii),2)/ii*1000;
            end
            data2{iR,1}(:,ctr)=fr;    
            bins{:,ctr}=[i-2000,ii];
        end
    end
    
    if cnts==1 && strcmp(monk,'Vic')
        save('Vicer_SVM_data_AvgCtsPerBin_FxdWind_180-360ms','data1','data2','trialNum',...
            'rewardLevel','dateSess','DAcells','SignificantCorrelation');
    elseif cnts==0 && strcmp(monk,'Vic')
        save('Vicer_SVM_data_FiringRates_FxdWind_180-360ms','data1','data2','trialNum',...
            'rewardLevel','dateSess','DAcells','SignificantCorrelation');
    end
     if cnts==1 && strcmp(monk,'Uly')
        save('Ulysses_SVM_data_AvgCtsPerBin_FxdWind_180-340ms','data1','data2',...
            'trialNum','rewardLevel','dateSess','DAcells','SignificantCorrelation');        
     elseif cnts==0 && strcmp(monk,'Uly')
        save('Ulysses_SVM_data_FiringRates_FxdWind_180-340ms','data1','data2',...
            'trialNum','rewardLevel','dateSess','DAcells','SignificantCorrelation');
    end
    
%     toc
    
%     %     nB = MinMaxFS(B,2);
%     badix = isnan(B(:,3))|B(:,3)==0;
%     B = B(~badix,:);
%     nB = zscore(B);
%     
%     sigix = B(:,3)<.05 & B(:,1)>0;
%     B = B(sigix,:);
%     nB = nB(sigix,:);
%     
%     if sum(sigix)>0 && max(B(:,6))>10
%         ctr2 = ctr2+1;
%         %         [~,ix]=max(B(:,2));
%         %         [~,ix]=max(B(:,6));
%         [~,ix]=max(nB(:,2).*nB(:,6));
%         bestBin(ctr2,1) = B(ix,4);
%         bestBin(ctr2,2) = B(ix,5);
%         bestBin(ctr2,3) = B(ix,2);
%         bestBin(ctr2,4) = B(ix,3);
%         disp(iR)
%         figure
%         subplot(7,1,1:4)
%         PlotTrueRaster(r)
%         ShadedBox([2000+B(ix,4),2000+B(ix,4)+B(ix,5)])
%         title(B(ix,3))
%         subplot(7,1,5:7)
%         fr2=[];
%         fr2 = nanmean(r(:,2000+B(ix,4):2000+B(ix,4)+B(ix,5)),2);
%         scatter(mb,fr2)
%         title([num2str(B(ix,4)),'  ',num2str(B(ix,5))]);
%         SkinnyFigs
%         B = sortrows(B,3);
%         ca
%     end
end
% bestBin = sortrows(bestBin,4);
% 
% 
% hist(bestBin(:,1))
% edges = 0:20:500
% h = histcounts(bestBin(:,1),edges)
% bar(h)

 %%
% data(:,1) = randi(10,300,1);
% R=[];
% for i=1:3:300
% % r = randi(3,3,1)
% r = datasample(1:3,3,'Replace',false);
% R=[R;r'];
% end
% data(:,2) = R;
% 
% winix1 = data(R==1)>3
% winix2 = data(R==2)>5
% winix3 = data(R==3)>7

