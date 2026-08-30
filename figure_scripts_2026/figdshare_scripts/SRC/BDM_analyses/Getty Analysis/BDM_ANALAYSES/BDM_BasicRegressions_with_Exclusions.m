%% basic regression
%%
[RES,MonkeyBid,Predictors,ZMonkeyBid,ZPredictors] = GenerateBDMTable(RES);

%% Exclusion Criteria






%%
figure
for iP = 1:width(Predictors)
    clear x y
    varname = Predictors.Properties.VariableNames{iP};
    mb = MonkeyBid;
    if ismember(iP,[1,10,11,12,17,18,19,20])
        var = Predictors{:,iP};
        q = quantile(var,15);
        [counts, Id] = histc(var,q);
        for i = 1:length(counts)
            x(i,1) = nanmean(var(Id==i));
            y(i,1) = nanmean(mb(Id==i));
            s(i,1) = Sem(mb(Id==i));
        end
    else
        var = ZPredictors{:,iP};
        q = quantile(var,15);
        [counts, Id] = histc(var,q);
        for i = 1:length(counts)
            x(i,1) = nanmean(var(Id==i));
            y(i,1) = nanmean(mb(Id==i));
            s(i,1) = Sem(mb(Id==i));

        end
    end
    
    X = [ones(length(x),1),x];
    [b,bint,~,~,stats] = regress(y,X);
    bn = BetaNormalization(b(2),x,y);
    allbeta(iP) = b(2);
    allbetaint(iP,:) = bint(2,:);
    
    subplot(4,5,iP)
    scatter(x,y,'filled')
    lsline %forces fit line--catchall in case polyfit doesn't work.
    hold on
    errorbar(x,y,s,'LineStyle','none')
    %     pf = polyfit(x,y,1);
%     pv = polyval(pf,x);
%     plot(X,pv)
    title(sprintf('beta = %.2g | R2 = %.2g \n p = %.2g',bn,stats(1),stats(3)),...
        'FontSize',10,'FontWeight','normal')
    xlabel(varname,'Interpreter','none','FontWeight','bold')
    pubify_figure_axis_robust
end

FullScreenFigs

% bar(allbeta)
% errorbar(allbeta,allbetaint)
%%
ix = Predictors.Fractal==2;

figure
for iP = 1:width(Predictors)
    clear x y
    varname = Predictors.Properties.VariableNames{iP};
    mb = MonkeyBid;
    if ismember(iP,[1,10,11,12,17,18,19,20])
        var = Predictors{ix,iP};
        q = quantile(var,15);
        [counts, Id] = histc(var,q);
        for i = 1:length(counts)
            x(i,1) = nanmean(var(Id==i));
            y(i,1) = nanmean(mb(Id==i));
        end
    else
        var = ZPredictors{ix,iP};
        q = quantile(var,15);
        [counts, Id] = histc(var,q);
        for i = 1:length(counts)
            x(i,1) = nanmean(var(Id==i));
            y(i,1) = nanmean(mb(Id==i));
        end
    end
    
    X = [ones(length(x),1),x];
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
end
FullScreenFigs


%%
figure;
for iP = 1:width(Predictors)
    X=[];y=[];pf=[];pv=[];
    x =  Predictors{:,iP};
    X = [ones(height(Predictors),1),x];
    y = MonkeyBid;
    varname = Predictors.Properties.VariableNames{iP};
    [b,bint,~,~,stats] = regress(y,X);
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
    %     FigureTitle(data_file_path_name)
        pubify_figure_axis_robust
end
FullScreenFigs


%%

figure;
for iP = 1:width(Predictors)
    X=[];y=[];pf=[];pv=[];
    ix = Predictors.Fractal==2;
    x =  Predictors{ix,iP};
    X = [ones(length(x),1),x];
    y = MonkeyBid(ix);
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
    %     FigureTitle(data_file_path_name)
    %     pubify_figure_axis_robust
end

