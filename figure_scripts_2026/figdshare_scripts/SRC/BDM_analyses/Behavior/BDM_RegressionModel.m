%% regression model
clear;monk = 'Vic';

d = DropboxDir;
minTrPerSes=1;

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

% BDM =  BDM_normalize_by_day(BDM);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % BDM.total_juice_sqrt = sqrt(BDM.total_juice);
% % % BDM.previous_total_liquid_sqrt = sqrt(BDM.previous_total_liquid);
% % % BDM.total_liquid_sqrt = sqrt(BDM.total_liquid);
% % % BDM.total_water_sqrt = sqrt(BDM.total_water);

% BDM.reward_value_ml = (BDM.reward_value*.7)-.4;
BDM.pMBmpCB = BDM.previous_MB_sameRV- BDM.previous_CB_sameRV;
BDM.MBmpCB = BDM.monkey_bid- BDM.previous_CB_sameRV;

varnams = {
    'monkey_bid'
    'reward_value'
    'starting_bid'
    'total_juice'
    'total_water'
    'previous_total_liquid'
    'total_liquid'
    'day_of_week'
    'session_number'
    'previous_MB_dif_RV' 
    'previous_MB'
    'previous_MB_sameRV'
    'pMBmCB'
    'MBmpCB'
    'previous_trial_error'
    'previous_CB'
    'previous_CB2'
    'previous_CB3'
    'previous_CB5'
    'previous_CB7'
    'previous_CB_sameRV' 
    'previous_CB_sameRV2'
    'previous_CB_sameRV3'
    'previous_CB_sameRV4'
    'previous_CB_sameRV5'
    'previous_CB_sameRV6'
    'previous_CB_sameRV7'
    'previous_CB_sameRV8'
    'previous_CB_sameRV9'
    'previous_CB_sameRV10'
    'previous_CB_sameRVmm2'
    'previous_CB_sameRVmm3'
    'previous_CB_sameRVmm4'
    'previous_CB_sameRVmm5'
    'previous_CB_sameRVmm6'    
    'previous_win_lose'
    'previous_win_lose2'
    'previous_win_lose3'
    'previous_win_lose4'
    'previous_win_lose5'
    'previous_win_lose_sameRV'
    'previous_win_lose_sameRV2'
    'previous_win_lose_sameRV3'
    'previous_win_lose_sameRV4'
    'previous_win_lose_sameRV5'
    'previous_win_lose_sameRV6'
    'previous_win_lose_sameRV7'
    'previous_win_lose_sameRV8'
    'previous_win_lose_sameRV9'
    'previous_win_lose_sameRV10'
    'previous_win_streak'
    'previous_lose_streak'
    'previous_win_streak_same_RV'
    'previous_lose_streak_same_RV'
    'trial_number'
};
[C,ia,ic] = unique(BDM.session_number);
bdses = C(histcounts(ic,max(ic))<minTrPerSes);
bdix = ismember(BDM.session_number,bdses);
BDM = BDM(~bdix,:);

% % % 
% % % 'total_juice_sqrt'
% % % 'total_water_sqrt'
% % % 'previous_total_liquid_sqrt'
% % % 'total_liquid_sqrt'

% gdvars = ismember(varnams,'reward_value');
% gdv(:,2) = varnams;
% % gdv(:,1) = num2cell(logical([0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]));
% gdv(:,1) = num2cell(logical([true;true;true;false;false;true;false;false;true;false;false;false;false;false;false;0;0;0;0;0;1;0;0;0;0;false;false;false;false;false;false;false;false;false;false;0;true;false]));


% gdvars = logical(ones(length(varnams),1));
% gdvars = logical([0 0 1 0 0 0 0 0 0 0 0 0 0 0]);

%% lasso to determine important vars
% clear gdv
gdv_lso(:,1) = ones(length(varnams),1);
% gdv_lso(1)=0;
% gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';...%'previous_MB_dif_RV';...
%     'previous_trial_error';'previous_CB';'previous_CB2';'previous_CB3';'previous_CB_sameRV';'previous_CB_sameRV2';...
%     'previous_CB_sameRV3';'previous_CB_sameRV4';'previous_win_lose';'previous_win_lose_sameRV';'trial_number'};

%%%%% Old recipe from first submission
% gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';...'previous_MB_dif_RV';...
%     'previous_trial_error';'previous_CB';'previous_CB2';'previous_CB3';'previous_CB5';...
%     'previous_CB7';'previous_CB_sameRV';'previous_CB_sameRV2';'previous_CB_sameRV3';'previous_CB_sameRV4';...
%     'previous_CB_sameRV5';'previous_CB_sameRV6';'previous_CB_sameRV7';'previous_CB_sameRV8';'previous_CB_sameRV9';...
%     'previous_CB_sameRVmm2';'previous_CB_sameRVmm3';'previous_CB_sameRVmm4';'previous_CB_sameRVmm5';'previous_CB_sameRVmm6';...
%     'previous_CB_sameRV10';'previous_win_lose';'previous_win_lose_sameRV';'trial_number'};

% %%%%%% Without movmean, prevCB, or prevWL
% gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';...%'previous_MB_dif_RV';...
%     'previous_trial_error';'previous_CB_sameRV';'previous_CB_sameRV2';'previous_CB_sameRV3';'previous_CB_sameRV4';...
%     'previous_CB_sameRV5';'previous_CB_sameRV6';'previous_CB_sameRV7';'previous_CB_sameRV8';'previous_CB_sameRV9';...
%     'previous_CB_sameRV10';'previous_win_lose_sameRV2';'previous_win_lose_sameRV3';'previous_win_lose_sameRV4';...
%     'previous_win_lose_sameRV5';'previous_win_streak';'previous_lose_streak';'previous_win_lose_sameRV';'trial_number'};

% %%%%%% Without movmean stuff
% gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';...%'previous_MB_dif_RV';...
%     'previous_trial_error';'previous_CB';'previous_CB2';'previous_CB3';'previous_CB5';...
%     'previous_CB7';'previous_CB_sameRV';'previous_CB_sameRV2';'previous_CB_sameRV3';'previous_CB_sameRV4';...
%     'previous_CB_sameRV5';'previous_CB_sameRV6';'previous_CB_sameRV7';'previous_CB_sameRV8';'previous_CB_sameRV9';...
%     'previous_CB_sameRV10';'previous_win_lose';  'previous_win_lose2';'previous_win_lose3';'previous_win_lose4';'previous_win_lose5';...
%     'previous_win_lose_sameRV2';'previous_win_lose_sameRV3';'previous_win_lose_sameRV4';'previous_win_lose_sameRV5';...
%     'previous_win_lose_sameRV6';'previous_win_lose_sameRV7';'previous_win_lose_sameRV8';'previous_win_lose_sameRV9';...
%     'previous_win_lose_sameRV10';'previous_win_streak';'previous_lose_streak';'previous_win_lose_sameRV';'trial_number'};

% %%%%%% Without movmean stuff and no wl past t-1
% gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';...%'previous_MB_dif_RV';...
%     'previous_trial_error';'previous_CB';'previous_CB_sameRV';'previous_CB_sameRV2';'previous_CB_sameRV3';'previous_CB_sameRV4';...
%     'previous_CB_sameRV5';'previous_CB_sameRV6';'previous_CB_sameRV7';'previous_CB_sameRV8';'previous_CB_sameRV9';...
%     'previous_CB_sameRV10';'previous_win_lose';'previous_win_lose_sameRV';'previous_win_lose_sameRV2';'previous_win_lose_sameRV3';...
%     'previous_win_lose_sameRV4';'previous_win_lose_sameRV5';'previous_win_lose_sameRV6';'previous_win_lose_sameRV7';...
%     'previous_win_lose_sameRV8';'previous_win_lose_sameRV9';'previous_win_lose_sameRV10';'previous_win_streak';'previous_lose_streak';...
%     'trial_number'};

%%%%%% WL_sRV only Without movmean stuff and no wl past t-1
% gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';...%'previous_MB_dif_RV';...
%     'previous_trial_error';'previous_win_lose';'previous_win_lose_sameRV2';'previous_win_lose_sameRV3';...
%     'previous_win_lose_sameRV4';'previous_win_lose_sameRV5';'previous_win_lose_sameRV6';'previous_win_lose_sameRV7';...
%     'previous_win_lose_sameRV8';'previous_win_lose_sameRV9';'previous_win_lose_sameRV10';'previous_win_streak';'previous_lose_streak';...
%     'previous_win_lose_sameRV';'trial_number'};

%%%%%% CB_sRV only Without movmean stuff and no wl past t-1
% gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';...%'previous_MB_dif_RV';...
%     'previous_trial_error';'previous_CB';'previous_CB_sameRV';'previous_CB_sameRV2';'previous_CB_sameRV3';'previous_CB_sameRV4';...
%     'previous_CB_sameRV5';'previous_CB_sameRV6';'previous_CB_sameRV7';'previous_CB_sameRV8';'previous_CB_sameRV9';...
%     'previous_CB_sameRV10';'previous_win_streak';'previous_lose_streak';...
%     'trial_number'};

%%% Everything but the W/L stuff 
gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';...%'previous_MB_dif_RV';...
    'previous_trial_error';'previous_CB';'previous_CB2';'previous_CB3';'previous_CB5';...
    'previous_CB7';'previous_CB_sameRV';'previous_CB_sameRV2';'previous_CB_sameRV3';'previous_CB_sameRV4';...
    'previous_CB_sameRV5';'previous_CB_sameRV6';'previous_CB_sameRV7';'previous_CB_sameRV8';'previous_CB_sameRV9';...
    'previous_CB_sameRVmm2';'previous_CB_sameRVmm3';'previous_CB_sameRVmm4';'previous_CB_sameRVmm5';'previous_CB_sameRVmm6';...
    'previous_CB_sameRV10';'previous_win_lose';'previous_win_lose_sameRV';'trial_number';...%'previous_win_streak';'previous_lose_streak';...
    'previous_win_streak_same_RV';'previous_lose_streak_same_RV'};


%%%%%%% With everything
% gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';...%'previous_MB_dif_RV';...
%     'previous_trial_error';'previous_win_lose_sameRV2';'previous_win_lose_sameRV3';'previous_win_lose_sameRV4';'previous_win_lose_sameRV5';...
%     'previous_win_lose_sameRV6';'previous_win_lose_sameRV7';'previous_win_lose_sameRV8';'previous_win_lose_sameRV9';...
%     'previous_win_lose_sameRV10';'previous_CB';'previous_CB2';'previous_CB3';'previous_CB5';...
%     'previous_CB7';'previous_CB_sameRV';'previous_CB_sameRV2';'previous_CB_sameRV3';'previous_CB_sameRV4';...
%     'previous_CB_sameRV5';'previous_CB_sameRV6';'previous_CB_sameRV7';'previous_CB_sameRV8';'previous_CB_sameRV9';...
%     'previous_CB_sameRVmm2';'previous_CB_sameRVmm3';'previous_CB_sameRVmm4';'previous_CB_sameRVmm5';'previous_CB_sameRVmm6';...
%     'previous_CB_sameRV10';'previous_win_lose';  'previous_win_lose2';'previous_win_lose3';'previous_win_lose4';'previous_win_lose5';...
%     'previous_win_lose_sameRV';'trial_number';'previous_win_streak';'previous_lose_streak'};


% 'reward_value';
gdvars = ismember(varnams,gdvn);
varix = find(ismember(BDM.Properties.VariableNames,varnams(gdvars)));
tbl = BDM(:,varix);
% tbl = tbl(:,[1:5,8:14,16:31,33]);
% tbl = tbl(:,[2:5,8:14,16:31,33]);% reduced model


tbvn = tbl.Properties.VariableNames;
jv = join(varnams(2:end));
mdlStr = ['monkey_bid ~ 1 + ', strrep(jv{:},' ',' + ')];

predictors = table2array(tbl);

y = BDM.monkey_bid;

y(y<0)=0;
o = ones(height(tbl),1);
X = [o predictors];

[b,bint,~,~,stats] = regress(y,X);

Xx = [predictors];
% lm = fitlm(Xx,y,'VarNames',[tbvn,{'d'}]);
% lm.Coefficients
for i = 1%:20
[B,fi] = lasso(Xx,y,'CV',2000,'PredictorNames',tbvn);


Btbl = array2table(B);
Btbl.Properties.RowNames = fi.PredictorNames;
% all_bstL(i) = fi.Index1SE
% all_bstL(i) = fi.IndexMinMSE
all_bstL(i) = fi.Index1SE


end
bstL= mode(all_bstL);
optBtbl = Btbl(:,bstL);
%%
ca

figure
cols = CB_blues(5);
if strcmp(monk,'Vic')
    col = cols(3,:);
else
    col=cols(5,:);
end
plot((fi.Lambda),(fi.MSE),'. ','Color',col)
hold on
% plot((fi.Lambda),(fi.MSE+fi.SE),'color',[.5 .5 1])
% plot((fi.Lambda),(fi.MSE-fi.SE),'color',[.5 .5 1])
lam = [fi.Lambda];mse = [fi.MSE];se = [fi.SE];
line([lam' lam']',[mse'-se' mse'+se']','color',col,'linewidth',1)
g=gca;
line([fi.Lambda(bstL) fi.Lambda(bstL)],g.YLim)
g.XScale = 'log';
g.XDir = 'reverse';
g.XLim = [1e-5 .2];
g.YLim = [.03 .065];
xlabel('Lambda');ylabel('MSE');
pubify_figure_axis_robust


lassoPlot(B,fi,'PlotType','CV');
legend('show') % Show legend
%%
% % % ci = coefCI(lm);
% % % 
% % % B = BetaNormalization(b',X,y);
% % % % B = b;
% % % figure
% % % bar(B(2:end))
% % % hold on
% % % % errorbar([1:length(B)-1],B(2:end),bint((2:end),1),bint((2:end),2),'LineStyle','none')
% % % errorbar([1:length(B)-1],B(2:end),ci(2:end,1)-B(2:end)',ci(2:end,2)-B(2:end)','LineStyle','none')
% % % 
% % % xticklabels(tbvn)
% % % 
% % % xtickangle(90)
% % % title(char(BDM.monkey_ID(1)),B(2))
% % % 
% % % pubify_figure_axis_robust
% % % lm.Rsquared

%% glm
% cat_vars = logical([ 0 0 0 0 1 0 0 0 1 ]);
% lm = fitglm(predictors,y);%,'CategoricalVars',cat_vars);
% 
% % Xx = [predictors];
% % lm = fitlm(Xx,y);
% b = lm.Coefficients.Estimate
% 
% B = BetaNormalization(b',X,y);
% figure
% bar(B(2:end))
% hold on
% er = lm.Coefficients.SE
% errorbar([1:length(B)-1],B(2:end),er(2:end),'LineStyle','none')
% xticklabels(varnams)
% xtickangle(90)
% title(char(BDM.monkey_ID(1)))
% 
% pubify_figure_axis_robust
% lm.Rsquared.Adjusted


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mixed Effects Model  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except BDM gdv varnams mdl1 optBtbl monk
tic
gdv(:,2) = varnams;
% gdv(:,1) = num2cell(logical([0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]));
% gdv(:,1) = num2cell(logical([true;true;true;false;false;true;false;false;true;false;false;false;false;false;false;0;0;0;0;0;1;0;0;0;0;false;false;false;false;false;false;false;false;false;false;0;true;false]));
% gdvn = { 'monkey_bid';'reward_value';'starting_bid';'previous_total_liquid';'session_number';...'previous_MB_dif_RV';...'day_of_week';
%     'previous_CB_sameRV';'previous_win_lose_sameRV';'trial_number'};

% gdvn = { 'monkey_bid';'reward_value';'starting_bid';'previous_total_liquid';'session_number';...'previous_MB_dif_RV';...'day_of_week';
%     'previous_CB_sameRV';'previous_win_lose_sameRV';'previous_win_streak_same_RV'; 'previous_lose_streak_same_RV';...
%     'trial_number'}%};'previous_CB2';'previous_win_lose'

gdvn = { 'monkey_bid';'reward_value';'starting_bid';'previous_total_liquid';'session_number';...'previous_MB_dif_RV';...'day_of_week';
    'previous_CB_sameRV';'previous_win_lose_same_RV';'previous_win_streak_same_RV'; 'previous_lose_streak_same_RV';...
    'trial_number'};
gdvars = ismember(varnams,gdvn);


% vif_vars =  {'monkey_bid';'reward_value';'previous_lose_streak_same_RV';'previous_win_lose_sameRV';'previous_win_streak_same_RV';...
%     'starting_bid';'previous_total_liquid';'session_number';...'previous_MB_dif_RV';...'day_of_week';
%     'previous_CB_sameRV'};
% gdvars = ismember(varnams,vif_vars);


gdv(:,1) =  num2cell(logical(gdvars));

varix = find(ismember(BDM.Properties.VariableNames,varnams(gdvars)));

tbl = BDM(:,varix);
tbvn = tbl.Properties.VariableNames;

% rnv = ismember(tbvn,{'session_number','trial_number'}); %random effects (dummy vars) ,'day_of_week'
% rnv = ismember(tbvn,{'reward_value','trial_number','session_number'}); % reduced model random effects
% rnv = ismember(tbvn,{'session_number','trial_number','previous_win_lose_same_RV'}); %random effects (dummy vars) ,'day_of_week'
rnv = ismember(tbvn,{'reward_value','trial_number','session_number','previous_win_lose_same_RV'}); % reduced model random effects


mdlvarnams=[];
mvn1 = tbvn(~rnv);
% mvn1 = strcat('(',tbvn(~rnv),'|reward_value)');
% mvn2 = {'(previous_total_liquid|trial_number)'};
% mvn3 = strcat('(',tbvn(~rnv),'|session_number)');
mvn4 = strcat('(1|',tbvn(rnv),')');
mdlvarnams=[mvn1,mvn4]%,mvn4];
% mdlvarnams=[mvn1,mvn2,mvn3,mvn4]


jv = join(mdlvarnams(2:end));
mdlStr = ['monkey_bid ~ 1 + ', strrep(jv{:},' ',' + ')];

% mdl = fitlme(tbl,mdlStr);
mdl = fitlme(tbl,mdlStr);

%%% fitlmematrix
%%% fitlme

nmix = ismember(tbl.Properties.VariableNames,mdl.Coefficients.Name);
lil_tbl = tbl(:,nmix);
X = [ones(height(lil_tbl),1),table2array(lil_tbl)];
y = tbl.monkey_bid;

b = mdl.Coefficients.Estimate;
ue = mdl.Coefficients.Upper;
disp(mdlStr);
[B,E] = BetaNormalization(b',X,y,ue'-b');


% B = b

p={};
p(:,1) = mdl.Coefficients.Name(:);
p(:,2) = num2cell(B');
p(:,3) = num2cell(mdl.Coefficients.pValue);
P = cell2table(p);
P.Properties.VariableNames = {'Var_Names','Beta','P-value'}; 

figure
bar(B(2:end))
hold on
% errorbar(B(2:end),mdl.Coefficients.SE(2:end),'LineStyle','none')
errorbar(1:length(B(2:end)),B(2:end),E(2:end),E(2:end),'LineStyle','none')

xticklabels(strrep(mdl.Coefficients.Name(2:end),'_',' '))
xtickangle(90)
pubify_figure_axis_robust
title(sprintf(['Mixed effects model \n',mdlStr]),'Interpreter','none')
toc
mdl.Coefficients
mdl.Rsquared
mdl.ModelCriterion
MedFigs
mdl1=mdl;
g=gca;
g.YLim = [-.15 .2];
%% approximate partial r2
r2mx={};
for i=2:length(mdlvarnams)
    ix = 2:length(mdlvarnams);
    ix(ix==i)=[];
    jv = join(mdlvarnams(ix));
    mdlStr = ['monkey_bid ~ 1 + ', strrep(jv{:},' ',' + ')];

    % mdl = fitlme(tbl,mdlStr);
    mdl = fitlme(tbl,mdlStr);
    r2mx{2,i} = mdl.Rsquared.Adjusted;
    r2mx{3,i} = mdl1.Rsquared.Adjusted-mdl.Rsquared.Adjusted;
    r2mx{1,i} = mdlvarnams(i);
    if i<7
    r2mx{4,i} = corr(tbl.monkey_bid,tbl.(mdlvarnams{i}),"rows","complete")^2;
    end
end

%%% fitlmematrix
%%% fitlme

nmix = ismember(tbl.Properties.VariableNames,mdl.Coefficients.Name);
lil_tbl = tbl(:,nmix);
X = [ones(height(lil_tbl),1),table2array(lil_tbl)];
y = tbl.monkey_bid;

b = mdl.Coefficients.Estimate;
ue = mdl.Coefficients.Upper;
disp(mdlStr);
[B,E] = BetaNormalization(b',X,y,ue'-b');


%%
%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mixed Effects Model win vs lose %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except BDM gdv varnams mdl1  
wl=1;
tic
gdv(:,2) = varnams;
% gdv(:,1) = num2cell(logical([0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]));
% gdv(:,1) = num2cell(logical([true;true;true;false;false;true;false;false;true;false;false;false;false;false;false;0;0;0;0;0;1;0;0;0;0;false;false;false;false;false;false;false;false;false;false;0;true;false]));
% gdvn = { 'monkey_bid';'reward_value';'starting_bid';'previous_total_liquid';'session_number';...'previous_MB_dif_RV';...'day_of_week';
%     'previous_CB_sameRV';'previous_win_lose_sameRV';'trial_number'};

gdvn = { 'monkey_bid';'reward_value';'starting_bid';'previous_total_liquid';'session_number';...'previous_MB_dif_RV';...'day_of_week';
    'previous_CB_sameRV';'previous_win_lose_sameRV';'trial_number'}%};'previous_CB2';'previous_win_lose'

% % gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';'previous_MB_dif_RV';...
% %     'previous_trial_error';'previous_CB';'previous_CB2';'previous_CB3';'previous_CB5';...
% %     'previous_CB7';'previous_CB_sameRV';'previous_CB_sameRV2';'previous_CB_sameRV3';'previous_CB_sameRV4';...
% %     'previous_CB_sameRV5';'previous_CB_sameRV6';'previous_CB_sameRV7';'previous_CB_sameRV8';'previous_CB_sameRV9';...
% %     'previous_CB_sameRV10';'previous_CB_sameRVmm2';'previous_CB_sameRVmm3';'previous_CB_sameRVmm4';...
% %     'previous_CB_sameRVmm5';'previous_CB_sameRVmm6';'previous_win_lose';'previous_win_lose_sameRV';'trial_number'};
gdvars = ismember(varnams,gdvn);
gdv(:,1) =  num2cell(logical(gdvars));

varix = find(ismember(BDM.Properties.VariableNames,varnams(gdvars)));
pwl = BDM.previous_win_lose_sameRV;
tblw =  BDM(pwl==1,varix);
tbll =  BDM(pwl==0,varix);
tbl = BDM(:,varix);
tbvn = tbl.Properties.VariableNames;
%%
%%



% predictors = [tbl.reward_value tbl.starting_bid tbl.total_juice tbl.total_water tbl.day_of_week ...
%     tbl.session_number tbl.Previous_MB_dif_RV tbl.previous_CB_sameRV tbl.previous_win_lose];
% predictors = [tbl.reward_value tbl.starting_bid tbl.total_juice tbl.total_water tbl.day_of_week ...
%     tbl.session_number tbl.previous_CB_sameRV tbl.previous_win_lose]; % AIC =   -1.1818e+04
% predictors = [tbl.reward_value tbl.starting_bid tbl.total_juice tbl.total_water  ...
%     tbl.session_number tbl.previous_CB_sameRV tbl.Previous_MB]; % AIC =    -1.1907e+04

% varnams = {
%     'monkey_bid'
%     'reward_value'
%     'starting_bid'
%     'total_juice'
%     'total_water'
%     'day_of_week'
%     'session_number'
%     'Previous_MB_dif_RV' 
%     'Previous_MB'
%     'previous_trial_error'
%     'Previous_CB'
%     'previous_CB_sameRV'  
%     'previous_win_lose'};


% + day_of_week + Previous_MB_dif_RV + Previous_MB + previous_trial_error + Previous_CB + previous_CB_sameRV + previous_win_lose + (1|session_number)',...
%     'DummyVarCoding','effects');




