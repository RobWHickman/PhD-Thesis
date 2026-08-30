function out = trialRecon2(option)
%   out = trialRecon2(option)
%   
%   option can be 'data' or left blank --reconstructs the flip TS
%   in relation to the epochs found in global Task. It's output is
%   'out', a epochs x 4 cell of cells with the TSs.
%
% See also MODIGTASKLOOP, MODIGRUNTRIAL
global Task TaskOp

% if nargin == 0, option = 'data'; end

header = [{'Event Name'} {'Planned epoch duration'} {'Actual epoch duration'} {'flip TS'}];
tf = fields(Task);
out = cell(size(tf,1)+1,size(header,2));
out(1,:) = header;
out(2:end,1) = tf;       

if isfield(TaskOp.EvntHist,'cur_trial_start_time') 
  % anchors with handshake finish
  trialStart = TaskOp.EvntHist.cur_trial_start_time; 
else
    % First trial since Modig started
    trialStart = GetSecs;
end

%  switch option
%     case 'data'
        % loop all trial epochs
        for i = 1:size(tf,1),
            out(i+1,2) = {Task.(tf{i}).time_planned};            
            fts = Task.(tf{i}).flipTimeStamp;
            
            if i==1,
                out(i+1,3) = {fts-trialStart};
            else
                out(i+1,3) = {fts-max([out{2:end,4}])};
            end
            out(i+1,4) = {fts};
        end
%      case 'init'
       % initialize an empty cell matrix that we fill in the next trials
% end