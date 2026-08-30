
col = autumn(300);

for i = 1:max(Predictors.SessionNumber) 
    ix = [Predictors.Fractal==2] & [Predictors.SessionNumber==i];
    plot([Predictors.TotalFluidConsumed(ix)],[MonkeyBid(ix)],'LineStyle','none','Marker','o','Color',col(i,:))
    hold on
end


