function ModigMessage(msg_where,msg_what,msg_level,option)
%
% ModigMessage(msg_where,msg_what,msg_level,option)
%
% Print message on Modig Main Menu and/or command window
% msg_where: 
%             'message_board" or 'm', or 'M' -> print on message window on the Modig Main Menu
%             'command_line' or 'c', or 'C'  -> print on command line
%             'm&c'                          -> print on both
% msg_what:  string to print out
% msg_level: 0 to 9, higher values mean less output (not used)
% option: only accepts the char 'clear' and clears the messages where
%           indicated
%

% SK    wrote it
% RBM   8.05.07 changed isstr to ischar, reposition of drawnow for faster
%       execution

global MENUs TaskOp

if nargin < 3
    msg_level = 1;
end

if nargin >=4
    if strcmp(option,'clear')
        switch msg_where,
            case {'message_board','m','M'}
                set(MENUs.ModigMainMenu.handles.LIST_MESSAGE,'string',{'';'';''},'Value',1,'ListboxTop',3);
            case {'command_line','c','C'}
                clc;
            case 'm&c'
                set(MENUs.ModigMainMenu.handles.LIST_MESSAGE,'string',{'';'';''},'Value',1,'ListboxTop',3);
                clc;
        end
    end
end

% decide to give output or not, 
% NOTE, all calls go through since I commented out the if-else structure
% if TaskOp.message_level <= msg_level
    switch msg_where
        case {'message_board','m','M'}
            if ischar(msg_what)
                str = get(MENUs.ModigMainMenu.handles.LIST_MESSAGE,'String');
                % truncate output string
                if length(str)>30,
                    str = {};
                end
                str = [str;{msg_what}];
                set(MENUs.ModigMainMenu.handles.LIST_MESSAGE,'string',str,'Value',1,'ListboxTop',length(str));
            elseif isnumeric(msg_what)
                str = get(MENUs.ModigMainMenu.handles.LIST_MESSAGE,'String');
                str = [str;{num2str(msg_what)}];
                set(MENUs.ModigMainMenu.handles.LIST_MESSAGE,'string',str,'Value',1,'ListboxTop',length(str));
            end
        case  {'command_line','c','C'}
            if ischar(msg_what)
                fprintf('%s\n',msg_what)
            elseif isnumeric(msg_what)
                fprintf('%f\n',msg_what)
            end
        case 'm&c'
            if ischar(msg_what)
                str = get(MENUs.ModigMainMenu.handles.LIST_MESSAGE,'String');
                if length(str)>30,
                    str = {};
                end
                str = [str;{msg_what}];
                set(MENUs.ModigMainMenu.handles.LIST_MESSAGE,'string',str,'Value',1,'ListboxTop',length(str));
            elseif isnumeric(msg_what)
                str = get(MENUs.ModigMainMenu.handles.LIST_MESSAGE,'String');
                str = [str;{num2str(msg_what)}];
                set(MENUs.ModigMainMenu.handles.LIST_MESSAGE,'string',str,'Value',1,'ListboxTop',length(str));
            end
            if ischar(msg_what)
                fprintf('%s\n',msg_what)
            elseif isnumeric(msg_what)
                fprintf('%f\n',msg_what)
            end
    end
     %  flush the event queue and update the figure(s) window
    drawnow;
    
% BUG report: ??? Error using ==> drawnow
% UIJ_AreThereWindowShowsPending - timeout waiting for window to show up.

% end