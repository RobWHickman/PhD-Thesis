function varargout = ModigMonitor(varargin)
% subroutines for experimenter's screen
% drawing eye positions
% drawing stimuli

% Last Modified by GUIDE v2.5 21-May-2007 12:41:40


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Monitor_OpeningFcn, ...
                   'gui_OutputFcn',  @Monitor_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


%% --- Executes just before Monitor is made visible.
function Monitor_OpeningFcn(hObject, eventdata, handles, varargin)
global VisParam TaskOp
handles.output = hObject;
set(hObject,'Visible','on');
guidata(hObject, handles);

% ModigArrangeMenuPosition(hObject); 
% set(handles.TOGGLE_DRAW_STIMULI,'value',1);
% set(handles.TOGGLE_DRAW_EYE_POS,'value',1);
% set(handles.report_hand, 'Value', VisParam.report_hand)
VisParam.h_MONITOR_AXIS = handles.MONITOR_AXIS;
VisParam.draw_eye_pos = 1;
VisParam.draw_stimuli = 1;

% Do the "thing"
axes(VisParam.h_MONITOR_AXIS);
hold on;
% tighten axis -where we draw-
w = Screen('Windows');
if isempty(w)
    rect = [0 0 800 600];
elseif size(w,2) == 1
    rect = Screen('Rect',max(w));
else
    rect = VisParam.scr_rect;
end

% change axes based on current selected setup
% if strcmp(TaskOp.curSetup,'A')
%     axis([rect(1) rect(3)/2 rect(2) rect(4)]);
% elseif strcmp(TaskOp.curSetup,'B')
%     axis([rect(3)/2 rect(3) rect(2) rect(4)])    
% else
    axis([rect(1) rect(3) rect(2) rect(4)]);
% end


% change color/string of key reporter...
% colors = [1 1 1; 0 1 0]; %[off; on]
% strings = {'OFF', 'ON'};
% set(handles.key_fb, 'BackgroundColor', colors(VisParam.report_hand+1,:));
% set(handles.key_fb, 'String', strings(VisParam.report_hand+1))
%%
function varargout = Monitor_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%%
function draw_eye_pos(hObject, eventdata, handles)
global VisParam
switch get(hObject,'Value');
    case 1
        VisParam.draw_eye_pos = 1;
    case 0
        VisParam.draw_eye_pos = 0;
end

%% --- Executes on button press in draw_stimuli
function draw_stimuli(hObject, eventdata, handles)
global VisParam

VisParam.draw_stimuli =  get(hObject,'Value');

%% --- Executes on button press in report_hand.
function report_hand_Callback(hObject, eventdata, handles)
% hObject    handle to report_hand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global VisParam
% equivalent to switch-case in drawing_stimuli
VisParam.report_hand = get(hObject, 'Value');
VisParam.report_hand_hdl = hObject;
% change color/string of key reporter...
colors = [1 1 1; 0 1 0]; %[off, on]
strings = {'OFF', 'ON'};
figHdl = guihandles;
set(figHdl.key_fb, 'BackgroundColor', colors(VisParam.report_hand+1,:));
set(figHdl.key_fb, 'String', strings(VisParam.report_hand+1))
%% --- Executes on button press in key_fb.
function key_fb_Callback(hObject, eventdata, handles)
% hObject    handle to key_fb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This button is only a "reporter" no function associated to it being pressed.

%% 
function center_eye_Callback(hObject, eventdata, handles)

% This valus is then called by the appropiate callback to center the eye
% signal on the stimulus or the center of the screen
global centerEye

centerEye = get(hObject, 'Value');

