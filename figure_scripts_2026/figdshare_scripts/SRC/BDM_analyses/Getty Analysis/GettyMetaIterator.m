function RES = GettyMetaIterator(Analysis_function)

db = DropboxDir;

sits = [1:3];
sitnam = ['_sits_',num2str(sits)];
% % 
top_dir = [db,'Schultz_Lab\BDM_Data\Vicer_data\'];
savnam = ['Vic_cells',sitnam];

% top_dir = [db,'Schultz_Lab\BDM_Data\Uly_Data\'];
% savnam = ['Uly_cells',sitnam];

if isempty(top_dir)
    error('none of the directories listed were found on this computer')
end

dr = dir([top_dir,'*M7*']);
folder_names = {dr.name};

Func_ID = func2str(Analysis_function);

RES = [];
for iF = 1:length(folder_names)
    disp(iF);
    dfdir = ls([top_dir,folder_names{iF},'\*w07*.mat']);
    dnix = contains(string(dfdir),'wavemark')|contains(string(dfdir),'Cluster')|contains(string(dfdir),'old');
    datafile = dfdir(~dnix,:);
    for id = 1:length(datafile(:,1))
        df = datafile(id,:);
        dfns = df(~isspace(df));
        
        data_file_path_name = [top_dir,folder_names{iF},'\',dfns];
        situations = sits;
        
%         bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
%             'WinLoseUp' 'RewardTapUp' 'BudgetTapUp' };

        bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' ...
            'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp' }; %'TrialOnsetUp' 

        
        trials = 'all';
        win_lose_both = 'both';%%%%win lose both
        tic
        result = Analysis_function(data_file_path_name,situations,bits,trials,win_lose_both);
        toc
        for ir = 1:length(result)
            result(ir).day = folder_names{iF};
        end
        
        %     if isstruct(result) && ~isfield(result,'RewardTapUp')
        %         for i=1:length(result)
        %             result(i).RewardTapUp = NaN;
        %         end
        %         c = [bits,'day'];
        %         result = orderfields(result,c);
        %     end
        %     BXfile = ['C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Uly_Data\ANALYSIS_',...
        %         date,'_RemoveNS\GettyBXPredictBidsRegression\BX.mat'];
        %     if exist(BXfile,'file')
        %         load(BXfile)
        %     end
        [Rr,Rc] = size(RES);
        [rr,rc] = size(result);
        if iF ==1
            RES = result;
        elseif Rr==rr
            RES = [RES,result];
        else
            RES = [RES;result];
        end
        %     savnam = 'BX';
        if ~isempty(RES)
            %         npth = We_want_dir_funk([top_dir,'\ANALYSIS_',date,'_RemoveNS\',Func_ID]);
            npth = We_want_dir_funk([top_dir,'\ANALYSIS_',date,'\',Func_ID]);
            save([npth,'\',savnam],'RES','-v7.3');
        end
    end
end
% if isnumeric(trials)
%     savnam = [win_lose_both,'_',num2str(situations),'_',num2str(trials)];
% else
%     savnam = [win_lose_both,'_',num2str(situations),'_all_trials'];
% end
% if ~isempty(RES)
%     npth = We_want_dir_funk([top_dir,'\ANALYSIS_',date,'_RemoveNS\',Func_ID]);
%     save([npth,'\',savnam],'RES');
% end
disp('------------------ Finished ------------------')


% 
% comps = {'D:\Dropbox\Schultz_Lab\BDM_Data\Uly_Data\',...
%     'C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Uly_Data\',...
%     'C:\Users\DHill\Dropbox\Schultz_Lab\BDM_Data\Uly_Data\'};
% 
% top_dir = [];
% for iD = 1:length(comps)
%     if isfolder(comps{iD})
%         top_dir = comps{iD};
%     end
% end
