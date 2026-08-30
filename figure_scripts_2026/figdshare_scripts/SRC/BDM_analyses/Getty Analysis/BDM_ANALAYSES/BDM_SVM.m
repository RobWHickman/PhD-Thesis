[RES,MonkeyBid,Predictors] = GenerateBDMTable(RES);

z=zeros(height(Predictors),1);
z(1:10:height(Predictors))=1;
xt = logical(z);
% varix = [2,4,7,9,10,15,16,18] %taken from playing with SVM -- dont use
% varix = [7,8,10,11,12,13]; %from elastic net regression--makes a dumb result
% varix = [1,5,10,11,12,15,18]; %significant variables from individual regressions--mathces the full model closely.
varix = [1,2,6,9,10,12,14,15,18];
% varix = 1:20;

vn = Predictors.Properties.VariableNames;


X = Predictors{~xt,varix};
Y = MonkeyBid(~xt);

% MdlLin = fitrsvm(X,Y,'Standardize',true,'KFold',5)
% MdlGau = fitrsvm(X,Y,'Standardize',true,'KFold',5,'KernelFunction','gaussian')
% MdlPol = fitrsvm(X,Y,'Standardize',true,'KFold',3,'KernelFunction',...
% 'polynomial','PolynomialOrder',3); % couldn't get this to run--too damn slow
%
% mseLin = kfoldLoss(MdlLin) %lowest for linear but still huge
% mseGau = kfoldLoss(MdlGau)
% msePol = kfoldLoss(MdlPol)



Mdl = fitrsvm(X,Y,'Standardize',true);

b = Mdl.Beta;
e = Mdl.Bias;

Xho = Predictors{xt,varix};
[ypred] = predict(Mdl,Xho);
%%

figure;scatter(ypred,MonkeyBid(xt),'filled')
lsline

YP = [ones(length(ypred),1),ypred];
[b,~,~,~,stats] = regress(MonkeyBid(xt),YP);
ar2 = AdjustedR2(stats(1),length(ypred),7);
% title(sprintf('beta = %.2g | R2 = %.2g \n p = %.2g',b(2),ar2,stats(3)),...
%     'FontSize',10,'FontWeight','normal')
xlabel('Predicted Bid')
ylabel('Actual Bid')
pubify_figure_axis_robust

% FigureTitle(join(vn(varix),','))
% MedFigs