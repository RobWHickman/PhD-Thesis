function ModigCommand(option)
% Collection of callback subroutines for commands from ModigMainMenu
%
% This function is pretty much the core of Modig, where all the in-trial 
%   functions are called.     
%
% See Also MODIGMAINMENU
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% coded by skoba (skoba-tky@umin.ac.jp) 8 June 2005
% last modified by skoba 4 Oct 2005
% RBM 30.04.07 included if-else on Juice for debugging (w/o lab
%       connection), on exit close PTB. Debugging message @ 'exit'
%     05.07    modifications for DIO with hand sensor
% rbm 09.07    flip, 'cla', and stopping timers/daq upon stop session
% rbm 11.07    /reset_day updates new MoMaMe/prjArea
%      6.08  added handshake enable-disable  
% CRvC 07.13 Added to 'Log' for ModigLog
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global MENUs TaskOp breaksession inside_session ModigDir
global Timers UserInfo ExtDevice VisParam IO Tbl ModigLog
            
switch option
    case 'start_button',
        button_val=get(MENUs.ModigMainMenu.handles.CNTR_PUSH_START,'value');
        start(ExtDevice.aiObject);
        % If we are connected, we start our DAQ
        if UserInfo.lab_connection,
            % do we need to start dio?
            if IO.Input.hand.monitor == 1 && strcmp(IO.Input.hand.tracking_method, 'daq')...
                    && strcmp(ExtDevice.inputDio.Running,'Off')
                    start(ExtDevice.inputDio)
            end

            if IO.Input.eye.monitor == 1 && ~strcmp(IO.Input.eye.tracking_method, 'mouse')...
                    && strcmp(ExtDevice.aiObject.Running,'Off')            
                start(ExtDevice.aiObject)
            end
        end
        
        switch button_val
            case 1 % start a trial
                % Update ModigMainMenu GUI
                set(MENUs.ModigMainMenu.handles.CNTR_PUSH_START,'string',...
                    'RUNNING');
                set(MENUs.ModigMainMenu.handles.CNTR_PUSH_START,...
                    'BackgroundColor', [1 0 0]);
                ModigCommand('start_trial');
            case 0
                p = Priority;
                if p == 0,
                    breaksession = 1;
                    % start button cannot be pulled manually, so we pull it
                    set(MENUs.ModigMainMenu.handles.CNTR_PUSH_START,'value',1); 
                end
                ModigCommand stop_session
        end
    case {'start_trial','start'}
        if ~inside_session
            if ~isempty(timerfind)
                stop(timerfind);
            end
            breaksession = 0;
            
            switch IO.Input.eye.tracking_method,
            % if eye tracking is via mouse (emulation/debugging), set mouse
            % in the center of principal screen
                case 'mouse'
                    SetMouse( VisParam.scr_center_x, VisParam.scr_center_y);
                case 'eye scan'
            % verify that if we are not connected, e.g. debugging, we don't
            % look for eye signals
                    if UserInfo.lab_connection == 0,
                        IO.Input.eye.tracking_method  = 'mouse';
                        IO.Input.hand.tracking_method = 'key';
                    end
            end
            ModigMessage('m&c','session started...',1);
            ModigTaskLoop;
        end
    case 'stop_session',
        % let us use the cmd line
        ListenChar(0);
        % stop timers
        tims =timerfind;
        if ~isempty(tims)
            tims.Running;
            stop(tims);
        end
        breaksession = 1;
        
        % flip to black bkg to clear the backbuffer and visual display
        if UserInfo.use_split,
            for i = 1:size(VisParam.scr_holder,2)
                Screen('FillRect', VisParam.scr_holder(i), 0, VisParam.scr_rect_holder(i,:));
                Screen('Flip', VisParam.scr_holder(i));
                Screen('FillRect', VisParam.scr_holder(i), 0, VisParam.scr_rect_holder(i,:));
                Screen('Flip', VisParam.scr_holder(i)); 
            end
        else
            Screen('FillRect', VisParam.scr_handle, [0, 0, 0], VisParam.scr_rect);
            Screen('Flip', VisParam.scr_handle);
        end

        % change the "state" of main menu
        set(MENUs.ModigMainMenu.handles.CNTR_PUSH_START,'value',0);
        set(MENUs.ModigMainMenu.handles.CNTR_PUSH_START,'string',' START');
        set(MENUs.ModigMainMenu.handles.CNTR_PUSH_START,'BackgroundColor', [0.8 0.8 0.8]);
        set(MENUs.ModigMainMenu.handles.CNTR_PUSH_START,'ForegroundColor', [0 0 0]);
        
        set(MENUs.ModigMainMenu.handles.CNTR_PUSH_REMEDY,'BackgroundColor',[0.12 0.7 0.4]);
        
        % used this for the double monitor version /not used at the moment/
       curMon = Tbl.MenuTbl{1}; 
       curActHdl = 'MONITOR_AXIS';
        
       % clear monitor handles
       delete(get(MENUs.(curMon).handles.(curActHdl),'children'))
       TaskOp.repeatError = 0; % in case the last trial of the session is an error
        
         % we stop our DIO and AI objects if they exist and running
        if UserInfo.lab_connection 
            if isrunning(ExtDevice.inputDio)
                % DEBUG tool
%                 disp(sprintf('MoMoBe is... %s',Timers.Input.behavior_monitor.running))
                WaitSecs(0.020);
                stop(ExtDevice.inputDio)
            end    
            if isrunning(ExtDevice.aiObject)
                stop(ExtDevice.aiObject)
            end 
            putvalue(ExtDevice.outputDio,0); % reset to 0
        end
        % give the mouse back
        ShowCursor;
        ModigMessage('c','session stopped...',8);
        % disable touch screen
%         if isfield(IO.Input,'use_touch_screen') && IO.Input.use_touch_screen==1
%               runED('d',1);
%         end
        
    case 'task_choice',
        if ~inside_session
            availPrj = get(MENUs.ModigMainMenu.handles.CNTR_LIST_TASK,'string'); % <0.001
            thisPrj  = availPrj(get(MENUs.ModigMainMenu.handles.CNTR_LIST_TASK,'value'));
            ModigChangeTask(cell2mat(thisPrj));
        end
    case 'juice',
        if UserInfo.lab_connection 
            [a, jtimer EMPTY] = isfield_sk(Timers,'Output.free_juice');clear a
            if ~EMPTY    
                    if strcmp(jtimer.Running,'off')
                        start(jtimer);
                        tf=Timers.Output.free_juice.TimerFcn;
                        f=strfind(tf,')');
                        s=strfind(tf,'(');
                        time = tf(s+1:f-1);
                        ModigMessage('m',['Free Juice: ' time ' s'],8);
                    end
            else
                ModigMessage('m&c','free juice timer not defined',8);    
            end
            % update MoMaMe
            TaskOp.count.day_rew = TaskOp.count.day_rew + 1;
            set(MENUs.ModigMainMenu.handles.day_rew,'String',...
                TaskOp.count.day_rew);
        else
            ModigMessage('m','No lab connection = No juice',8);
        end
    case 'check_num_trials'
        button_val = get(MENUs.ModigMainMenu.handles.CNTR_CHECK_FIXED_TRIALS,'value');
        switch button_val
            case 1 % fixed number of trials
                set(MENUs.ModigMainMenu.handles.CNTR_EDIT_NUM_TRIALS,'visible','on');
                set(MENUs.ModigMainMenu.handles.CNTR_TEXT_NUM_TRIALS,'visible','on');
                set(MENUs.ModigMainMenu.handles.CNTR_TEXT_REMAINING_TRIALS,'visible','on');
                TaskOp.running_mode = 'fixed_num_trials';
            case 0 % endless loop 
                set(MENUs.ModigMainMenu.handles.CNTR_EDIT_NUM_TRIALS,       'visible','off');
                set(MENUs.ModigMainMenu.handles.CNTR_TEXT_NUM_TRIALS,       'visible','off');
                set(MENUs.ModigMainMenu.handles.CNTR_TEXT_REMAINING_TRIALS, 'visible','off');
                TaskOp.running_mode = 'infinite';
        end
    case 'set_num_trials'
        GUI_value=get_GUI_value(MENUs.ModigMainMenu.handles.CNTR_EDIT_NUM_TRIALS);
        if ~isempty(GUI_value.numerical)
            TaskOp.count.set_total=floor(GUI_value.numerical);
            TaskOp.count.set_remaining=floor(GUI_value.numerical);
            set(MENUs.ModigMainMenu.handles.CNTR_TEXT_REMAINING_TRIALS,'string',num2str(TaskOp.count.set_remaining));
        else
            % TODO: it should correct the values!
            errordlg('inappropriate input!'); 
            set(MENUs.ModigMainMenu.handles.CNTR_EDIT_NUM_TRIALS,'string','');
            set(MENUs.ModigMainMenu.handles.CNTR_TEXT_REMAINING_TRIALS,'string','');
            return
        end
    case 'reset_block'
        if ~inside_session
            set_GUI_value(MENUs.ModigMainMenu.handles.CNTR_TEXT_BLOCK_TOTAL,    'String','0');
            set_GUI_value(MENUs.ModigMainMenu.handles.CNTR_TEXT_BLOCK_CORRECT,  'String','0');
            set_GUI_value(MENUs.ModigMainMenu.handles.CNTR_TEXT_BLOCK_ERROR,    'String','0');
            set_GUI_value(MENUs.ModigMainMenu.handles.CNTR_TEXT_BLOCK_PERCENT,  'String','0');
            TaskOp.count.block_total = 0;
            TaskOp.count.block_correct = 0;
            TaskOp.count.block_error = 0;
            TaskOp.count.block_ignored  = 0;
            TaskOp.count.block_rew      = 0;
            TaskOp.count.block_noRew    = 0;
            set(MENUs.ModigMainMenu.handles.block_ignored,'string',0)
            set(MENUs.ModigMainMenu.handles.block_rew,    'string',0)
            set(MENUs.ModigMainMenu.handles.block_noRew,  'string',0)
            ModigMessage('message_board','block counter reset...',8);
            
            % in case we are using the project updating area, we also reset it 
            fileStr = ['updateMoMaMe_',TaskOp.prj];
            if exist(fileStr,'file')
                cmd = [fileStr,'(''reset'')'];
                eval(cmd)
            end
        end
    case 'reset_day'
        if ~inside_session
            set_GUI_value(MENUs.ModigMainMenu.handles.CNTR_TEXT_DAY_TOTAL,'String','0');
            set_GUI_value(MENUs.ModigMainMenu.handles.CNTR_TEXT_DAY_CORRECT,'String','0');
            set_GUI_value(MENUs.ModigMainMenu.handles.CNTR_TEXT_DAY_ERROR,'String','0');
            set_GUI_value(MENUs.ModigMainMenu.handles.CNTR_TEXT_DAY_PERCENT,'String','0');
            TaskOp.count.day_total = 0;
            TaskOp.count.day_correct = 0;
            TaskOp.count.day_error = 0;
            TaskOp.count.day_ignored  = 0;
            TaskOp.count.day_rew      = 0;
            TaskOp.count.day_noRew    = 0;
            TaskOp.EvntHist.rewHistVol = [0 0];
            set(MENUs.ModigMainMenu.handles.day_ignored,'string',0)
            set(MENUs.ModigMainMenu.handles.day_rew,    'string',0)
            set(MENUs.ModigMainMenu.handles.day_noRew,  'string',0)
            % update juice volumen counter
            set(MENUs.ModigMainMenu.handles.textJuiceVol_A,'String',...
                sprintf('%d ml',round(TaskOp.EvntHist.rewHistVol(1))))
            set(MENUs.ModigMainMenu.handles.textJuiceVol_B,'String',...
                sprintf('%d ml',round(TaskOp.EvntHist.rewHistVol(2))))

            ModigMessage('message_board','day counter reset',8);
        end
    case 'shuffle_seq'
        if ~inside_session
            TaskOp.Trial.to_be_shuffled = 1;
            ModigMessage('message_board','sequence will be shuffled somehow, somewhere',8);
%             TODO:  write this snipet, ModigRand_(prj)?? AND ModigTaskLoop-->SeqDisp?? 
        end
%     case 'log_in'
%         if ~inside_session
%             ModigLogIn;
%             % TODO, if user changes from lab connected to not connected and
%             %   viceversa be sure to generate the appropiate objects and
%             %   timers.
%         end
%     case 'log_off'
%         if ~inside_session
%              db_location = which('ModigLogIn.m');
%             PATHSTR = fileparts(db_location);
%             % TODO, prepare a log-in menu in the future???
%             user_db_file = strcat(PATHSTR,'/','UserDabaBase.mat');
%             if exist(user_db_file,'file'),
%                 load(user_db_file);
%                 usernames = fields(UserDataBase);
%                 if ~isempty(UserInfo)
%                     buf = findcell_sk(usernames,UserInfo.username);
%                     if ~isempty(buf)
%                         eval(strcat('UserDataBase.',UserInfo.username,'.default_param = UserInfo.default_param;'))
%                     end
%                     save(user_db_file,'UserDataBase');
%                 end
%             else
%                 ModigMessage('c', 'Couldn''t save params to UserDataBase files BYE! ;-(');
%             end
%             UserInfo.username = '';
%         end
    case 'change_priority'
        ModigMenuControl('ModigPriority');
    case 'change_comment_level'
        if ~inside_session
            ModigMenuControl('ModigCommentLevel');
        end
    case 'save_par_in_file'
        if ~inside_session
            ModigCopyParam('WorkSpace','file');
            ModigMessage('m&c','Current params saved in a file...',3);
        end
    case 'load_par_from_file'
        if ~inside_session
            ModigCopyParam('file','WorkSpace');
        end
    case 'save_par_as_default'
        if ~inside_session
            ModigCopyParam('WorkSpace','default_param');
            ModigMessage('m&c','Current params saved as default...',3);            
        end
    case 'load_par_from_default'
        if ~inside_session
            ModigCopyParam('default_param','WorkSpace');
            ModigMessage('m&c','Params loaded from default...',3);             
        end
    case'clear_message_window'
        ModigMessage('m&c','',1,'clear');
    case 'remedy'
        % stop the behavioral monitor timer if it exists
        if sum(strcmp(fields(Timers),'Input'))>0 
            if isvalid(Timers.Input.behavior_monitor)
                disp('ModigCommand, Ln303, stopped behavioural Timers')
                stop(Timers.Input.behavior_monitor)
            end
        end
        breaksession = 1; 
        inside_session = 0;
        % clean timers
        myTimers = timerfind;
        if ~isempty(myTimers),
            stop(myTimers)
        end
        set(MENUs.ModigMainMenu.handles.CNTR_PUSH_REMEDY,'BackgroundColor',[0.12 0.7 0.4]);
        
        ModigCommand('stop_session');
        
        % if using touchscreen, disable touchscreen
        if UserInfo.use_touch_screen,
            runED('d',1);
        end
    case 'exit'
        % Stop and Delete DAQ device
        myDaqs = daqfind;
        if ~isempty(myDaqs),
            putvalue(myDaqs(1),0); % reset to 0
           stop(myDaqs);
           delete(myDaqs);
        end
        
        % clean timers
        myTimers = timerfind;
        if ~isempty(myTimers),
            stop(myTimers);
            delete(myTimers);
        end
        
        ModigCommand('log_off');
        % Close PTB
        Priority(0);
        ShowCursor;
        ListenChar(0);
        Screen('CloseAll');
%         PsychPortAudio('Close');

        % Close Modig
        ModigCommand('close_all_menu');
        delete(gcf)
        close all
    case 'close_all_menu'
        if ~isempty(MENUs)
            menu_list = fields(MENUs);
            for mm = menu_list'
                fieldname = strcat(cell2mat(mm),'.handle');
                [a, h_menu EMPTY_handle] = isfield_sk(MENUs,fieldname);clear a
                if ~EMPTY_handle
                    if ishandle(h_menu)
                        delete(h_menu);
                    end
                end
            end
        end
        MENUs = [];
    case 'delete_saved_params'
        ModigMenuControl('ModigDeleteSavedParams');
    case 'log'
        buf = get_GUI_value(MENUs.ModigMainMenu.handles.CNTR_CHECK_LOG);
        switch buf.Value
            case 0
                TaskOp.log.on = 0;
                FileKnown= isfield (ModigLog,'filename');
                if FileKnown
                    FileExists=exist(strcat(ModigLog.filename,'.mat'),'file')==2;
                    if FileExists
                        comments=inputdlg('Enter any comments about Modig session','Comments',1);
                        ModigDataLog = load(ModigLog.filename); %Load relevant file
                        ModigDataLog.HEADER.comments=comments;
                        save(ModigLog.filename,'-struct','ModigDataLog');
                        disp('data logged, ModigData Session-end')
                        ModigLog=[];            % Clean Up
                        clear ModigDataLog
                    end
                    clear FileExists FileKnown
                end
            case 1
                TaskOp.log.on = 1;
                if isfield(ModigLog,'SessionNum')               
                    ModigLog.SessionNum=ModigLog.SessionNum+1;            
                    ModigLog.filename =  sprintf('%s\\ModigLog_%d-%d-%d_Session_%d',...
                        ModigDir.Log,ModigLog.date(1),ModigLog.date(2),ModigLog.date(3),ModigLog.SessionNum);                  
                end
        end 
    case 'handshake'
        if strcmp(get(MENUs.ModigMainMenu.handles.MENU_EnableHandshake,'Checked'),'on')
            set(MENUs.ModigMainMenu.handles.MENU_EnableHandshake,'Checked','off');
            UserInfo.gettyHandshake = 0;
            set(MENUs.ModigMainMenu.handles.togglebutton_openConnection,'enable','off');
        else 
            set(MENUs.ModigMainMenu.handles.MENU_EnableHandshake,'Checked','on');
            UserInfo.gettyHandshake = 1;
            set(MENUs.ModigMainMenu.handles.togglebutton_openConnection,'enable','on');
        end        
    case 'open connection',
        myHandle = MENUs.ModigMainMenu.handles.togglebutton_openConnection;
        if get(myHandle,'Value')==1,
            % Open TCP/IP connection
            success = TCPOpenConnection;
            if success==false,
                ModigCommand stop_session
                return
            else
                set(myHandle,'String','Close Connection',...
                    'BackgroundColor',[1 0 0]);
            end
            % disable changing type of handshake
%             set(MENUs.ModigMainMenu.handles.typeOfHandshake,'enable','off');%
%             not allowed
        else
            % close TCP/IP connection
            TCPCloseConnection;
            set(myHandle,'String','Open Connection',...
                    'BackgroundColor',[0 1 0]);
            % enable changing type of handshake % NOT allowed
%             set(MENUs.ModigMainMenu.handles.typeOfHandshake,'enable','on');
        end
end


