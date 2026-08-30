clear;ca;
%
d = DropboxDir;
dt = date;

monk='Vic';

RES = LoadMonkDataBDM(monk);
RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
RES=RES(RESix);
%%
clearvars -except RES monk dt d
test_sit = [1:3];
ts = num2str(test_sit);

%%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%
if strcmp(monk,'Vic')
%     td = [d,'\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_29-Nov-2021\GettyBidRegressionWithClustersRobust\'];
%     load([td,'Vic_cells_sits_1  2  3.mat'])
    savDir = We_want_dir_funk([d,'Schultz_Lab\BDM_Data\Manuscript\Misc Figs\Rasters by frac smooth\Vic\',dt,'\sit_',ts,'_Wwtd\']);
else strcmp(monk,'Uly')
%     td = [d,'\Schultz_Lab\BDM_Data\Uly_Data\ANALYSIS_25-Nov-2021\GettyBidRegressionWithClustersRobust\'];
%     load([td,'Uly_cells_sits_1  2  3.mat'])
    savDir = We_want_dir_funk([d,'\Schultz_Lab\BDM_Data\Manuscript\Misc Figs\Rasters by frac smooth\Uly\',dt,'\sit_',ts,'\']);
end

%%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%

%%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%%
pre = 2000;
post = 2000;
num_msec = pre+post;

pop = 0;
bin = 1;
nq = 10;
num_splits = 5; %number of splits for PETH traces
sw = 200;
smeth = 'hamming';
bgs=1;
smoothit=1;
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
%     cc1=50;
%     cc2=500;

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
        omb=[];fr=[];frb=[];mmb=[];bix=[];
        omb = double(RES(i).event.monkeybid);
        cb = double(RES(i).event.computerbid);
        %         fr = RES(i).FR.(sigbit);
        sits = double(RES(i).event.situations);      
        
        rst = RES(i).rast.(testBit);
        ct_rst = RES(i).rast.FixationCrossUp;
        
        %         rst = zscore(RES(i).rast.(testBit),0,[2]);
        if bgs
%             rst = Z_scores_control_data(rst,ct_rst(:,bin:(pre-500)/bin));
            rst = rst-mean(ct_rst([1:pre,pre+1000:end]),2);
        end
        fr=[];mb=[];
        for iSit=1:3
            srst=[];
            st = ismember(sits,iSit);
            srst = rst(st,:);
            sct_rst = ct_rst(st,:);
            smb =  omb(st);
        
            if isempty(smb)
                continue
            end
            
            
            sfr = mean(srst(:,(pre+cc1)/bin:(pre+cc2)/bin),2);%/bin*1000;
            
            nfr = MinMaxFS(sfr);
            nmb = MinMaxFS(smb);
            
            fr = [fr;nfr];
            mb = [mb;nmb];
        end
        
%         figure
%         scatter(mb,fr)
%         ca
        
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
        
        frbw = nan(1,nq);
        ubix = unique(bix);
        w=[];mbb=[];frb=[];iBfr=[];
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
        bds = mbb;
        badix=[]; badix = isnan(frbw);bds=bds(~badix);frbw=frbw(~badix);%w=w(~badix);
        X = [ones(length(bds),1),bds'];
        [bb,~,~,~,stats_bin] = regress(frbw',X);
        p_binw(i) = stats_bin(3);
        r2_binw(i) = stats_bin(1);
        b_binw(i) = bb(2);
    end
end
% sigix = p<0.05&p~=0&b>0 | p_bin<0.05&p_bin~=0&b_bin>0;

% sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;
sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0|p_binw<0.05&b_binw>0;

% wtd_sig = p_binw<0.05&b_binw>0;
% sigix = p<0.05 | p_bin<0.05;
% sigix = b>0 | b_bin>0;

sum(sigix)

% sum(sigix|wtd_sig)
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
        
    fig = figure;%('Visible','off');
    newPre = 500;
    newPost = 1000;
    for iB = 1:length(bits)
        rast = [];lrast=0;mxRst=[];mnRst=[];mid=0;
        for ii = 1:3
            rst = sRES(iR).rast.(bits{iB});
            crst = sRES(iR).rast.FixationCrossUp;

            rast = rst(:,(pre-newPre)/bin:(pre+newPost)/bin);
            sits = double(sRES(iR).event.situations);
            mb =  double(sRES(iR).event.monkeybid);
            cb =  double(sRES(iR).event.computerbid);
            
            if numel(test_sit)==1
                mid_sits = ismember(sits,test_sit);
                sits = sits(mid_sits);
                rst = rst(mid_sits,:);
                rast = rast(mid_sits,:);
                mb =  mb(mid_sits);
                cb =  cb(mid_sits);
            end
            
            if numel(mb)<10
                continue
            end
            
            if numel(unique(sits))==1 
                splt = num_splits;
            else
                splt = 1;
            end
            mnmb = min(mb);mxmb=max(mb);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             edgs = linspace(mnmb-std(mb),mxmb+std(mb),nq2+1);
            edgs = linspace(mnmb,mxmb,splt+1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             edgs = quantile(mb,nq2+1);
%             edgs = linspace(0,100,nq2+1);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            pd = fitdist(mb,'Normal');
            avMb = pd.mean;stdMb = pd.std;
            %             edgs = linspace(avMb-(stdMb+2),avMb+(stdMb+2),nq2+1);

            
%             echnk = round(length(mb)/(nq2));
%             bix = ones(length(mb),1);
%             bix(1:echnk*1)=1; bix((echnk*1)+1:echnk*2)=2;bix((echnk*2)+1:length(mb))=3;
            edgs(1) = 0;edgs(end)=101;
            [N,~,bix] = histcountsEvenBins(mb,splt);   
% %             ubix = unique(bix);
% %             sml_ix = find(N<5); 
% %             for iSm = 1:length(sml_ix)
% %                 bix(bix==ubix(sml_ix(iSm)))= ubix(sml_ix(iSm))-1;
% %             end
            bixix = find(diff(bix));
            

            
            if strcmp(bits{iB},'RewardTapUp')
                wlix =  mb>cb;
            else
                wlix = logical(ones(size(mb)));
            end
            %                 if strcmp(bits{iB},'RewardTapUp')
            %                     mb = mb(wlix);
            %                     rast = rast(wlix,:);
            %                     sits=sits(wlix);
            %                 end
            if strcmp(monk, 'Vic')
                if iB==5
                    rast(:,oops(ii)-1:oops(ii)+1) = zeros(length(rast(:,1)),3);%repmat(mean(mean(rast(:,1:50))),length(rast(:,1)),3);
                end
            end
            
            sitRast = rast(sits==ii,:);
            
            %             if all(unique(sits)==2)
            if numel(test_sit)==1
                mid=1;
            end
            if sum(sum(sitRast))==0
                continue
            end
            lb=length(bits);
            lft = (.97/(lb));
            la = .125/lb;
%             wdth = (1-((la*lb)+.1))/(lb);
            wdth = lft-la;
            chnk = .205;
            if mid
                subplot('Position',[(lft*iB)-lft+la 0.3+(chnk*0) wdth .68])
            else
                subplot('Position',[(lft*iB)-lft+la 0.3+(chnk*(ii-1)) wdth chnk-.01])%-lft+la
            end
%             smoothRast = FiringRateWindowRaster(sitRast,smeth,sw);
%             imagesc(smoothRast);
%             
%             set(gca,'YDir','normal')
            PlotTrueRaster(sitRast,col(ii,:));
            hold on
            if splt>1
                %                 ejs = repmat(bixix',100,1)';
                for ibx = 1:length(bixix)
                    line([1 100],[bixix(ibx) bixix(ibx)]);
                end
            end
            g = gca;
            g.YLim(2) = sum(sits==ii);
            ShadedBox([(newPre+cc1)/bin,(newPre+cc2)/bin]);
            g.XAxis.Visible = 'off';
            %                 if iB>1
            g.YAxis.Visible = 'off';
            %                 else
            %                     yticks([0:20:200])
            %                 end
            if ii==3
                title(bits{iB});
            end
            pubify_figure_axis_robust
            if iB == length(bits)
                mbSit = [];
                subplot('Position',[(lft*iB)+la 0.3+(chnk*(ii-1)) .01 chnk-.01])%%%%%%%%%%
                mbSit = mb(sits==ii);
                clims = [0 100];
                c = flipud(colormap('hot'));
                for i = 1:length(mbSit)
                    c_chnk=length(c(:,1))/diff(clims);
                    colix = floor((c_chnk*mbSit(i)));
                    colix(colix>256)=256;
                    patch([0 1 1 0],[i-1 i-1 i i],c(colix,:),'EdgeColor','none')
                    %                     rectangle('Position',[0 i 1 i+1],'FaceColor',c(colix,:))
                    box off;axis tight
                end
                box off;axis off
            end
            subplot('Position',[(lft*iB)-lft+la 0+.08 wdth .2])
            %                 trace = smoothdata(nanmean(sitRast),'gaussian',100)*1000;
            %                 xax = ((0:length(trace)-1)/bin/1000)-(newPre/1000);
            %                 plot(xax,trace,'color',col(ii,:),'LineWidth',2)
            mxtrc = 0;
            alltrc=[];
            for inq = 1:splt
                trace = [];
                if splt>1
                    icol=inq;
%                     col = CambridgeDark(split);
                    col = cool(splt);

                else
                    icol=ii;
                    col = CambridgeDark(3);
                end
                if sum(sits==ii&bix==inq&wlix)<1
                    continue
                end
                
                % % %                 sitRast_bdqnt = rast(sits==ii&bix==inq&wlix,:);
                st = rast(sits==ii&bix==inq&wlix,:);
                cst = crst(sits==ii&bix==inq&wlix,:);
                if bgs
                    st=st-mean(cst(:,[1:pre,pre+1000:end]),2);
                    % Z_scores_control_data(st,cst,[pre-1000:pre]);
                end
                if smoothit
                    % st = FiringRateWindowRaster(st,smeth,sw);
                    st = smoothdata(st,2,'movmean',sw);
                end
                if isempty(st)
                    st = nan(size(rast(sits==ii&bix==inq&wlix,:)));
                end
                %                 sitRast_bdqnt = smoothdata(st,2,smeth,sw);
                sitRast_bdqnt = st;

%                 sitRast_bdqnt = zscore(sitRast_bdqnt,[],2);
                %                     sitRast_bdqnt = sitRast;
                
                % % %                 trace = smoothdata(mean(sitRast_bdqnt,1,'omitnan'),smeth,sw)*1000;
                trace = mean(sitRast_bdqnt,1,'omitnan')*1000;
                xax = ((0:length(trace)-1)/bin/1000)-(newPre/1000);
                plot(xax,trace,'color',col(icol,:),'LineWidth',2)
                hold on
                col = CambridgeDark(3);
                mxtrc(inq) = max(trace);
                alltrc(inq,:)=trace;
            end
            g=gca;
            g.YLim=[min(min(alltrc)) max(max(alltrc))];
%             if sum(trace)>0
%                 mxRst(ii)=max(trace(newPre/bin:newPost/bin));
%                 mnRst(ii)=min(trace(newPre/bin:newPost/bin));
%                 rng = max(mxRst-mnRst);
%                 g.YLim(1) = min(mnRst)-(rng*.1);
%                 g.YLim(2) = max([max(mxRst)*1.05,.001,mxtrc]);
% %                     g.YLim(2) = max([max(mxRst)*1.05,.001]);                
%             end
%             
            if g.YLim(2)<5,rn=1;else,rn=0;end
%             if g.YLim(2)<1,g.YLim(2)=1;end
            oyl = g.YLim;
            tks = linspace(oyl(1),oyl(2),3);
            tks = round(tks,rn);
            g.YLim = [min(tks),max(tks)];
            yticks(tks);
            pubify_figure_axis_robust
            hold on
            if iB == length(bits)
                subplot('Position',[(lft*iB)+la 0+.08 .01 .2])%(iB+1))-lft+.01
                c = flipud(colormap('hot'));
                mb_cb = 0:1:100;
                for i = 1:length(mb_cb)
                    colix = round((length(c(:,1))/100)*(i));
                    colix(colix>256)=256;
                    patch([0 1 1 0],[i-1 i-1 i i],c(colix,:),'EdgeColor','none')
                    box off
                    %                     rectangle('Position',[0 i-1 1 i],'FaceColor', c(colix,:))
                end
                yticks([0 100]);
                yticklabels([0 100]);
                box off;
            end
        end
    end
    WideFigs
    %         saveas(fig,[RES(iR).day,'_',num2str(iR)],'meta')
    nam=[savDir,sRES(iR).day,'_',num2str(iR),'.emf'];
    exportgraphics(fig,nam,'ContentType','vector');
    %
    saveas(fig,nam(1:end-4),'png')
  
    ca
    disp('.')
    %     end
    % end
    %
%     nq = 10;
    % for iR = 1:length(RES)
    
    %     for iB =2
    %         rst = RES(iR).rast.(bits{iB});
    %         mb = RES(iR).(bits{iB})(:,3);
    %         fr = nanmean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2);
    %         [r,p] = corr(mb,fr);
    %     end
    %     if r>0 && p<.05
    sct = figure('Visible','off');
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
    
    subplot(3,1,1)
    fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2);
    fr = fr/(cc2-cc1)*1000;
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
    
    subplot(3,1,2)
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
    
    subplot(3,1,3)
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
    
    pubify_figure_axis_robust
    SkinnyFigs
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