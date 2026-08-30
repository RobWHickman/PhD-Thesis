function varargout = ModigMonitorTable(varargin)
%MODIGMONITORTABLE M-file for ModigMonitorTable.fig
%      MODIGMONITORTABLE, by itself, creates a new MODIGMONITORTABLE or raises the existing
%      singleton*.
%
%      H = MODIGMONITORTABLE returns the handle to a new MODIGMONITORTABLE or the handle to
%      the existing singleton*.
%
%      MODIGMONITORTABLE('Property','Value',...) creates a new MODIGMONITORTABLE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to ModigMonitorTable_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MODIGMONITORTABLE('CALLBACK') and MODIGMONITORTABLE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MODIGMONITORTABLE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModigMonitorTable

% Last Modified by GUIDE v2.5 16-Jul-2015 17:55:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ModigMonitorTable_OpeningFcn, ...
                   'gui_OutputFcn',  @ModigMonitorTable_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ModigMonitorTable is made visible.
function ModigMonitorTable_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

global VisParam TaskOp UserInfo

% clear up the clog on the  handles... 
handles = guihandles(hObject);
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(hObject,'Visible','on');

% pass axis handles and re-scale it to full monitor
VisParam.h_MONITOR_AXIS = handles.MONITOR_AXIS;

axes(VisParam.h_MONITOR_AXIS);
hold on;

% split screen or whole screen
if UserInfo.use_split,
    rect = sum(VisParam.scr_rect_holder,1);
    axis([0 rect(3) - abs(rect(1)) rect(2) rect(4)/2])
else    
    axis(VisParam.scr_rect([1 3 2 4]))
end

% UIWAIT makes ModigMonitorTable wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ModigMonitorTable_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% 
function center_eye_Callback(hObject, eventdata, handles)

% This valus is then called by the appropiate callback to center the eye
% signal on the stimulus or the center of the screen
global centerEye

centerEye = get(hObject, 'Value');


% --- Executes on button press in togglebuttonEyeHistory.
function togglebuttonEyeHistory_Callback(hObject, eventdata, handles)
% hObject    handle to togglebuttonEyeHistory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% pass the toggle status to handle of the plotting axis
doEyeHistory = get(hObject,'Value')==1;
set(handles.MONITOR_AXIS,'UserData',doEyeHistory)

if doEyeHistory,
    set(hObject,'String','Stop Eye History',...
                'BackgroundColor',[1 0 0])
else
     set(hObject,'String','Start Eye History',...
                'BackgroundColor',[0 1 0])
end
               

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in key_fb_A.
function key_fb_A_Callback(hObject, eventdata, handles)
% hObject    handle to key_fb_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
