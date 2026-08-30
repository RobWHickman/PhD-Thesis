function varargout = StimulusEditGUI(varargin)
% STIMULUSEDITGUI MATLAB code for StimulusEditGUI.fig
%      STIMULUSEDITGUI, by itself, creates a new STIMULUSEDITGUI or raises the existing
%      singleton*.
%
%      H = STIMULUSEDITGUI returns the handle to a new STIMULUSEDITGUI or the handle to
%      the existing singleton*.
%
%      STIMULUSEDITGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STIMULUSEDITGUI.M with the given input arguments.
%
%      STIMULUSEDITGUI('Property','Value',...) creates a new STIMULUSEDITGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StimulusEditGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StimulusEditGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StimulusEditGUI

% Last Modified by GUIDE v2.5 02-Aug-2016 14:39:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StimulusEditGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @StimulusEditGUI_OutputFcn, ...
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


% --- Executes just before StimulusEditGUI is made visible.
function StimulusEditGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StimulusEditGUI (see VARARGIN)
global TO VisParam
% Choose default command line output for StimulusEditGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set to vals currently in param space:
handles.Current_Div_Space.String            = num2str(TO.Stimuli.BDM.D_DivSpacing);
handles.Current_Div_MBIDEDGE.String         = num2str(TO.Stimuli.BDM.D_MBidEdge);
handles.Current_Div_CBIDEDGE.String         = num2str(TO.Stimuli.BDM.D_CBidEdge);
handles.Current_Bar_BaseDistance.String     = num2str(TO.Stimuli.Bar.Base_Distance);
handles.Current_Bar_Height.String           = num2str(TO.Stimuli.BDM.BarHeight/VisParam.scr_rect(4));

if TO.Stimuli.Control.MainScale
    handles.Main_Scale_On.Value     = 1;
    handles.Main_Scale_Off.Value    = 0;
else
    handles.Main_Scale_On.Value     = 0;
    handles.Main_Scale_Off.Value    = 1;
end

if TO.Stimuli.Control.FineScale
    handles.Fine_Scale_On.Value     = 1;
    handles.Fine_Scale_Off.Value    = 0;
else
    handles.Fine_Scale_On.Value     = 0;
    handles.Fine_Scale_Off.Value    = 1;
end

% UIWAIT makes StimulusEditGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StimulusEditGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Get default command line output from handles structure
varargout{1} = handles.output;



function Edit_Div_Space_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Div_Space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TO

Input       = get(hObject,'String');
InputVal    = str2double(Input);

handles.Current_Div_Space.String    = Input;
TO.Stimuli.BDM.D_DivSpacing         = InputVal;

UpdateBDMBar;

% Hints: get(hObject,'String') returns contents of Edit_Div_Space as text
%        str2double(get(hObject,'String')) returns contents of Edit_Div_Space as a double


% --- Executes during object creation, after setting all properties.
function Edit_Div_Space_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Div_Space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Div_MBIDEDGE_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Div_MBIDEDGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO

Input       = get(hObject,'String');
InputVal    = str2double(Input);

handles.Current_Div_MBIDEDGE.String = Input;
TO.Stimuli.BDM.D_MBidEdge           = InputVal;

UpdateBDMBar;

% Hints: get(hObject,'String') returns contents of Edit_Div_MBIDEDGE as text
%        str2double(get(hObject,'String')) returns contents of Edit_Div_MBIDEDGE as a double


% --- Executes during object creation, after setting all properties.
function Edit_Div_MBIDEDGE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Div_MBIDEDGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Div_CBIDEDGE_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Div_CBIDEDGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TO

Input       = get(hObject,'String');
InputVal    = str2double(Input);

handles.Current_Div_CBIDEDGE.String = Input;
TO.Stimuli.BDM.D_CBidEdge           = InputVal;

UpdateBDMBar;

% Hints: get(hObject,'String') returns contents of Edit_Div_CBIDEDGE as text
%        str2double(get(hObject,'String')) returns contents of Edit_Div_CBIDEDGE as a double


% --- Executes during object creation, after setting all properties.
function Edit_Div_CBIDEDGE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Div_CBIDEDGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Bar_BaseDistance_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Bar_BaseDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO VisParam

Input       = get(hObject,'String');
InputVal    = str2double(Input);

if (InputVal + TO.Stimuli.BDM.BarHeight) > VisParam.scr_rect(4)
    InputVal = VisParam.scr_rect(4) - TO.Stimuli.BDM.BarHeight;
    Input    = num2str(InputVal);
end

handles.Current_Bar_BaseDistance.String = Input;
TO.Stimuli.Bar.Base_Distance            = InputVal;

UpdateBDMBar;
% Hints: get(hObject,'String') returns contents of Edit_Bar_BaseDistance as text
%        str2double(get(hObject,'String')) returns contents of Edit_Bar_BaseDistance as a double


% --- Executes during object creation, after setting all properties.
function Edit_Bar_BaseDistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Bar_BaseDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Bar_Height_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Bar_Height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO VisParam

Input       = get(hObject,'String');
InputVal    = str2double(Input);

if InputVal > 1
    InputVal = 1;
    Input    = num2str(InputVal);
elseif InputVal < 0
    InputVal = 0;
    Input    = num2str(InputVal);
end



handles.Current_Bar_Height.String = Input;
TO.Stimuli.BDM.BarHeight          = (InputVal*VisParam.scr_rect(4));

UpdateBDMBar;
% Hints: get(hObject,'String') returns contents of Edit_Bar_Height as text
%        str2double(get(hObject,'String')) returns contents of Edit_Bar_Height as a double


% --- Executes during object creation, after setting all properties.
function Edit_Bar_Height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Bar_Height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Main_Scale_Off.
function Main_Scale_Off_Callback(hObject, eventdata, handles)
% hObject    handle to Main_Scale_Off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Main_Scale_Off


% --- Executes when selected object is changed in MainScale_Control.
function MainScale_Control_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in MainScale_Control 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO
Selection = get(eventdata.NewValue,'Tag');

switch Selection
    case 'Main_Scale_On'
        TO.Stimuli.Control.MainScale = true;
    case 'Main_Scale_Off'
        TO.Stimuli.Control.MainScale = false;
end

UpdateBDMBar;


% --- Executes when selected object is changed in FineScale_Control.
function FineScale_Control_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in FineScale_Control 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO
Selection = get(eventdata.NewValue,'Tag');

switch Selection
    case 'Fine_Scale_On'
        TO.Stimuli.Control.FineScale = true;
    case 'Fine_Scale_Off'
        TO.Stimuli.Control.FineScale = false;
end

UpdateBDMBar;
