function varargout = ModigBitMonitor(varargin)
% MODIGBITMONITOR M-file for ModigBitMonitor.fig
%      MODIGBITMONITOR, by itself, creates a new MODIGBITMONITOR or raises the existing
%      singleton*.
%
%      H = MODIGBITMONITOR returns the handle to a new MODIGBITMONITOR or the handle to
%      the existing singleton*.
%
%      MODIGBITMONITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODIGBITMONITOR.M with the given input arguments.
%
%      MODIGBITMONITOR('Property','Value',...) creates a new MODIGBITMONITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ModigBitMonitor_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ModigBitMonitor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModigBitMonitor

% Last Modified by GUIDE v2.5 04-Jun-2008 12:17:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ModigBitMonitor_OpeningFcn, ...
                   'gui_OutputFcn',  @ModigBitMonitor_OutputFcn, ...
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


% --- Executes just before ModigBitMonitor is made visible.
function ModigBitMonitor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ModigBitMonitor (see VARARGIN)

% Choose default command line output for ModigBitMonitor
handles.output = hObject;

if length(varargin)~=2,
   error(['ModigBitMonitor needs as input the input dio object and ',...
       'the output dio object'])
end
handles.inputDio  = varargin{1};
handles.outputDio = varargin{2};

% add line name from dio object to the label of the bits

namesIn= handles.inputDio.Line.LineName;

adH = [0:7; 0:7]'; 
for i = 1:16,
    port = 1+(i>8);
    lnTag = ['checkbox',num2str(port),num2str(adH(i))];
    set(handles.(lnTag),'String',namesIn{i});
end

namesOut= handles.outputDio.Line.LineName;
for i = 1:32,
    lnTag = ['checkbox0',num2str(i-1)];
    set(handles.(lnTag),'String',namesOut{i});
end
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = ModigBitMonitor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14


% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15


% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16
function checkbox17_Callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox017.
function checkbox017_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox017 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox017


% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20


% --- Executes on button press in checkbox21.
function checkbox21_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox21


% --- Executes on button press in checkbox22.
function checkbox22_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22


% --- Executes on button press in checkbox23.
function checkbox23_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox23


% --- Executes on button press in checkbox24.
function checkbox24_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox24


% --- Executes on button press in checkbox25.
function checkbox25_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox25


% --- Executes on button press in checkbox26.
function checkbox26_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox26


% --- Executes on button press in checkbox27.
function checkbox27_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox27


% --- Executes on button press in checkbox00.
function checkbox00_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox00 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox00


% --- Executes on button press in checkbox01.
function checkbox01_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox01


% --- Executes on button press in checkbox02.
function checkbox02_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox02


% --- Executes on button press in checkbox03.
function checkbox03_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox03


% --- Executes on button press in checkbox04.
function checkbox04_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox04


% --- Executes on button press in checkbox05.
function checkbox05_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox05


% --- Executes on button press in checkbox06.
function checkbox06_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox06


% --- Executes on button press in checkbox07.
function checkbox07_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox07


% --- Executes on button press in checkbox08.
function checkbox08_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox08


% --- Executes on button press in checkbox09.
function checkbox09_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox09


% --- Executes on button press in checkbox010.
function checkbox010_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox010 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox010


% --- Executes on button press in checkbox011.
function checkbox011_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox011 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox011


% --- Executes on button press in checkbox012.
function checkbox012_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox012 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox012


% --- Executes on button press in checkbox013.
function checkbox013_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox013 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox013


% --- Executes on button press in checkbox014.
function checkbox014_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox014 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox014


% --- Executes on button press in checkbox015.
function checkbox015_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox015 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox015


% --- Executes on button press in checkbox016.
function checkbox016_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox016 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox016


% --- Executes on button press in checkbox018.
function checkbox018_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox018 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox018


% --- Executes on button press in checkbox019.
function checkbox019_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox019 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox019


% --- Executes on button press in checkbox020.
function checkbox020_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox020 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox020


% --- Executes on button press in checkbox021.
function checkbox021_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox021 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox021


% --- Executes on button press in checkbox022.
function checkbox022_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox022 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox022


% --- Executes on button press in checkbox023.
function checkbox023_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox023 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox023


% --- Executes on button press in checkbox024.
function checkbox024_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox024 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox024


% --- Executes on button press in checkbox025.
function checkbox025_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox025 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox025


% --- Executes on button press in checkbox026.
function checkbox026_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox026 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox026


% --- Executes on button press in checkbox027.
function checkbox027_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox027 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox027


% --- Executes on button press in checkbox028.
function checkbox028_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox028 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox028


% --- Executes on button press in checkbox029.
function checkbox029_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox029 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox029


% --- Executes on button press in checkbox030.
function checkbox030_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox030 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox030


% --- Executes on button press in checkbox031.
function checkbox031_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox031 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox031


% --- Executes on button press in readInput.
function readInput_Callback(hObject, eventdata, handles)
% hObject    handle to readInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of readInput

if  get(hObject,'Value'),
    set(hObject,'String','reading');
    while get(hObject,'Value')==1
        pause(0.25)
        % update all ports...
        inState = getvalue(handles.inputDio);
%         inState = handles.inputDio;
        adH = [0:7; 0:7]'; 
        for i = 1:16,
            port = 1+(i>8);
            lnTag = ['checkbox',num2str(port),num2str(adH(i))];
            set(handles.(lnTag),'Value',inState(i));
        end
    end
    set(hObject,'String','Read');
end

% Update handles structure
guidata(handles.ModigBitMonitor, handles);

% --- Executes on button press in writeInput.
function writeInput_Callback(hObject, eventdata, handles)
% hObject    handle to writeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of writeInput

if get(hObject,'Value')
    handles.inputDio.Line.direction = 'out';
    out = zeros(16,1);
    adH = [0:7; 0:7]'; 
    for i = 1:16,
        port = 1+(i>8);        
        lnTag = ['checkbox',num2str(port),num2str(adH(i))];
        out(i) = get(handles.(lnTag),'Value');
    end
    set(hObject,'Value',0);
    putvalue(handles.inputDio,out);
    handles.inputDio.Line.direction = 'in';
end

% Update handles structure
guidata(handles.ModigBitMonitor, handles);

% --- Executes on button press in readOutput.
function readOutput_Callback(hObject, eventdata, handles)
% hObject    handle to readOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of readOutput

if  get(hObject,'Value'),
    set(hObject,'String','reading');
    handles.outputDio.line.direction = 'in';
    while get(hObject,'Value')==1
        pause(0.2) 
        inState = getvalue(handles.outputDio);
        for i = 1:32,
            lnTag = ['checkbox0',num2str(i-1)];
            set(handles.(lnTag),'Value',inState(i));
        end
    end
   handles.outputDio.line.direction = 'out';
   set(hObject,'String','Read');
end
% Update handles structure
guidata(handles.ModigBitMonitor, handles);

% --- Executes on button press in writeOutput.
function writeOutput_Callback(hObject, eventdata, handles)
% hObject    handle to writeOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of writeOutput
if get(hObject,'Value')
    out = zeros(32,1);
    for i = 1:32,
        lnTag = ['checkbox0',num2str(i-1)];
        out(i) = get(handles.(lnTag),'Value');
    end
    set(hObject,'Value',0);
end

putvalue(handles.outputDio,out)

% Update handles structure
guidata(handles.ModigBitMonitor, handles);


% --- Executes on button press in allOut.
function allOut_Callback(hObject, eventdata, handles)
% hObject    handle to allOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

togOn = get(hObject,'Value');
for i = 1:32,
    lnTag = ['checkbox0',num2str(i-1)];
    set(handles.(lnTag),'Value',togOn);
end  

% Update handles structure
guidata(handles.ModigBitMonitor, handles);

