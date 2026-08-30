%%
clear;ca;clc;
load('Sit_betas.mat')
load('Bid_betas.mat')
load('Sit_bin_betas.mat')
load('Bid_bin_betas7.mat')
load('Bid_terc_betas.mat')

%% pop
r2bids = [];r2sits=[];
r2bids = BIDS(:,1);
r2sits = SITS(:,1);
bbids = BIDS(:,3);
bsits = SITS(:,3);

ranksum(r2sits,r2bids)

[r2sits,r2bids]=nan_fill(r2sits,r2bids);
figure
Plot_Bars_SEM([SITS(:,1),BIDS(:,1)])
xticklabels({'Rew. mag.','Bid'})
ylabel('R2')
pubify_figure_axis_robust

ranksum(bsits,bbids)

[bsits,bbids]=nan_fill(bsits,bbids);
figure
Plot_Bars_SEM([bsits,bbids])
xticklabels({'Rew. mag.','Bid'})
ylabel('Beta')
pubify_figure_axis_robust

%% pop bin
r2bids = [];r2sits=[];
r2bids = BIDS_bin(:,1);
r2sits = SITS_bin(:,1);
bbids = BIDS_bin(:,3);
bsits = SITS_bin(:,3);

ranksum(r2sits,r2bids)

[r2sits,r2bids]=nan_fill(r2sits,r2bids);
figure
Plot_Bars_SEM([SITS(:,1),BIDS(:,1)])
xticklabels({'Rew. mag.','Bid'})
ylabel('R2')
pubify_figure_axis_robust


bsits(isinf(bsits))=nan;
ranksum(bsits,bbids)

[bsits,bbids]=nan_fill(bsits,bbids);
figure
Plot_Bars_SEM([bsits,bbids])
xticklabels({'Rew. mag.','Bid'})
ylabel('Beta')
pubify_figure_axis_robust
%% sig 
r2bids = [];r2sits=[];
sigBid = BIDS(:,2)<.05;
r2bids = BIDS(sigBid,1);
bbids = BIDS(sigBid,3);

sigSit = SITS(:,2)<.05;
r2sits = SITS(sigSit,1);
bsits = SITS(sigSit,3);

ranksum(r2sits,r2bids)

[r2sits,r2bids]=nan_fill(r2sits,r2bids);
figure
Plot_Bars_SEM([r2sits,r2bids])
xticklabels({'Rew. mag.','Bid'})
ylabel('R2')
pubify_figure_axis_robust

ranksum(bsits,bbids)

[bsits,bbids]=nan_fill(bsits,bbids);
figure
Plot_Bars_SEM([bsits,bbids])
xticklabels({'Rew. mag.','Bid'})
ylabel('Beta')
pubify_figure_axis_robust

ovrlp = sigSit-sigBid;
onlyBd = find(ovrlp==-1);
onlySt = find(ovrlp==1);
Sit_n_Bid=find(sigSit==1&sigBid==1);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pop bid terc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r2bids = [];r2sits=[];bbids=[];bsits=[];
r2bids = BIDS_terc(:,1);
r2sits = SITS(:,1);
bbids = BIDS_terc(:,3);
bsits = SITS_bin(:,3);

ranksum(r2sits,r2bids)

[r2sits,r2bids]=nan_fill(r2sits,r2bids);
figure
Plot_Bars_SEM([SITS(:,1),BIDS(:,1)])
xticklabels({'Rew. mag.','Bid'})
ylabel('R2')
pubify_figure_axis_robust


bsits(isinf(bsits))=nan;
ranksum(bsits,bbids)

[bsits,bbids]=nan_fill(bsits,bbids);
figure
Plot_Bars_SEM([bsits,bbids])
xticklabels({'Rew. mag.','Bid'})
ylabel('Beta')
pubify_figure_axis_robust
%% sig bid terc
r2bids = [];r2sits=[];
sigBid = BIDS_terc(:,2)<.05;
r2bids = BIDS_terc(sigBid,1);
bbids = BIDS_terc(sigBid,3);

sigSit = SITS(:,2)<.05;
r2sits = SITS(sigSit,1);
bsits = SITS(sigSit,3);

ranksum(r2sits,r2bids)

[r2sits,r2bids]=nan_fill(r2sits,r2bids);
figure
Plot_Bars_SEM([r2sits,r2bids])
xticklabels({'Rew. mag.','Bid'})
ylabel('R2')
pubify_figure_axis_robust

ranksum(bsits,bbids)

[bsits,bbids]=nan_fill(bsits,bbids);
figure
Plot_Bars_SEM([bsits,bbids])
xticklabels({'Rew. mag.','Bid'})
ylabel('Beta')
pubify_figure_axis_robust

ovrlp = sigSit-sigBid;
onlyBd = find(ovrlp==-1);
onlySt = find(ovrlp==1);
Sit_n_Bid=find(sigSit==1&sigBid==1);
%%
% r2bids = [];r2sits=[]
% sigBid = BIDS_bin(:,2)<.05;
% r2bids = BIDS_bin(sigBid,1);
% 
% sigSit = SITS_bin(:,2)<.05;
% r2sits = SITS_bin(sigSit,1);
% 
% ranksum(r2sits,r2bids)
% 
% [r2sits,r2bids]=nan_fill(r2sits,r2bids);
% figure
% Plot_Bars_SEM([r2sits,r2bids])