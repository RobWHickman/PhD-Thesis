if ~exist('BDM')
    clear;
    load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Results_and_Figs\Ulysses_BDM_table.mat')
%     load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Results_and_Figs\Vicer_BDM_table.mat')
    BDM = BDM_Exclusion_Criteria(BDM);
end
%%
col = lines(2);
if ismember(char(BDM.monkey_ID(1)),'Uly')
    cl = 1;
else 
    cl = 2;
end

figure

ses = unique(BDM.session_number);
for i = 1:3
    
    for is = 1:length(ses)
        ix = BDM.reward_value==i&BDM.session_number==ses(is);
        mb = BDM.monkey_bid(ix);
        mdmb = nanmedian(mb);
        MAD(is) = nanmedian(abs(mb-mdmb));
        
    end
    ax = (randi(300,length(MAD),1)-150)/1000;
    plot(i+ax,MAD,'.','Color',col(cl,:))
    hold on

end

g=gca;
g.YLim(1) = -.05;
line(g.XLim,[0 0],'color','k')
title(char(BDM.monkey_ID(1)))

pubify_figure_axis_robust
