%% basic regression
%%
[C,ia,ic] = unique(BDM.session_number);
vnam = BDM.Properties.VariableNames;

nanBDM = nan(size(BDM));
zBDM = array2table(nanBDM);
zBDM.Properties.VariableNames = vnam;
for iPw = 1:width(BDM)
    if isnumeric(BDM.(vnam{iPw}))
        disp(vnam{iPw})
        for i = 1:length(C)
            ix = find(ic==C(i));
            zBDM.(vnam{iPw})(ix) = normalize(BDM.(vnam{iPw})(ix));
        end
    else
        zBDM.(vnam{iPw}) = BDM.(vnam{iPw});
    end
end

% normvars = {'trial_number' 'reward_value' 'previous_reward_value' 'previous_win_lose'...
%     'previous_trial_error' 'session_number' 'date_number' 'day_of_week'} ;
normvars = BDM.Properties.VariableNames;
badvars = {'monkey_bid' 'budget' 'budget_liquid' 'date' 'error_timeout' ...
    'finish' 'free_reward' 'results' 'subtask' 'time' 'task_failure' 'juice' 'water'...
    'rewarded' 'unrewarded' };
% goodvars = {'session_number' 'trial_number' 'starting_bid' 'total_juice' 'total_water' 'total_liquid' 'previous_CB_sameRV' 'previous_MB_sameRV' };
goodvars = {'previous_CB_sameRV' 'previous_MB_sameRV' 'total_juice' 'total_water' 'total_liquid' };


ix = BDM.task_failure==0&...
    BDM.monkey_bid>0&BDM.monkey_bid<1&...
    BDM.date>datetime(2020,01,01)&...
        BDM.error<=30;%&... % This is arbitrary. This might need more attention and a more careful means of selection. 

%     BDM.previous_MB_sameRV>0&BDM.previous_MB_sameRV<1&...
%     BDM.date>datetime(2020,01,01)&...
BDM = BDM(ix,:);
zBDM = zBDM(ix,:);


%%
figure
sp = 1;

for iP = 1:width(BDM)
    clear x y
    varname = BDM.Properties.VariableNames{iP};
    mb = BDM.monkey_bid;
    if ismember(varname,badvars)
        continue
    end
    if ismember(varname,normvars)
        var = BDM{:,iP};
        q = quantile(var,15);
        q=[0,q,max(var)];
        [counts,~, Id] = histcounts(var,q);
        for i = 1:length(counts)
            x(i,1) = nanmean(var(Id==i));
            y(i,1) = nanmean(mb(Id==i));
            s(i,1) = Sem(mb(Id==i));
        end
    else
        var = zBDM{:,iP};
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
    
    subplot(5,5,sp)
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
    
    sp = sp+1;
end

FullScreenFigs

% bar(allbeta)
% errorbar(allbeta,allbetaint)
%%
rv = 2;
ix = BDM.reward_value==rv;

figure
sp =1;
for iP = 1:width(BDM)
    clear x y
    varname = BDM.Properties.VariableNames{iP};
    if ismember(varname,badvars)
        continue
    end
    mb = BDM.monkey_bid(ix);
    if ismember(varname,normvars)
        var = BDM.(varname)(ix);
        q = quantile(var,15);
        q =[0,q,max(var)];
        [counts,~, Id] = histcounts(var,q);
        for i = 1:length(counts)
            x(i,1) = nanmean(var(Id==i));
            y(i,1) = nanmean(mb(Id==i));
            s(i,1) = Sem(mb(Id==i));
            
        end
    else
        var = zBDM.(varname)(ix);
        q = quantile(var,15);
        q=[0,q,max(var)];
        [counts,~, Id] = histcounts(var,q);
        for i = 1:length(counts)
            x(i,1) = nanmean(var(Id==i));
            y(i,1) = nanmean(mb(Id==i));
            s(i,1) = Sem(mb(Id==i));
        end
    end
    
    X = [ones(length(x),1),x];
    [b,~,~,~,stats] = regress(y,X);
    bn = BetaNormalization(b(2),x,y);
    
    subplot(5,5,sp)
    scatter(x,y,'filled')
    lsline %forces fit line--catchall in case polyfit doesn't work.
    hold on
    errorbar(x,y,s,'LineStyle','none')
    
    pf = polyfit(x,y,1);
    pv = polyval(pf,x);
    plot(x,pv)
    title(sprintf('beta = %.2g | R2 = %.2g \n p = %.2g',bn,stats(1),stats(3)),...
        'FontSize',10,'FontWeight','normal')
    xlabel(varname,'Interpreter','none','FontWeight','bold')
    sp = sp+1;
    clearvars -except BDM BC zBDM normvars badvars sp ix rv
end
FullScreenFigs
FigureTitle(sprintf('Reward value = %g',rv));


%%
% figure;
sp = 1;
for iP = 1:width(BDM)
    
    varname = BDM.Properties.VariableNames{iP};
    if ismember(varname,badvars)
        continue
    end
    figure
    X=[];y=[];pf=[];pv=[];
    x =  BDM{:,iP};
    X = [ones(height(BDM),1),x];
    y = BDM.monkey_bid;
    [b,bint,~,~,stats] = regress(y,X);
    bn = BetaNormalization(b(2),x,y);
    
    %     subplot(5,6,sp)
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
    sp = sp+1;
    
end
FullScreenFigs


%%


for iP = 1:width(BDM)
    varname = BDM.Properties.VariableNames{iP};
    if ismember(varname,badvars)
        continue
    end
    figure;
    for rv = 1:3
        
        X=[];y=[];pf=[];pv=[];
        ix = BDM.reward_value==rv;
        x =  BDM{ix,iP};
        X = [ones(length(x),1),x];
%         X=x;
        y = BDM.monkey_bid(ix);
        [b,~,~,~,stats] = regress(y,X);
        bn = BetaNormalization(b(2),x,y);
        
        subplot(3,1,rv)
        scatter(x,y)
        lsline %forces fit line--catchall in case polyfit doesn't work.
        hold on
        pf = polyfit(x,y,1);
        pv = polyval(pf,x);
        plot(x,pv)
        ay = 1-(rv*.3)+.23;
        dim = [.65 ay .3 .04];
        str = sprintf('beta = %.2g | R2 = %.2g \n p = %.2g',bn,stats(1),stats(3));
        annotation('textbox',dim,'String',str,'HorizontalAlignment','center');%,'FitBoxToText','on');
%         title(sprintf('beta = %.2g | R2 = %.2g \n p = %.2g',bn,stats(1),stats(3)),...
%             'FontSize',10,'FontWeight','normal')
        FigureTitle(varname)
        title(sprintf('Reward value = %g',rv));
        LongFigs
        %     FigureTitle(data_file_path_name)
        %     pubify_figure_axis_robust
    end
end

