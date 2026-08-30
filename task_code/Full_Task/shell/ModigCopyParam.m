function cb = ModigCopyParam(space1,space2)
% cb = ModigCopyParam(space1,space2)
% 
% Copy task parameters from space 1 to space 2
% space1, space2 can be: 'WorkSpace' (Current work space memory), 
%   'current_param', 'default_param','file'
% parameters in 'WorkSpace' is used for current control of behavioral task.
% parameters in 'current_param' is read when the task is changed from 
%   previous one to the current one.
% parameters in 'default_param' is read if there is no parameter saved as 'current_param'.
% cb, ptr of success on function evaluation (1) or not (0)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% coded by skoba (skoba-tky@umin.ac.jp) 8 June 2005
% last modified by skoba 4 Oct 2005
% RBM   3.5.07 returns to Modig directory after looking for a loaded file
%       6.08 warning strings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global UserInfo TaskOp ModigDir
cb = 1;
switch space1
    case 'WorkSpace' 
        ModigUpdateMenuPos;
        % put each param in work space into a structure 'SavedParam'
        TF = 1;
        for ii = UserInfo.save_list
            [temp_TF ginfo] = isglobal_sk(cell2mat(ii));
            TH = temp_TF *TF;
            str = 'global item';
            str = strcat(str(1:8),cell2mat(ii)); 
            str(8) = [];           
            eval(str);                           % retrieve global
            eval(strcat('SavedParam.',cell2mat(ii),'=',cell2mat(ii),';')); % copy stored data into global
        end
        if TF ==1
            cb = Save_SavedParam(space2,SavedParam);
        else
            cb = 0;
        end
    case 'default_param'
        % load default_param
        field_name = strcat('default_param.',TaskOp.prj,'.SavedParam');
        [TH VALUE EMPTY] = isfield_sk(UserInfo,field_name);
        if TH
            eval(strcat('SavedParam = UserInfo.default_param.',TaskOp.prj,'.SavedParam;'));
            cb = Save_SavedParam(space2,SavedParam);
        else
            warning('UserInfo.default_param.(TaskOp.prj).SavedParam not present');
            cb = 0;
        end
    case 'current_param'
        % load current_param
        field_name = strcat('current_param.',TaskOp.prj,'.SavedParam');
        [TH VALUE EMPTY] = isfield_sk(UserInfo,field_name);
        if TH
            eval(strcat('SavedParam = UserInfo.current_param.',TaskOp.prj,'.SavedParam;'));
            cb = Save_SavedParam(space2,SavedParam);
        else
            warning('UserInfo.current_param.(TaskOp.prj).SavedParam not present');            
            cb = 0;
        end        
    case 'file'
        curDir = cd;
        prj_dir = strcat(ModigDir.Projects,'\',TaskOp.prj,'\param');
        if isdir(prj_dir)
            cd(prj_dir)
            filename_filter = strcat('par_',TaskOp.prj,'_','*.mat');
            [filename, pathname, filterindex] = uigetfile(filename_filter,...
                'select a parameter file');
            if filename ~= 0
                load_filename = strcat(pathname,'/',filename);
                load(load_filename);
                cb = Save_SavedParam(space2,SavedParam);
            else
                % user pressed cancel
                cb = 0;
            end
            % return to work directory
            cd (curDir)
        else
            warning('couldn''t find %s',prj_dir)
            cb = 0;
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb = Save_SavedParam(space2,SavedParam)

global UserInfo TaskOp ModigDir
cb = 1;
switch space2
    case 'current_param'  
        % copy parameters in work space memory into UserInfo.current_param
        eval(strcat('UserInfo.current_param.',TaskOp.prj,'.SavedParam = SavedParam;'));
    case 'default_param'
        eval(strcat('UserInfo.default_param.',TaskOp.prj,'.SavedParam = SavedParam;'));
    case 'file'
        param_dir = strcat(ModigDir.Projects,'/',TaskOp.prj,'/param');
        temp_save_filename = strcat('par_',TaskOp.prj,'_',UserInfo.username,'_',date,'.mat');
        if exist(param_dir,'dir')
            cd(param_dir)
            [filename, pathname] = uiputfile(temp_save_filename, ...
                'Save prj param as');
            if filename ~= 0       % if dialog box is not cancelled
                save_filename = strcat(pathname,'/',filename);
                save(save_filename,'SavedParam');
            else
                cb = 0;
            end
        end
    case 'WorkSpace'
        items = fields(SavedParam)';
        for ii = items
            eval(['global ', cell2mat(ii)]);        
            % copy stored data into global
            eval(strcat(cell2mat(ii),'=SavedParam.',cell2mat(ii),';')); 
        end
end