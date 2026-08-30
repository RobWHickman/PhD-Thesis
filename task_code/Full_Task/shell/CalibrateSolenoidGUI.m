function varargout = CalibrateSolenoidGUI(varargin)
%CALIBRATESOLENOIDGUI M-file for CalibrateSolenoidGUI.fig
% 
% CalibrateSolenoidGUI is a GUI to deliver exact quantitities of juice. The
% user selects the opening time (seconds), the number of pulses (between 1
% and 5) and the delay betwen juice pulses (in seconds). The user can also
% select which solenoid (or setup) should receive the opening pulse. 
%
% After every change in the parameters, the user needs to press the
% 'update' button to make changes to the opening command. The user also
% can also read the command to execute reward delivery in the GUI.
%
% RBM

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalibrateSolenoidGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CalibrateSolenoidGUI_OutputFcn, ...
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


% --- Executes just before CalibrateSolenoidGUI is made visible.
function CalibrateSolenoidGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for CalibrateSolenoidGUI
handles.output = hObject;
handles.pulses = 1;
handles.curLine = 10;
handles.openTime = 0.035;
pushbutton_update_Callback(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = CalibrateSolenoidGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function openTime_Callback(hObject, eventdata, handles)

handles.openTime = str2double(get(hObject,'String'));
pushbutton_update_Callback(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function openTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to openTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function interPulseDelay_Callback(hObject, eventdata, handles)
global IPD
handles.interPulseDelay =str2double(get(hObject,'String'));
IPD = handles.interPulseDelay;
pushbutton_update_Callback(hObject, eventdata, handles)
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function interPulseDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interPulseDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_update.
function pushbutton_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IPD
% put together juice string 
upDownDelay = 0.001;%[latest latency measurements suggest latencies =1ms, Feb 2013]
openTime = handles.openTime-upDownDelay; % DIO up/down adjustment

curJuiceCall = ['DIOjuice(',num2str(openTime),',',num2str(handles.curLine),');'];    
if handles.pulses>1,
    juiceAndDelay = sprintf('%s WaitSecs(%d); ',curJuiceCall, IPD);
    handles.juiceString = [repmat(juiceAndDelay,1,handles.pulses-1), curJuiceCall];
else
    handles.juiceString = curJuiceCall;
end

set(handles.text_currentCall,'String',handles.juiceString)
guidata(handles.pushbutton_update,handles)

% --- Executes on selection change in popupmenu_pulses.
function popupmenu_pulses_Callback(hObject, eventdata, handles)

contents = cellstr(get(hObject,'String')); %returns popupmenu_pulses contents as cell array
handles.pulses = str2double(contents{get(hObject,'Value')}); % returns selected item from popupmenu_pulses
pushbutton_update_Callback(hObject, eventdata, handles);
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_pulses_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_pulses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton_deliver_Callback(hObject, eventdata, handles)
eval(handles.juiceString)


function pushbutton_close_Callback(hObject, eventdata, handles)
close(handes.calibrateSolenoid)

function calibrateSolenoid_CreateFcn(hObject, eventdata, handles)


% --- Executes when selected object is changed in uipanel_setup.
function uipanel_setup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_setup 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global ExtDevice
if handles.radiobutton_A==eventdata.NewValue 
    handles.curLine = ExtDevice.outputDio.juice1.Index;
elseif handles.radiobutton_B==eventdata.NewValue
    handles.curLine = ExtDevice.outputDio.juice2.Index;
end
% Update handles structure
guidata(hObject, handles);
pushbutton_update_Callback(hObject, eventdata, handles);


% --- Executes when user attempts to close calibrateSolenoid.
function calibrateSolenoid_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to calibrateSolenoid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(handles.calibrateSolenoid);
