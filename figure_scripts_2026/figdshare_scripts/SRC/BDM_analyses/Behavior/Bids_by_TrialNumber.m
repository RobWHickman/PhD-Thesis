clear
monk = 'Vic';

d = DropboxDir;

if ~exist('BDM')
    %      [BDM,BC] = BDM_BX_GenerateTable(monk);
    if strcmp(monk,'Vic')
        load([d,'Schultz_Lab\Vicer\VicBx_All\Vic_BDM_BxTable.mat']);
    else
        load([d,'Schultz_Lab\Ulysses\UlyBx_All\Uly_BDM_BxTable.mat']);
    end
    [BDM, zBDM] = BDM_Exclusion_Criteria(BDM,0);
end 

BDM.reward_value = BDM.reward_value;
%%
ses = BDM.session_number;
% col = {'r' 'g' 'b'};
% col = lines(3);  
col = CambridgeDark(3);


 
PCB = [];
CB = [];
FD = [];
MB = [];
[ses,iC,iA] = unique(ses);
    
for ic = 1:length(iC)
    fig = figure('Visible','off');
    mb = [];
    fd = [];
    sesNum = ses(ic);
    iciC = iC(ic);
    l = max([sum(BDM.session_number==sesNum & BDM.reward_value==1),...
        sum(BDM.session_number==sesNum & BDM.reward_value==2),...
        sum( BDM.session_number==sesNum & BDM.reward_value==3)]);
    lt = sum(BDM.session_number==sesNum);
    
    mb = NaN(l,3);
    fd = NaN(l,3);
    cb = NaN(l,3);
    pcb = NaN(l,3);
    
    xdst = 0:.001:1;
    dist=nan(3,length(xdst));
    
    fn = {'low' 'mid' 'high'};
    for iF = 1:3
        ix = BDM.session_number==sesNum & BDM.reward_value==iF & BDM.task_failure==0;
        if sum(ix)>10
        smb = [];scb=[];MBmpMB=[];
        tn = BDM.trial_number(ix,:);
        %         smb = BDM.monkey_bid(ix);
        %         scb = BDM.previous_CB_sameRV(ix,:);
        %         MBmpMB = BDM.monkey_bid(ix)-BDM.previous_MB_sameRV(ix,:);
        gwl=21;alph = 5;
        gw = gausswin(gwl,5);
        smb = conv(BDM.monkey_bid(ix),gw,'same')/alph;
        scb = conv(BDM.previous_CB_sameRV(ix,:),gw,'same')/alph;
        MBmpMB = conv(BDM.monkey_bid(ix)-BDM.previous_MB_sameRV(ix,:),gw,'same')/alph;

        
%         mb(1:length(smb),iF)= smb;
%         fd(1:length(smb),iF) = smb-scb;
%         cb(1:length(smb),iF)= scb;
%         pcb(1:length(smb),iF) = scb;

        subplot(3,1,1)
        plot(tn,smb,'Color',col(iF,:),'LineWidth',2,'LineStyle','-','Marker','o',...
            'MarkerFaceColor',col(iF,:),'MarkerEdgeColor','none')
        pubify_figure_axis_robust
        hold on
        
        subplot(3,1,2)        
        plot(tn,MBmpMB ,'Color',col(iF,:),'LineWidth',2);%,'Marker','o')
        pubify_figure_axis_robust
        hold on
        
        subplot(3,1,3)
        plot(tn,scb,'Color',col(iF,:),'LineWidth',2);%,'Marker','o')
        pubify_figure_axis_robust
        hold on        
               
        pd=fitdist(smb,'Normal');
        dist(iF,:) = pdf(pd,0:.001:1);
        end
    end
    ti = [monk,'|',datestr(unique(BDM.date(iciC)))];
    FigureTitle(ti);
    MedFigs
    saveas(fig,['D:\Dropbox\Schultz_Lab\BDM_Data\Manuscript\Misc Figs\Bid figs\',monk,'\',strfix(ti)],'meta');
    saveas(fig,['D:\Dropbox\Schultz_Lab\BDM_Data\Manuscript\Misc Figs\Bid figs\',monk,'\',strfix(ti)],'png');
    
    fig2 = figure('Visible','off');
    for i = 1:3
        plot(xdst,dist(i,:),'color',col(i,:),'LineWidth',2)
        hold on        
    end
    
    pubify_figure_axis_robust
    
    saveas(fig2,['D:\Dropbox\Schultz_Lab\BDM_Data\Manuscript\Misc Figs\Bid figs\',monk,'\',strfix(ti),'_dist'],'meta');
    
    PCB = [PCB;pcb];
    CB = [CB;cb];
    FD = [FD;fd];
    MB = [MB;mb];
    
    
%     [r,p] = corrcoef(mb,'rows','complete');
%     Rp12(i,1) = r(1,2);
%     Rp23(i,1) = r(2,3);
%     Rp13(i,1) = r(1,3);
%     
%     Rp12(i,2) = p(1,2);
%     Rp23(i,2) = p(2,3);
%     Rp13(i,2) = p(1,3);
%     
%     
%     [r,p] = corrcoef(fd,'rows','complete');
%     fdRp12(i,1) = r(1,2);
%     fdRp23(i,1) = r(2,3);
%     fdRp13(i,1) = r(1,3);   
%     
%     fdRp12(i,2) = p(1,2);
%     fdRp23(i,2) = p(2,3);
%     fdRp13(i,2) = p(1,3);
    
%     [r,p] = corrcoef(mb(:,1),pcb(:,1),'rows','complete');
%     cbRp1(i,1) = r(1,2); 
%     cbRp1(i,2) = p(1,2);
% 
%     [r,p] = corrcoef(mb(:,2),pcb(:,2),'rows','complete');
%     cbRp2(i,1) = r(1,2);    
%     cbRp2(i,2) = p(1,2);
% 
%     [r,p] = corrcoef(mb(:,3),pcb(:,3),'rows','complete');
%     cbRp3(i,1) = r(1,2);
%     cbRp3(i,2) = p(1,2);


    
    %     msc = mscohere(mb(:,1),mb(:,2))
    %     cxy = cohere(mb(:,1),mb(:,2))
    
    %     dtw(mb(:,1),mb(:,2))
    
    %     PlotFitCurves(f)
    ca
end


%%
% % % % if 1
% % % % ca
% % % % ses = unique(BDM.date_number);
% % % % MAD=[];
% % % % for sesNum = 1:length(ses)
% % % %     mad=[];
% % % %     for sit=1:3
% % % %         pix = [];f_ix=[];
% % % % %         f_ix = find(BDM.reward_value==sit & BDM.session_number==ses(sesNum));
% % % %         f_ix = find(BDM.reward_value==sit & BDM.date_number==ses(sesNum));
% % % % 
% % % % %         mad(1:numel(f_ix),i)=nan;
% % % %         if numel(f_ix)<3
% % % %             continue
% % % %         end
% % % %         mMB(sesNum,sit) = nanmean(BDM.monkey_bid(f_ix)*1.2);
% % % %         medMB(sesNum,sit) = nanmean(BDM.monkey_bid(f_ix)*1.2);
% % % % 
% % % %         MAD(sesNum,sit) = nanmean(abs((BDM.monkey_bid(f_ix)*1.2)-medMB(sesNum,sit)));
% % % %         mSTD(sesNum,sit) = nanmean(nanstd(BDM.monkey_bid(f_ix)*1.2));
% % % % 
% % % % %         mad(1:numel(f_ix),i) = abs((BDM.monkey_bid(f_ix)*1.2)-mMB(iS,i));
% % % % %  
% % % % %         mad(mad==0)=nan;
% % % % %         mad = mad(~isnan(mad(:,i)),i);
% % % %     end
% % % % %     MAD = [MAD;mad];
% % % % end
% % % % % MAD(isoutlier(MAD,'gesd'))=nan;
% % % % MAD(MAD==0)=nan;
% % % % % mSTD(isoutlier(mSTD,'gesd'))=nan;
% % % % mSTD(mSTD==0)=nan;
% % % % 
% % % % 
% % % % for i = 1:3
% % % %     [h(i,:),p(i,:),ci(i,:),stats(i,:)]=ttest(MAD(:,i));
% % % %     Cd(i) = Cohens_D_Paired(MAD(:,i));
% % % % end
% % % % 
% % % % 
% % % % mMB(mMB==0)=nan;
% % % % fig1 = figure;
% % % % boxplot(mMB,'Symbol','xk','Widths',.3,'Jitter',.2)
% % % % title([monk,' | Session Monkey Bids']);
% % % % ylabel('Bids')
% % % % xticklabels({'Low' 'Med' 'High'});
% % % % pubify_figure_axis_robust
% % % % 
% % % % fig2 = figure;
% % % % % boxplot(MAD,'Symbol','xk','Widths',.3,'Jitter',.2)
% % % % % hold on
% % % % Plot_Mean_SEM_All_Points(MAD)
% % % % title([monk,' | Bid absolute deviation from median'])
% % % % ylabel('Abs. Deviation from mean')
% % % % xticklabels({'Low' 'Med' 'High'});
% % % % pubify_figure_axis_robust
% % % % SkinnyFigs
% % % % 
% % % % fig3 = figure;
% % % % Plot_Mean_SEM_All_Points(mSTD)
% % % % title([monk,' | Bid absolute deviation from median'])
% % % % ylabel('Abs. Deviation from mean')
% % % % xticklabels({'Low' 'Med' 'High'});
% % % % pubify_figure_axis_robust
% % % % SkinnyFigs
% % % % 
% % % % saveas(fig1,['BoxBids_',monk],'meta')
% % % % saveas(fig2,['MADBids_',monk],'meta')
% % % % %% average bid all data
% % % % mnb = nan(sum(BDM.reward_value==2),3); % 2 should be the longest because of the days where we only did 2nd rew val
% % % % mnb(1:sum(BDM.reward_value==1),1) = BDM.monkey_bid(BDM.reward_value==1);
% % % % mnb(1:sum(BDM.reward_value==2),2) = BDM.monkey_bid(BDM.reward_value==2);
% % % % mnb(1:sum(BDM.reward_value==3),3) = BDM.monkey_bid(BDM.reward_value==3);
% % % % figure;
% % % % boxplot(mnb,'Symbol','xk','Widths',.3,'Jitter',.2);
% % % % end
% % % % %%
% % % % % function PlotFitCurves(FitObj)
% % % % % fn = {'low' 'mid' 'high'};
% % % % %
% % % % % figure
% % % % % for iF = 1:3
% % % % %     plot(FitObj.(fn{iF}))
% % % % %     hold on
% % % % % end
% % % % % end
% % % % 
% % % % 
