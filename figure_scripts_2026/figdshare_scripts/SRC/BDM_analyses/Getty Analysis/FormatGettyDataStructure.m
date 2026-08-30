function [DataStruct,path] = FormatGettyDataStructure(file_location_and_name, bit_names, format_spec, addval_names)


if nargin < 1
    %     [fl,pth] = uigetfile('C:\Users\dfhil\Dropbox\Schultz_Lab\Uly_Data\*.mat');
    [fl,pth] = uigetfile('D:\Dropbox\Schultz_Lab\Uly_Data\*.mat');
    file_location_and_name = [pth,fl];
end
path = pth;

if nargin < 2
    % these must be entered in the order of bit number 0 to 15.
    bit_names = {'TrialOnset' 'FixationCross' 'FractalDisplay' 'BidStart' 'BidStable' 'WinLose' 'RewardEpochEnd' ...
        'ButdgetEpochEnd' 'FreeReward' 'RewardTap' 'BudgetTap' 'ThirdTap' 'TrialEnd' 'Error'};
end

if nargin < 3
    format_spec = 'SpikeTime'; % options are 'Strct', 'SpikeTime', and 'RealTime'
end

if nargin < 4
    addval_names = {'NumberAddVals','TrialNumberXL','TrialNumber', 'GettySetDuration1','GettySetDuration2', 'Situation',...
        'Task','SubTask','FractalValue', 'BudgetMagnitude', 'TrialStartBid','ComputerBid','PrevTrial_BudgetLiquid',...
        'PrevTrial_BudgetTotal','PrevTrial_ComputerBid','PrevTrial_Correct','PrevTrial_FreeReward','PrevTrial_MonkeyBid',...
        'PrevTrial_RewardProb','PrevTrial_RewardLiquid','PrevTrial_RewardMagnitude'};
end

%%
% file_location_and_name = 'C:\Users\dfhil\Dropbox\Schultz_Lab\Uly_Data\M75_ses077\w075-0077.mat';
% file_location_and_name = 'D:\Dropbox\Schultz_Lab\Uly_Data\M75_ses077\w075-0077.mat';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RADdur = [pth,'r',fl(2:end-4),'.radDURATION'];
durations_ms = GETTYANALYSIS_Get_RAD_Trial_Durations(RADdur);
%   t_start = [0 cumsum(durations)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GD = load(file_location_and_name);
fld = fieldnames(GD);
GDstruct = GD.(fld{1}); %this is the structure that comes from justopenfile.m

fld_nams = fields(GDstruct.trial);
notclstix = cellfun(@isempty,(strfind(fld_nams,'clust')));

O = GDstruct.trial;
switch format_spec
    case 'Strct'
        % put data in structure without all the fluff
        flds = {'data', 'emg', 'analogfrequency','numberchannels','timefirstanalog','analog','bit'};
        DataStruct = rmfield(O,flds);
        
        for iTrial = 1:length(O)
            for iB = 1:length(O(iTrial).bit)
                btu = O(iTrial).bit(iB).upat;
                btd = O(iTrial).bit(iB).downat;
                if isempty(btu)
                    btu = NaN;
                    btd = NaN;
                    % % %                 elseif numel(bt)>1 % this is a crude workaround for the cross-talk across bits. We have to solve this on the front end. This could really screw things up.
                    % % %                     warning('There are two values for one bit. THIS IS NOT GOOD!!!')
                    % % %                     disp(iD)
                    % % %                     disp(O(iD).bit(iB).upat)
                    % % %                     bt = bt(2);
                end
                DataStruct(iTrial).UpBits{iB} = btu; %this is in a cell because there can be multiple free rewards in one trial
                DataStruct(iTrial).DwnBits{iB} = btd; %this is in a cell because there can be multiple free rewards in one trial
                DataStruct(iTrial).BitNames{iB} = bit_names{iB};
                %                 DataStruct(iD).(['BitUp',bit_names{iB},num2str(iB)])= O(iD).bit{iB}.upat;
                %                 DataStruct(iD).(['BitDwn',bit_names{iB},num2str(iB)])= O(iD).bit{iB}.downat;
            end
        end
    case 'SpikeTime'
        % put data in spike time format (one row per spike time)
        %%
        n_s = cellfun(@numel,{O.neuron});  % number of spikes per trial--dictates number of rows in final output structure.
        addvals = {O.addvals};
        sit = [O.situation];
%         dur = [O.duration];
%         cdur = cumsum([O.duration]);
        
        dur = durations_ms;
        cdur = cumsum(durations_ms);
        
        for i = 1:length(n_s)-1  % ignor the last trial--addvals always sent on subsequent trial so no use in analyzing this.
            if n_s(i)~=0
                TrNum{i} = repelem(i,n_s(i));
                Sit{i} = repelem(sit(i),n_s(i));
                cDur {i} = repelem(cdur(i),n_s(i));
                Dur {i} = repelem(dur(i),n_s(i));
                if i==1
                    dr = 0;
                else
                    dr = cdur(i-1);
                end
                spks{i} =  O(i).neuron+dr;
                MBid{i} =  repelem(O(i+1).addvals(18),n_s(i)); % this is i+1 because addvals 13-21 are from the previous trial
                CBid{i} =  repelem(O(i+1).addvals(15),n_s(i));
                Win{i} =  repelem(O(i+1).addvals(18)>O(i+1).addvals(15),n_s(i));
                RewLiq{i} =  repelem(O(i+1).addvals(20),n_s(i));
                BudgLiq{i} =  repelem(O(i+1).addvals(13),n_s(i));
                BudgMag{i} =  repelem(O(i+1).addvals(14),n_s(i));
            else
                TrNum{i}=i;
                Sit{i} = sit(i);
                cDur {i} = cdur(i);
                Dur {i} = dur(i);
                spks{i} = NaN;
                MBid{i} =  O(i+1).addvals(18); % this is i+1 because addvals 13-21 are from the previous trial
                CBid{i} =  O(i+1).addvals(15);
                Win{i} =  O(i+1).addvals(18)>O(i+1).addvals(15);
                RewLiq{i} =  O(i+1).addvals(20);
                BudgLiq{i} =  O(i+1).addvals(13);
                BudgMag{i} =  O(i+1).addvals(14);
            end
        end
        ST_fnames = {'TrialNumber' 'Situation' 'CumSumDuration' 'Duration' 'SpikeTimesMs' 'MonkeyBid' ...
            'CompBid' 'Win' 'RewardLiquid' 'BudgetLiquid' 'BudgetMagnitude'};
        ST(:,1) = [double([TrNum{:}])]';
        ST(:,2) = [double([Sit{:}])]';
        ST(:,3) = [double([cDur{:}])]';
        ST(:,4) = [double([Dur{:}])]';
        ST(:,5) = [double([spks{:}])]';
        ST(:,6) = [double([MBid{:}])]';
        ST(:,7) = [double([CBid{:}])]';
        ST(:,8) = [double([Win{:}])]';
        ST(:,9) = [double([RewLiq{:}])]';
        ST(:,10) = [double([BudgLiq{:}])]';
        ST(:,11) = [double([BudgMag{:}])]';
        
        find(isnan(ST))
        
        STT  = array2table(ST,'VariableNames',ST_fnames);
        STS = table2struct(STT);
        
        % allocate empty spots for the bit data
        for iB = 1:length(O(1).bit)
            STS(length(STS)).([bit_names{iB},'Up'])= [];%double.empty(length(ST),0);
            STS(length(STS)).([bit_names{iB},'Dwn'])= [];
        end
        
        
        %%
        ctr = 0;
        ct = 0;
        for iTrial = 1:length(O)-1
            
            if iTrial==1
                dr = 0;
            else
                dr = cdur(iTrial-1);
            end
            for iB = 1:length(O(iTrial).bit)
                btu = double(O(iTrial).bit(iB).upat)+dr;
                btd = double(O(iTrial).bit(iB).downat)+dr;
                if ~isempty(btu)
                    for iBB = 1:length(btu)
                        if isempty(min(find(ST(:,5)>btu(iBB),1,'first')))||isempty(min(find(ST(:,5)>btd(iBB),1,'first')))
                            btuix(iBB) = find(ST(:,1)==iTrial,1,'last');
                            btdix(iBB) = find(ST(:,1)==iTrial,1,'last');
                        else
                            btuix(iBB) = min(find(ST(:,5)>btu(iBB),1,'first'),find(ST(:,1)==iTrial,1,'last'));
                            btdix(iBB) = min(find(ST(:,5)>btd(iBB),1,'first'),find(ST(:,1)==iTrial,1,'last'));
                        end
                        
                        if iTrial~=1 && ~isempty(STS(btuix(iBB)).([bit_names{iB},'Up']))&& sum(ST(:,1)==iTrial)>=numel(iBB)
                            STS(btuix(iBB)+1).([bit_names{iB},'Up'])= btu(iBB);
                            STS(btdix(iBB)+1).([bit_names{iB},'Dwn'])= btd(iBB);
                            if STS(btuix(iBB)).TrialNumber ~=STS(btuix(iBB)-1).TrialNumber
                                error(sprintf('There was more than 1 occurence of bit %s during trial %g and this stupid code has iterated it into the next trial in the structure...I will find a way to fix this is and when it happens',([bit_names{iB},'Up']),iTrial));
                            end
                            ct = 1;
                        elseif sum(ST(:,1)==iTrial)< numel(iBB)%test whether
                            error('cannot format data this way')
                            %                         elseif ~isempty(STS(btuix(iBB)).([bit_names{iB},'Up']))&&~isempty(STS(btuix(iBB)+1).([bit_names{iB},'Up']))
                            %                             warning('double yikes')
                        end
                        STS(btuix(iBB)).([bit_names{iB},'Up'])= btu(iBB);
                        STS(btdix(iBB)).([bit_names{iB},'Dwn'])= btd(iBB);
                    end
                end
            end
            if ct==1
                ctr = ctr+1;
            end
            ct = 0;
        end
        fprintf('iterated to next index %g times',ctr)
        DataStruct = STS;
        
        % % %use this if you want to change DataStruct to a matrix
        %         DT = struct2table(DataStruct);
        %         DM = table2array(DT);
        %         names = fieldnames(DataStruct);
        
        %
        %     case 'RealTime'
        %         % put data in real time format (a data point for every ms of a trial)
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
end
