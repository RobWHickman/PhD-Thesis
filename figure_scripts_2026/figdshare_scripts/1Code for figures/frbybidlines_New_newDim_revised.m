% this code produces components of figures 2, 3, s3, s4, s5, and s6

ca;clear; 
monk= 'Uly'; % 'Uly' or 'Vic'

RES = LoadMonkDataBDM(monk);
RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
RES=RES(RESix);

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
clearvars -except RES sigix bin cc1 cc2 testBit monk
ca

%%%% Analysis params %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% DO NOT CHANGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sw = 80;
meth  ='movmean';% movmean gaussian
pre = 2000;
post = 2000;
npre = 500;
npost = 1000;
zsc = 1;
bgs = 0;
zsd = 2;
zst = 'zs'; %'zs';'zscd'
wl = 2;
splitType = 'quant'; %'lin';'quant';'fitted_dist';'linpop';'quantpop';'evenSplit';
dst = 'normal';
numGdTr = 5;
nBds = 1;
stdOffset = 0;%.15
correctForSkewness = 1;% this helps to split the data into more symetric 'chunks' based on the skewness of each distribution (e.g., bids are negatively skewed for high physical reward amount)
adjstSkewness = .33333;%must be >0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% FOR MANUSCRIPT FIGURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pop = 0; % toggle to test all neurons in population (1) or only significant neurons (0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if numel(testSit)>1
%     nq=5;
% else
%     nq=3;
% end
nq=3;
saveIt=0;

if pop
    sRES = RES;
else
    sRES = RES(sigix);
end
for testSit = 1:3
    ctr=0;Traces=[];cTraces=[];
    for iR = 1:length(sRES)
        rst=[];crst=[];sits=[];cb=[];mb=[];wlix=[];wsix=[];stix=[];stmb=[];stcb=[];
        mb = double(sRES(iR).event.monkeybid);
        %     mb = sRES(iR).event.previouscomputerbid_same_RV;

        cb = sRES(iR).event.computerbid;

        sits = sRES(iR).event.situations;
        rst = sRES(iR).rast.(testBit)(:,(pre-npre)/bin:(pre+npost)/bin);
        %     crst = sRES(iR).rast.FixationCrossUp(:,(pre-npre)/bin:(pre+npost)/bin);
        crst = sRES(iR).rast.FixationCrossUp;

        if numel(unique(sits))<3 && all(testSit~=2)
            continue
        end
        if length(rst(:,1))<numGdTr
            continue
        end


        if wl==0
            wlix = mb<cb;
            if strcmp(testBit,'RewardTapUp')
                error('No reward in lost trial');
            end
        elseif wl==1 || strcmp(testBit,'RewardTapUp')
            wlix = mb>cb;
        else
            wlix = ones(size(mb));
        end
        wlix = logical(wlix);
        stix = ismember(sits,testSit);

        wsix = wlix&stix;
        stmb = mb(wsix);
        stcb = cb(wsix);
        rst = rst(wsix,:);
        crst = crst(wsix,:);

        %         if isempty(stmb) || all(unique(sits)==2)
        %             continue
        %         end

        edgs=[];
        [bPDF,bPDF_pop,dist_pop,abds]=Bids_pdf(RES,testSit,'normal');


        switch splitType
            case 'lin'
                edgs=linspace(min(stmb),max(stmb),nq+1);%***U
            case 'quant'
                qt = quantile(stmb,nq-1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if correctForSkewness
                    stdOffset = adjstSkewness*(skewness(stmb)-0);
                    edgs = [0,qt(1)+(stdOffset*std(stmb)),qt(2)+(stdOffset*std(stmb)),101];
                else
                    switch testSit
                        case 1
                            edgs = [0,qt(1),qt(2)+(stdOffset*std(stmb)),101];
                            %                         edgs = [0,qt(1)+(stdOffset*std(stmb)),qt(2)+(stdOffset*std(stmb)),101];
                        case 2
                            edgs = [0,qt(1)-(stdOffset*std(stmb)),qt(2)+(stdOffset*std(stmb)),101];
                        case 3
                            edgs = [0,qt(1)-(stdOffset*std(stmb)),qt(2),101];
                            %                         edgs = [0,qt(1)-(stdOffset*std(stmb)),qt(2)-(stdOffset*std(stmb)),101];
                    end
                end
            case 'fitted_dist'
                edgs = DistEdges(stmb,nq,dst);
                %             edgs = DistEdges(mb,nq*3,dst);
                %             edgs(1)=0;edgs(end)=100;
                %             edgs(2)=edgs(2)-(stdOffset*std(stmb)); edgs(3)=edgs(3)+(stdOffset*std(stmb));
                if correctForSkewness
                    stdOffset = adjstSkewness*(skewness(stmb)-0);
                end
                edgs = [0,edgs(2)+(stdOffset*std(stmb)),edgs(3)+(stdOffset*std(stmb)),101];
                %             edgs = [edgs(testSit*3-2:testSit*3+1)];
            case 'linpop'
                edgs=linspace(min(abds),max(abds),nq+1);
            case 'quantpop'
                qt=quantile(abds,nq-1);
                if correctForSkewness
                    stdOffset = adjstSkewness*(skewness(abds)-0);
                    edgs = [0,qt(1)+(stdOffset*std(abds)),qt(2)+(stdOffset*std(abds)),101];
                else
                    switch testSit
                        case 1
                            % edgs = [0,qt(1),qt(2)+(stdOffset*std(abds)),101];
                            %                     stdOffset = skewness(abds)-0;
                            edgs = [0,qt(1)+(stdOffset*std(abds)),qt(2)+(stdOffset*std(abds)),101];
                        case 2
                            stdOffset = skewness(abds)-0;
                            edgs = [0,qt(1)-((stdOffset)*std(abds)),qt(2)+((stdOffset)*std(abds)),101];
                            % edgs = [0,qt,101];
                        case 3
                            % edgs = [0,qt(1)-(stdOffset*std(abds)),qt(2),101];
                            %                     stdOffset = skewness(abds)-0;
                            edgs = [0,qt(1)-(stdOffset*std(abds)),qt(2)-(stdOffset*std(abds)),101];
                    end
                end
            case 'quantpopDist'
                m = dist_pop.mu;s=dist_pop.sigma;
                qt = [.3333,.6666];
                edgs = [1,norminv(qt,m,s),100];
            case 'evenSplit'
                nb = numel(stmb);
                nperbin = floor(nb/nq);
                bnixx = [1*nperbin:nperbin:nperbin*nq-1];
                edgs = [0;stmb(bnixx);101];
        end



        [nbidsPerBin(iR,:),~,bnix] = histcounts(stmb,edgs);
        bdMed(iR,1) = median(stmb(bnix==1));
        bdMed(iR,2) = median(stmb(bnix==2));
        bdMed(iR,3) = median(stmb(bnix==3));

        if any(nbidsPerBin(iR,:)<nBds)
            continue
        end

       
        if bgs
                    rst = Z_scores_control_data(rst,crst(:,1:pre-500));% %[1:pre]
        end
        ctr=ctr+1;


        for iBd = 1:nq
            ix = bnix==iBd;
            Traces(ctr,:,iBd) = nanmean(rst(ix,:),1);%/bin*1000;
            cTraces(ctr,:,iBd) = nanmean(crst(ix,:),1);%/bin*1000;
            trCtr(ctr,iBd) = sum(ix);
            trMb(ctr,iBd) = median(mb(ix));
        end
    end
    col = CB_blues(nq);


    if pop, ti='Pop';else,ti=['n = ',num2str(sum(sigix))];end

    if zsc
        switch zst
            case 'zs'
                Traces = zscore(Traces,0,zsd);
            case 'zscd'
                Traces = Z_scores_control_data(Traces,cTraces(:,1:500,:),zsd);
        end
    end

    trcFig=figure;
    sitBdTrc=[];sitBdMb=[];smooth_trace=[];trc=[];strc=[];mtrc=[];
    for iBd = 1:nq%

        sitBdTrc(:,iBd) = mean(Traces(:,npre+cc1:npre+cc2,iBd),2,'omitnan');
        sitBdMb(:,:,iBd) = repmat(iBd,length(sitBdTrc(:,1)),1);
        %     TRC(:,:) = Traces(iBd,npre+cc1:npre+cc2,:);
        %     sitBdTrc(:,iBd) = WeightedMean(TRC,trCtr(:,iBd)');
        trc = Traces(:,:,iBd);
        strc = smoothdata(trc,2,meth,sw);
        %     strc=trc;

        if ~zsc
            strc = strc./bin*1000;
        end
        xax = (0:(npost+npre))- npre;
        %     [lnn]=plot_error_lines(strc,'SEM',xax,col(iBd,:));
        %     lns(iBd,:) = lnn(2,:);
%         mtrc = WeightedMean(strc,trCtr(:,iBd));
        mtrc = mean(strc);

        plot(xax,mtrc,'Color',col(iBd,:),'LineWidth',2)
        lns(iBd,:) = mtrc;

        hold on
        smooth_trace(iBd,:,:)=strc';
        %     smooth_trace(iBd,:,:)=trc;

    end
    g=gca;
    ShadedBox([cc1 cc2],g.YLim)
    pubify_figure_axis_robust
    % xticks([-npre:300:npost])
    xlim([-npre npost]);
    yl = [min(min(lns)) max(max(lns))];
    if yl(2)==0
        yl(2)=.1;
    end
    ylim(yl);
    % xlim([-200,700]);

    % legend
    title(['situation ',num2str(testSit),' ',ti])
    WideFigSmall
    nam = sprintf('Traces_pop%d_zsc%d_wl%d_sits%d%d%d.emf',pop,zsc,wl,testSit(:));
%     g.YLim=[-.15 .21];

    switch testSit
        case 1          
            g.YLim=[-.15 .1];
            case 2         
            g.YLim=[-.1 .1];
            case 3         
            g.YLim=[-.1 .22];
    end
    g.XLim = [-200 700];
%     axis tight
    if saveIt
        saveas(trcFig,nam,'meta')
    end
    %
    sit_nams = {'sit1' 'sit2' 'sit3'};

    coFig=figure;
    mx = max(max(max(smooth_trace)));
    mn = min(min(min(smooth_trace)));

    % for i= 1:length(sRES)
    %     [~,pt(i)] = max(max(smooth_trace(:,npre:npre+400,i)));
    % end
    % xax=xax/1000;
    tc = [];
    for i = 1:nq
        sp=nq+1-i;
        subplot(nq,1,sp)
        %     subplot(3,2,sp)

        mmb = trMb(:,i);

        [~,sx]=sort(mmb);
        %     [~,sx]=sort(pt);
        sst = size(smooth_trace);
        tc(:,:) = smooth_trace(i,:,sx(sx<sst(3)));
        l = min(size(tc));
        if zsc
            imagesc(xax,[1:l],tc',[-.2 .4]);%[-.2 .3]
            %         imagesc(xax,[1:length(sRES)],tc',[-2 10]);%[mn+((mx-mn)/6) mx/3])
        else
            imagesc(xax,[1:l],tc',[mn mx/6])
        end
        %     xlim([-npre npost])
        set(gca,'YDir','normal')

        pubify_figure_axis_robust
        if i>1
            set(gca,'XTick',[])
        end
        %     colorbar
        g=gca;
        g.XLim = [-200 600];
        title(['quantile ',num2str(i)])
    end
    FigureTitle(['situation ',num2str(testSit),' ',ti])
    LongFig
    % ht = colormap('hot');
    % flrht = flipud(fliplr(ht));
    % BlueRed = [flrht(end-(256/2):end,:);ht(21:end,:)];
    % cmap = yellowblue;
    cmap = GenerateColorMap([0 0 0;.25 .25 1;1 1 0]);
    cmap(cmap<0)=0;
    colormap(cmap);
    nam = sprintf('Colormap_pop%d_zsc%d_wl%d_sits%d%d%d',pop,zsc,wl,testSit(:));
    nam = [nam,'.emf'];
    if saveIt
        exportgraphics(coFig,nam,'ContentType','vector')
    end

end

%%
%%
%% Sit Trace (plot norm imp/s vs time grouped by physical reward amount)
% Fig 2e and S3j in Manuscript
clearvars -except RES sigix bin cc1 cc2 testBit monk
ca

%%%% Analysis params %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% DO NOT CHANGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sw = 80;
meth  ='movmean';% movmean gaussian
pre = 2000;
post = 2000;
npre = 500;
npost = 1000;
zsc =1;
zsd = 2;
wl=2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% FOR MANUSCRIPT FIGURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pop = 0; % toggle to test all neurons in population (1) or only significant neurons (0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveIt=0;


ctr=0;

if pop
    sRES = RES;
else
    sRES = RES(sigix);
end
for iR = 1:length(sRES)
    mb = sRES(iR).event.monkeybid;
    cb = sRES(iR).event.computerbid;
    sits = sRES(iR).event.situations;
    rst = sRES(iR).rast.(testBit)(:,(pre-npre)/bin:(pre+npost)/bin);
    crst = sRES(iR).rast.FixationCrossUp;

    %     if zsc
    %         rst = Z_scores_control_data(rst,crst,[1:pre]);
    %         %         rst = zscore(rst,0,2);
    %     end
    for iS = 1:3

        if wl==0
            wlix = mb<cb;
            if strcmp(testBit,'RewardTapUp')
                error('No reward in lost trial');
            end
        elseif wl==1 || strcmp(testBit,'RewardTapUp')
            wlix = mb>cb;
        else
            wlix = ones(size(mb));
        end
        wlix = logical(wlix);
        stix = ismember(sits,iS);

        wsix = wlix&stix;
        stmb = mb(wsix);
        stcb = cb(wsix);
        sitrst = rst(wsix,:);
        %     crst = crst(wsix,:);

        %         crst = crst(stix,:);

        Traces(iS,:,iR) = nanmean(sitrst,1);%/bin*1000;
        cTraces(iS,:,iR) = nanmean(crst,1);%/bin*1000;
    end
end
col = CambridgeLight(3);

figure
for iSt = 1:3
    trc = [];strc=[];
    if zsc
        Traces = zscore(Traces,0,[2]);
    end
    sitBdTrc(:,iSt,:) = nanmean(Traces(iSt,npre+cc1:npre+cc2,:));
    trc(:,:) = Traces(iSt,:,:);
    strc = smoothdata(trc',2,'movmean',sw);
    if ~zsc
        strc = strc./bin*1000;
    end
    xax = (0:(npost+npre))- npre;
    [lnn]=plot_error_lines(strc,'none',xax,col(iSt,:));
    lns(iSt,:) = lnn(2,:);
    hold on
end
g=gca;
ShadedBox([cc1 cc2],g.YLim)
pubify_figure_axis_robust
WideFigSmall
% xticks([-npre:300:npost])
xlim([-npre npost]);
ylim([min(min(lns)) max(max(lns))]);
if pop, ti='Pop';else,ti=['n = ',num2str(sum(sigix))];end
title(ti)
% legend

figure
% Plot_Bars_SEM(sitBdTrc)
boxplot(sitBdTrc)
pubify_figure_axis_robust


% [anv.p,anv.tbl,anv.stats] = anova1(sitBdTrc);
[anv.p,tbl,anv.stats] = kruskalwallis(sitBdTrc)

anv.mc = multcompare(anv.stats);
title(['Anova | ',num2str(anv.p)])

%%
%%
%%
%% Sliding Window
% clearvars -except RES sigix bin cc1 cc2 testBit monk
% % ca
% pre = 2000;
% bin=1;
% npre = 200;
% npost = 700;
% nbin = 50;
% 
% testSit = 1:3;
% testBit = 'FractalDisplayUp';
% % bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp',...
% % 'RewardTapUp' 'RewardEpochEndUp' 'BudgetTapUp'};
% %
% sRES = RES;
% % sRES = RES(sigix);
% for iR = 1:length(sRES)
%     mb = sRES(iR).event.monkeybid;
%     cb = sRES(iR).event.computerbid;
%     pcb = sRES(iR).event.previouscomputerbid_same_RV;
%     sit = sRES(iR).event.situations;
%     wl = sRES(iR).event.previouswinlose;
%     tl = sRES(iR).event.previoustotalliquid;
%     sb = sRES(iR).event.startingbid;
%     sits = sRES(iR).event.situations;
%     rst = sRES(iR).rast.(testBit)(:,(pre-npre)/bin:(pre+npost)/bin);
%     crst = sRES(iR).rast.FixationCrossUp(:,(pre-npre)/bin:(pre+npost)/bin);
% 
%     %     if numel(unique(sits))<3 && ~all(testSit==2)
%     %         continue
%     %     end
% 
%     stix = ismember(sits,testSit);
%     stmb = mb(stix);
% 
%     %     sitRst = rebin(rst(stix,:),nbin,1);
%     sitRst = rst(stix,:);
%     if isempty(sitRst)
%         continue
%     end
%     X = [ones(size(stmb)),stmb];
%     %     X = [ones(size(stmb)),stmb,pcb(stix),sit(stix),wl(stix),tl(stix),sb(stix)];
% 
%     for ii = 1:length(sitRst(1,:))-nbin
%         %         if 1%zsc
%         %             sitRst = zscore(sitRst);%,0,[2]);
%         %         end
%         fr=[];
%         fr = nanmean(sitRst(:,ii:ii+nbin),2);
%         [b,bint,r,rint,stats]= regress(fr,X); %stats=[r2 F p var];
%         r2(iR,ii) = stats(1);
%         bta(iR,ii) = BetaNormalization(b(2),stmb,fr);
%     end
% end
% sw = round(50/nbin);
% xax = (1:length(r2(1,:)))-npre;
% figure
% plot_error_lines(smoothdata(r2,2,'movmean',sw),'SEM',xax)
% figure
% plot_error_lines(smoothdata(bta,2,'movmean',sw),'SEM',xax)
