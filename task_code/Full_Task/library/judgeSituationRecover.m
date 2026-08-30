function params = judgeSituationRecover(param, Tbl,Timers)
% params = judgeSituationRecover(param, Tbl,Timers);
%
% 

params.prev_event_name = cell2mat(Tbl.TaskTbl(param.prev_id,Tbl.TaskTblColumnID.evnt_name));
params.prev_timer      = Timers.Event.(param.prev_event_name);

params.next_event_name = cell2mat(Tbl.TaskTbl(param.next_id,Tbl.TaskTblColumnID.evnt_name));
params.next_timer      = Timers.Event.(param.next_event_name);
params.next_page       = cell2mat(Tbl.TaskTbl(param.next_id, Tbl.TaskTblColumnID.vis_page));
