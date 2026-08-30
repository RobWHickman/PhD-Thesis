%%
[B,fi] = lasso(Predictors{:,:},MB,'Alpha',0.75,'CV',10,'Standardize',true);





b = [];
b_norm = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IVs = [mb];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     IVs = [mfr_frac];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DV = mfr_frac;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = [ones(length(DV),1),IVs];
%     X = [ones(length(mfr_frac),1),mb.*pwl,mb,pwl];
[b,bint,r,rint,stats] = regress(DV,X);
for iB = 1:length(IVs(1,:));
    b_norm = BetaNormalization(b,IVs(:,iB),DV);
end

