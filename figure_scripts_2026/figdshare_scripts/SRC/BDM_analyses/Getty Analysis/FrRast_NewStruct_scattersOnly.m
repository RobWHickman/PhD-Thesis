clear;ca;
%
d = DropboxDir;
dt = date;

monk='Vic';

RES = LoadMonkDataBDM(monk);
RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
RES=RES(RESix);
%%

test_sit = [3];
ts = num2str(test_sit);

%%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%
if strcmp(monk,'Vic')
%     td = [d,'\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_29-Nov-2021\GettyBidRegressionWithClustersRobust\'];
%     load([td,'Vic_cells_sits_1  2  3.mat'])
    savDir = We_want_dir_funk([d,'Schultz_Lab\BDM_Data\Manuscript\Misc Figs\Rasters by frac\Vic\',dt,'\sit_',ts,'\']);
else strcmp(monk,'Uly')
%     td = [d,'\Schultz_Lab\BDM_Data\Uly_Data\ANALYSIS_25-Nov-2021\GettyBidRegressionWithClustersRobust\'];
%     load([td,'Uly_cells_sits_1  2  3.mat'])
    savDir = We_want_dir_funk([d,'\Schultz_Lab\BDM_Data\Manuscript\Misc Figs\Rasters by frac\Uly\',dt,'\sit_',ts,'\']);
end

%%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%

%%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%%
pre = 2000;
post = 2000;
num_msec = pre+post;

pop = 1;
bin = 1;
nq = 5;
num_splits = 3; %number of splits for PETH traces
sw = 150;
smeth = 'movmean';
%%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% 


%%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%%%%%
if strcmp(monk,'Uly')
    cc1=180;%%%%%%%%%%%%%%%%%%    CHANGE BACK   %%%%%%%%%%%%%%%%%
    cc2=340;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     cc1=180;
%     cc2=340;
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%    CHANGED 01Feb2022   %%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     cc1=145;
%     cc2=395;
end
% Vic alt win 140:230
%%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%%%%%


%%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%
bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardTapUp' 'BudgetTapUp'};
testBit = 'FractalDisplayUp';
sigbit = testBit;
%%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
col = CambridgeDark(3);

numBin = (pre+post)/bin;
x = (((1:numBin)-.5)*bin)-pre;

nanix=zeros(length(RES),1);
p=[];r=[];fr=[];zfr=[];
for i = 1:length(RES)
    if isnan(RES(i).rast.(sigbit))
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double(RES(i).event.monkeybid);
        cb = double(RES(i).event.computerbid);
        %         fr = RES(i).FR.(sigbit);
        sits = double(RES(i).event.situations);      
        
        rst = RES(i).rast.(testBit);
        ct_rst = RES(i).rast.FixationCrossUp;
        
        %         rst = zscore(RES(i).rast.(testBit),0,[2]);
%         rst = Z_scores_control_data(rst,ct_rst(:,bin:(pre-500)/bin));
        
        mid_sits = ismember(sits,test_sit);
        rst = rst(mid_sits,:);
        ct_rst = ct_rst(mid_sits,:);
        mb =  mb(mid_sits);   
        
        if isempty(mb)
            continue
        end
        
%         fr_ev = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
% %         fr_ct = mean(ct_rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
%         fr_ct = mean(ct_rst,2)/bin*1000;
%         fr = fr_ev-fr_ct;
        
        fr = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
%         fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2);
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
        
%         ridge(fr,mb,[0:0.1:1])
        
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
% sigix = b>0 | b_bin>0;

sum(sigix)

%%

% if strcmp(monk,'Vic')
%     cc1 = 145;
%     cc2 = 395;
% else strcmp(monk,'Uly')
%     cc1 = 180;
%     cc2 = 340;
% end
oops = [573 730 888];
% nq=10;


SigCtr = 0;ctr=0;
if pop
    sRES =RES;
else
    sRES = RES(sigix);
end
for iR = 1:length(sRES)
    p=1;fr=[];mb=[];frb=[];mbb=[];pb=1;r=0;rb=0;
    
%     if numel(unique(sRES(iR).event.situations))>1 && only_mid
%         continue
%     end
        
    newPre = 500;
    newPost = 1000;


    sct = figure%;('Visible','off');
    p=1;fr=[];mb=[];
    
    sits = double(sRES(iR).event.situations);
 
    rst = sRES(iR).rast.FractalDisplayUp;
    %         mb = RES(iR).FractalDisplayUp(:,3);
    mb = double(sRES(iR).event.monkeybid);
    
    mid_sits = ismember(sits,test_sit);
    rst = rst(mid_sits,:);
    mb =  mb(mid_sits);
    
    if numel(mb)<10
        continue
    end
    
    fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2);
    fr = fr/(cc2-cc1)*1000;
    
    subplot(3,2,1)
    [r,p] = corr(mb,fr);
    scatter(mb,fr)
    r2 = r^2;
    title([p,r2])
    pubify_figure_axis_robust
    
    mnmb = min(mb);mxmb=max(mb);
    edgs = linspace(mnmb,mxmb,nq+1);
    edgs(1)=0; edgs(end)=100;
    [~,~,bix] = histcounts(mb,edgs);
    frb = nan(1,nq);
    frbw = nan(1,nq);
    ubix = unique(bix);
    for ib = 1:length(ubix)
        iBfr = ubix(ib);
        frb(iBfr) = nanmean(fr(bix==iBfr));
        mbb(iBfr) = nanmean(mb(bix==iBfr));
        w(ib) = sum(bix==iBfr);
        frbw(iBfr) = WeightedMean(fr(bix==iBfr),w(ib),1,'omitnan');
        if sum(bix==iBfr)<1
            frb(iBfr) = nan;
        end
    end
    
    subplot(3,2,3)
    bds = mbb;
    badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);%w=w(~badix);
    X = [ones(length(bds),1),bds'];
    [bb,~,~,~,stats_bin] = regress(frb',X);
    p_bin = stats_bin(3);
    r2_bin = stats_bin(1);
    b_bin = bb(2);
    %         mdl = fitlm(bds',frb','Weights',w);
    %         mdl.Coefficients.pValue(2);mdl.Rsquared(1);
    pf = polyfit(bds,frb,1);
    pv = polyval(pf,bds);
    scatter(bds,frb,'filled')
    hold on
    plot(bds,pv,'k');
    title([p_bin,r2_bin,b_bin])
    
    subplot(3,2,5)
    bds = mbb;
    badix=[]; badix = isnan(frbw);bds=bds(~badix);frbw=frbw(~badix);%w=w(~badix);
    X = [ones(length(bds),1),bds'];
    [bb,~,~,~,stats_bin] = regress(frbw',X);
    p_binw = stats_bin(3);
    r2_binw = stats_bin(1);
    b_binw = bb(2);
    %         mdl = fitlm(bds',frb','Weights',w);
    %         mdl.Coefficients.pValue(2);mdl.Rsquared(1);
    pf = polyfit(bds,frbw,1);
    pv = polyval(pf,bds);
    scatter(bds,frbw,'filled')
    hold on
    plot(bds,pv,'k');
    title([p_binw,r2_binw,b_binw])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    oix = isoutlier(fr,'grubbs');
    fr = fr(~oix);
    mb=mb(~oix);
    subplot(3,2,2)
    [r,p] = corr(mb,fr);   
    scatter(mb,fr)
    r2 = r^2;
    title([p,r2])
    pubify_figure_axis_robust
    
    mnmb = min(mb);mxmb=max(mb);
    edgs = linspace(mnmb,mxmb,nq+1);
    edgs(1)=0; edgs(end)=100;
    [~,~,bix] = histcounts(mb,edgs);
    frb = nan(1,nq);
    frbw = nan(1,nq);
    ubix = unique(bix);
    for ib = 1:length(ubix)
        iBfr = ubix(ib);
        frb(iBfr) = nanmean(fr(bix==iBfr));
        mbb(iBfr) = nanmean(mb(bix==iBfr));
        w(ib) = sum(bix==iBfr);
        frbw(iBfr) = WeightedMean(fr(bix==iBfr),w(ib),1,'omitnan');
        if sum(bix==iBfr)<1
            frb(iBfr) = nan;
        end
    end
    
    subplot(3,2,4)
    bds = mbb;
    badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);%w=w(~badix);
    X = [ones(length(bds),1),bds'];
    [bb,~,~,~,stats_bin] = regress(frb',X);
    p_bin = stats_bin(3);
    r2_bin = stats_bin(1);
    b_bin = bb(2);
    %         mdl = fitlm(bds',frb','Weights',w);
    %         mdl.Coefficients.pValue(2);mdl.Rsquared(1);
    pf = polyfit(bds,frb,1);
    pv = polyval(pf,bds);
    scatter(bds,frb,'filled')
    hold on
    plot(bds,pv,'k');
    title([p_bin,r2_bin,b_bin])
    
    subplot(3,2,6)
    bds = mbb;
    badix=[]; badix = isnan(frbw);bds=bds(~badix);frbw=frbw(~badix);%w=w(~badix);
    X = [ones(length(bds),1),bds'];
    [bb,~,~,~,stats_bin] = regress(frbw',X);
    p_binw = stats_bin(3);
    r2_binw = stats_bin(1);
    b_binw = bb(2);
    %         mdl = fitlm(bds',frb','Weights',w);
    %         mdl.Coefficients.pValue(2);mdl.Rsquared(1);
    pf = polyfit(bds,frbw,1);
    pv = polyval(pf,bds);
    scatter(bds,frbw,'filled')
    hold on
    plot(bds,pv,'k');
    title([p_binw,r2_binw,b_binw])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pubify_figure_axis_robust
    MedFigs
    nam=[savDir,sRES(iR).day,'_',num2str(iR),'_scatter_','.emf'];
    exportgraphics(sct,nam,'ContentType','vector');
    nam=[savDir,sRES(iR).day,'_',num2str(iR),'_scatter_','.png'];
    saveas(sct,nam);
    ca
end

%%
%%
%%
%%
%%
%%
if 0
    oops = [73 230 388];
    sw=100;
    for iR = 1:length(sRES)
        for iB = 1:length(bits);
            rast = [];lrast=0;
            for ii = 1:3
                sitRast = [];rst=[];rast=[];
                rst = [sRES(iR).rast.(bits{iB})];
                cb =  sRES(iR).(bits{iB})(:,7);
                mb = sRES(iR).(bits{iB})(:,3);
                sits = sRES(iR).(bits{iB})(:,5);
                
                wlix = mb>cb;
                if strcmp(bits{iB},'RewardTapUp')
                    mb = mb(wlix);
                    rst = rst(wlix,:);
                    sits=sits(wlix);
                end
                if strcmp(monk, 'Vic')
                    if iB==5
                        rst(:,pre+oops(ii)-5:pre+oops(ii)+5) = repmat(mean([rst(:,pre+oops(ii)-5),rst(:,pre+oops(ii)+5)],2),1,11);%repmat(mean(mean(rast(:,1:50))),length(rast(:,1)),3);
                    end
                end
                rast = rst(:,(pre-500)/bin:((pre+1000)/bin)-1);
                sitRast = rast(sits==ii,:);
                sitTrace{iB}(iR,:,ii) = nanmean(sitRast,1);
            end
        end
    end
    oops = [59 74 90];
    lft = 1/6;
    % col = lines(3);
    col = CambridgeDark(3);
    pop = figure('Visible','on');
    for iB = 1:length(sitTrace)
        mxle=[];mnle=[];
        st = sitTrace{iB};
        %     zsitTrace = zscore(st,0,[2]);
        zsitTrace = st;
        
        for ii=1:3
            %         subplot('Position',[(lft*iB)-lft+.03 0+(chnk) .11 .6])
            subplot('Position',[(lft*iB)-lft+.03 .2 .125 .6])
            trace = zsitTrace(:,:,ii);
            
            xax = (((0:length(trace)-1)*bin)-500)/1000;
            %         ztrace = zscore(trace,0,[2]);
            trace = trace/bin*1000;
            sztrace = smoothdata(trace,2,'gaussian',sw);
            le=[];
            le = plot_error_lines(sztrace,'none',xax,col(ii,:));
            mxle(ii) = max(le(1,:));
            mnle(ii) = min(le(3,:));
            
        end
        mmxle = max(mxle);
        mmnle = min(mnle);
        
        ylim([mmnle mmxle])
        pubify_figure_axis_robust
        legend
    end
    
    WideFigs
    nam=[savDir,'POPULATION_by_Frac','.emf'];
    exportgraphics(pop,nam,'ContentType','vector');
    ca
    %%
    if 0
        %%
        ctr=1;ctr2 = 1;siggy=0;siggy2 = 0;
        for iR = 1:length(sRES)
            for iB = 1:length(bits)
                if iR==1
                    aFR.(bits{iB})=[];
                    aSits.(bits{iB}) = [];
                end
                rast = [];cont_rast=[];
                for ii = 1:3
                    rast = [rast;[sRES(iR).(bits{iB}){ii}]];
                    cont_rast = [cont_rast;[sRES(iR).FixationCrossUp{ii}]];
                end
                sits=[];FR=[];cFR=[];FRbgs=[];
                sits = [sRES(iR).situations];
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
        numQuants = 5;

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
        for iR= 1:numQuants
            % plot_error_lines(szfr(:,:,i),'SEM',x,col(i,:));
            plot(x,nanmean(szfr(:,:,iR)),'color',col(iR,:),'LineWidth',2);
            
            %     mzfr(iR,:) = nanmean(szfr(:,(pre/bin):ix2,iR));
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
        for iR= 1:numQuants
            % plot(x,ctd(:,:,i),'color',col(i,:))
            plot(x,nanmean(ctd(:,:,iR)),'color',col(iR,:),'LineWidth',2);
            
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
    end
end
% line([((pre-500)/bin) ((pre-200)/bin)],[g.YLim(2)-.5 g.YLim(2)-.5],'color','r','linewidth',2)
%%

%                 imagesc(mbSit,clims)
%                 c = flipud(colormap('hot'));
%                 colormap(c)
%                 set(gca,'YDir','normal');
%                 set(gca,'YTickLabel','');set(gca,'XTickLabel','');


%     imagesc(1,[min(mb):10:max(mb)],[min(mb):10:max(mb)]',[min(mb) max(mb)]);
%                 set(gca,'YDir','normal');
%%
%%
% % % % %%
% % % %
% % % %     for iB = 2
% % % % %         if unique([RES(iR).(bits{iB})(:,5)])==2
% % % % %              unique([RES(iR).(bits{iB})(:,5)])
% % % %             crst = sRES(iR).rast.FixationCrossUp;
% % % %             rst = sRES(iR).rast.(bits{iB});
% % % % %             rst = zscore(RES(iR).rast.(bits{iB}),1,2);
% % % % %             rst = Z_scores_control_data(rst,crst,[(pre-1000)/bin:(pre-100)/bin]);
% % % %
% % % %
% % % %             cb = sRES(iR).event.monkeybid;
% % % %             mb = sRES(iR).event.computerbid;
% % % % %             cfr  = nanmean(crst(:,(pre-1500)/bin:(pre-100)/bin),2);
% % % %             fr = nanmean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2);
% % % % %             bgfr = fr-cfr;
% % % %             mnmb = min(mb);mxmb=max(mb);
% % % %             edgs = linspace(mnmb,mxmb,nq+1);
% % % % %             edgs = quantile(mb,nq+1);
% % % %             edgs(1)=0; edgs(end)=100;
% % % %             [~,~,bix] = histcounts(mb,edgs);
% % % %             frb = nan(1,nq);
% % % %             ubix = unique(bix);
% % % %             for ib = 1:length(ubix)
% % % %                 iBfr = ubix(ib);
% % % %                 bfr = fr;
% % % % %                 frb(iBfr) = (sum(bfr(bix==iBfr)*sum(bix==iBfr)))./sum(bix==iBfr);
% % % %                 frb(iBfr) = nanmean(bfr(bix==iBfr));
% % % % %                 if sum(bix==iBfr)<=3
% % % % %                     frb(iBfr) = nan;
% % % % %                 end
% % % %                 mbb(iBfr) = nanmean(mb(bix==iBfr));
% % % %                 w(ib) = sum(bix==iBfr);
% % % %             end
% % % %             badix = isnan(frb);mbb=mbb(~badix);frb=frb(~badix);%w=w(~badix);
% % % %             if ~isempty(mbb)
% % % %             [rb,pb] = corr(mbb',frb');
% % % %             end
% % % %             [r,p] = corr(mb,fr);
% % % %             %             [bgr,bgp] = corr(mb,bgfr);
% % % %             ctr = ctr+1;
% % % %             if 0%r>0 && p<.05 || rb>0 && pb<.05
% % % %                 SigCtr = SigCtr+1;
% % % %                 figure
% % % %                 subplot(7,1,1:5)
% % % %                 nbin = 20;
% % % %                 rbrst = rebin(rst,nbin,bin);
% % % %                 srbrst=FiringRateGaussRaster(rst,20,4,bin);
% % % %                 imagesc(srbrst)
% % % %                 set(gca,'YDir','normal')
% % % %                 colormap('turbo')
% % % %                 title([pb,p])
% % % %                 subplot(7,1,6:7)
% % % %                 scatter(mbb,frb,'filled')
% % % %                 hold on
% % % %                 scatter(mb,fr,'c')
% % % %                 %             hold on
% % % %                 %             scatter(mb,bgfr,'m')
% % % %
% % % %                 ca
% % % %             end
% % % % %         end
% % % %     end
% % % %     if r>0 && p<.1 || rb>0 && pb<.1