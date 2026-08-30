function varargout = ModigDoubleMonitor(varargin)
%MODIGDOUBLEMONITOR M-file for ModigDoubleMonitor.fig
%      MODIGDOUBLEMONITOR, by itself, creates a new MODIGDOUBLEMONITOR or raises the existing
%      singleton*.
%
%      H = MODIGDOUBLEMONITOR returns the handle to a new MODIGDOUBLEMONITOR or the handle to
%      the existing singleton*.
%
%      MODIGDOUBLEMONITOR('Property','Value',...) creates a new MODIGDOUBLEMONITOR using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to ModigDoubleMonitor_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MODIGDOUBLEMONITOR('CALLBACK') and MODIGDOUBLEMONITOR('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MODIGDOUBLEMONITOR.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModigDoubleMonitor

% Last Modified by GUIDE v2.5 08-Oct-2007 11:57:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ModigDoubleMonitor_OpeningFcn, ...
                   'gui_OutputFcn',  @ModigDoubleMonitor_OutputFcn, ...
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


%% --- Executes just before ModigDoubleMonitor is made visible.
function ModigDoubleMonitor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
global VisParam

% Choose default command line output for ModigDoubleMonitor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(hObject,'Visible','on');
guidata(hObject, handles);

VisParam.h_MONITOR_AXIS_A = handles.MONITOR_AXIS_A;
VisParam.h_MONITOR_AXIS_B = handles.MONITOR_AXIS_B;

% Do the "thing"
axes(VisParam.h_MONITOR_AXIS_A);
hold on;
% tighten axis -where we draw-
rect = VisParam.scr_rect_holder;
axis([rect(1,1) rect(1,3) rect(1,2) rect(1,4)]);
% hold off,

axes(VisParam.h_MONITOR_AXIS_B);
hold on;
axis([rect(2,1) rect(2,3) rect(2,2) rect(2,4)])    
% hold off
% change color/string of key reporter...
colors = [1 1 1; 0 1 0]; %[off; on]
strings = {'OFF', 'ON'};
set(handles.key_fb_a, 'BackgroundColor', colors(VisParam.report_hand+1,:));
set(handles.key_fb_a, 'String', strings(VisParam.report_hand+1))
set(handles.key_fb_b, 'BackgroundColor', colors(VisParam.report_hand+1,:));
set(handles.key_fb_b, 'String', strings(VisParam.report_hand+1))

%% 
function center_eye_a_Callback(hObject, eventdata, handles)
% This valus is then called by the appropiate callback to center the eye
% signal on the stimulus or the center of the screen
global centerEye

centerEye(1) = get(hObject, 'Value');
%% 
function center_eye_b_Callback(hObject, eventdata, handles)
% This valus is then called by the appropiate callback to center the eye
% signal on the stimulus or the center of the screen
global centerEye

centerEye(2) = get(hObject, 'Value');

%% --- Outputs from this function are returned to the command line.
function varargout = ModigDoubleMonitor_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
