
fn = fieldnames(RES);
fn = fn(1:end-2);
for iF = 1:length(fn)
    for iR = 1:length(RES)
        if ~isempty(RES(iR).(fn{iF}))
            RS.(fn{iF})(iR).SR = RES(iR).(fn{iF}).SignRank_p;
            RS.(fn{iF})(iR).Bid_b = RES(iR).(fn{iF}).BidReg_b;
            RS.(fn{iF})(iR).Bid_r2 = RES(iR).(fn{iF}).BidReg_r2;
            RS.(fn{iF})(iR).Bid_p = RES(iR).(fn{iF}).BidReg_p;
            RS.(fn{iF})(iR).MCBid_b = RES(iR).(fn{iF}).MCBidReg_b;
            RS.(fn{iF})(iR).MCBid_r2 = RES(iR).(fn{iF}).MCBidReg_r2;
            RS.(fn{iF})(iR).MCBid_p = RES(iR).(fn{iF}).MCBidReg_p;
        end
    end
end
%%
cutoff = 0.01;
nams = {'FixCross' 'Fractal' 'BidStart' 'BidStable' 'CompBid' 'Reward' 'Budget'};
fldn = fieldnames(RS);
for i = 1:length(nams)
    cnts.SR.(nams{i}) = sum([RS.(fldn{i}).SR]<cutoff);
    cnts.Bid_p.(nams{i}) = sum([RS.(fldn{i}).Bid_p]<cutoff);
    cnts.MCBid_p.(nams{i}) = sum([RS.(fldn{i}).MCBid_p]<cutoff);
  
    %     cnts.Bid_b.(nams{i}) = sum([RS.(fldn{i}).Bid_b]<cutoff);
%     cnts.Bid_r2.(nams{i}) = sum([RS.(fldn{i}).Bid_r2]<cutoff);

end
%%
bsix = [RS.(fldn{i}).Bid_p]<cutoff;

    
sig_cells.p=[RS.(fldn{i})(bsix).Bid_p];
sig_cells.r2=[RS.(fldn{i})(bsix).Bid_r2];
sig_cells.b=[RS.(fldn{i})(bsix).Bid_b];