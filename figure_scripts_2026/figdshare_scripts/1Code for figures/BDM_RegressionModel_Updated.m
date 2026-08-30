%% this code will generate components of figures 1e, S2d, s2e, and s2f

%% regression model
clear;monk = 'Vic'; %'Vic' or 'Uly'; Monkey V and monkey U, respectively.
minTrPerSes=1;

BDM = LoadMonkBxDataBDM(monk); %change the path in this function to reflect the location of the behavioral data on the user's machine

[BDM, zBDM] = BDM_Exclusion_Criteria(BDM);
BDM.previous_trial_error(isnan(BDM.previous_trial_error))=0;
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



%% Lasso regression to eliminate variables
gdv_lso(:,1) = ones(length(varnams),1);

%%%%% Old recipe from first submission
% gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';...'previous_MB_dif_RV';...
%     'previous_trial_error';'previous_CB';'previous_CB2';'previous_CB3';'previous_CB5';...
%     'previous_CB7';'previous_CB_sameRV';'previous_CB_sameRV2';'previous_CB_sameRV3';'previous_CB_sameRV4';...
%     'previous_CB_sameRV5';'previous_CB_sameRV6';'previous_CB_sameRV7';'previous_CB_sameRV8';'previous_CB_sameRV9';...
%     'previous_CB_sameRVmm2';'previous_CB_sameRVmm3';'previous_CB_sameRVmm4';'previous_CB_sameRVmm5';'previous_CB_sameRVmm6';...
%     'previous_CB_sameRV10';'previous_win_lose';'previous_win_lose_sameRV';'trial_number'};

%%% Everything but the multi-trial W/L stuff 
gdvn = {'reward_value';'starting_bid';'previous_total_liquid';'day_of_week';'session_number';...%'previous_MB_dif_RV';...
    'previous_trial_error';'previous_CB';'previous_CB2';'previous_CB3';'previous_CB5';...
    'previous_CB7';'previous_CB_sameRV';'previous_CB_sameRV2';'previous_CB_sameRV3';'previous_CB_sameRV4';...
    'previous_CB_sameRV5';'previous_CB_sameRV6';'previous_CB_sameRV7';'previous_CB_sameRV8';'previous_CB_sameRV9';...
    'previous_CB_sameRVmm2';'previous_CB_sameRVmm3';'previous_CB_sameRVmm4';'previous_CB_sameRVmm5';'previous_CB_sameRVmm6';...
    'previous_CB_sameRV10';'previous_win_lose';'previous_win_lose_sameRV';'trial_number';...%'previous_win_streak';'previous_lose_streak';...
    'previous_win_streak_same_RV';'previous_lose_streak_same_RV'};



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
%% fig s2d
% ca

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

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mixed Effects Model  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except BDM gdv varnams mdl1 optBtbl monk
tic
gdv(:,2) = varnams;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change this to plot each respective figure
manuscript_figure = 'figs2e'; % 'fig1e' ; 'figs2e' ; 'figs2f'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch manuscript_figure
    case {'fig1e', 'figs2e'}
        %fig 1 and s2d
        gdvn = { 'monkey_bid';'reward_value';'starting_bid';'previous_total_liquid';'session_number';...
            'previous_CB_sameRV';'previous_win_lose_sameRV';'trial_number'};
    case 'figs2f'
        %fig s2e (previous_win_lose_same_RV must be included as random effect due
        %         to colinearity with previous_win_streak_same_RV and
        %         previous_lose_streak_same_RV)
        gdvn = { 'monkey_bid';'reward_value';'starting_bid';'previous_total_liquid';'session_number';...
            'previous_CB_sameRV';'previous_win_lose_same_RV';'previous_win_streak_same_RV'; 'previous_lose_streak_same_RV';...
            'trial_number'};
end

gdvars = ismember(varnams,gdvn);

% vif_vars =  {'monkey_bid';'reward_value';'previous_lose_streak_same_RV';'previous_win_lose_sameRV';'previous_win_streak_same_RV';...
%     'starting_bid';'previous_total_liquid';'session_number';...'previous_MB_dif_RV';...'day_of_week';
%     'previous_CB_sameRV'};
% gdvars = ismember(varnams,vif_vars);


gdv(:,1) =  num2cell(logical(gdvars));

varix = find(ismember(BDM.Properties.VariableNames,varnams(gdvars)));

tbl = BDM(:,varix);
tbvn = tbl.Properties.VariableNames;


switch manuscript_figure
    case 'fig1e'
        rnv = ismember(tbvn,{'session_number','trial_number'}); %full model random effects
    case 'figs2e'
        rnv = ismember(tbvn,{'reward_value','trial_number','session_number'}); % reduced model 1 random effects
    case 'figs2f'
        rnv = ismember(tbvn,{'reward_value','trial_number','session_number','previous_win_lose_same_RV'}); % reduced model 2 random effects
end

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

