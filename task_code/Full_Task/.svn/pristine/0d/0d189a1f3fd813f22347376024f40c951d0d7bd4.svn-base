function noKeyRelease_module(rowNoToUpdate, nameOfEpoch) 
% noKeyRelease_module(rowNoToUpdate, nameOfEpoch) 
%
% No Key Release is defined as when the acting monkey doesn't release his
% key trying to reach for the target(s)
%
% This module updates a NKR counter and a GUI.
%
% in, nameOfEpoch: self-explanatory
%     rowNoToUpdate, index integer of matrix to update. The error counter
%     matrix should be found in global MENUs*
%
% rbm 06.11
global MENUs TaskOp BehaveData


% determine if monkey didn't release the key
theStr = get(MENUs.ModigMainMenu.handles.errorNos,'String');
origNt = str2double(theStr(rowNoToUpdate,:));
if origNt<TaskOp.count.noTouch,              
   % time of target on
   out = trialRecon;
   thisRow = find(strcmpi(out(:,1),nameOfEpoch));               
   indices = BehaveData.Tbl(:,1)>(out{thisRow-1,7}/1000) & ...
       BehaveData.Tbl(:,1)>(out{thisRow,7}/1000);

   % did monkey release key?
   nkr = sum(BehaveData.Tbl(indices,7)==1)==sum(indices);
   TaskOp.count.noKeyRelease = TaskOp.count.noKeyRelease+nkr; 
end          