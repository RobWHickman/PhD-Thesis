clear;load('Uly_cells_sits_1  2  3.mat')
% clear;load('Vic_cells_sits_3.mat')

% ca
numQuants =3;
pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];
% 

ix = logical(ones(length(RES),1));
ix(13)=0;
RES=RES(ix);


tstBit = 'FractalDisplayUp';%  
% bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardEpochEndUp' 'BudgetTapUp'};
% % 
gdix = zeros(1,length(RES));
for iR=1:length(RES)
    if sum(sum(isnan(RES(iR).(tstBit))))<1
        gdix(iR) = 1;
    end
end
gdix = logical(gdix);            
RES = RES(gdix);

for i = 1:length(RES)
    for ii = 1:numQuants
%         if i ==49
%              fr(i,:,ii) = nan(1,400);
%             continue
%         end
        fr(i,:,ii) = [RES(i).(tstBit)(ii,:)];
        ctd(i,:,ii) = [RES(i).FixationCrossUp(ii,:)];
    end
end
[~,numBin,~] = size(fr);
bin = num_msec/numBin;
% zfr = Z_scores_DH(fr);%,[((pre-990)/bin):((pre)/bin)]);
% zfr = Z_scores_control_data(fr,ctd,[((pre-500)/bin):((pre)/bin)]);
zfr = zscore(fr,0,2);%
% zfr = fr;%-nanmean(ctd(:,((pre-990)/bin):((pre)/bin)),2);
% % 
szfr = smoothdata(zfr,2,'gaussian',15);
% szfr = smoothdata(zfr,2,'movmean',7);
% szfr = zfr;

x = (((1:numBin)-.5)*bin)-pre;
% 
% ix1 = find(x>=100,1,'first');
% ix2 = find(x<=250,1,'last');
% 
ix1 = round((pre+200)/bin);%100
ix2 = round((pre+500)/bin);%400

tix1 = (ix1*bin)-pre;
tix2 = (ix2*bin)-pre;


figure
col = lines(numQuants);
y1 = min(min(nanmean(szfr)))-.01;
y2 = max(max(nanmean(szfr)));
xptch = [tix1 tix2 tix2 tix1];
yptch = [y1   y1   y2   y2];
patch(xptch,yptch,'b','FaceColor','k','FaceAlpha',.075,'EdgeColor','none');
hold on
for i= 1:numQuants
% plot_error_lines(szfr(:,:,i),'SEM',x,col(i,:));
plot(x,nanmean(szfr(:,:,i)),'color',col(i,:),'LineWidth',2);

mzfr(i,:) = nanmean(szfr(:,(pre/bin):ix2,i));
hold on
end
legend
g=gca;
g.YLim = [min(min(mzfr))-.01 max(max(mzfr))+.01];
g.XLim = [-150 650];
pubify_figure_axis
%% ANOVA
mfr=[];
mfr(:,1:numQuants) = mean(zfr(:,ix1:ix2,:),2);
% [p,tbl,stats] = anova1(mfr);
% multcompare(stats,'CType','hsd')
% % 
% % [h,p,ci,stats] = ttest(mfr(:,1),mfr(:,2))
% [p,h,stats] = signrank(mfr(:,1),mfr(:,2))
% [p,h,stats] = ranksum(mfr(:,1),mfr(:,2))
% 

[p,tbl,stats] = kruskalwallis(mfr)
multcompare(stats,'CType','bonferroni')

% [p,tbl,stats] =friedman(mfr,1,'on')
% figure
% multcompare(stats,'CType','hsd')

%%
figure
for i= 1:numQuants
% plot(x,ctd(:,:,i),'color',col(i,:))
plot(x,nanmean(ctd(:,:,i)),'color',col(i,:),'LineWidth',2);

hold on
end
pubify_figure_axis

%% f
lmh = {'low' 'mid' 'high'};
for ii=1:numQuants
figure
imagesc(zfr(:,:,ii))
title(lmh{ii})
colorbar
g=gca;
g.CLim = [0 1];
end
% hold on
% 
% g=gca;
% line([((pre-500)/bin) ((pre-200)/bin)],[g.YLim(2)-.5 g.YLim(2)-.5],'color','r','linewidth',2)



