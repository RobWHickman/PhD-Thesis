function [BDM,BC] = BDM_BX_GenerateTable(monk)

tic

db = DropboxDir;

if strcmp(monk,'Uly')
    pd = [db,'Schultz_Lab\Ulysses\UlyBx_All\UlyBx_All_wdups\'];mID = 'Uly';
elseif strcmp(monk,'Vic')
    pd = [db,'Schultz_Lab\Vicer\VicBx_All\VicBx_All_wdups\'];mID = 'Vic';
else
    error('no monk by that name')
end


dr = dir([pd,'*COMP*']);
[~,ix] = sortrows([dr.datenum].');
drs = dr(ix);
fn = {drs.name};

BC = [];
BDM = [];
ALL = [];

for i = 1:length(fn)
    tbl = [];
    tbl = readtable([pd,fn{i}],'DatetimeType','text');
    tbl.trial_number = tbl.trial_no;
    tbl = removevars(tbl,'trial_no');
    
    if ismember('trial_end', tbl.Properties.VariableNames)
        tbl = removevars(tbl,'trial_end');
        tbl = removevars(tbl,'trial_start');
    end
    if ismember('type', tbl.Properties.VariableNames)
        tbl = removevars(tbl,'type');
    end
    if ~ismember('free_reward', tbl.Properties.VariableNames)
        free_reward = nan(height(tbl),1);
        tbl = addvars(tbl,free_reward,'Before','juice');
    end
    
    tbl.table_number(1:height(tbl)) = i;
    tbl.date = datetime(tbl.date,'InputFormat','uuuu-dd-MM');
    
    %     date_str =fn{i}(1:10);
    %     dt(1:height(tbl),:) = datetime(date_str,'Format','uuuu-MM-dd');
    %     if dt ~= tbl.date(1)
    %         error('dates don''t match')
    %     end
    
%     bp_ix = categorical(tbl.subtask)=='blind_pav';
    bdm_ix = categorical(tbl.subtask)=='BDM'|categorical(tbl.subtask)=='Blind_Pav';
    bc_ix = categorical(tbl.subtask)=='bundle_choice';
    
    if sum(bdm_ix)<10
        bdm_ix = [];
    end
    if sum(bc_ix)<10
        bc_ix = [];
    end
    
    tbl.primary_side = categorical(tbl.primary_side);
    
    BC = [BC;tbl(bc_ix,:)];
    BDM = [BDM;tbl(bdm_ix,:)];
    ALL = [ALL;tbl];
    clear dt tbl
end

bbix = categorical(ALL.subtask)=='BDM'|categorical(ALL.subtask)=='bundle_choice';
OT = ALL(~bbix,:);

% bbdt = [unique(BDM.date);unique(BC.date)];
% TR = ALL(~ismember(ALL.date,bbdt),:);
% TR.date2 = TR.date;

% Sort
dtix = find(strcmp(BDM.Properties.VariableNames,'date'));
tmix = find(strcmp(BDM.Properties.VariableNames,'time'));
BDM = sortrows(BDM,[dtix tmix]);
dtix = find(strcmp(BC.Properties.VariableNames,'date'));
tmix = find(strcmp(BC.Properties.VariableNames,'time'));
BC = sortrows(BC,[dtix tmix]);

BDM(diff(BDM.time)==0,:) = [];
BC(diff(BC.time)==0,:) = [];

%% monkey ID
BDM.monkey_ID(1:height(BDM)) = {mID};
BC.monkey_ID(1:height(BC)) = {mID};

%% add session number
tbix = [0;find(diff(BDM.table_number)~=0);height(BDM)-1];
BDM.session_number(1:height(BDM)) = nan;
for itb = 2:length(tbix)
    BDM.session_number(tbix(itb-1)+1:tbix(itb)+1) = itb-1;
end
clear tbix itb
tbix = [0;find(diff(BC.table_number)~=0);height(BC)-1];
BC.session_number(1:height(BC)) = nan;
for itb = 2:length(tbix)
    BC.session_number(tbix(itb-1)+1:tbix(itb)+1) = itb-1;
end

BDM = removevars(BDM,{'table_number'});
BC = removevars(BC,{'table_number'});




%% find and remove duplicates
[dt,~,ic] = unique(BDM.date);
badses = [];
BadSes = [];
ctr = 1;
for id = 1:length(dt)
    dab = [];
    ix = BDM.date==dt(id);
    dtses = BDM.session_number(ix);
    [uds,idtses,iuds] = unique(dtses);
    BDMsm = BDM.monkey_bid(ix);
    if numel(idtses)>1
        ab=[];
        idtses = [idtses;length(BDMsm)];  
        didtses = diff(idtses);
        L = max(didtses);
        ab=nan(L,numel(idtses)-1);
        for ii = 1:length(idtses)-1
            ab(1:didtses(ii),ii)= BDMsm(idtses(ii):idtses(ii+1)-1);
        end
        ab(isnan(ab)) = -1;
        dab = diff(ab,1,2);
        if sum(sum(abs(dab))==0)>0
            badix = find(sum(abs(dab))==0);
            badses{ctr,1} = unique(dtses);
            badses{ctr,2} = uds(badix+1);
            badses{ctr,3} = ab;
            BadSes = [BadSes;uds(badix+1)];
            ctr = ctr+1;
        end
    end
end

for ibs = 1:length(BadSes)
    badsesix = BDM.session_number==BadSes(ibs);
    BDM(badsesix,:) = [];
end

%%
[dt,ia,ic] = unique(BDM.date);
BDM.date_number = ic;
BDM.day_of_week = weekday(BDM.date);

iae = [ia;height(BDM)];
TotJuc = [];
TotWat = [];
TotLiq = [];
for idt = 1:length(iae)-1
    tmpw=[];
    ix = iae(idt);ixx = iae(idt+1)-1;
    tmp = BDM(ix:ixx,:);
    w = tmp.water;
    j = tmp.juice;
    wix = [1;find(abs(diff(w))>2);numel(w)];
    wat=[];
    juc = [];
    for i = 1:length(wix)-1
        if i==1
            wat = [wat;w(wix(i):wix(i+1))];
            juc = [juc;j(wix(i):wix(i+1))];
        else
            wat = [wat;w(wix(i)+1:wix(i+1))+w(wix(i))];
            juc = [juc;j(wix(i)+1:wix(i+1))+j(wix(i))];
        end
    end
    TotJuc = [TotJuc;juc];
    TotWat = [TotWat;wat];
end
lvw = wat(end)+diff([w(end),w(end-1)]);
lvj = juc(end)+diff([j(end),j(end-1)]);
BDM.total_juice = [TotJuc;lvj];
BDM.total_water = [TotWat;lvw];
BDM.total_liquid = BDM.total_juice+BDM.total_water;


%%
tottm=[];
for it = 1:length(dt)
    tm = [];ix=[];
    ix = BDM.date==dt(it);
    tm = BDM.time(ix);
    tm = tm-tm(1);
    tottm = [tottm;tm];
end
    
BDM.time_elapsed = datenum(tottm);
% BDM.time_between_trials = datenum(diff(tottm));

%%

t1ix = BDM.trial_number==1;

sameRV = diff(BDM.reward_value)==0;
dpmb = BDM.monkey_bid;
dpmb(sameRV) = NaN;
pmb = [nan;dpmb(1:end-1)];
BDM.previous_MB_dif_RV = pmb;

pmb = [nan;BDM.monkey_bid(1:end-1)];
pmb(t1ix) = NaN;
BDM.previous_MB = pmb;

pcb = [nan;BDM.computer_bid(1:end-1)];
pcb(t1ix) = NaN;
BDM.previous_CB = pcb;

pcb2 = [nan(2,1);BDM.computer_bid(1:end-2)];
pcb2(t1ix) = NaN;
BDM.previous_CB2 = pcb2;

pcb3 = [nan(3,1);BDM.computer_bid(1:end-3)];
pcb3(t1ix) = NaN;
BDM.previous_CB3 = pcb3;

pcb5 = [nan(5,1);BDM.computer_bid(1:end-5)];
pcb5(t1ix) = NaN;
BDM.previous_CB5 = pcb5;

pcb7 = [nan(7,1);BDM.computer_bid(1:end-7)];
pcb7(t1ix) = NaN;
BDM.previous_CB7 = pcb7;
% % % pcb2 = movmean([nan;BDM.computer_bid(1:end-1)],[2 0],'omitnan');
% % % pcb2(t1ix) = NaN;
% % % BDM.previous_CB2 = pcb2;
% % % 
% % % pcb3 = movmean([nan;BDM.computer_bid(1:end-1)],[3 0],'omitnan');
% % % pcb3(t1ix) = NaN;
% % % BDM.previous_CB3 = pcb3;
% % % 
% % % pcb5 = movmean([nan;BDM.computer_bid(1:end-1)],[5 0],'omitnan');
% % % pcb5(t1ix) = NaN;
% % % BDM.previous_CB5 = pcb5;
% % % 
% % % pcb7 = movmean([nan;BDM.computer_bid(1:end-1)],[7 0],'omitnan');
% % % pcb7(t1ix) = NaN;
% % % BDM.previous_CB7 = pcb7;


prv = [nan;BDM.reward_value(1:end-1)];
prv(t1ix) = NaN;
BDM.previous_reward_value = prv;

pb = [nan;BDM.budget(1:end-1)];
pb(t1ix) = NaN;
BDM.previous_budget = pb;

pwl = [nan;BDM.paid(1:end-1)];
pwl(t1ix) = NaN;
BDM.previous_win_lose = pwl;

pwl2 = [nan(2,1);BDM.paid(1:end-2)];
pwl2(t1ix) = NaN;
BDM.previous_win_lose2 = pwl2;

pwl3 = [nan(3,1);BDM.paid(1:end-3)];
pwl3(t1ix) = NaN;
BDM.previous_win_lose3 = pwl3;

pwl4 = [nan(4,1);BDM.paid(1:end-4)];
pwl4(t1ix) = NaN;
BDM.previous_win_lose4 = pwl4;

pwl5 = [nan(5,1);BDM.paid(1:end-5)];
pwl5(t1ix) = NaN;
BDM.previous_win_lose5 = pwl5;

pd=[];
pd = BDM.paid==1;
pd(isnan(pd))=0;
wins = pd;
iter=0;
for i = 2:length(wins)
    if wins(i-1)==1
        iter(i,1) = iter(i-1)+1;
    else 
        iter(i,1) = 0;
    end
end
pwstk = iter;
BDM.previous_win_streak = pwstk;

pd=[];
pd = BDM.paid==0;
pd(isnan(pd))=0;
losses = pd;
iter=0;
for i = 2:length(losses)
    if losses(i-1)==1
        iter(i,1) = iter(i-1)+1;
    else 
        iter(i,1) = 0;
    end
end
plstk = iter;
BDM.previous_lose_streak = plstk;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BDM.previous_win_streak_same_RV = zeros(height(BDM),1);
BDM.previous_lose_streak_same_RV = zeros(height(BDM),1);

for iSit = 1:3
    rvix=[];
    rvix = BDM.reward_value==iSit & BDM.task_failure==0;

    pwstk=[];
    pd=[];
    pd = BDM.paid(rvix)==1;
    pd(isnan(pd))=0;
    wins = pd;
    iter=0;
    for i = 2:length(wins)
        if wins(i-1)==1
            iter(i,1) = iter(i-1)+1;
        else
            iter(i,1) = 0;
        end
    end
    pwstk = iter;
    BDM.previous_win_streak_same_RV(rvix) = pwstk;

    plstk=[];
    pd=[];
    pd = BDM.paid(rvix)==0;
    pd(isnan(pd))=0;
    losses = pd;
    iter=0;
    for i = 2:length(losses)
        if losses(i-1)==1
            iter(i,1) = iter(i-1)+1;
        else
            iter(i,1) = 0;
        end
    end
    plstk = iter;
    BDM.previous_lose_streak_same_RV(rvix) = plstk;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pte = [nan;BDM.task_failure(1:end-1)];
pte(t1ix) = NaN;
BDM.previous_trial_error = pte;

ptj = [nan;BDM.total_juice(1:end-1)];
ptj(t1ix) = NaN;
BDM.previous_total_juice = ptj;

ptw = [nan;BDM.total_water(1:end-1)];
ptw(t1ix) = NaN;
BDM.previous_total_water = ptw;

ptl = [nan;BDM.total_liquid(1:end-1)];
ptl(t1ix) = NaN;
BDM.previous_total_liquid = ptl;

BDM.previous_MB_sameRV = nan(height(BDM),1);
BDM.previous_CB_sameRV = nan(height(BDM),1);
BDM.previous_CB_sameRV2 = nan(height(BDM),1);
BDM.previous_CB_sameRV3 = nan(height(BDM),1);
BDM.previous_CB_sameRV4 = nan(height(BDM),1);
BDM.previous_CB_sameRV5 = nan(height(BDM),1);
BDM.previous_CB_sameRV6 = nan(height(BDM),1);
BDM.previous_CB_sameRV7 = nan(height(BDM),1);
BDM.previous_CB_sameRV8 = nan(height(BDM),1);
BDM.previous_CB_sameRV9 = nan(height(BDM),1);
BDM.previous_CB_sameRV10 = nan(height(BDM),1);

BDM.previous_CB_sameRVmm2 = nan(height(BDM),1);
BDM.previous_CB_sameRVmm3 = nan(height(BDM),1);
BDM.previous_CB_sameRVmm4 = nan(height(BDM),1);
BDM.previous_CB_sameRVmm5 = nan(height(BDM),1);
BDM.previous_CB_sameRVmm6 = nan(height(BDM),1);

BDM.previous_win_lose_sameRV = nan(height(BDM),1);
BDM.previous_win_lose_sameRV2 = nan(height(BDM),1);
BDM.previous_win_lose_sameRV3 = nan(height(BDM),1);
BDM.previous_win_lose_sameRV4 = nan(height(BDM),1);
BDM.previous_win_lose_sameRV5 = nan(height(BDM),1);
BDM.previous_win_lose_sameRV6 = nan(height(BDM),1);
BDM.previous_win_lose_sameRV7 = nan(height(BDM),1);
BDM.previous_win_lose_sameRV8 = nan(height(BDM),1);
BDM.previous_win_lose_sameRV9 = nan(height(BDM),1);
BDM.previous_win_lose_sameRV10 = nan(height(BDM),1);


BDM.numBack_to_sameRV = nan(height(BDM),1);

pixx = zeros(height(BDM),1);
for i=1:3
    pix = [];pix2 = [];pix3 = [];pix4 = [];pix5 = [];pix6 = [];
    pix7 = [];pix8 = [];pix9 = [];pix10 = [];
    rv_ix=[];
    rv_ix = find(BDM.reward_value==i & BDM.task_failure==0);
    pix(2:length(rv_ix)) = rv_ix(1:end-1);
    pix2(3:length(rv_ix)) = rv_ix(1:end-2);
    pix3(4:length(rv_ix)) = rv_ix(1:end-3);
    pix4(5:length(rv_ix)) = rv_ix(1:end-4);
    pix5(6:length(rv_ix)) = rv_ix(1:end-5);
    pix6(7:length(rv_ix)) = rv_ix(1:end-6);
    pix7(8:length(rv_ix)) = rv_ix(1:end-7);
    pix8(9:length(rv_ix)) = rv_ix(1:end-8);
    pix9(10:length(rv_ix)) = rv_ix(1:end-9);
    pix10(11:length(rv_ix)) = rv_ix(1:end-10);

    BDM(rv_ix,:).previous_MB_sameRV = [NaN;BDM.monkey_bid(pix(2:end))];
    BDM(rv_ix,:).previous_CB_sameRV = [NaN;BDM.computer_bid(pix(2:end))];
    BDM(rv_ix,:).previous_CB_sameRV2 = [NaN(2,1);BDM.computer_bid(pix2(3:end))];
    BDM(rv_ix,:).previous_CB_sameRV3 = [NaN(3,1);BDM.computer_bid(pix3(4:end))];
    BDM(rv_ix,:).previous_CB_sameRV4 = [NaN(4,1);BDM.computer_bid(pix4(5:end))];
    BDM(rv_ix,:).previous_CB_sameRV5 = [NaN(5,1);BDM.computer_bid(pix5(6:end))];
    BDM(rv_ix,:).previous_CB_sameRV6 = [NaN(6,1);BDM.computer_bid(pix6(7:end))];
    BDM(rv_ix,:).previous_CB_sameRV7 = [NaN(7,1);BDM.computer_bid(pix7(8:end))];
    BDM(rv_ix,:).previous_CB_sameRV8 = [NaN(8,1);BDM.computer_bid(pix8(9:end))];
    BDM(rv_ix,:).previous_CB_sameRV9 = [NaN(9,1);BDM.computer_bid(pix9(10:end))];
    BDM(rv_ix,:).previous_CB_sameRV10 = [NaN(10,1);BDM.computer_bid(pix10(11:end))];

    BDM(rv_ix,:).previous_CB_sameRVmm2 = movmean([NaN;BDM.computer_bid(pix(2:end))],[2 0],'omitnan');
    BDM(rv_ix,:).previous_CB_sameRVmm3 = movmean([NaN;BDM.computer_bid(pix(2:end))],[3 0],'omitnan');
    BDM(rv_ix,:).previous_CB_sameRVmm4 = movmean([NaN;BDM.computer_bid(pix(2:end))],[4 0],'omitnan');
    BDM(rv_ix,:).previous_CB_sameRVmm5 = movmean([NaN;BDM.computer_bid(pix(2:end))],[5 0],'omitnan');
    BDM(rv_ix,:).previous_CB_sameRVmm6 = movmean([NaN;BDM.computer_bid(pix(2:end))],[6 0],'omitnan');


    BDM(rv_ix,:).previous_win_lose_sameRV = [NaN;BDM.paid(pix(2:end))];
    BDM(rv_ix,:).previous_win_lose_sameRV2 = [NaN(2,1);BDM.paid(pix2(3:end))];
    BDM(rv_ix,:).previous_win_lose_sameRV3 = [NaN(3,1);BDM.paid(pix3(4:end))];
    BDM(rv_ix,:).previous_win_lose_sameRV4 = [NaN(4,1);BDM.paid(pix4(5:end))];
    BDM(rv_ix,:).previous_win_lose_sameRV5 = [NaN(5,1);BDM.paid(pix5(6:end))];
    BDM(rv_ix,:).previous_win_lose_sameRV6 = [NaN(6,1);BDM.paid(pix6(7:end))];
    BDM(rv_ix,:).previous_win_lose_sameRV7 = [NaN(7,1);BDM.paid(pix7(8:end))];
    BDM(rv_ix,:).previous_win_lose_sameRV8 = [NaN(8,1);BDM.paid(pix8(9:end))];
    BDM(rv_ix,:).previous_win_lose_sameRV9 = [NaN(9,1);BDM.paid(pix9(10:end))];
    BDM(rv_ix,:).previous_win_lose_sameRV10 = [NaN(10,1);BDM.paid(pix10(11:end))];


    BDM(rv_ix,:).numBack_to_sameRV = [NaN;diff(rv_ix)];
end

tn1 = find(BDM.trial_number==1);
rv = [BDM.reward_value];
bpix = contains(BDM.subtask,'Blind_Pav');
rv(bpix)=NaN;
for iR = 1:3    
    for iT = 2:length(tn1)
        rvtn1=[];
        rvtn1 = rv(tn1(iT-1):tn1(iT)-1);
        frv = find(rvtn1==iR,1,'first');
        if ~isempty(frv)
            BDM(frv+tn1(iT-1)-1,:).previous_MB_sameRV = NaN;
            BDM(frv+tn1(iT-1)-1,:).previous_CB_sameRV = NaN;
            BDM(frv+tn1(iT-1)-1,:).previous_win_lose_sameRV = NaN;
        end
    end
end
    

% % % rvix=[];
% % % for iR = 1:3
% % %     rvix(:,iR) = double([BDM.reward_value])==iR;
% % % end


%% clean up
BDM = removevars(BDM,{'ITI','bidding','budget_magnitude','budget_payout','budget_value',...
    'fixation','fractal_offer','left','ordered','primary_side','reward_chance','reward_payout','right',...
    'second_budget_value','second_reward_chance','second_reward_magnitude','second_reward_value','target_box_shift',...
    'target_box_size'});

BC = removevars(BC,{'ITI','bidding','budget_magnitude','budget_payout','budget_value',...
    'fixation','fractal_offer','ordered','primary_side','reward_chance','reward_payout','right',...
    'second_reward_chance','second_reward_magnitude','second_reward_value','starting_bid','target_box_shift',...
    'target_box_size'});
%%
BDM = BDM(ismember(BDM.subtask,'BDM'),:);

toc


