[r,p] = corr(tbl.monkey_bid,tbl.reward_value,'type','Spearman')
tbl = BDM;
[c,ia,ic] = unique(tbl.session_number);
r_all=[];p_all=[];
for i =1:length(c)
    ix = tbl.session_number==c(i);
    if sum(ix)<10 || all(tbl.reward_value(ix)==2) ,continue,else
    [r,p]=corr(tbl.monkey_bid(ix),tbl.reward_value(ix),"type",'Spearman');
    r_all = [r_all;r];p_all=[p_all;p];
%     if isnan(r) || r==-1 || r < 0 || r == 1
%         sdisp(1)
%     end
    end
end

r2_all = r_all.^2;
proportion_positive_corr = sum(r_all>0)/numel(r_all)

average_r2 = mean(r2_all)
std_r2 = std(r2_all)


proportion_sig = sum(p_all<.05)/numel(p_all)