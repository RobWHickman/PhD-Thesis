% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')

ca;clear;load('Vic_cells_sits_3.mat')
% bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardEpochEndUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';

fr=[];cfr=[];nfr=[];mb=[];
for i = 1:length(RES)
    nfrt=[];frt=[];mbt=[];
    mbt = RES(i).(bit)(:,4);
    frt = RES(i).(bit)(:,1);
    cont = RES(i).FixationCrossUp(:,2);
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
    olix = isoutlier(nfrt,'gesd');
    nfrt = nfrt(~olix);
    mbt = mbt(~olix);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    nfr = [nfr;nfrt];
    mb = [mb;mbt];

end

% nfr = nfr(~isnan(nfr));
% mb = mb(~isnan(mb));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Remove Outlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% olix = isoutlier(nfr,'gesd');
% nfr = nfr(~olix);
% mb = mb(~olix);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % bix = mb>90;
% % nfr=nfr(~bix);
% % mb=mb(~bix);
% nfr = fr-cfr;

% nfr = zscore(nfr);
figure
scatter(mb,nfr);
[r,p] = corr(mb,nfr,'type','Spearman')

%% 
badix=[];mmb=[];sfr=[];mfr=[];
for i = 1:101
    mbix = mb==i;
    nbids(i) = sum(mbix);
end
minbid = max(mean(nbids)-std(nbids),10);

% minbid =0;

for i = 1:100
    mbix = mb>(i-1)/100&mb<(i)/100;
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

figure
badix = isnan(mfr)| mmb==0;
scatter(mmb(~badix)',mfr(~badix)')
% [r,p] = corr(mmb(~badix)',mfr(~badix)')
[r,p] = corr(mmb(~badix)',mfr(~badix)','type','Spearman')

hold on
x=1:100;
x=x(~badix);
for i=x
    line([i i],[mfr(i)-sfr(i) mfr(i)+sfr(i)])
end
%%
mmb=[];sfr=[];mfr=[];nbids=[];incbids=[];q=[];
nbg = 20;
for  i = 1:nbg
%     mbix = ismember(mb,(round((i-1)*(100/nbg))+1):round(i*(100/nbg)));
    mbix = mb>(i-1)/nbg&mb<(i)/nbg;    
    nbids(i) = sum(mbix);
end
minbid = max(mean(nbids)-std(nbids),20);
minbid =100; % min of 50 bids works for VIC %min 20 for Uly
for i = 1:nbg
%     mbix = ismember(mb,(round((i-1)*(100/nbg))+1):round(i*(100/nbg)));
    mbix = mb>(i-1)/nbg&mb<(i)/nbg;

    nbids(i) = sum(mbix);
    if nbids(i)<minbid
        continue
    end
    incbids(i)=1;
    mfr(i) = mean(nfr(mbix));%/nbids(i);
    sfr(i) = Sem(nfr(mbix));%/nbids(i);
    mmb(i) = i;
end

incbids=find(incbids);
figure
badix = isnan(mfr)| mmb==0;
% scatter(mb/(100/nbg),nfr,'cyan')
scatter(mb,nfr,'cyan')

hold on
mmb=mmb/nbg;
scatter(mmb(~badix),mfr(~badix),'magenta')

% [r,p] = corr(mmb(~badix)',mfr(~badix)','type','Pearson')
[r,p] = corr(mmb(~badix)',mfr(~badix)','type','Spearman')

hold on
x=(1:nbg)/nbg;

for i = 1:length(x)
    line([x(i) x(i)],[mfr(i)-sfr(i) mfr(i)+sfr(i)])
end

x=x(~badix);

p = polyfit(mmb(~badix),mfr(~badix),1);
pv = polyval(p,mmb(~badix));


plot(x,pv)

%significant rho=0.3 for mid frac with no normalization
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bin = 10;%10
% pre = 1000;
% post = 2000;
% comp = 400;%400
% cont_comp = 500;
% offset = 100;%80
%
% alpha = 0.001;%0.001
% minNumTrials = 1;%3
% normMethod = 'none';%Zscore BGsubtract none
% ExclSensoredBids = 1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
