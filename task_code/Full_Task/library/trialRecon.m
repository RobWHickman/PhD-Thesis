function out = trialRecon(option)
%   out = trialRecon(option)
%   
%   option can be 'data' or left blank --reconstructs the flip TS, and
%   timer TS in relation to the epochs found in global Task. It's output is
%   'out', a epochs x 9 cell of cells with the TSs.
%
% See also TIMERTIMESTAMPER, MODIGTASKLOOP, MODIGSETTIMER
%
% rbm 09.07
%       3.08
%       4.08 
%       7.08 uses anchor after handshake
%       8.08 no need to call w/ option init, since we reconstruct for all
%       trials in ModigTaskLoop 
global Timers BehaveData Task TaskOp

if nargin == 0, option = 'data'; end

header = [{'Event Name'} {'plan dur'} {'eT Timer tiF-stF'}, ....
    {'eT flip from st'},...
    {'eT flips diff'} {'eT flip-stFcnTS'} {'flip TS'} {'stFcn TS'} {'tiFcn TS'}];
tf = fields(Timers.Event);
evTiming = zeros(size(tf,1),1);
flipTS = zeros(size(tf,1),3);
out = cell(size(tf,1)+1,size(header,2));
out(1,:) = header;



if isfield(TaskOp.EvntHist,'cur_trial_start_time') 
%                 trialStart = BehaveData.Tbl(1);
  trialStart = TaskOp.EvntHist.cur_trial_start_time; 
  % anchors with handshake finish
else
    % First trial since Modig started
    trialStart = GetSecs;
end

 switch option
    case 'data'
        % loop all trial epochs
        for i = 1:size(tf,1),
            timTs = Timers.Event.(tf{i}).userdata;
            fts = Task.(tf{i}).flipTimeStamp;
            
            st = [];
            ti = [];

            % extract time stamps from timer
            if ~isempty(timTs),                
                for j = 1:size(timTs,1), 
                    if strcmp(timTs(j).Type,'StartFcn'),
                        st = timTs(j).Data(end);
                    elseif strcmp(timTs(j).Type,'TimerFcn')
                        ti = timTs(j).Data(end);
                    end
                end
            end
            
            % time elapsed in this epoch 
            if i>1 && fts >0
                flipTS(i,2) = fts-Task.(tf{i-1}).flipTimeStamp;
            end
            % time elapsed since trial start
            flipTS(i,1) = fts-trialStart;

            % append results 
            fts = round(fts*1000);
            st  = round(st*1000);
            ti  = round(ti*1000);
            out(i+1,:) = [tf{i} Task.(tf{i}).time_planned {evTiming(i,1)}, ...
                {flipTS(i,1)} {flipTS(i,2)},...
                {flipTS(i,3)} {fts} {st} {ti}] ;

        end
     case 'init'
       % initialize an empty cell matrix that we fill in the next trials
       out(2:end,1) = tf;
end
