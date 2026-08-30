

monk = 'Vicer';
BDM = BDM;
BDM.reward_value = BDM.reward_value;
%%
ses = max(BDM.SessionNumber);
col = {'r' 'g' 'b'};
 
PCB = [];
CB = [];
FD = [];
MB = [];
    
for i = 1:ses
%     figure
    mb = [];
    fd = [];
    l = max([sum(BDM.SessionNumber==i & BDM.reward_value==1),...
        sum(BDM.SessionNumber==i & BDM.reward_value==2),...
        sum( BDM.SessionNumber==i & BDM.reward_value==3)]);
    lt = sum(BDM.SessionNumber==i);
    
    mb = NaN(l,3);
    fd = NaN(l,3);
    cb = NaN(l,3);
    pcb = NaN(l,3);

    fn = {'low' 'mid' 'high'};
    for iF = 1:3
        ix = BDM.SessionNumber==i & BDM.reward_value==iF & BDM.task_failure==0;
        tn = BDM(ix,:).TrialNumber;
        smb = MonkeyBid(ix);
%         scb = smoothdata(Predictors(ix,:).Previous_CB_sameRV,'movmean',7);
        scb = BDM(ix,:).Previous_CB_sameRV;

        
%         ntn=linspace(tn(1),tn(end),lt);
%         nsmb(:,iF)=interp1(tn,smb,ntn,'linear');
        % plot(tn,smb,'o',ntn,nsmb)
        
        mb(1:length(MonkeyBid(ix)),iF)= smb;
        % plot(ntn,nsmb(:,iF),'Color',col{iF})        
        fd(1:length(MonkeyBid(ix)),iF) = MonkeyBid(ix)-BDM(ix,:).Previous_MB_sameRV;
        cb(1:length(MonkeyBid(ix)),iF)= scb;
        pcb(1:length(MonkeyBid(ix)),iF) = BDM(ix,:).Previous_CB_sameRV;

%         subplot(3,1,1)
%         plot(tn,smb,'Color',col{iF},'Marker','o')
%         hold on
%         
%         subplot(3,1,2)        
%         plot(tn, MonkeyBid(ix)-Predictors(ix,:).Previous_MB_sameRV,'Color',col{iF},'Marker','o')
%         hold on
%         
%         subplot(3,1,3)
%         plot(tn,scb,'Color',col{iF},'Marker','o')
%         hold on        
        
        
        %         f.(fn{iF}) = fit(tn,MonkeyBid(ix),'smoothingspline','SmoothingParam',.5);
        
    end
    FigureTitle([monk,'|',datestr(unique(BDM.date(i)))]);
    FullScreenFigs
    
    PCB = [PCB;pcb];
    CB = [CB;cb];
    FD = [FD;fd];
    MB = [MB;mb];
    
    
    [r,p] = corrcoef(mb,'rows','complete');
    Rp12(i,1) = r(1,2);
    Rp23(i,1) = r(2,3);
    Rp13(i,1) = r(1,3);
    
    Rp12(i,2) = p(1,2);
    Rp23(i,2) = p(2,3);
    Rp13(i,2) = p(1,3);
    
    
    [r,p] = corrcoef(fd,'rows','complete');
    fdRp12(i,1) = r(1,2);
    fdRp23(i,1) = r(2,3);
    fdRp13(i,1) = r(1,3);   
    
    fdRp12(i,2) = p(1,2);
    fdRp23(i,2) = p(2,3);
    fdRp13(i,2) = p(1,3);
    
    [r,p] = corrcoef(mb(:,1),pcb(:,1),'rows','complete');
    cbRp1(i,1) = r(1,2); 
    cbRp1(i,2) = p(1,2);

    [r,p] = corrcoef(mb(:,2),pcb(:,2),'rows','complete');
    cbRp2(i,1) = r(1,2);    
    cbRp2(i,2) = p(1,2);

    [r,p] = corrcoef(mb(:,3),pcb(:,3),'rows','complete');
    cbRp3(i,1) = r(1,2);
    cbRp3(i,2) = p(1,2);


    
    %     msc = mscohere(mb(:,1),mb(:,2))
    %     cxy = cohere(mb(:,1),mb(:,2))
    
    %     dtw(mb(:,1),mb(:,2))
    
    %     PlotFitCurves(f)
    
end


%%
ses = unique(BDM.SessionNumber);
for iS = 1:length(ses)
    for i=1:3
        pix = [];f_ix=[];
        f_ix = find(BDM.reward_value==i & BDM.SessionNumber==ses(iS));
        mMB(iS,i) = nanmean(MonkeyBid(f_ix));
        mabsDev(iS,i) = nanmean(abs(MonkeyBid(f_ix)-mMB(iS,i)));
        
    end
end

figure;boxplot(mMB)
title('Session Monkey Bids');
ylabel('Bids')
xticklabels({'Low' 'Med' 'High'});
pubify_figure_axis_robust

figure;Plot_Mean_SEM_All_Points(mabsDev)
title('Bid absolute deviation from mean')
ylabel('Abs. Deviation from mean')
xticklabels({'Low' 'Med' 'High'});
pubify_figure_axis_robust
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


