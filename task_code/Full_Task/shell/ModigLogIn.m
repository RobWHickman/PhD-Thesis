function varargout = ModigLogIn(varargin)
% Log in menu
%
% loads a default user, otherwise the operator needs to type in username or 
%   select it from the dropdown menu
%

% RBM 30.03.07 Load default user into the popup menu, changed GUI colors,
%               introduced PUSH_CANCEL callback (closes the GUI)
%    9.07 using uiwait, uiresume and guidata we can cancel logging in to
%       modig. we don't need to call MoLoIn with a waitfor command.
%   11.07 changed radiobuttons to checkboxes -radio is for choosing.
%         Commented out Touch Screen. Currently no one uses it. Included
%         use_split for the 'game setup' or any other potential setup where
%         two stimuli monitors will be used.
%     1.08 returned use touch screen checkbox and with updating the handle
%        structure the last log in are saved next time it is loaded

% a global that stores user information
global UserDataBase UserInfo
% LAUNCH GUI
if nargin == 0  
    cur_file = which(mfilename);                                  % Gets the full pathname for the current m-file (ModigLogIn)
    PATHSTR = fileparts(cur_file);                                % Gets the path only from cur_file.
    user_db_file = strcat(PATHSTR,'\','UserDabaBase.mat');        % Creates a string allowing it to search for the database.mat file.
    if exist(user_db_file,'file'),                                
        load(user_db_file);                                       % Loads the database structure.
        usernames = fields(UserDataBase);                         % Produces a variable of strings taken from the database fields.
    else
        fprintf('Couldn''t find UserDabaBase! Will run without predefined variables\n') 
        usernames = {'Alaa'};
        UserInfo.animal_ID = 70;
        UserInfo.lab_connection = 0;
        UserInfo.use_split =0;
        fprintf('Modig assumes user name is "Alaa", animal id=70, no lab connection, nor split monitor\n')        
    end
    fig = Creat_Fig(usernames);
    set(fig,'name','LOG IN MENU');
    
    % move GUI to center of screen #2
    rect=get(0,'MonitorPositions');
    frect=get(gcf,'position');
%     CenterScreen1=[rect(1,1)+round((rect(2,3)-rect(2,1))/2)-round(frect(1,3)/2) rect(1,4)/2-round(frect(1,4)/2) frect(1,3:4)];
    CenterScreen2=[rect(2,1)+round((rect(2,3)-rect(2,1))/2)-round(frect(1,3)/2) rect(2,4)/2-round(frect(1,4)/2) frect(1,3:4)];
    set(gcf, 'Position',CenterScreen2)
    
    
    % wait in case user cancels Modig  
    handles = guihandles(fig);
    handles.loggedIn = 6; % initialize with bogus data
    guidata(handles.ModigLogIn,handles)
    uiwait(fig), % waits for uiresume (cancel or login push buttons)
    if nargout > 0
        pre = guidata(handles.ModigLogIn);
        varargout{1} = pre.loggedIn;
    end
    close(handles.ModigLogIn)
    
    clear global UserDataBase
% INVOKE NAMED SUBFUNCTION OR CALLBACK 
%   (callbacks can also be called directly from the GUI, but theres no 
% need to change this)
elseif ischar(varargin{1}) 
    try
        % FEVAL switchyard... jump to the subfunctions!
        [varargout{1:nargout}] = feval(varargin{:}); 
    catch
        disp(lasterr);
    end
end

%% Creat_Fig function:
function h = Creat_Fig(usernames)
global UserDataBase UserInfo
h = figure;
set(h,'Position',[624 553 320 186],'Color',[0.828 0.812 0.781],'Name','ModigLogIn',...
    'Tag','ModigLogIn','Units','pixels','Menubar','none','NumberTitle','off');
uicontrol(h,'Style','popupmenu','units','pixels','string','  ',...
    'position',[11 140 209 32],'BackgroundColor',[1 1 1],'tag','POPUPMENU_LOGIN',...
    'callback','ModigLogIn(''popup_log_in_Callback'',gcbo,[],guidata(gcbo))');
uicontrol(h,'Style','text','units','pixels','position',[11 121 195 20],...
    'BackgroundColor',[0.828 0.812  0.781],'tag','TEXT_USER',...
    'String','Selected User / Type In New Username');
uicontrol(h,'Style','edit','units','pixels','position',[11 100 193 20],...
    'BackgroundColor',[1 1 1],'tag','EDIT_LOGIN');
uicontrol(h,'Style','text','units','pixels','position',[210 121 60 20],...
    'BackgroundColor',[0.828 0.812  0.781],'tag','TEXT_ANIMAL',...
    'String','Animal ID #');
uicontrol(h,'Style','edit','units','pixels','position',[210 100 51 20],...
    'tag','EDIT_ANIMAL','String','',...
    'BackgroundColor', [1 1 1],...
    'Callback','ModigLogIn(''EDIT_ANIMAL_Callback'',gcbo,[],guidata(gcbo))');
uicontrol(h,'Style','checkbox','units','pixels','position',[11 65 150 25],...
    'tag','CHECK_USE_SPLIT','String',' Use Two Monitors');
uicontrol(h,'Style','checkbox','units','pixels','position',[11 35 150 25],...
    'tag','CHECK_LAB_CONNECTION','String',' Interface Connected ');
uicontrol(h,'Style','pushbutton','units','pixels','position',[223 50 78 23],...
    'tag','PUSH_CANCEL','String','CANCEL',...
    'callback','ModigLogIn(''PUSH_CANCEL_Callback'',gcbo,[],guidata(gcbo))');
uicontrol(h,'Style','pushbutton','units','pixels','position',[223 17 78 23],...
    'tag','PUSHBUTTON_LOGIN','String','LOG IN',...
    'callback','ModigLogIn(''pushbutton_log_in_Callback'',gcbo,[],guidata(gcbo))');

% load users into popupmenu
handles = guihandles(gcf);
set(handles.POPUPMENU_LOGIN,'String',usernames,'visible','on');

% Load by default a given username
defaultUsr = {'Alaa'}; % define as cell to keep with programming standard
[TH pre_UserInfo EMPTY] = isfield_sk(UserDataBase,cell2mat(defaultUsr));
if EMPTY==0,
    UserInfo = pre_UserInfo;
end

set(handles.EDIT_LOGIN,'String',cell2mat(defaultUsr));
set(handles.EDIT_ANIMAL,'string',num2str(UserInfo.animal_ID));
set(handles.CHECK_LAB_CONNECTION,'value',UserInfo.lab_connection);
set(handles.CHECK_USE_SPLIT, 'value', UserInfo.use_split)

% update handles structure
guidata(handles.ModigLogIn,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function popup_log_in_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global UserDataBase UserInfo
buf = get_GUI_value(hObject);
if ~isempty(buf.cur_name)
    set(handles. EDIT_LOGIN,'String',cell2mat(buf.cur_name));
    [TH UserInfo EMPTY] = isfield_sk(UserDataBase,cell2mat(buf.cur_name));
    if ~EMPTY
        if ~isempty(UserInfo.animal_ID)
           set_GUI_value(handles.EDIT_ANIMAL,'string',num2str(UserInfo.animal_ID));
        end
%         if ~isempty(UserInfo.use_touch_screen)
%            set_GUI_value(handles.CHECK_USE_TOUCHSCREEN,'value',UserInfo.use_touch_screen);
%         end
        if ~isempty(UserInfo.lab_connection)
           set_GUI_value(handles.CHECK_LAB_CONNECTION,'value',UserInfo.lab_connection);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton_log_in_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global UserDataBase UserInfo
cur_file = which(mfilename);
PATHSTR = fileparts(cur_file);
user_db_file = strcat(PATHSTR,'/','UserDabaBase.mat');
username = get(handles.EDIT_LOGIN,'String');

% if there is no UserDataBase (New User), make it.
if isempty(UserDataBase) && ~isempty(username)       
    eval(strcat('UserDataBase.',username,'.count=1;'));
    eval(strcat('UserDataBase.',username,'.login_time = clock;'));
    eval(strcat('UserDataBase.',username,'.PC = Screen(','''','Computer','''',');'));
    eval(strcat('UserDataBase.',username,'.default_param = [];'));
    eval(strcat('UserDataBase.',username,'.current_param = [];'));
%if there is UserDatabase, search current username.
elseif ~isempty(UserDataBase) && ~isempty(username)  
    usernames = fields(UserDataBase);
    temp = findcell_sk(usernames,username);
    if isempty(temp) % this is a new user name. add on the list
        eval(strcat('UserDataBase.',username,'.count = 1;'));
        eval(strcat('UserDataBase.',username,'.login_time = clock;'));
        eval(strcat('UserDataBase.',username,'.PC = Screen(','''','Computer','''',');'));
        eval(strcat('UserDataBase.',username,'.default_param = [];'));
        eval(strcat('UserDataBase.',username,'.current_param = [];'));
    else             % this is a existing user name
        count = eval(strcat('UserDataBase.',username,'.count'))+1;
        eval(strcat('UserDataBase.',username,'.count = count;'));
        eval(strcat('UserDataBase.',username,'.login_time(count,:) = clock;'));
        UserInfo.default_param = eval(strcat('UserDataBase.',username,'.default_param;'));
        UserInfo.current_param = [];
        eval(strcat('UserDataBase.',username,'.PC = Screen(','''','Computer','''',');'));
    end
end
buf = get_GUI_value(handles.EDIT_ANIMAL);
if ~isempty(buf.numerical)
    animal_ID = num2str(buf.numerical);
else
    animal_ID = [];
end
% use_touch_screen = get(handles.CHECK_USE_TOUCHSCREEN, 'value');
use_split = get(handles.CHECK_USE_SPLIT,'Value');
lab_connection = get(handles.CHECK_LAB_CONNECTION, 'value');

% fool-proof start-up without lab connected 
if lab_connection
    availDaq = daqhwinfo;
    availDaq = availDaq.InstalledAdaptors;
    if sum(strcmpi(availDaq, 'nidaq')) == 0 
        errordlg('Couldn''t find NIDAQ-MX Adaptor. Starting without lab connection!',...
            'Error while starting up');
        lab_connection = 0;
    end
end

if ~isempty(username) % when would it be empty?
    UserDataBase.(username).animal_ID = animal_ID;
    UserDataBase.(username).use_split = use_split;
    UserDataBase.(username).lab_connection = lab_connection;
    save(user_db_file,'UserDataBase');
    UserInfo = UserDataBase.(username);
    UserInfo.username = username;
    UserInfo.ModigDir = [];
else
    UserInfo.username = [];
    UserInfo.ModigDir = [];
    UserInfo.animal_ID = animal_ID;
    UserInfo.lab_connection   = lab_connection;
end
UserInfo.PC = Screen('Computer'); % get type of OS with PTB
UserInfo.save_list = {'Task','Stim','VisStat','IO','MenuPos'};
openglinfo = opengl('data');
UserInfo.PC.renderer = openglinfo.Renderer;

% this will work until we get two computers with the same video card but
% different desired setup
if strcmpi(openglinfo.Renderer,'Quadro NVS 160M/PCI/SSE2')
    UserInfo.PC.mainwin = 1;
    UserInfo.PC.dispwin = 2;
else
    UserInfo.PC.mainwin = 2;
    UserInfo.PC.dispwin = 1;
end

% return control flow 
handles.loggedIn = 1; % we logged in
guidata(handles.ModigLogIn, handles); % update handles structure
uiresume(handles.ModigLogIn), 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EDIT_ANIMAL_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
buf = get_GUI_value(hObject);
if isempty(buf.numerical)
   set_GUI_value(hObject,'String',''); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PUSH_CANCEL_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.loggedIn = 0;
guidata(handles.ModigLogIn, handles);
uiresume(handles.ModigLogIn),

