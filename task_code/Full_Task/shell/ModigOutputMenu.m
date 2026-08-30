function varargout = ModigOutputMenu(varargin)
% varargout = ModigOutputMenu(varargin)
%
% M-file of the GUI of the same name
%
% display bit asignment loaded on the global Tbl. 
% cf. ModigLoadBitAsignTbl.m
% display menu has space only upto 14 bit events
% if an event in Tbl.BitTbl isn't defined it won't appear in the
% GUI
% hides undeclared uicontrols
% in theory it updates the Bit values, but i'm not sure where the
% uicontrol is 
% subfunction test isn't necessary and update_BitTable might be flexible,
% but maybe too flexible
%
% SK wrote it
% RBM 01.08 comments
%
% TODO, save and change values on definition .mat file and pass them to the
%   global Tbl
% TODO, clean code from global IO assignments which are superseded by gl Tbl

if nargin == 0,  % LAUNCH GUI
    h_menu = openfig(mfilename,'new');
    handles = guihandles(h_menu);
    guidata(h_menu, handles);
    ModigOutputMenu_OpeningFcn(h_menu,[],handles);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargout > 0,
        varargout{1} = h_menu;
    end
elseif ischar(varargin{1}), % INVOKE NAMED SUBFUNCTION OR CALLBACK
    try
        [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
    catch
        disp(lasterr);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ModigOutputMenu_OpeningFcn(hObject, eventdata, handles, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global Tbl
% Initialie GUI size variables
event_left  = 20;
bit_left    = 170;
event_top   = 480;
event_width = 120;
event_height = 25;
bit_width   = 80;
bit_height  = 25;
v_int       = 5;
set(hObject,'Unit','Pixel');

% assuming that we use bit from 0-15. This is put into the popupmenu
% string.
bit_range = num2cell(0:15)';
if Tbl.BitAsign.loaded
    % create the UIcontents
    set(handles.TEXT_ANIMAL_ID, 'String',num2str(Tbl.BitAsign.animal_ID));
    set(handles.TEXT_PRJ, 'String',Tbl.BitAsign.prj);
    
    % loop all possible bit positions and create a uicontrol for each one..
    for event_id = 1:14
        tag_name = strcat('EDIT_EVENT_',num2str(event_id));
        h_event(event_id) = uicontrol(hObject,'Style','edit',...
            'position',[event_left event_top-(event_id-1)*event_height-(event_id-1)*v_int event_width event_height],...
            'tag',tag_name);
        tag_name = strcat('POP_BIT_',num2str(event_id));
        h_bit(event_id) = uicontrol(hObject,'Style','popupmenu',...
            'position',[bit_left event_top-(event_id-1)*event_height-(event_id-1)*v_int bit_width bit_height],...
            'tag',tag_name,'visible','on','String',bit_range);
    end
    handles = guihandles(hObject);
    % display menu has space only upto 14 bit events
    for event_id = 1: min(size(Tbl.BitTbl,1),14)  
        event_name = Tbl.BitTbl(event_id,Tbl.BitTblColumnID.bit_event_name);
        event_bit = Tbl.BitTbl(event_id,Tbl.BitTblColumnID.bit_asignment);
        % if an event in Tbl.BitTbl isn't defined it won't appear in the 
        % GUI
        if ~isempty(cell2mat(event_name))
            eval(strcat('set(handles.EDIT_EVENT_',num2str(event_id),',',...
                '''','string','''',',','''',cell2mat(event_name),'''',');'));
        else
            eval(strcat('set(handles.EDIT_EVENT_',num2str(event_id),',',...
                '''','visible','''',',','''','off','''',');'));
        end

        if ~isempty(cell2mat(event_bit))
            eval(strcat('set(handles.POP_BIT_',num2str(event_id),',',...
                '''','string','''',',','bit_range',');'));
            eval(strcat('set_GUI_value(handles.POP_BIT_',num2str(event_id),',',...
                '''','string','''',',',num2str(cell2mat(event_bit)),');'));
        else
            eval(strcat('set(handles.POP_BIT_',num2str(event_id),',','''','visible','''',',','''','off','''',');'));
        end
    end
    
    % hide undeclared uicontrols
    if size(Tbl.BitTbl,1)<14
        for event_id = size(Tbl.BitTbl,1)+1:14
            eval(strcat('set(handles.EDIT_EVENT_',num2str(event_id),',','''','visible','''',',','''','off','''',');'));
            eval(strcat('set(handles.POP_BIT_',num2str(event_id),',','''','visible','''',',','''','off','''',');'));
        end
    end
else
    errordlg('BitAsignment file is not loaded.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = ModigOutputMenu_OutputFcn(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PUSH_CLOSE_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global MENUs
% [TH h_menu EMPTY] = isfield_sk(MENUs, 'ModigOutputMenu.handle');
ModigMenuControl('ModigOutputMenu','off');

function cancel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global MENUs IO
[TH h_menu EMPTY] = isfield_sk(MENUs, 'ModigOutputMenu.handle');
if ~EMPTY
   IO = get(h_menu ,'userdata');
end
ModigMenuControl('ModigOutputMenu','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Update_Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ModigDir MENUs IO Tbl Timers
[TH h_menu EMPTY] = isfield_sk(MENUs, 'ModigOutputMenu.handle');
if ~EMPTY
    GUI_Info = get_menu_contents(h_menu);

    IO.Output.free_juice.bit = GUI_Info.CONTENTS.POP_BIT_FREE_JUICE.numerical;
    IO.Output.task_juice.bit = GUI_Info.CONTENTS.POP_BIT_TASK_JUICE.numerical;
    IO.Output.sound_1.bit = GUI_Info.CONTENTS.POP_BIT_SOUND_1.numerical;
    IO.Output.sound_2.bit = GUI_Info.CONTENTS.POP_BIT_SOUND_2.numerical;
    IO.Output.sound_3.bit = GUI_Info.CONTENTS.POP_BIT_SOUND_3.numerical;

    IO.Output.free_juice.dur = GUI_Info.CONTENTS.EDIT_DUR_FREE_JUICE.numerical;
    IO.Output.task_juice.dur = GUI_Info.CONTENTS.EDIT_DUR_TASK_JUICE.numerical;
    IO.Output.sound_1.dur = GUI_Info.CONTENTS.EDIT_DUR_SOUND_1.numerical;
    IO.Output.sound_2.dur = GUI_Info.CONTENTS.EDIT_DUR_SOUND_2.numerical;
    IO.Output.sound_3.dur = GUI_Info.CONTENTS.EDIT_DUR_SOUND_3.numerical;

    IO.Output.free_juice.event = [];
    IO.Output.free_juice.event_id = [];
    if strcmpi(cell2mat(GUI_Info.CONTENTS.POP_EVENT_TASK_JUICE.cur_name),'off')
        IO.Output.task_juice.event = [];
        IO.Output.task_juice.event_id = [];
    else
        IO.Output.task_juice.event = cell2mat(GUI_Info.CONTENTS.POP_EVENT_TASK_JUICE.cur_name);
        IO.Output.task_juice.event_id = eval(strcat('Tbl.Task.',IO.Output.task_juice.event,'.id'));
    end
    if strcmpi(GUI_Info.CONTENTS.POP_EVENT_SOUND_1.cur_name,'off')
        IO.Output.sound_1.event = [];
        IO.Output.sound_1.event_id = [];
    else
        IO.Output.sound_1.event = cell2mat(GUI_Info.CONTENTS.POP_EVENT_SOUND_1.cur_name);
        IO.Output.sound_1.event_id = eval(strcat('Tbl.Task.',IO.Output.sound_1.event,'.id'));
    end


    for ee = 1:10
        event_name = eval(strcat('GUI_Info.CONTENTS.EDIT_EVENT_',num2str(ee),'.String'));
        if ~isempty(event_name)
            event_bit = eval(strcat('GUI_Info.CONTENTS.POP_BIT_EVENT_',num2str(ee),'.numerical;'));
            eval(strcat('IO.Event.',event_name,'.bit=',num2str(event_bit),';'));
            eval(strcat('IO.Event_ID(',num2str(ee),').bit=',num2str(event_bit),';'));
            eval(strcat('IO.Event_ID(',num2str(ee),').name=','''',event_name,'''',';'));
        else
            eval(strcat('IO.Event_ID(',num2str(ee),').bit=[];'));
            eval(strcat('IO.Event_ID(',num2str(ee),').name=[];'));
        end
    end
else
    ModigMessage('m&c','Output setting was not saved due to an internal problem');
    errordlg('code error');
end
ModigMenuControl('ModigOutputMenu','Off');

%%%%%%%%%%%%%%%%%%%%%
function test(option)

global IO Timers

switch option
    case 'free juice'
        hObj_bit = findobj('tag','POP_BIT_FREE_JUICE');
        temp_bit = get_GUI_value(hObj_bit);
        hObj_dur = findobj('tag','EDIT_DUR_FREE_JUICE');
        temp_dur = get_GUI_value(hObj_dur);
        if isfield(temp_bit,'numerical')
            IO.Output.free_juice.bit = temp_bit.numerical;
        else
            return
        end
        if isfield(temp_dur,'numerical')
            IO.Output.free_juice.dur = temp_dur.numerical;
        else
            return
        end
        cb = ModigSetTimer('Output','free_juice');
        [TH cur_timer EMPTY] = isfield_sk(Timers,'Output.free_juice');
        if ~EMPTY
           start(cur_timer);
        end
     case 'task juice'
        hObj_bit = findobj('tag','POP_BIT_TASK_JUICE');
        temp_bit = get_GUI_value(hObj_bit);
        hObj_dur = findobj('tag','EDIT_DUR_TASK_JUICE');
        temp_dur = get_GUI_value(hObj_dur);
        if isfield(temp_bit,'numerical')
            IO.Output.task_juice.bit = temp_bit.numerical;
        else
            return
        end
        if isfield(temp_dur,'numerical')
            IO.Output.task_juice.dur = temp_dur.numerical;
        else
            return
        end
        cb = ModigSetTimer('Output','task_juice');
        [TH cur_timer EMPTY] = isfield_sk(Timers,'Output.task_juice');
        if ~EMPTY
           start(cur_timer);
        end
     case 'sound 1'
        hObj_bit = findobj('tag','POP_BIT_SOUND_1');
        temp_bit = get_GUI_value(hObj_bit);
        hObj_dur = findobj('tag','EDIT_DUR_SOUND_1');
        temp_dur = get_GUI_value(hObj_dur);
        if isfield(temp_bit,'numerical')
            IO.Output.sound_1.bit = temp_bit.numerical;
        else
            return
        end
        if isfield(temp_dur,'numerical')
            IO.Output.sound_1.dur = temp_dur.numerical;
        else
            return
        end
        cb = ModigSetTimer('Output','sound_1');
        [TH cur_timer EMPTY] = isfield_sk(Timers,'Output.sound_1');
        if ~EMPTY
           start(cur_timer); 
        end
     case 'sound 2'
        hObj_bit = findobj('tag','POP_BIT_SOUND_2');
        temp_bit = get_GUI_value(hObj_bit);
        hObj_dur = findobj('tag','EDIT_DUR_SOUND_2');
        temp_dur = get_GUI_value(hObj_dur);
        if isfield(temp_bit,'numerical')
            IO.Output.sound_2.bit = temp_bit.numerical;
        else
            return
        end
        if isfield(temp_dur,'numerical')
            IO.Output.sound_2.dur = temp_dur.numerical;
        else
            return
        end
        cb = ModigSetTimer('Output','sound_2');
        [TH cur_timer EMPTY] = isfield_sk(Timers,'Output.sound_2');
        if ~EMPTY
           start(cur_timer); 
        end        
     case 'sound 3'
        hObj_bit = findobj('tag','POP_BIT_SOUND_3');
        temp_bit = get_GUI_value(hObj_bit);
        hObj_dur = findobj('tag','EDIT_DUR_SOUND_3');
        temp_dur = get_GUI_value(hObj_dur);
        if isfield(temp_bit,'numerical')
            IO.Output.sound_3.bit = temp_bit.numerical;
        else
            return
        end
        if isfield(temp_dur,'numerical')
            IO.Output.sound_3.dur = temp_dur.numerical;
        else
            return
        end
        cb = ModigSetTimer('Output','sound_3');
        [TH cur_timer EMPTY] = isfield_sk(Timers,'Output.sound_3');
        if ~EMPTY
           start(cur_timer); 
        end                
end