% clear;load('Uly_cells_sits_1  2  3.mat')
clear;load('Vic_cells_sits_1  2  3.mat')

% ca
bin=1;
numQuants = 5;
pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];
% 

col = lines(3);

% tstBit = 'FractalDisplayUp';%  
% bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardEpochEndUp' 'BudgetTapUp'};
bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardTapUp' 'BudgetTapUp'};

% % 
% gdix = zeros(1,length(RES));
% for iR=1:length(RES)
%     for i = 1:3
%         if sum(sum(RES(iR).(tstBit){i}))>1 || sum(sum(isnan(RES(iR).(tstBit){i})))<1;
%             gdix(iR)=1;
%         end
%     end
% end
% gdix = logical(gdix);            
% RES = RES(gdix);

numBin = (pre+post)/bin;
x = (((1:numBin)-.5)*bin)-pre;
lb=length(bits);
% corrs
%%
ctr=1;ctr2 = 1;siggy=0;siggy2 = 0;
for i = 1:length(RES)
    for iB = 1:length(bits)
        if i==1
            aFR.(bits{iB})=[];
            aSits.(bits{iB}) = [];
        end
        rast = [];cont_rast=[];
        for ii = 1:3
            rast = [rast;[RES(i).(bits{iB}){ii}]];
            cont_rast = [cont_rast;[RES(i).FixationCrossUp{ii}]];
        end
        sits=[];FR=[];cFR=[];FRbgs=[];
        sits = [RES(i).situations];
        FR = mean(rast(:,(pre+100)/bin:(pre+400)/bin),2);
        cFR = mean(cont_rast(:,(pre-800)/bin:(pre-60)/bin),2);
        FRbgs = FR-cFR;
        
        X = [ones(length(FR),1),FRbgs];
        y = sits;
        [rho,p] = corr(FRbgs,y,'type','Spearman','rows','pairwise');
%         [rho,p] = corrcoef(FRbgs,y);
%         p=p(1,2);rho=rho(1,2);
        [b,bint,~,~,stats] = regress(y,X);
        if stats(3)<.01 && length(unique(y))>1
            REG(ctr).(bits{iB}).b = BetaNormalization(b(2),FRbgs,y);
            REG(ctr).(bits{iB}).bint = bint;
            REG(ctr).(bits{iB}).r2 = AdjustedR2(stats(1),length(y),1);
            REG(ctr).(bits{iB}).p = stats(3);
            siggy=1;
        end
        if p<.05 && rho>0
            COR(ctr2).(bits{iB}).rho = rho;
            COR(ctr2).(bits{iB}).p = p;
            siggy2 = 1;
            aFR.(bits{iB}) = [aFR.(bits{iB});FRbgs];
            aSits.(bits{iB}) = [aSits.(bits{iB});sits];
        end

    end
    if siggy==1 && stats(1)~=-inf
        ctr = ctr+1;
        siggy=0;
    end
    if siggy2==1 
        ctr2 = ctr2+1;
        siggy2=0;
    end
end
fracfr = [aFR.FractalDisplayUp];
fracsit = [aSits.FractalDisplayUp];
[r,p]=corr(fracfr,fracsit,'type','Spearman')
numel([COR.FractalDisplayUp])
%%
for i = 1:length(RES)
    p=1;fr=[];mb=[];
    
    for iB =2
        rst = [RES(i).(bits{iB})];
        mb = RES(i).monkey_bids(:,1);
        fr = nanmean(rst(:,(pre+140)/bin:(pre+400)/bin),2);
        [r,p] = corr(mb,fr);
    end 
    if p<.05
    fig = figure%('Visible','off');
    for iB = 1:length(bits);
        rast = [];lrast=0;mxRst=[];
        for ii = 1:3
            rst = [RES(i).(bits{iB})];
            rast = rst(:,(pre-500)/bin:(pre+1000)/bin);
            sits = RES(i).situations;
            sitRast = rast(sits==ii,:);
            % subplot(4,lb,(lb*ii)-lb+iB)
            lft = (1/(lb))-0.005;
            btm = 1/4;
            subplot('Position',[(lft*iB)-lft+.03 1-(btm*ii) .125 .22])
%             axes('OuterPosition',[(lft*iB)-lft 1-(btm*ii) .166 .195])% [l b w h]


            imagesc(sitRast);
            g=gca;
            colormap(g,SingleColorMap(col(ii,:)));
            colormap(turbo);

            if iB>1
                yticklabels([])
            end
            xticklabels([]);
            if ii==1
                title(bits{iB});
            end
            pubify_figure_axis_robust
            % subplot(4,length(bits),(lb*4)-lb+iB)
            subplot('Position',[(lft*iB)-lft+.03 1-(btm*3.9) .125 .2])
            %             btax = axes('OuterPosition',[lft*iB-lft 1-(btm*3.9) .166 .195])% [l b w h]
            %             plot_error_lines(rast,'SEM',x,col(ii,:));
            trace = smoothdata(nanmean(sitRast),'gaussian',7);
            plot(trace,'color',col(ii,:))
            g=gca;
            mxRst(ii)=max(trace(500/bin:1000/bin));
            g.YLim(1)=-.05;g.YLim(2)=max(mxRst);
            pubify_figure_axis_robust
            hold on
        end
    end
    WideFigs
%     saveas(fig,[RES(i).cluster,'_',RES(i).day],'meta')
%     saveas(fig,[RES(i).cluster,'_',RES(i).day],'png')
%     saveas(fig,['turbo_',RES(i).cluster,'_',RES(i).day],'meta')
%     saveas(fig,['turbo_',RES(i).cluster,'_',RES(i).day],'png')

    ca
    end
end


%%
% zfr = Z_scores_DH(fr,[((pre-800)/bin):((pre-100)/bin)]);
% 
% zfr = Z_scores_control_data(fr,ctd,[((pre-600)/bin):((pre)/bin)]);
% 
% zfr = zscore(fr,0,2);%
% % 
zfr = fr;

szfr = smoothdata(zfr,2,'gaussian',7);
% szfr = smoothdata(zfr,2,'movmean',7);
% szfr = zfr;

% 
% ix1 = find(x>=100,1,'first');
% ix2 = find(x<=250,1,'last');
% 
ix1 = round((pre+200)/bin);
ix2 = round((pre+400)/bin);

tix1 = (ix1*bin)-pre;
tix2 = (ix2*bin)-pre;


figure
col = lines(numQuants);
y1 = min(min(mean(szfr)))-.01;
y2 = max(max(mean(szfr)));
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
g=gca;
g.YLim = [min(min(mzfr))-.01 max(max(mzfr))+.01];
g.XLim = [-150 650];
pubify_figure_axis
%% ANOVA
mfr=[];
mfr(:,1:numQuants) = mean(zfr(:,ix1:ix2,:),2);
[p,tbl,stats] = anova1(mfr);

multcompare(stats,'CType','bonferroni')

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
for ii=1:3
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
%%
for i = 1:length(RES)
    for iB = 1:length(bits);
        rast = [];lrast=0;
        for ii = 1:3
            rst = [RES(i).(bits{iB})];
            
            rast = rst(:,(pre-500)/bin:((pre+1000)/bin)-1);
            sits = RES(i).situations;
            sitRast = rast(sits==ii,:);
            
            sitTrace{iB}(i,:,ii) = nanmean(sitRast);
            
        end
    end
end
oops = [59 74 90];
lft = .14;
col = lines(3);
figure
for iB = 1:length(sitTrace)
    for ii=1:3
        subplot('Position',[(lft*iB)-lft+.03 1-(btm*3.7) .11 .85])
        trace = sitTrace{iB}(:,:,ii);
        if iB==6
            trace(:,oops(ii)-3:oops(ii)+3) = repmat(mean(mean(trace(:,1:50))),length(trace(:,1)),7);
        end
        xax = (((0:length(trace)-1)*bin)-500)/1000;
        plot_error_lines(trace,'SEM',xax,col(ii,:));
    end
    pubify_figure_axis_robust

end

WideFigs
