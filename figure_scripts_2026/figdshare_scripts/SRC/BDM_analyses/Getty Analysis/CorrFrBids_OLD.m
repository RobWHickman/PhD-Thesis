% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')

clearvars -except BIDsig BIDS;
load('Uly_cells_sits_1  2  3.mat');
%

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
sigbit = bit;

sigOnly = 1;
wl=2;
testSit = 1:3;
nq=7;

pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];
% 
bin=1;

cc1=180;
cc2=340;

nanix=zeros(length(RES),1);
p=[];r=[];
for i = 1:length(RES)
    if isnan(RES(i).(bit)) 
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = RES(i).(bit)(:,3);
        cb = RES(i).(bit)(:,7);
%         fr = RES(i).(bit)(:,1);
        rst = RES(i).rast.(bit);

        fr = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;

        %         rst = zscore(RES(i).rast.(testBit),0,[2]);        
        if strcmp(bit,'RewardTapUp')
            fr = fr(mb>cb,:);
            mb = mb(mb>cb);
        end
        X = [ones(length(mb),1),mb];
        [bta,~,~,~,stats] = regress(fr,X);
        p(i) = stats(3);
        r2(i) = stats(1);
        b(i)=BetaNormalization(bta(2),mb,fr);
%         if p(i)<.05 && b(i)<0
%             QuickRasterPeth(rst)
%             figure;scatter(mb,fr)
%             ca
%         end
        
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
% sigix = p<0.05&b<0 | p_bin<0.05&b_bin<0; %% negative correlation
% sigix = p<0.05 | p_bin<0.05;

% sigix = p_bin<0.05&p_bin~=0&b_bin>0;
sum(sigix)

% sum(p<0.05&p~=0&b>0)
% sum(p_bin<0.05&p_bin~=0&b_bin>0)
BIDsig.(bit)=sigix';
BIDS.(bit) = [r2',p',b'];
BIDS_bin = [r2_bin',p_bin',b_bin'];
BIDS_terc = [r2_terc',p_terc',b_terc'];
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

if sigOnly
    RES = RES(~nanix & sigix');
else
    RES = RES(~nanix);
end
fr=[];cfr=[];nfr=[];mb=[];cb=[];sits=[];pctr = 0;ctr=0;cellnum=[];

for i = 1:length(RES)
    nfrt=[];frt=[];mbt=[];cbt=[];sitt=[];p=[];r=[];bitmat=[];nbitmat=[];
    bitmat = RES(i).(bit);
    if wl==0
        wlix = [bitmat(:,3)]<[bitmat(:,7)];
        if strcmp(bit,'RewardTapUp')
             error('No reward in lost trial');
        end
    elseif wl==1 || strcmp(bit,'RewardTapUp')
        wlix = [bitmat(:,3)]>[bitmat(:,7)];
    else 
        wlix = ones(size([bitmat(:,3)]));
    end
    wlix = logical(wlix);
    nbitmat = bitmat(wlix,:);

    mbt = nbitmat(:,3);
    cbt = nbitmat(:,7);
    frt = nbitmat(:,1);
    rst = RES(i).rast.(bit)(wlix,:);
    %         rst = zscore(RES(i).rast.(testBit),0,[2]);    
    frt = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;

    sitt = nbitmat(:,5);
    cont = nbitmat(:,2);

   
    cfr = [cfr;cont];
    fr = [fr;frt];
    if sum(cont==0)==length(cont)
        continue
    end
%         nfrt = (frt-nanmean(cont))./nanstd(cont);
    % %     nfrt = (frt-nanmean(frt))./nanstd(frt);
    nfrt = zscore(frt);
    %     cont =  zscore(cont);
    %     nfrt = (frt-(cont))./(cont+.00000001)*100;
    %     nfrt = (frt-(cont));
%         nfrt= MinMaxFS(frt);
%         nfrt =frt;
%     
    
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
    cb = [cb;cbt];
    sits = [sits;sitt];
    ctr=ctr+1;
    cctr = repmat(ctr,size(sitt));
    cellnum = [cellnum;cctr];
end

% if wl==1
%     winix = mb>cb;
% elseif wl==0
%     winix = mb<cb;
% else
%     winix = ones(size(mb));
% end
% 
% if strcmp(bit,'RewardTapUp')
%     rewix = mb>cb;
% else
%     rewix = ones(size(mb));
% end

% ix = ~isnan(nfr)&winix&rewix;
ix = ~isnan(nfr);

mb = mb(ix);
cb = 100-cb(ix);
nfr = nfr(ix);
cn = cellnum(ix);
sits = sits(ix);


Sitix = ismember(sits,testSit);
nfr = nfr(Sitix);
mb=mb(Sitix);
cb=cb(Sitix); 
cn = cellnum(Sitix);

cellcnt = numel(unique(cn));

ocb=cb;
% cb = 100-ocb;

fig = figure;
scatter(mb,nfr);
[r,p] = corr(mb,nfr,'type','Pearson')
disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
mdl=fitlm(mb,nfr,'RobustOpts','on')
sum(~nanix)
savnam = [bit,'_pop_sit_',num2str(testSit),'_p',strrep(num2str(p),'.','-')];
saveas(fig,savnam,'png')
%%
fig = figure;
scatter(cb,nfr);
[r,p] = corr(cb,nfr,'type','Pearson')
disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
mdl=fitlm(cb,nfr,'RobustOpts','on')
sum(~nanix)

%% 
badix=[];mmb=[];sfr=[];mfr=[];
for i = 1:101
    mbix = mb==i;
    nbids(i) = sum(mbix);
end
minbid = max(mean(nbids)-std(nbids),10);
minbid =5;

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


disp('~~~~~~~~~~~~~~~~~~~~Weighted~~~~~~~~~~~~~~~~~~~~')
mdlw=fitlm(mmb(~badix)',mfr(~badix)','Weights',nbids(~badix))
figure;plot(mdlw);title('Weighted')
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
nbg = 30;
for  i = 1:nbg
    mbix = ismember(mb,(round((i-1)*(100/nbg))+1):round(i*(100/nbg)));
    nbids(i) = sum(mbix);
end
zx = nbids==0;
% minbid = max(median(nbids(~zx))-(1*std(nbids(~zx))),50);%,20);
% minbid = median(nbids(~zx));
% minbid = mode(nbids);
minbid = 20; % min of 50 bids works for VIC %min 20 for Uly
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
col = CambridgeDark(3);
incbids=find(incbids);
for iF=1:2
    fig = figure;
    if iF==1
    badix = isnan(mfr)| mmb==0;
    scatter(mb/(100/nbg),nfr,'cyan')
    hold on
    end
    % scatter(mmb(~badix),mfr(~badix),'magenta')
    
    mmbb = mmb(~badix);mmfr = mfr(~badix);nnbids=nbids(~badix);
    for i=1:length(mmbb)
        plot(mmbb(i),mmfr(i),'LineStyle','none','Marker','o','MarkerEdgeColor','none','MarkerFaceColor',col(:,2),'MarkerSize',nnbids(i)/50)
        hold on
    end
    
    [r,p] = corr(mmb(~badix)',mfr(~badix)','type','Pearson')
    % [r,p] = corr(mmb(~badix)',mfr(~badix)','type','Spearman')
    disp(['p = ',num2str(p),' | r2 = ',num2str(r^2)])
    title([r^2,p])
    
    hold on
    x=1:nbg;
    x=x(~badix);
    
    
    % p=flip(table2array(mdl.Coefficients(:,1)))
    [pf,s] = polyfit(mmb(~badix),mfr(~badix),1);
    [pv,d] = polyval(pf,mmb(~badix),s);
    
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
%     plot(x,mdlw.Fitted,'m')
    disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
    mdlr=fitlm(mmb(~badix)',mfr(~badix)','RobustOpts','bisquare')
%     plot(x,mdlr.Fitted,'r')

    % disp('~~~~~~~~~~~~~~~~~~~~Weighted and robust~~~~~~~~~~~~~~~~~~~~')
    % mdl=fitlm(mmb(~badix)',mfr(~badix)','RobustOpts','on','Weights',nbids(~badix)/10)
    % figure;plot(mdl);title('Weighted & Robust');
    % figure;plot(mdlw);title('Weighted');
    % figure;plot(mdlr);title('Robust');
    savnam = [bit,'_popBinned_sit',num2str(testSit),'_minBid',num2str(minbid),'__p',strrep(num2str(p),'.','-'),'_',num2str(iF)];
    if iF==1
        ft = 'png';
    else
        ft='meta';
    end
    axis tight
    pubify_figure_axis_robust
%     WideFigs
    saveas(fig,savnam,ft)
    
end

%%
%%
%%
%%
badix=[];mmb=[];sfr=[];mfr=[];
for i = 1:101
    mbix = cb==i;
    nbids(i) = sum(mbix);
end
minbid = max(mean(nbids)-std(nbids),10);
minbid =5;

for i = 1:100
    mbix = cb==i;
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


disp('~~~~~~~~~~~~~~~~~~~~Weighted~~~~~~~~~~~~~~~~~~~~')
mdlw=fitlm(mmb(~badix)',mfr(~badix)','Weights',nbids(~badix))
figure;plot(mdlw);title('Weighted')
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
mb
mmb=[];sfr=[];mfr=[];nbids=[];incbids=[];q=[];
nbg = 30;
for  i = 1:nbg
    mbix = ismember(cb,(round((i-1)*(100/nbg))+1):round(i*(100/nbg)));
    nbids(i) = sum(mbix);
end
zx = nbids==0;
minbid = 20; % min of 50 bids works for VIC %min 20 for Uly
for i = 1:nbg
    mbix=[];
    mbix = ismember(cb,(round((i-1)*(100/nbg))+1):round(i*(100/nbg)));
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
col = CambridgeDark(3);
incbids=find(incbids);
for iF=1:2
    fig = figure;
    if iF==1
    badix = isnan(mfr)| mmb==0;
    scatter(cb/(100/nbg),nfr,'cyan')
    hold on
    end
    mmbb = mmb(~badix);mmfr = mfr(~badix);nnbids=nbids(~badix);
    for i=1:length(mmbb)
        plot(mmbb(i),mmfr(i),'LineStyle','none','Marker','o','MarkerEdgeColor','none','MarkerFaceColor',col(:,2),'MarkerSize',nnbids(i)/50)
        hold on
    end
    
    [r,p] = corr(mmb(~badix)',mfr(~badix)','type','Pearson')
    % [r,p] = corr(mmb(~badix)',mfr(~badix)','type','Spearman')
    disp(['p = ',num2str(p),' | r2 = ',num2str(r^2)])
    title([r^2,p])
    
    hold on
    x=1:nbg;
    x=x(~badix);
    
    % p=flip(table2array(mdl.Coefficients(:,1)))
    [pf,s] = polyfit(mmb(~badix),mfr(~badix),1);
    [pv,d] = polyval(pf,mmb(~badix),s);
    
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
%     plot(x,mdlw.Fitted,'m')
    disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
    mdlr=fitlm(mmb(~badix)',mfr(~badix)','RobustOpts','bisquare')
%     plot(x,mdlr.Fitted,'r')

    % disp('~~~~~~~~~~~~~~~~~~~~Weighted and robust~~~~~~~~~~~~~~~~~~~~')
    % mdl=fitlm(mmb(~badix)',mfr(~badix)','RobustOpts','on','Weights',nbids(~badix)/10)
    % figure;plot(mdl);title('Weighted & Robust');
    % figure;plot(mdlw);title('Weighted');
    % figure;plot(mdlr);title('Robust');
    savnam = [bit,'_popBinned_sit',num2str(testSit),'_minBid',num2str(minbid),'__p',strrep(num2str(p),'.','-'),'_',num2str(iF)];
    if iF==1
        ft = 'png';
    else
        ft='meta';
    end
    axis tight
    pubify_figure_axis_robust
%     WideFigs
    saveas(fig,savnam,ft)
    
end


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

%%
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
