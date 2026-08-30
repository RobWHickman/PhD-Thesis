for i = min(BDM.session_number):max(BDM.session_number)
    fig  = figure('Visible','off');
    plt = 0;
%     fig  = figure
    for ir = 1:3
        ix = BDM.reward_value == ir & BDM.session_number==i;
        tn = BDM.trial_number(ix);
        mb = BDM.monkey_bid(ix);
        if ~isempty(mb)
            plot(tn,mb,'.-')
            hold on
            plt = 1;
        end        
    end
    if plt
        pubify_figure_axis_robust
        WideFigs
        
        dtstr = datestr(BDM.date(i),'yyyy-mm-dd');
        savnam = ['C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Results_and_Figs\Figure_1\Bid_by_trial_png\',...
            dtstr,'_Session',num2str(i)];
        saveas(fig, savnam,'png')
    end
    close(fig);
end

      