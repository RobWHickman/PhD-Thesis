function ModigHard(varargin)
% Hardware setting menu
%
% collection of some callbacks asociated to ModigMainMenu
%
% See Also MODIGMAINMENU
%

global Timers TaskOp MENUs UserInfo ExtDevice

switch varargin{1}
    case 'test free juice'
        [TH_jtimer jtimer EMPTY] = isfield_sk(Timers, 'command.free_juice');
        if ~EMPTY
            start(jtimer);
            planned_time = get(jtimer,'StartDelay');
            actual_time = TaskOp.free_juice.dur;
            str = strcat('juice duration [set / actual] -> [',num2str(planned_time),' / ',num2str(actual_time),'] (sec).');
            ModigMessage('message_board',str,10);
        end
    case 'test task juice'
        [TH_jtimer jtimer EMPTY] = isfield_sk(Timers, 'command.task_juice');
        if ~EMPTY
            start(jtimer);
            planned_time = get(jtimer,'StartDelay');
            actual_time = TaskOp.task_juice.dur;
            str = strcat('juice duration [set / actual] -> [',num2str(planned_time),' / ',num2str(actual_time),'] (sec).');
            ModigMessage('message_board',str,10);
        end
    case 'input_menu'
        ModigMenuControl('ModigInputMenu');
        [TH h_menu EMPTY] = isfield_sk(MENUs, 'ModigInputMenu.handles.ModigInputMenu');
        if ~EMPTY
           if ishandle(h_menu);

           end
        end
    case 'output_menu'
        ModigMenuControl('ModigOutputMenu');
         [TH h_menu EMPTY] = isfield_sk(MENUs, 'ModigOutputMenu.handles.ModigOutputMenu');
        if ~EMPTY
           if ishandle(h_menu);
               ModigArrangeMenuPosition(h_menu);
           end
        end
    case 'test visual page'
        cb = ModigMenuControl('ModigTestVisualPage');
        [TH h_menu EMPTY] = isfield_sk(MENUs, 'ModigTestVisualPage.handles.ModigTestVisualPage');
        if ~EMPTY
           if ishandle(h_menu);
               ModigArrangeMenuPosition(h_menu);
           end
        end
    case 'behavior_input_menu'
        ModigMenuControl('ModigBehaviorInputMenu');
    case 'bit_monitor'
        if UserInfo.lab_connection,
            bitMonHdl = ModigBitMonitor(ExtDevice.inputDio,ExtDevice.outputDio);
            ModigArrangeMenuPosition(bitMonHdl);
        else
            warndlg('Can''t launch ModigBitMonitor with lab disconected!','Modigliani says...')
        end
end



