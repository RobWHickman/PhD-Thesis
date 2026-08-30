function ModigLog(option)
% ModigLog(option)
%
% A collection of subroutines to log trial conditions into a file
% A log file is made in "modig\log" directry.
% by the name of "LOG-yyyy-mm-dd.xls". (tab separated text format)
% option: 
%     open_file           : open a log file. If it does not exist, create one
%     close_file          : close a log file
%     print_basic_header  : print out a header for common log items
%     print_basic_log     : print out data for common log items
%     print_prj_header    : print out a header for project specific log items
%     print_prj_log       : print out data for project specific log items

% SK wrote it,

% NOTE, check output!

global ModigDir TaskOp UserInfo

switch option
    case 'open_file'
        TaskOp.log.filename = strcat('LOG-',datestr(now,29),'.xls');% (ISO 8601 date format is used to name a log file)
        TaskOp.log.fullname = strcat(ModigDir.Log,'/',TaskOp.log.filename);
        if ~exist(TaskOp.log.fullname,'file')
            TaskOp.log.prj = '';
        end
        TaskOp.log.handle = fopen(TaskOp.log.fullname,'a');
    case 'close_file'
        [TH handle Empty] = isfield_sk(TaskOp,'log.handle');
        if ~Empty
            fclose(handle);
            TaskOp.log.filename = [];
            TaskOp.log.fullname = [];
            TaskOp.log.handle = [];
        end
    case 'print_basic_header',% print basic header on a file.
        [TF LOG_PRJ EMPTYprj] =isfield_sk(TaskOp,'log.prj');
        if EMPTYprj
           LOG_PRJ = ' '; % This is the case at the very first trial
           % FIXME, struct field assignment overwrites a double
           TaskOp.log.prj = ' ';
        end
        if ~strcmp(TaskOp.prj,LOG_PRJ) % prj changed from the previous trial. so, print header for the new prj
            [TH header Empty] = isfield_sk(TaskOp,'log.basic_header');
            if ~Empty
                ModigLog('open_file');
                fprintf(TaskOp.log.handle,'header\t'); % print 'header'
                for hh = 1:size(header,2)
                    str = cell2mat(header(hh));
                    if ischar(str)
                        fprintf(TaskOp.log.handle,'%s\t',str);
                    else
                        fprintf(TaskOp.log.handle,'%s\t');
                    end
                end
                ModigLog('close_file');
            end
        end
    case 'print_basic_log',
        [TH header Empty] = isfield_sk(TaskOp,'log.basic_header');
        if ~Empty
            ModigLog('open_file');
            fprintf(TaskOp.log.handle,'data\t'); % print 'data'
            for hh = 1:size(header,2)
                str = cell2mat(header(hh));
                switch str
                    case 'subject'
                        [TH animal_ID Empty] = isfield_sk(UserInfo,'animal_ID');
                        if ~Empty
                            fprintf(TaskOp.log.handle,'%s\t',num2str(animal_ID));
                        else
                            fprintf(TaskOp.log.handle,'%s\t');
                        end
                    case 'project'
                        [TH prj Empty] = isfield_sk(TaskOp,'prj');
                        if ~Empty
                            fprintf(TaskOp.log.handle,'%s\t',prj);
                        else
                            fprintf(TaskOp.log.handle,'%s\t');
                        end
                    case 'recorded'
                        [TH gettycom Empty] = isfield_sk(TaskOp,'EvntHist.gettycom');
                        if ~Empty
                            fprintf(TaskOp.log.handle,'%s\t',num2str(gettycom));
                        else
                            fprintf(TaskOp.log.handle,'%s\t');
                        end
                    case 'day total count'
                        [TH day_total Empty] = isfield_sk(TaskOp,'count.day_total');
                        if ~Empty
                            fprintf(TaskOp.log.handle,'%s\t',num2str(day_total));
                        else
                            fprintf(TaskOp.log.handle,'%s\t');
                        end
                    case 'block total count'
                        [TH block_total Empty] = isfield_sk(TaskOp,'count.block_total');
                        if ~Empty
                            fprintf(TaskOp.log.handle,'%s\t',num2str(block_total));
                        else
                            fprintf(TaskOp.log.handle,'%s\t');
                        end
                    case 'time start'
                        [TH block_total Empty] = isfield_sk(TaskOp,'count.block_total');
                        if ~Empty
                            fprintf(TaskOp.log.handle,'%s\t',datestr(TaskOp.EvntHist.cur_trial_start_time,'HH:MM:SS'));
                        else
                            fprintf(TaskOp.log.handle,'%s\t');
                        end
                    case 'shuffle'
                        [TH shuffle Empty] = isfield_sk(TaskOp,'Trial.just_shuffled');
                        if ~Empty
                            fprintf(TaskOp.log.handle,'%s\t',num2str(shuffle));
                        else
                            fprintf(TaskOp.log.handle,'%s\t');
                        end
                    otherwise
                        fprintf(TaskOp.log.handle,'%s\t');
                end
            end
            ModigLog('close_file');
        end
    case 'print_prj_header' % print project specific header on a file
        if ~strcmp(TaskOp.prj,TaskOp.log.prj)
            command_filename = strcat('ModigLog_',TaskOp.prj);
            if exist(command_filename, 'file')
                str = strcat(command_filename,'(','''','print_prj_header','''',')');
                eval(str);
            else
                ModigLog('open_file');
                fprintf(TaskOp.log.handle,'\n');
                ModigLog('close_file');
            end
        end
    case 'print_prj_log' % print project specific header on a file
        command_filename = strcat('ModigLog_',TaskOp.prj);
        if exist(command_filename, 'file')
            str = strcat(command_filename,'(','''','print_prj_log','''',')');
            eval(str);
        else
            ModigLog('open_file');
            fprintf(TaskOp.log.handle,'\n');
            ModigLog('close_file');
        end        
end