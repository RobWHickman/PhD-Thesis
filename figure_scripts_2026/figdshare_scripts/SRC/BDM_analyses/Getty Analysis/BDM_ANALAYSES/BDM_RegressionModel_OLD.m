[RES,MonkeyBid,Predictors,ZMonkeyBid,ZPredictors] = GenerateBDMTable(RES);
clear b bint stats

% mpix = [2,4,10,12,14,15];
% mpix = [1,10,12];
mpix = [1,2,6,9,10,12,14,15];



[C,ia,ic] = unique(Predictors.SessionNumber);
vn = Predictors.Properties.VariableNames;
svn = join(vn);
for i = 1:length(C)
    ix = find(ic==C(i));
    X=[];y=[];pf=[];pv=[];
  
    x =  [Predictors{ix,1},ZPredictors{ix,[2,6,9]},Predictors{ix,[10,12]},ZPredictors{ix,[14,15]}];
    X = [ones(length(x(:,1)),1),x];
    y = ZMonkeyBid(ix);
    [b(i,:),bint(:,:,i),~,~,stats(i,:)] = regress(y,X);
%     bn(i,:) = BetaNormalization(b(2:end),x,y);
end
%%
mb = mean(b);

figure
Plot_Bars_SEM(b(:,2:end))
xticklabels(vn(mpix))
xtickangle(45)

[p,tbl,astats] = anova1(b(:,2:end),vn(mpix))
multcompare(astats)