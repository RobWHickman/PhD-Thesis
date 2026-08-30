[RES,MonkeyBid,Predictors] = GenerateBDMTable(RES);

nams = Predictors.Properties.VariableNames;
A = table2array(Predictors);
% A = MinMaxFS(A)


[lass,stats] = lasso(A,MonkeyBid,'CV',10,'Standardize',true);
% [lass,stats] = lassoglm(A,MonkeyBid);


% lassoPlot(lass,stats,'PlotType','CV')

lassoPlot(lass,stats,'PlotType','Lambda','XScale','log');

%%
[elnet,estats] = lasso(A,MonkeyBid,'CV',10,'Alpha',0.75,'Standardize',true);

lassoPlot(elnet,estats,'PlotType','CV')

lassoPlot(elnet,estats,'PlotType','Lambda','XScale','log',...
    'PredictorNames',nams);