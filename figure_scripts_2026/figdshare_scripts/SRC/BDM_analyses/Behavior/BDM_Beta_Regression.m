tbl = BDM;

y = tbl.monkey_bid;
o = ones(height(tbl),1);
predictors = [tbl.reward_value tbl.starting_bid tbl.total_juice tbl.total_water tbl.day_of_week ...
    tbl.session_number tbl.Previous_MB_dif_RV tbl.previous_CB_sameRV tbl.previous_win_lose];
X = [o predictors];
% X = [predictors];
badix= isnan(prod(predictors,2));
y=y(~badix);
X = X(~badix,:);

betareg(y,X)