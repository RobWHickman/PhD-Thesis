 function BDMn = BDM_normalize_by_day(BDM)

dtn = unique(BDM.date_number);
AllVars = BDM.Properties.VariableNames;
nvars = {'budget','budget_liquid','computer_bid','juice','monkey_bid','paid','reward_liquid','reward_magnitude','reward_value',...
    'starting_bid','unrewarded','water','trial_number','total_juice','total_water','total_liquid','time_elapsed',...
    'previous_MB_dif_RV','previous_MB','previous_CB','previous_CB2','previous_CB3','previous_CB5','previous_CB7',...
    'previous_reward_value','previous_budget','previous_total_juice','previous_total_water','previous_total_liquid',...
    'previous_MB_sameRV','previous_CB_sameRV','previous_CB_sameRV2','previous_CB_sameRV3','previous_CB_sameRV4',...
    'previous_CB_sameRV5','previous_CB_sameRV6','previous_CB_sameRV7','previous_CB_sameRV8','previous_CB_sameRV9',...
    'previous_CB_sameRV10','previous_CB_sameRVmm2','previous_CB_sameRVmm3','previous_CB_sameRVmm4','previous_CB_sameRVmm5',...
    'previous_CB_sameRVmm6','pMBmpCB','MBmpCB'};
 
BDMn = [];

for iD = 1:numel(dtn)
    ix = BDM.date_number==dtn(iD);
    BDMs = BDM(ix,:);
    
    for iV = 1:length(AllVars)
        if ismember(AllVars{iV},nvars)
            BDMsn.(AllVars{iV}) = MinMaxFS(BDMs.(AllVars{iV}));
        else
            BDMsn.(AllVars{iV}) = BDMs.(AllVars{iV});
        end
    end
    BDMsnt = struct2table(BDMsn);
    BDMn = [BDMn;BDMsnt];
end
        
    
    
    
    
    