%% Quantreg
goodvars = {'reward_value' 'previous_CB_sameRV' 'previous_MB_sameRV' 'total_juice' 'total_water' 'total_liquid' };

quants = [.1 .25 .5 .75 .9];

for iP = 1:width(BDM)
    varname = BDM.Properties.VariableNames{iP};
    if ~ismember(varname,goodvars)
        continue
    end
    fig = figure;
    
    X=[];y=[];pf=[];pv=[];b=[];x=[];
    
    ix = ~isnan(BDM.(varname))&~isnan(BDM.monkey_bid)&...
        BDM.monkey_bid<1&BDM.monkey_bid>0;
    
    x =  BDM{ix,iP};
    %         X = [ones(length(x),1),x];
    X = [x,ones(length(x),1)];
    y = BDM.monkey_bid(ix);
    %         [b,~,~,~,stats] = regress(y,X);
    %         bn = BetaNormalization(b(2),x,y);
    
    scatter(x,y)
    %         lsline %forces fit line--catchall in case polyfit doesn't work.
    hold on
    %         pf = polyfit(x,y,1);
    %         pv = polyval(pf,x);
    
    for iq = 1:length(quants)
        tic
        [b,stats] = quantreg(x,y,quants(iq));
        toc
        f = b(2)+(b(1)*x);
        
        yresid = y-(b(1)*x);
        
        [n,~] = size(yresid);
        [mu,~] = tstat(n-1);
        [~,p] = ttest(yresid,mu,0.05);
        
        se = stats.pse;
        z = b(1)/se(1);
        p2 = exp((-.717*z)-((.416*z)^2));%%% https://www-bmj-com.ezp.lib.cam.ac.uk/content/343/bmj.d2304
        
        P(iq) = p;
        P2(iq) = p2;
        B(iq) = b(1);
        pv(:,iq) = f;
        R2(iq) = stats.R2;
    end
%     [xx,six]=sortrows(x);
    plot(x,pv,'k')
    xlabel(sprintf(['beta = ',num2str(B),'\n p = ',num2str(P),'\n R2 = ',num2str(R2)]))
    
%     annotation('textbox',[.15 .15 .8 .07],'String',sprintf(['beta = ',num2str(B),'\n p = ',num2str(P),'\n R2 = ',num2str(R2)]));%,'FitBoxToText','on');
%     annotation('textbox',[.13 ay .1 .05],'String',sprintf('RV = %g',rv));%,'FitBoxToText','on');
    FigureTitle(varname)
    LongFigs
    pubify_figure_axis_robust
    pubify_figure_axis_robust
    saveas(fig,varname,'meta')
end

%%
goodvars = {'previous_CB_sameRV' 'previous_MB_sameRV' 'total_juice' 'total_water' 'total_liquid' };

for iP = 1:width(BDM)
    varname = BDM.Properties.VariableNames{iP};
    if ~ismember(varname,goodvars)
        continue
    end
    fig  = figure;
    for rv = 1:3
        
        X=[];y=[];pf=[];pv=[];b=[];x=[];
        ix = BDM.reward_value==rv;
        x =  BDM{ix,iP};
        %         X = [ones(length(x),1),x];
        X = [x,ones(length(x),1)];
        y = BDM.monkey_bid(ix);
        %         [b,~,~,~,stats] = regress(y,X);
        %         bn = BetaNormalization(b(2),x,y);
        
        subplot(3,1,rv)
        scatter(x,y)
        %         lsline %forces fit line--catchall in case polyfit doesn't work.
        hold on
        %         pf = polyfit(x,y,1);
        %         pv = polyval(pf,x);
        
        for iq = 1:length(quants)
            tic
            [b,stats] = quantreg(x,y,quants(iq));
            toc
            f = b(2)+(b(1)*x);
            
            yresid = y-(b(1)*x);
            
            [n,~] = size(yresid);
            [mu,~] = tstat(n-1);
            [~,p] = ttest(yresid,mu,0.05);
            
            se = stats.pse;
            z = b(1)/se(1);
            p2 = exp((-.717*z)-((.416*z)^2));%%% https://www-bmj-com.ezp.lib.cam.ac.uk/content/343/bmj.d2304
            
            P(iq) = p;
            P2(iq) = p2;
            B(iq) = b(1);
            pv(:,iq) = f;
            R2(iq) = stats.R2;
        end
        
        plot(x,pv)
        ay = 1-(rv*.3)+.23;

        %         dim = [.35 ay .6 .05];
        annotation('textbox',[.25 ay .7 .06],'String',sprintf(['beta = ',num2str(B),'\n p = ',num2str(P),'\n R2 = ',num2str(R2)]));%,'FitBoxToText','on');
        annotation('textbox',[.13 ay .1 .05],'String',sprintf('RV = %g',rv));%,'FitBoxToText','on');
        FigureTitle(varname)
        LongFigs
  
    end
end
