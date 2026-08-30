function reply = ModigMenuControl(gui_name,option)
% Control Menu On Off and check and uncheck the menu status on the Modig Main Menu
% the argument 'gui_name' should be a fig/m file name, without extention (eg. ModigMonitor).
% Option should be 'ON'/ 'OFF'. [TODO: set up for 'HIDE']
% eg. ModigMenuControl('ModigMonitor','ON')
% If the file is not found, it returns an error. [reply == 0]
%
% All the children handles on the activated menu are stored in the global 'MENUs'
% When the menu is opened or closed status in the MENUs is set 'ON' or 'OFF'    
%   (eg. MENUs.ModigMonitor.status = 'ON');
% CloseReqFunction of the menu is also set when the menu is opened.             
%   (eg. ModigMenuControl('ModigMonitor','off'))
% List in the Main menu tab is checked on or off, when the menu is opend or closed. 
%
% coded by skoba (skoba-tky@umin.ac.jp) 3 June 2005
% last modified by skoba 4 June 2005
% rbm 11.07 use of dynamic fields and some commenting
%       7.09 re-use of global MenuPos to keep constant GUI positions

global MENUs MenuPos
if nargin == 1
    % if the requested gui_name had been loaded then we can close it
    if isfield(MENUs,gui_name)
        switch MENUs.(gui_name).status
            case 'ON',
                option = 'OFF';
            case 'OFF',
                option = 'ON';
            otherwise
                option = 'OFF';
        end
    else
        option = 'ON';
    end
end

% open gui_name
if strcmpi(option,'ON')
    if exist(gui_name,'file') == 2
        gui_handle=eval(gui_name);
        % in case we use a predefined GUI, e.g. shiftSetup we don't need to
        % update MENUs or arm a closereqfcn
        if gui_handle ~= -1
            % update our global MENUs
            gui_tag = get(gui_handle,'tag');
            MENUs.(gui_name).tag = gui_tag;
            gui_handles = guidata(gui_handle);
            MENUs.(gui_name).handles = sort_structure(gui_handles);
            MENUs.(gui_name).handle  = gui_handle;
            MENUs.(gui_name).status  = 'ON';
            % arm a closeRequestFcn
            Fcn=strcat('ModigMenuControl(','''',gui_name,'''',',','''','OFF','''',');');
            set(gui_handle,'CloseRequestFcn',Fcn); 

            % update position using our global MenuPos
            if isempty(MenuPos),
                gp = get(gui_handle,'position');
                sprintf('MenuPos is empty, gui position is: %s',mat2str(gp))
            else
                if isfield(MenuPos,gui_name),
                    if isfield(MenuPos.(gui_name), 'position'),
                        attr = {'Units','Position'};
                        vals = { 'pixels', MenuPos.(gui_name).position};
                        set(gui_handle, attr, vals)
                    end
                end
            end
            field_name = strcat(gui_tag,'.position');
            [TH_pos menu_position EMPTY_pos] = isfield_sk(MenuPos,field_name); % EMPTY so returns no val.
            set(gui_handle,'Unit','Pixel');
            cur_position = get(gui_handle,'Position');
%             menu_position(1) = -1700;
%             menu_position(2) = 200;
            menu_position([3 4]) = cur_position([3 4]); % keep height and width
%             set(gui_handle,'Position', menu_position);
            if ~EMPTY_pos
               set(gui_handle,'Position', menu_position);
            end

            % output, 
            field_name = strcat('ModigMainMenu.handles.MENU_',gui_name); 
            [TH_gui h_menu EMPTY] = isfield_sk(MENUs,field_name);
            if ~ishandle(h_menu),
                warning('MENUs.%s, not a handle.',field_name)
                reply = 1;
                return
            end
            
            if ~EMPTY
                set(h_menu,'Checked','on');
                reply = 1;
            elseif strcmp(gui_name, 'ModigMainMenu')
                reply = 1;
            else
                reply = 0;
            end
        end
    else
        error('file named: %s doesn''t exist.', gui_name);
        reply = 0;
    end
% if requested to close a MENU. the handles are deleted
elseif strcmpi(option,'OFF'),
    if isfield(MENUs,gui_name)
        gui_tag = MENUs.(gui_name).tag;
        gui_handle = findobj('tag',gui_tag);
        if ~isempty(gui_handle)
            if ishandle(gui_handle)
                if ~strcmp(get(gui_handle,'Type'),'uimenu')
                    set(gui_handle,'Unit','Pixel');
                end
                menu_position = get(gui_handle,'Position');
                MenuPos.(gui_tag).position = menu_position;
                delete(gui_handle);
%                 set(gui_handle,'Visible','off')
                field_name = gui_name;
                [TH_gui h_gui EMPTY] = isfield_sk(MENUs,field_name);
                if ~EMPTY
                    MENUs.(gui_name).handles = [];
                    MENUs.(gui_name).status  = 'OFF';
                end
                % output/update
                field_name = strcat('ModigMainMenu.handles.MENU_',gui_name);
                [TH_gui h_menu EMPTY] = isfield_sk(MENUs,field_name);
                if ~EMPTY
                    set(h_menu,'Checked','off');
                    reply = 1;
                else
                    reply = 0;
                end
            else
                error('%s ain''t a handle', gui_handle)
                reply = 0;
            end
        % if the gui_handle was empty
        else
            MENUs.(gui_name).handles = [];
            MENUs.(gui_name).status  = 'OFF';
            % output/update
            field_name = strcat('ModigMainMenu.handles.MENU_',gui_name);
            [TH_gui h_menu EMPTY] = isfield_sk(MENUs,field_name);
            if ~EMPTY
                set(h_menu,'Checked','off');
                reply = 1;
            else
                reply = 0;
            end
        end
    end
end


