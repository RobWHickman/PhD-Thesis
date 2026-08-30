% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')

ca;clear;load('Uly_cells_sits_1  2  3.mat')
bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardEpochEndUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
testSit = 1:3;
nanix=zeros(length(RES),1);
p=[];r=[];
for i = 1:length(RES)
    if isnan(RES(i).(bit)) 
        nanix(i,1) = 1;
    else
        sits=[];fr=[];frb=[];mmb=[];bix=[];
        sits = RES(i).(bit)(:,5);
        fr = RES(i).(bit)(:,1);        
         X = [ones(length(sits),1),sits];
        [bta,~,~,~,stats] = regress(fr,X);
        p(i) = stats(3);
        r2(i) = stats(1);
        b(i) = BetaNormalization( bta(2),sits,fr);
        for iS = 1:3            
            frb(iS) = nanmean(fr(sits==iS));
            sits_b(iS) = iS;
        end
        X = [ones(length(sits_b),1),sits_b'];
        [bb,~,~,~,stats_bin] = regress(frb',X);
        p_bin(i) = stats_bin(3);
        r2_bin(i) = stats_bin(1);
        b_bin(i) = BetaNormalization(bb(2),sits_b,frb);
    end
end
sum(p<0.05&p~=0&b>0 | p_bin<0.05&p_bin~=0&b_bin>0)

SITS = [r2',p',b'];
SITS_bin = [r2_bin',p_bin',b_bin'];

% sum(p<0.05&p~=0&r>0)
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
    mbt = bRES(i).(bit)(:,3);
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
fig = figure;
scatter(sits,nfr);
[r,p] = corr(sits,nfr,'type','Pearson')
disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
mdl=fitlm(sits,nfr,'RobustOpts','on')
sum(~nanix)
savnam = [bit,'_pop_sit_',num2str(testSit),'_p',strrep(num2str(p),'.','-')];
saveas(fig,savnam,'png')

%%
msit=[];sfr=[];mfr=[];nbids=[];incbids=[];q=[];
nbg = 30;


for i = 1:3
    six=[];
    six = sits==i;
    mfr(i) = mean(nfr(six));%/nbids(i);
    sfr(i) = Sem(nfr(six));%/nbids(i);
%     sfr(i) = ci(nfr(mbix));%/nbids(i);   
    msit(i) = i;
end

col = CambridgeDark(3);
for iF=1:2
    fig = figure;
    if iF==1
        scatter(sits,nfr,'cyan')
        hold on
    end
    
    mmsit = msit;mmfr = mfr;nnbids=nbids;
    for i=1:3
        plot(i,mmfr(msit==i),'LineStyle','none','Marker','o','MarkerEdgeColor','none','MarkerFaceColor',col(:,2))
        hold on
    end
    
    [r,p] = corr(msit',mfr','type','Pearson')
    disp(['p = ',num2str(p),' | r2 = ',num2str(r^2)])
    title([testSit,r^2,p])
    
    hold on
    x=1:3;
    
    % p=flip(table2array(mdl.Coefficients(:,1)))
    [pf,s] = polyfit(msit,mfr,1);
    [pv,d] = polyval(pf,msit,s);
    
    for i = x
        line([i i],[mfr(i)-sfr(i) mfr(i)+sfr(i)],'color',col(:,3))
        %     line([x(i) x(i)],[pv(i)-(d(i)*2) pv(i)+(d(i)*2)])
    end
    hold on
    plot(x,pv,'k')
    hold on
    xlim([0.9 3.1]);
   
%     disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
%     mdlr=fitlm(msit',mfr','RobustOpts','bisquare')
%     plot(x,mdlr.Fitted,'r')
pubify_figure_axis_robust
    savnam = [bit,'_pop_SITS','__p',strrep(num2str(p),'.','-'),'_',num2str(iF)];
    if iF==1
        ft = 'png';
    else
        ft='meta';
    end
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
