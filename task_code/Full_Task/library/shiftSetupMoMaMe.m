function varargout = shiftSetupMoMaMe(varargin)
% varargout = shiftSetupMoMaMe(varargin)
%
% Generates the "split screen" UI controls and contains its callbacks. It
% is also used during setup shifting to keep counters for each setup
% separate from each other.
%
% rbm 2007
% rbm 1.13 help text
%   juice counter
global MENUs TaskOp UserInfo

if nargin==0,
    uipanel('parent',MENUs.ModigMainMenu.handle,...
        'units','characters',...
        'title','Select(ed) Setup',...
        'position',[75 26 25 12.5],...
        'tag','selectSetupPanel')

    % update handles
    MENUs.ModigMainMenu.handles = guihandles(MENUs.ModigMainMenu.handle);
    guidata(MENUs.ModigMainMenu.handle, MENUs.ModigMainMenu.handles);

    setupPanel = MENUs.ModigMainMenu.handles.selectSetupPanel;

    if numel(setupPanel)>1
        keyboard
    end
    uicontrol(setupPanel,'style','text',...
        'units','characters',...
        'position',[.8 9 22.6 1.3],...
        'horizontalAlignment','left',...
        'string','     A                 					B',...
        'tag','textSetupName')

    uicontrol(setupPanel,'style','pushbutton',...
        'units','characters',...
        'position',[1 6.7 10.5 2],...
        'string','off',...
        'callback','shiftSetupMoMaMe(''pushbuttonSetup'',gcbo,[],guidata(gcbo))',...
        'tag','pushbuttonSetupA')

    uicontrol(setupPanel,'style','pushbutton',...
        'units','characters',...
        'position',[13 6.7 10.5 2],...
        'string','off',...
        'callback','shiftSetupMoMaMe(''pushbuttonSetup'',gcbo,[],guidata(gcbo))',...
        'tag','pushbuttonSetupB')
    uicontrol(setupPanel,'style','text',...
            'units','characters',...
            'position',[1 5 10 1.3],...
            'horizontalAlignment','center',...
            'string','Juice Volume',...
            'tag','textJuiceVol_A')
         uicontrol(setupPanel,'style','text',...
            'units','characters',...
            'position',[15 5 10 1.3],...
            'horizontalAlignment','center',...
            'string','Juice Volume',...
            'tag','textJuiceVol_B')
        
    
    uicontrol(setupPanel,'style','text',...
            'units','characters',...
            'position',[1 3 22.6 1.3],...
            'horizontalAlignment','center',...
            'string','Players'' IDs',...
            'tag','textMonkeyIDs')
        
    uicontrol(setupPanel,'style','edit',...
        'units','characters',...
        'position',[1 1 10.5 2],...
        'background','white',...
        'string','60',...
        'callback','shiftSetupMoMaMe(''editMkyId'',gcbo,[],guidata(gcbo))',...
        'tag','editMkyIdA')
    
    uicontrol(setupPanel,'style','edit',...
        'units','characters',...
        'position',[13 1 10.5 2],...
        'background','white',...
        'string','61',...
        'callback','shiftSetupMoMaMe(''editMkyId'',gcbo,[],guidata(gcbo))',...    
        'tag','editMkyIdB')  
    
    UserInfo.setupB = '99';
    UserInfo.setupA = '70';
 
    % update handles
    MENUs.ModigMainMenu.handles = guihandles(MENUs.ModigMainMenu.handle);
    guidata(MENUs.ModigMainMenu.handle, MENUs.ModigMainMenu.handles);
    
    % check which setup is currently active, and activate the pushbutton!
    objHdl = eval(['MENUs.ModigMainMenu.handles.pushbuttonSetup',(TaskOp.curSetup)]);
    allHdl = MENUs.ModigMainMenu.handles;
    pushbuttonSetup(objHdl, [], allHdl)
    
    % INVOKE NAMED SUBFUNCTION OR CALLBACK 
    %   (callbacks can also be called directly from the GUI, but theres no 
    % need to change this)
elseif ischar(varargin{1}) 
    try
        % FEVAL switchyard... jump to the subfunctions!
        [varargout{1:nargout}] = feval(varargin{:}); 
    catch
        rethrow(lasterror);
    end
else
    error('shiftSetupMoMaMe needs char input');
end

%% callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbuttonSetup(hObject, eventdata, handles)
% make the pressed 'setup' active and the other inactive
global TaskOp VisParam MENUs

props = get(hObject);
if strcmp(props.Tag(end),'A') 
    TaskOp.curSetup = 'A';
    clear ModigMonitorBehavior ModigDoubleMonitorBehavior
    % change current onscreen window if we're running split screens
    rectWholeWin = Screen('Rect',1);
    split = sum(VisParam.scr_rect==rectWholeWin)~=4;

    if split && isfield(VisParam,'scr_holder')
        VisParam.scr_handle = VisParam.scr_holder(1);
        VisParam.scr_rect = VisParam.scr_rect_holder(1,:);
    end
    
    set(handles.pushbuttonSetupB,'BackgroundColor',[0.8314 0.8157 0.7843]);
    set(handles.pushbuttonSetupB,'String','off');
    
    % save the TaskOp.count stats in the other's pushbutton userdata
    if strcmp(props.String(end),'f') 
        set(handles.pushbuttonSetupB,'UserData',TaskOp.count);
        setupAdata = get(handles.pushbuttonSetupA,'UserData');
        if ~isempty(setupAdata), 
            TaskOp.count = setupAdata;
        end
        ModigTaskLoop('Summary',1);
        file = strcat('updateMoMaMe_',(TaskOp.prj));
        if exist(file,'file')==2,
            TaskOp.choice = 0;
            TaskOp.correct = 0;
            eval([file, '(''update'');']);
        end
    end
elseif  strcmp(props.Tag(end),'B') 

    TaskOp.curSetup = 'B';
    clear ModigMonitorBehavior ModigDoubleMonitorBehavior
    % change current onscreen window if we're running split screens
    rectWholeWin = Screen('Rect',1);
    split = sum(VisParam.scr_rect==rectWholeWin)~=4;

    if split && isfield(VisParam,'scr_holder')
        VisParam.scr_handle = VisParam.scr_holder(2);
        VisParam.scr_rect = VisParam.scr_rect_holder(2,:);
    end
    
    set(handles.pushbuttonSetupA,'BackgroundColor',[0.8314 0.8157 0.7843]);
    set(handles.pushbuttonSetupA,'String','off');

    % save the TaskOp.count stats in the other's
    % pushbutton userdata
    if strcmp(props.String(end),'f') 
        set(handles.pushbuttonSetupA,'UserData',TaskOp.count);
        setupBdata = get(handles.pushbuttonSetupB,'UserData');
        if ~isempty(setupBdata), 
            TaskOp.count = setupBdata;
        end
        ModigTaskLoop('Summary',1);
        file = strcat('updateMoMaMe_',(TaskOp.prj));
        if exist(file,'file')==2,
            TaskOp.choice = 0;
            TaskOp.correct = 0;
            eval([file, '(''update'');']);
        end
    end
end

set(hObject,'BackgroundColor',[.9 0 .9]);
set(hObject,'String', 'Active');

% update handles
MENUs.ModigMainMenu.handles = guihandles(MENUs.ModigMainMenu.handle);
guidata(MENUs.ModigMainMenu.handle, MENUs.ModigMainMenu.handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function editMkyId(hObject, eventdata, handles)
% update values for the corresponding setup
global UserInfo

props = get(hObject);

% go through the input...
str = str2double(props.String);
if isnan(str), 
    % it is a character, look up database
    switch props.String,
        case 'nig',
            set(hObject,'String', '60');
        case 'obi',
             set(hObject,'String', '61');
        case 'l40',
             set(hObject,'String', '62');
        otherwise
            disp('unrecognized input!')
    end
end

UserInfo.(['setup' (props.Tag(end))]) = get(hObject,'String');

