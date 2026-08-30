[RES,MonkeyBid,Predictors,ZMonkeyBid,ZPredictors] = GenerateBDMTable(RES);




% z=zeros(height(Predictors),1);
% z(1:10:height(Predictors))=1;
% xt = logical(z);
% varix = 1:20;

X = [ZPredictors{:,1:16},Predictors{:,17:20}];
Y = MonkeyBid;

Mdl = stepwiselm(X,Y,'Criterion','AIC');


