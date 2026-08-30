function [BDM, zBDM] = BDM_Exclusion_Criteria(BDM,ExcludeSensoredBids)

if nargin<2
    ExcludeSensoredBids=1;
end

if ismember(BDM.monkey_ID(1),'Uly')
    ims = BDM.reward_liquid==.7|BDM.reward_liquid==.45|BDM.reward_liquid==.2|BDM.reward_liquid==0;
end
if ismember(BDM.monkey_ID(1),'Vic')
    ims = BDM.date>datetime(2020,01,01);
end
if ExcludeSensoredBids
    isbd = BDM.monkey_bid>0 & BDM.monkey_bid<1;
else
    isbd = ones(height(BDM),1);
end

itf = BDM.task_failure==0;

ix = ims & isbd & itf;

 [zBDM] = BDM_normalize_table(BDM);
BDM = BDM(ix,:);
zBDM = zBDM(ix,:);