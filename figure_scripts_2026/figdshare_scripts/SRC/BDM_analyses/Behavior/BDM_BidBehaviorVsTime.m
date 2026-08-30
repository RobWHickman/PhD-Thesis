%% bid variance and bid coherence
clear;monk = 'Vic';

d = DropboxDir;

%      [BDM,BC] = BDM_BX_GenerateTable(monk);
if strcmp(monk,'Vic')
    load([d,'Schultz_Lab\Vicer\VicBx_All\Vic_BDM_BxTable.mat'])
elseif strcmp(monk,'Uly')
    load([d,'Schultz_Lab\Ulysses\UlyBx_All\Uly_BDM_BxTable.mat'])
end
[BDM, zBDM] = BDM_Exclusion_Criteria(BDM);

BDM.previous_trial_error(isnan(BDM.previous_trial_error))=0;
% ix =  BDM.reward_value==2;
% tbl = BDM(ix,:);
% ca
% BDM.total_juice = [BDM.total_juice]/max([BDM.total_juice]);
% BDM.total_water = [BDM.total_water]/max([BDM.total_water]);
% BDM.total_liquid = [BDM.total_liquid]/max([BDM.total_liquid]);


BDM.total_juice_sqrt = sqrt(BDM.total_juice);
BDM.previous_total_liquid_sqrt = sqrt(BDM.previous_total_liquid);
BDM.total_liquid_sqrt = sqrt(BDM.total_liquid);

BDM.total_water_sqrt = sqrt(BDM.total_water);
BDM.reward_value_ml = (BDM.reward_value*.7)-.4;
BDM.pMBmpCB = BDM.previous_MB_sameRV- BDM.previous_CB_sameRV;
BDM.MBmpCB = BDM.monkey_bid- BDM.previous_CB_sameRV;


%% BDM_BidBehaviorVsTime
dn = [BDM.date_number];
undn = unique(dn);

% mb = nan(500,500);
for i = 1:length(undn)
    for ii=1:3
        idn = [BDM.date_number] == undn(i) & [BDM.reward_value]==ii;
        mb{i,ii} =  double([BDM.monkey_bid(idn)]).*1.2;
        ca
    end
end

nObs = cellfun(@numel,mb);
gdix = sum(nObs,2)>20;
mb = mb(gdix,:);
nObs = nObs(gdix,:);

bdix = find(nObs<10&nObs>0);
for i=1:numel(bdix)
    mb{bdix(i)}=nan;
end

% mb{nObs<2&nObs>0}=nan;
undn = undn(gdix)-undn(1)+1;

mbM = cellfun(@mean,mb);
mbSem = cellfun(@Sem,mb);

x=1:numel(undn);

col=CB_reds(3);
figure
% x =  repmat(undn,1,3);

mbMsm = smoothdata(mbM,1,'movmean',3);
% mbMsm = mbM;

for i = 1:3
    plot(undn,mbM(:,i),'o','MarkerEdgeColor','none','MarkerFaceColor',col(i,:))
    hold on
    plot(undn,mbMsm(:,i),'-','Color',col(i,:))
    line([undn undn]',[mbM(:,i)-mbSem(:,i) mbM(:,i)+mbSem(:,i)]','color',col(i,:))
end
pubify_figure_axis_robust
% plot(mbM-mbSem,'. ')
WideFigs

%% cell2mat(mb)
mmbM = mbM-movmean(mbM,10,1,'omitnan');
% mmbM = mbM-mean(mbM,1,'omitnan');
nein = isnan(sum(mmbM,2));
mmbMC = mmbM(~nein,:);
[r,p] = corr(mmbMC)
%% Bid coherence
ca
ses_type = 'session_number';% session_number date_number
ses = unique(BDM.(ses_type));
MnAD=[]; 
MdAD=[];ctr=0;rAll=[];pAll=[];
for sesNum = 1:length(ses)
    mbWtr=[];
    dt_ix = BDM.(ses_type)==ses(sesNum);
    daySit=[];
    daySit = [BDM.reward_value(dt_ix)];    
    if numel(unique(daySit))<3
        continue
    end
    for sit=1:3
        pix = [];f_ix=[];
        %         f_ix = find(BDM.reward_value==sit & BDM.session_number==ses(sesNum));
        sit_ix = BDM.reward_value==sit;
        f_ix =  find(sit_ix & dt_ix);

%         mad(1:numel(f_ix),i)=nan;

        tn = double([BDM.trial_number(dt_ix)]);
        
        tn_ix = tn(daySit==sit);
%         mbWtr = nan(numel(tn),3);
        mbWtr(tn_ix,sit) = double([BDM.monkey_bid(f_ix)*1.2]);
        
        mMB(sesNum,sit) = nanmean(BDM.monkey_bid(f_ix)*1.2);
        medMB(sesNum,sit) = nanmean(BDM.monkey_bid(f_ix)*1.2);

        MnAD(sesNum,sit) = mad(BDM.monkey_bid(f_ix)*1.2);
        MdAD(sesNum,sit) = mad(BDM.monkey_bid(f_ix)*1.2,1);


%         MAD(sesNum,sit) = nanmean(abs((BDM.monkey_bid(f_ix)*1.2)-medMB(sesNum,sit)));
        mSTD(sesNum,sit) = nanmean(nanstd(BDM.monkey_bid(f_ix)*1.2));

%         mad(1:numel(f_ix),i) = abs((BDM.monkey_bid(f_ix)*1.2)-mMB(iS,i));
%  
%         mad(mad==0)=nan;
%         mad = mad(~isnan(mad(:,i)),i);
    end
    bdsit = find(diff(daySit,5)==0)+5;
    tnbds_ix = tn(bdsit);
    bdsitix = zeros(max(tn),1);
    bdsitix(tnbds_ix) = 1;
    zn = sum(mbWtr,2)==0 | bdsitix;
    mbWtr = mbWtr(~zn,:);
    numGrtrZro = (length(mbWtr(:,1))-sum(mbWtr==0,1));
    dNGZ = diff(numGrtrZro);
    if any(numGrtrZro<10)%||any(abs(dNGZ)>30)
        continue
    end
    mbWtr(mbWtr==0)=nan;   
%     mbWtr_filled = fillmissing(mbWtr,'linear');
    mbWtr_filled = fillmissing(mbWtr,'nearest','EndValues','nearest');
%     mbWtr_filled = fillmissing(mbWtr,'movmean',20,'EndValues','nearest');


%     mbWtr_filled = fillmissing(mbWtr,'makima',1);

%     figure
%     plot(mbWtr_filled)    
    [r,p] =corr(mbWtr_filled)
    rAll(:,:,sesNum)=r;pAll(:,:,sesNum)=p;
    sgixp(:,:,sesNum) = p<.05 & p>0 & r>0;
    sgixn(:,:,sesNum) = p<.05 & p>0 & r<0;
    rOff = [r(1,2),r(1,3),r(2,3)];
    if any(rOff>.9)||any(rOff<-.6)
        figure
        plot(mbWtr_filled)
        ca
    end
    rix(:,:,sesNum) = r>0;
    ctr = ctr+1;
%     ca
%     MAD = [MAD;mad];
end
for i=1:length(rAll(1,1,:))
    if all(all(rAll(:,:,i)==0))
        bdix(i)=1;
    else
        bdix(i)=0;
    end
end
mean(rAll(:,:,~bdix),3)
sum(sgixp(:,:,~bdix),3)
sum(sgixn(:,:,~bdix),3)

sum(rix(:,:,~bdix),3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
col=CB_reds(3);p=[];

rLM=[];rLH=[];rMH=[];
rLM(:,1) = rAll(1,2,~bdix);
rLH(:,1) = rAll(1,3,~bdix);
rMH(:,1) = rAll(2,3,~bdix);
figure
Plot_Mean_SEM_All_Points([rLM,rMH,rLH],col)
median(rLM)
median(rMH)
median(rLH)
% boxplot([rLM,rMH,rLH])

hold on
g=gca;
line([g.XLim],[0 0],'color','k');
pubify_figure_axis_robust
title(['Bid Coherence | ',monk])
ylabel('rho')
xticklabels({'L:M' 'M:H' 'L:H'})
g.YLim = [-.8 1];
p{1,1}='LM';p{1,2}='MH';p{1,3}='LH';
[p{2,1}] = signrank(rLM);
[p{2,2}] = signrank(rMH);
[p{2,3}] = signrank(rLH);
[p{3,1}] = median(rLM,'omitnan');
[p{3,2}] = median(rMH,'omitnan');
[p{3,3}] = median(rLH,'omitnan');

%%
p=[];
% MAD(isoutlier(MAD,'gesd'))=nan;
MnAD(MnAD==0)=nan;
MdAD(MdAD==0)=nan;

% mSTD(isoutlier(mSTD,'gesd'))=nan;
mSTD(mSTD==0)=nan;


for i = 1:3
    [h(i,:),p(i,:),ci(i,:),stats(i,:)]=ttest(MnAD(:,i));
    Cd(i) = Cohens_D_Paired(MnAD(:,i));
end


mMB(mMB==0)=nan;
fig1 = figure;
boxplot(mMB,'Symbol','xk','Widths',.3,'Jitter',.2)
title([monk,' | Session Monkey Bids']);
ylabel('Bids')
xticklabels({'Low' 'Med' 'High'});
pubify_figure_axis_robust

fig2 = figure;
% boxplot(MAD,'Symbol','xk','Widths',.3,'Jitter',.2)
% hold on
Plot_Mean_SEM_All_Points(MdAD,col)
title([monk,' | Bid absolute deviation from median'])
ylabel('Abs. Deviation from median')
xticklabels({'Low' 'Med' 'High'});
pubify_figure_axis_robust
SkinnyFigs
xlim([0,4])

fig3 = figure;
Plot_Mean_SEM_All_Points(MnAD,col)
title([monk,' | Bid absolute deviation from mean'])
ylabel('Abs. Deviation from mean')
xticklabels({'Low' 'Med' 'High'});
pubify_figure_axis_robust
SkinnyFigs
xlim([0,4])


saveas(fig1,['BoxBids_',monk],'meta')
saveas(fig2,['MADBids_',monk],'meta')
%% average bid all data
mnb = nan(sum(BDM.reward_value==2),3); % 2 should be the longest because of the days where we only did 2nd rew val
mnb(1:sum(BDM.reward_value==1),1) = BDM.monkey_bid(BDM.reward_value==1);
mnb(1:sum(BDM.reward_value==2),2) = BDM.monkey_bid(BDM.reward_value==2);
mnb(1:sum(BDM.reward_value==3),3) = BDM.monkey_bid(BDM.reward_value==3);
figure;
boxplot(mnb,'Symbol','xk','Widths',.3,'Jitter',.2);

%%
% function PlotFitCurves(FitObj)
% fn = {'low' 'mid' 'high'};
%
% figure
% for iF = 1:3
%     plot(FitObj.(fn{iF}))
%     hold on
% end
% end





