% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')

ca;clear;load('Uly_cells_sits_1  2  3.mat')
bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardEpochEndUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
testSit = 1:3;
nanix=zeros(length(RES),1);
for i = 1:length(RES)
    if isnan(RES(i).(bit)) 
        nanix(i,1) = 1;
    else
        [r(i),p(i)] = corr(RES(i).(bit)(:,1),RES(i).(bit)(:,3));
    end
end
sum(p<0.05&p~=0&r>0)
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

bRES = RES(~nanix);
fr=[];cfr=[];nfr=[];mb=[];sits=[];pctr = 0;ctr=0;cellnum=[];

for i = 1:length(bRES)
    nfrt=[];frt=[];mbt=[];sitt=[];p=[];r=[];
    mbt = (round(bRES(i).(bit)(:,3)*100)+100)/2;
    frt = bRES(i).(bit)(:,1);
    sitt = bRES(i).(bit)(:,5);
    cont = bRES(i).(bit)(:,2);
    cfr = [cfr;cont];
    fr = [fr;frt];
    if sum(cont==0)==length(cont)
        continue
    end
%     nfrt = (frt-nanmean(cont))./nanstd(cont);
%     nfrt = (frt-nanmean(frt))./nanstd(frt);
    nfrt = zscore(frt);
%     cont =  zscore(cont);
%     nfrt = (frt-(cont))./(cont+.00000001)*100;
%     nfrt = (frt-(cont));
%     nfrt= MinMaxFS(frt);
%     nfrt =frt;
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Remove Outlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     olix = isoutlier(nfrt,'gesd');
%     nfrt = nfrt(~olix);
%     mbt = mbt(~olix);
%     sitt = sitt(~olix);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nfr = [nfr;nfrt];
    mb = [mb;mbt];
    sits = [sits;sitt];
    ctr=ctr+1;
    cctr = repmat(ctr,size(sitt));
    cellnum = [cellnum;cctr];
end

nfr = nfr(~isnan(nfr));
mb = mb(~isnan(nfr));
cn = cellnum(~isnan(nfr));
sits = sits(~isnan(nfr));


ix = ismember(sits,testSit);
nfr = nfr(ix);
mb=mb(ix);
cn = cellnum(ix);

cellcnt = numel(unique(cn));

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Remove Outlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% olix = isoutlier(nfr,'gesd');
% nfr = nfr(~olix);
% mb = mb(~olix);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % bix = mb>90;
% % nfr=nfr(~bix);
% % mb=mb(~bix);
% nfr = fr-cfr;

% nfr = zscore(nfr);
figure
scatter(mb,nfr);
[r,p] = corr(mb,nfr,'type','Pearson')
disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
mdl=fitlm(mb,nfr,'RobustOpts','on')
sum(~nanix)
%% 
badix=[];mmb=[];sfr=[];mfr=[];
for i = 1:101
    mbix = mb==i;
    nbids(i) = sum(mbix);
end
minbid = max(mean(nbids)-std(nbids),10);
minbid =0;

for i = 1:100
    mbix = mb==i;
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


% disp('~~~~~~~~~~~~~~~~~~~~Weighted~~~~~~~~~~~~~~~~~~~~')
% mdlw=fitlm(mmb(~badix)',mfr(~badix)','Weights',nbids(~badix))
% figure;plot(mdlw);title('Weighted')
disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
mdlr=fitlm(mmb(~badix)',mfr(~badix)','RobustOpts','on')
figure;plot(mdlr);title('Robust')
% disp('~~~~~~~~~~~~~~~~~~~~Weighted and robust~~~~~~~~~~~~~~~~~~~~')
% mdl=fitlm(mmb(~badix)',mfr(~badix)','Weights',nbids(~badix),'RobustOpts','on')
% figure;plot(mdl);title('Weighted & Robust')

[p,s] = polyfit(mmb(~badix),mfr(~badix),1);
[pv,d] = polyval(p,mmb(~badix),s);

figure
scatter(mmb(~badix)',mfr(~badix)')

hold on
x=1:100;
x=x(~badix);
for i=x
    line([i i],[mfr(i)-sfr(i) mfr(i)+sfr(i)])
end

plot(x,mdlr.Fitted,'r')
plot(x,pv,'k')

%%
mmb=[];sfr=[];mfr=[];nbids=[];incbids=[];q=[];
nbg = 20;
for  i = 1:nbg
    mbix = ismember(mb,(round((i-1)*(100/nbg))+1):round(i*(100/nbg)));
    nbids(i) = sum(mbix);
end
zx = nbids==0;
% minbid = max(median(nbids(~zx))-(1*std(nbids(~zx))),50);%,20);
% minbid = median(nbids(~zx));
% minbid = mode(nbids);
minbid = 50; % min of 50 bids works for VIC %min 20 for Uly
% minbid = std(nbids);
for i = 1:nbg
    mbix=[];
    mbix = ismember(mb,(round((i-1)*(100/nbg))+1):round(i*(100/nbg)));
    nbids(i) = sum(mbix);
    if nbids(i)<minbid
        continue
    end
    incbids(i)=1;
    mfr(i) = mean(nfr(mbix));%/nbids(i);
        sfr(i) = Sem(nfr(mbix));%/nbids(i);
%     sfr(i) = ci(nfr(mbix));%/nbids(i);   
    mmb(i) = i;
end

incbids=find(incbids);
figure
badix = isnan(mfr)| mmb==0;
scatter(mb/(100/nbg),nfr,'cyan')
hold on
% scatter(mmb(~badix),mfr(~badix),'magenta')

mmbb = mmb(~badix);mmfr = mfr(~badix);nnbids=nbids(~badix);
for i=1:length(mmbb)
plot(mmbb(i),mmfr(i),'LineStyle','none','Marker','o','MarkerEdgeColor','none','MarkerFaceColor','b','MarkerSize',nnbids(i)/20)
hold on
end

[r,p] = corr(mmb(~badix)',mfr(~badix)','type','Pearson')
% [r,p] = corr(mmb(~badix)',mfr(~badix)','type','Spearman')
disp(['p = ',num2str(p),' | r2 = ',num2str(r^2)])


hold on
x=1:nbg;
x=x(~badix);


% p=flip(table2array(mdl.Coefficients(:,1)))
[p,s] = polyfit(mmb(~badix),mfr(~badix),1);
[pv,d] = polyval(p,mmb(~badix),s);

for i = x
    line([i i],[mfr(i)-sfr(i) mfr(i)+sfr(i)])
%     line([x(i) x(i)],[pv(i)-(d(i)*2) pv(i)+(d(i)*2)])
end
hold on
plot(x,pv,'k')
hold on
disp('~~~~~~~~~~~~~~~~~~~~Weighted~~~~~~~~~~~~~~~~~~~~')
w = nbids;
% w(nbids>100)=100;
mdlw=fitlm(mmb(~badix)',mfr(~badix)','Weights',w(~badix))
% mdlw=fitlm(mmb(~badix)',mfr(~badix)','Weights',nbids(~badix))
plot(x,mdlw.Fitted,'m')
disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
mdlr=fitlm(mmb(~badix)',mfr(~badix)','RobustOpts','bisquare')
plot(x,mdlr.Fitted,'r')
% disp('~~~~~~~~~~~~~~~~~~~~Weighted and robust~~~~~~~~~~~~~~~~~~~~')
% mdl=fitlm(mmb(~badix)',mfr(~badix)','RobustOpts','on','Weights',nbids(~badix)/10)
% figure;plot(mdl);title('Weighted & Robust');
% figure;plot(mdlw);title('Weighted');
% figure;plot(mdlr);title('Robust');


%%
% ca
% disp('~~~~~~~~~~~~~~~~~~~~shuffle Weighted and robust~~~~~~~~~~~~~~~~~~~~')
% sortix = randperm(length(mmb));
% smmb = mmb(sortix);snbids = nbids(sortix);
% mdlwr=fitlm(smmb(~badix)',mfr(~badix)','RobustOpts','on','Weights',snbids(~badix))
% % mdl=fitlm(smmb(~badix)',mfr(~badix)','RobustOpts','on')
% % 
% figure;plot(mdlwr);title('shuffle Weighted & Robust');

%%
% [r,p]=corr(mbt(sitt==testSit),nfrt(sitt==testSit));
%     if p<.05
%         pctr=pctr+1;
%         scatter(mbt(sitt==testSit),nfrt(sitt==testSit))
%         title([num2str(r),' | ',num2str(p),' | ',num2str(numel(nfrt(sitt==testSit)))])
%         waitforbuttonpress
%         ca
%     end
