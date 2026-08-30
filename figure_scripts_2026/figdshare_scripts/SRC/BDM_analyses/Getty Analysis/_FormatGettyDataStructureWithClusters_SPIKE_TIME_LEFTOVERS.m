%% this was code that was in 'FormatGettyDataStructureWithClusters'

% it was removed because it would be really tricky to put everything in
% 'spike time' (one row per spike) when there are multiple clusters. 


case 'SpikeTime'
        % put data in spike time format (one row per spike time)
        %%
        if clust_exist
            fn = fieldnames(O);
            clstix = find(~cellfun(@isempty,strfind(fn,'Clust')));
            for iC = 1:length(clstix)
                clst_sums(iC) = sum(cellfun(@numel,{O.(fn{clstix(iC)})}));
            end
            [~,most_spks] = max(clst_sums);            
            n_s = cellfun(@numel,{O.(fn{clstix(most_spks)})});            
        else
            n_s = cellfun(@numel,{O.neuron});  % number of spikes per trial--dictates number of rows in final output structure.
        end
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

        
        %% put spike times from other clusters in the right spots with reference to largest cluster
        
            % allocate empty spots for the clust data
        for iB = 1:length(O(1).bit)
            STS(length(STS)).([bit_names{iB},'Up'])= [];%double.empty(length(ST),0);
        end
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
        
        %% put bit times in the right spots with reference to spike times
        ST(:,6) = [double([MBid{:}])]';
        ST(:,7) = [double([CBid{:}])]';
        ST(:,8) = [double([Win{:}])]';
        ST(:,9) = [double([RewLiq{:}])]';
        ST(:,10) = [double([BudgLiq{:}])]';
        ST(:,11) = [double([BudgMag{:}])]';
        
%         find(isnan(ST))
        
        STT  = array2table(ST,'VariableNames',ST_fnames);
        STS = table2struct(STT);
        
        % allocate empty spots for the bit data
        for iB = 1:length(O(1).bit)
            STS(length(STS)).([bit_names{iB},'Up'])= [];%double.empty(length(ST),0);
            STS(length(STS)).([bit_names{iB},'Dwn'])= [];
        end
        
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