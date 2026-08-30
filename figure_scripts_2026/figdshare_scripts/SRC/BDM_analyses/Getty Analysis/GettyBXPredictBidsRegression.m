function [BX] = GettyBXPredictBidsRegression(data_file_path_name,situations,bits,trials,win_lose_both)


[DS,pth] = FormatGettyDataStructureWithClusters(data_file_path_name);

situation_names = {'BDM Low ' 'BDM Mid ' 'BDM HIgh ' 'Free Reward'};

if nargin < 1
    val = inputdlg('What situations would you like to analyze?','Situation',1,{'1:3'});
    situations = str2num(val{1});
end

if nargin < 2
    % important_bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
    %     'WinLoseUp' 'FreeRewardUp' 'RewardTapUp' 'BudgetTapUp'};
    allBits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
        'WinLoseUp' 'FreeRewardUp' 'RewardTapUp' 'BudgetTapUp' 'ErrorUp'};
    bit_ix = listdlg('ListString',allBits);
    bits = allBits(bit_ix);
end

if nargin < 3
    trials = 'all';
end
if ~isnumeric(trials) && strcmp(trials,'all')
    trials = 1:length([DS]);
end
%
if nargin < 4
    win_lose_both = 'both';
end
wlb_nam_cell = {'win','lose','both'};
wlb_num_cell = {[1],[0],[1,0]};
wlb_ix = strcmp([wlb_nam_cell],win_lose_both);
wlb = wlb_num_cell(wlb_ix);

% uniqsit = unique([DS.Situation]);
% for iS = 1:numel(uniqsit)
%     DS_sit.(sit_nams{uniqsit(iS)}) = DS([DS.Situation]==uniqsit(iS));
% end
%%
err_ix = ~cellfun(@isnan,{DS.ErrorUp});
good_trials = zeros(1,length(DS));
good_trials(trials) = 1;
good_trials(err_ix) = 0;

goodix = find(good_trials...%find the trials that were passed into fxn
    &ismember([DS.situation],situations));%...%find situations passed into fxn
%     &ismember([DS.Win],[wlb{:}]));
gdix = goodix;

% [~,DS_sort_ix] = sort([DS.Situation]);
% DS = DS(DS_sort_ix);
fn = fieldnames(DS);
cix = ~cellfun(@isempty,strfind(fn,'SpikeTimesMs'));
clust_nams = fn(cix);

%%

% Outcome Variable(s)
MonkeyBid = double([DS(goodix).MonkeyBid]');

% Predictor Variables
tn = 1:length(DS);
TrialNumber = [tn(goodix)]';
ln = length(TrialNumber);
BidStart = double([DS(goodix).BidStartPosition]');
Previous_MB(1:ln,1) = [NaN;MonkeyBid(1:end-1)];
ComputerBid = double([DS(goodix).ComputerBid]');
Previous_CB(1:ln,1) = [NaN;ComputerBid(1:end-1)];

Rew = double([DS(goodix).RewardVolume]')/100;
Previous_Rew(1:ln,1) = [NaN;Rew(1:end-1)];
Budg = double([DS(goodix).BudgetVolume]')/100;
Previous_Budg(1:ln,1) = [NaN;Budg(1:end-1)];
TotalFluidConsumed = [cumsum(Budg)+cumsum(Rew)];

Fractal = double([DS(goodix).situation]');
Previous_Fractal(1:ln,1) = [NaN;Fractal(1:end-1)];
WinLose = double([DS(goodix).Win]');
Previous_WinLose(1:ln,1)= [NaN;WinLose(1:end-1)];

ReactionTime = double([DS(goodix).ReactionTime]');
TotalMovementTime = double([DS(goodix).total_movement_time_s]');
AvgVelocity = double([DS(goodix).avg_velocity]');
AvgAcceleration = double([DS(goodix).avg_acceleration]');

err = find(double([DS.ErrorUp])>0); 
PreviousTrialError = double(ismember(TrialNumber-1,err));

Previous_CB_sameFractal(1,:) = NaN;
Previous_MB_sameFractal(1,:) = NaN;
for iC = 2:length(ComputerBid)
    cf = Fractal(iC);
    last_same_frac = find(Fractal(1:iC-1)==cf,1,'last');
    if isempty(last_same_frac)      
        Previous_CB_sameFractal(iC,:) = NaN;
        Previous_MB_sameFractal(iC,:) = NaN;
    else        
        Previous_CB_sameFractal(iC,:) =  ComputerBid(last_same_frac);
        Previous_MB_sameFractal(iC,:)  = MonkeyBid(last_same_frac);
    end
%     Computerbid(1:iC
end


% make table
MonkeyBid;
Predictors = table(TrialNumber,BidStart,Previous_MB,Previous_MB_sameFractal,Previous_CB,Previous_CB_sameFractal,Previous_Rew,Previous_Budg,TotalFluidConsumed,...
    Fractal,Previous_Fractal,Previous_WinLose,ReactionTime,TotalMovementTime,AvgVelocity,AvgAcceleration,PreviousTrialError);


AllVars = table(MonkeyBid,TrialNumber,BidStart,Previous_MB,Previous_MB_sameFractal,Previous_CB,Previous_CB_sameFractal,Previous_Rew,Previous_Budg,TotalFluidConsumed,...
    Fractal,Previous_Fractal,Previous_WinLose,ReactionTime,TotalMovementTime,AvgVelocity,AvgAcceleration,PreviousTrialError);

%%
fig = figure('Visible','off');
for iP = 1:width(Predictors)
    X=[];y=[];pf=[];pv=[];
    x =  Predictors{:,iP};
    X = [ones(height(Predictors),1),x];
    y = MonkeyBid;
    varname = Predictors.Properties.VariableNames{iP};
    [b,~,~,~,stats] = regress(y,X);
    bn = BetaNormalization(b(2),x,y);

    subplot(4,5,iP)
    scatter(x,y)
    lsline %forces fit line--catchall in case polyfit doesn't work.    
    hold on
    pf = polyfit(x,y,1);
    pv = polyval(pf,x);
    plot(X,pv)   
    title(sprintf('beta = %.2g | R2 = %.2g \n p = %.2g',bn,stats(1),stats(3)),...
        'FontSize',10,'FontWeight','normal')
    xlabel(varname,'Interpreter','none','FontWeight','bold')
    FullScreenFigs
    FigureTitle(data_file_path_name)
%     pubify_figure_axis_robust
end
s = strfind(data_file_path_name,'\');
fpth = We_want_dir_funk([data_file_path_name(1:s(end)),'BxRegressions\']);
figsavnam = [fpth,'Individual_Regressions.png'];
saveas(fig,figsavnam);
ca

pth = 'C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Uly_Data\ANALYSIS\BX\';
savnam = [pth,'BxTable_',data_file_path_name(s(end-1)+1:s(end)-1)];
save(savnam,'MonkeyBid','Predictors')

BX = table2struct(AllVars);



