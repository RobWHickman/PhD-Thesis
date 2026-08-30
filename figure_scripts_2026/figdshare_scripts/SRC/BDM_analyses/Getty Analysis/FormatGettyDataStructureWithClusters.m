function [O,pth] = FormatGettyDataStructureWithClusters(file_location_and_name, bit_names, addval_names)


if nargin < 1
    %     [fl,pth] = uigetfile('C:\Users\dfhil\Dropbox\Schultz_Lab\Uly_Data\*.mat');
    [fl,pth] = uigetfile('D:\Dropbox\Schultz_Lab\Uly_Data\*.mat');
    file_location_and_name = [pth,fl];
else 
    [path,fil,ext] = fileparts(file_location_and_name);
    pth = [path,'\'];
    fl = [fil,ext];
end

if nargin < 2
    % these must be entered in the order of bit number 0 to 15.
    bit_names = {'TrialOnset' 'FixationCross' 'FractalDisplay' 'BidStart' 'BidStable' 'WinLose' 'RewardEpochEnd' ...
        'ButdgetEpochEnd' 'FreeReward' 'RewardTap' 'BudgetTap' 'ThirdTap' 'TrialEnd' 'Error'};
end

if nargin < 3
    addval_names = {'NumberAddVals','TrialNumberXL','TrialNumber', 'GettySetDuration1','GettySetDuration2', 'Situation',...
        'Task','SubTask','FractalValue', 'BudgetMagnitude', 'TrialStartBid','ComputerBid','PrevTrial_BudgetLiquid',...
        'PrevTrial_BudgetTotal','PrevTrial_ComputerBid','PrevTrial_Correct','PrevTrial_FreeReward','PrevTrial_MonkeyBid',...
        'PrevTrial_RewardProb','PrevTrial_RewardLiquid','PrevTrial_RewardMagnitude'};
end

%% Get trial durations 

sFreq = 22000; %this is hardcoded for now but should be changed at some point so that it gets read from rad header. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RADdur = [pth,'r',fl(2:end-4),'.radDURATION'];
durations_ms = GETTYANALYSIS_Get_RAD_Trial_Durations(RADdur,sFreq);
%   t_start = [0 cumsum(durations)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
GD = load(file_location_and_name);
fld = fieldnames(GD);
GDstruct = GD.(fld{1}); %this is the structure that comes from justopenfile.m
fld_nams = fields(GDstruct.trial);
%% add wavemarks to file
notclstix = cellfun(@isempty,(strfind(fld_nams,'Clust')));
if sum(~notclstix)<1 
    clust_exist = 1;
    GETTYANALYSIS_Add_Wavemarks(file_location_and_name)
    GD = load(file_location_and_name);
    fld = fieldnames(GD);
    GDstruct = GD.(fld{1}); %this is the structure that comes from justopenfile.m
end

%% get joystick data
% notjsix = cellfun(@isempty,(strfind(fld_nams,'lever')));
% if sum(~notjsix)<1 
% %     GETTYANALYSIS_Get_JoyStick_Data(file_location_and_name)
% %     GD = load(file_location_and_name);
% %     fld = fieldnames(GD);
% %     GDstruct = GD.(fld{1}); %this is the structure that comes from justopenfile.m
% %  
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ytr = GETTYANALYSIS_Get_JoyStick_Data_YmovementOnly(file_location_and_name);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
O = GDstruct.trial;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iJ=1:length(O)-1
    O(iJ).JoyStick = ytr(iJ,:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars GD GDstruct

% switch format_spec
%     case 'Strct'
% put data in structure without all the fluff
flds = {'data', 'emg', 'analogfrequency','timefirstanalog','analog','duration','neuron'};
O = rmfield(O,flds);
sbix = ~(cellfun(@isempty,(strfind(addval_names,'TrialStartBid'))));
mbix = ~(cellfun(@isempty,(strfind(addval_names,'PrevTrial_MonkeyBid'))));
cbix = ~(cellfun(@isempty,(strfind(addval_names,'PrevTrial_ComputerBid'))));
rlix = ~(cellfun(@isempty,(strfind(addval_names,'PrevTrial_RewardLiquid'))));
blix = ~(cellfun(@isempty,(strfind(addval_names,'PrevTrial_BudgetLiquid'))));
tnix = ismember(addval_names,'TrialNumber');

for iTrial = 2:length(O)
    O(iTrial-1).BidStartPosition = O(iTrial-1).addvals(sbix);% for these variables, the current ix is the current trial's value. iTrial-1 to get it to align with the others below.
    O(iTrial-1).TrialNumber = O(iTrial-1).addvals(tnix);
    if isfield(O,'lever') && ~isempty(O(iTrial-1).lever)
        O(iTrial-1).ReactionTime = O(iTrial-1).lever.reaction_time_s;
        O(iTrial-1).total_movement_time_s = O(iTrial-1).lever.total_movement_time_s;
        O(iTrial-1).acceleration = O(iTrial-1).lever.acceleration;
        O(iTrial-1).avg_acceleration = O(iTrial-1).lever.avg_acceleration;
        O(iTrial-1).velocity = O(iTrial-1).lever.velocity;
        O(iTrial-1).avg_velocity = O(iTrial-1).lever.avg_velocity;
    end
    O(iTrial-1).MonkeyBid = O(iTrial).addvals(mbix);% for this and the following variables the current ix is the previous trial's value (see indexes above). The last trial should be omitted.
    O(iTrial-1).ComputerBid = O(iTrial).addvals(cbix);    
    O(iTrial-1).RewardVolume = O(iTrial).addvals(rlix);   
    O(iTrial-1).BudgetVolume = O(iTrial).addvals(blix);
    O(iTrial-1).Win = O(iTrial).addvals(rlix)>0;
end

for iTrial = 1:length(O)
    O(iTrial).duration = durations_ms(iTrial);
    for iB = 1:length(O(iTrial).bit)
        btu = O(iTrial).bit(iB).upat;
        btd = O(iTrial).bit(iB).downat;
        if isempty(btu)
            btu = NaN;
            btd = NaN;
        end
        
        O(iTrial).([bit_names{iB},'Up']) = btu; %this is in a cell because there can be multiple free rewards in one trial
        O(iTrial).([bit_names{iB},'Dwn']) = btd; %this is in a cell because there can be multiple free rewards in one trial
    end
end


gdflds = fields(O);
clix = strfind(gdflds,'Clust');
nclix = cellfun(@isempty,clix);
drix = strfind(gdflds,'duration');
ndrix = cellfun(@isempty,drix);
sitix = strfind(gdflds,'situation');
nsitix = cellfun(@isempty,sitix);
notix = ones(length(gdflds),1);
notix(~ndrix) = 0;notix(~nclix) = 0; notix(~nsitix) = 0;
notix = logical(notix);
fieldorder = [gdflds(~nsitix);gdflds(~ndrix);gdflds(~nclix);gdflds(notix)];
O = orderfields(O,fieldorder);

O = O(1:end-1); %last trial ommitted 
%%
bxFile = ls([pth,'*BX_*']);
load([pth,bxFile]);
% DTmb = floor([dtTBL.monkey_bid]*100);
% DTmb(isnan(DTmb))=-1;
% DTtn = [dtTBL.trial_number];
% DTtnmb = [DTtn,DTmb];
% 
% Otn = double([O.TrialNumber]');
% Omb = double([O.MonkeyBid]');
% Otnmb = [Otn,Omb];

eightbitix = find([O.TrialNumber]==255);
ebd = length(O)-eightbitix;
for i=1:ebd
    O(eightbitix+i).TrialNumber = [O(eightbitix+i).TrialNumber]+256; % can only send 8 bit advals so now we have to guess that all the trials > 255 were actually greater than 255 ...so dumb
end
% Rob sucks and didn't put a unique code in (like I told him to)...so I had to waste A LOT of
% time matching the trials up. 
dtTBLvn = dtTBL.Properties.VariableNames;
for i = 1:length(O)
    tnix=[];tnixix = [];
    tnix = find([dtTBL.trial_number]==O(i).TrialNumber);   
    cb = floor(dtTBL.computer_bid(tnix)*100);
    CB = O(i).ComputerBid;
    cb(isnan(cb))=0;
    CB(CB==99&cb==100)=100;   
    if numel(tnix)>1        
        tnixix = cb==CB;   
        ct=0;
        while sum(tnixix)>1
            ntnix = tnix+ct;
            mb = floor(dtTBL.monkey_bid(ntnix)*100);
            MB = O(i+ct).MonkeyBid;
            mb(isnan(mb))=0;
            MB(MB==99&mb==100)=100;
            tnixix = mb==MB;
            ct=ct+1;
        end
        tnix = tnix(tnixix);
        cb = cb(tnixix);
    end
    for ii = 1:width(dtTBL)      
        if ~isempty(tnix) && cb==CB
            O(i).(dtTBLvn{ii})=dtTBL.(dtTBLvn{ii})(tnix);  
        else
            O(i).(dtTBLvn{ii})=nan;
        end
        if isempty(cb)
            cb=0;
        end           
        cb_all(i,1) = double(cb);
        CB_all(i,1) = double(CB);
    end
end
ncb = floor(double([O(i).computer_bid])*100);
nCB = double([O(i).ComputerBid]);
for i = 1:length(O)
    O(i).matchy = ncb==nCB;
end
matchy = length(O)==sum(CB_all==cb_all);
if~matchy
    warning('no mathcy')
    CB_all(CB_all==0)= NaN;
    disp(sum(CB_all==cb_all));disp(sum(ismember(double([O.situation]),1:3)))
end

%%

%     case 'RealTime'
%         % put data in real time format (a data point for every sample of a trial)
%         time = [];
%         dur = [O.duration];
%         t = length(time);
%         tt = 1:dur;
%         RealTimeData.time_ms(t+1:t+dur) = tt;
%         RealTimeData.spike_times_ms = [];
%
%         findgroups(O.addvals)
%
%         M(iM).spike_time_ms = 1;
% end