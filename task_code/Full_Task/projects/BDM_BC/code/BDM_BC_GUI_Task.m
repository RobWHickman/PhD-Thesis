function varargout = BDM_BC_GUI_Task(varargin)
% BDM_BC_GUI MATLAB code for BDM_BC_GUI.fig
%      BDM_BC_GUI, by itself, creates a new BDM_BC_GUI or raises the existing
%      singleton*.
%
%      H = BDM_BC_GUI returns the handle to a new BDM_BC_GUI or the handle to
%      the existing singleton*.
%
%      BDM_BC_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BDM_BC_GUI.M with the given input arguments.
%
%      BDM_BC_GUI('Property','Value',...) creates a new BDM_BC_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BDM_BC_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BDM_BC_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BDM_BC_GUI

% Last Modified by GUIDE v2.5 07-Aug-2017 13:33:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BDM_BC_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BDM_BC_GUI_OutputFcn, ...
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

% --- Executes just before BDM_BC_GUI is made visible.
function BDM_BC_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BDM_BC_GUI (see VARARGIN)

% Choose default command line output for BDM_BC_GUI:
handles.output = hObject;

% Update handles structure:
guidata(hObject, handles);

% UIWAIT makes BDM_BC_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = BDM_BC_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in Set_Defaults.

function Set_Defaults_Callback(hObject, eventdata, handles)
% hObject    handle to Set_Defaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TP TC TG
%% INTERACTIVE FUNCTIONS:
% Load default scripts:
CleanVisParamTextures;
Task_Parameters_BDM_BC;
Task_Objects_BDM_BC;
InitialiseErrorSound;
SetJoyParams(1, 1, 0.05, 0.01);
TP.Effector = 'Joy';
% GUI setting values at current parameter values:
UpdateSettings('SetUp');
handles.SetDefaults_IO.BackgroundColor = [0 1 0];
handles.Comments_Text.String = 'Default settings loaded';
% Set defaults:
handles.Set_Marker.Value    = 1 - (+TP.BDM.VaryMarkerPos);
handles.Rand_Marker.Value   = +TP.BDM.VaryMarkerPos;
handles.Current_MP.String   = num2str(TO.Rewards.Water.BDM.RelMPos);
handles.Current_MV.String   = num2str(TO.Rewards.Water.BDM.MMVar);
handles.JGain_Current.String= num2str(TP.BDM.Joy.Gain);

switch TC.All.SessionType
    case 'BDM'
        handles.BDM_Only.Value = 1;
        handles.BCb_Only.Value = 0;
        handles.Both_Only.Value = 0;
    case 'BCb'
        handles.BDM_Only.Value = 0;
        handles.BCb_Only.Value = 1;
        handles.Both_Only.Value = 0;
    case 'BDM/BCb'
        handles.BDM_Only.Value = 0;
        handles.BCb_Only.Value = 0;
        handles.Both_Only.Value = 1;
end

handles.BDM_BH_Set.Value    = TP.BDM.JuiceSet(1);
handles.BDM_BM_Set.Value    = TP.BDM.JuiceSet(2);
handles.BDM_BL_Set.Value    = TP.BDM.JuiceSet(3);
handles.BCb_BH_Set.Value    = TP.BCb.JuiceSet(1);
handles.BCb_BM_Set.Value    = TP.BCb.JuiceSet(2);
handles.BCb_BL_Set.Value    = TP.BCb.JuiceSet(3);
handles.BDM_WH_Set.Value    = TP.BDM.JuiceSet(4);
handles.BDM_WM_Set.Value    = TP.BDM.JuiceSet(5);
handles.BDM_WL_Set.Value    = TP.BDM.JuiceSet(6);
handles.BCb_WH_Set.Value    = TP.BCb.JuiceSet(4);
handles.BCb_WM_Set.Value    = TP.BCb.JuiceSet(5);
handles.BCb_WL_Set.Value    = TP.BCb.JuiceSet(6);
handles.BDM_OH_Set.Value    = TP.BDM.JuiceSet(7);
handles.BDM_OM_Set.Value    = TP.BDM.JuiceSet(8);
handles.BDM_OL_Set.Value    = TP.BDM.JuiceSet(9);
handles.BCb_OH_Set.Value    = TP.BCb.JuiceSet(7);
handles.BCb_OM_Set.Value    = TP.BCb.JuiceSet(8);
handles.BCb_OL_Set.Value    = TP.BCb.JuiceSet(9);
handles.BDM_NR_Set.Value    = TP.BDM.JuiceSet(10);
handles.BCb_NR_Set.Value    = TP.BCb.JuiceSet(10);

handles.Current_NDIVS.String = num2str(TO.Params.BDM.D_nDivs);

switch TP.BDM.CurrencyType
    case 'W'
        handles.Blackcurrant_Currency.Value = 0;
        handles.Water_Currency.Value        = 1;
    case 'B'
        handles.Blackcurrant_Currency.Value = 1;
        handles.Water_Currency.Value        = 0;
end

switch TC.BDM.BlockType
    case 'R'
        handles.BDM_Random_JBlocks.Value    = 1;
        handles.BDM_Blocked_JBlocks.Value   = 0;
    case 'B'
        handles.BDM_Blocked_JBlocks.Value   = 1;
        handles.BDM_Random_JBlocks.Value    = 0;
end

switch TC.BCb.BlockType
    case 'R'
        handles.BCb_Random_JBlocks.Value    = 1;
        handles.BCb_Blocked_JBlocks.Value   = 0;
    case 'B'
        handles.BCb_Random_JBlocks.Value    = 0;
        handles.BCb_Blocked_JBlocks.Value   = 1;
end

if TP.BCb.BiasFix == 1
    handles.Bias_Fix_Mode.Value = 1;
else
    handles.Bias_Fix_Mode.Value = 0;
end

handles.BCb_Logit_Type.Value = 0;
TG.BCb.Logit_Mode = 'All';
    
% --- Executes on button press in Set_Parameters.
function Set_Parameters_Callback(hObject, eventdata, handles)
% hObject    handle to Set_Parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Run scripts to prepare session:
global TC TP
[TC.All.TrialType, TC.BDM.Block, TC.BCb.Block]  = SessionBlockType(TC.All.SessionType, TP.BDM.BlockS, TP.BCb.BlockS);

handles.Comments_Text.String = 'Trial type block vector set';
% Indicate that trial is ready:
handles.Parameters_IO.BackgroundColor = [0 1 0];

% --- Executes on button press in JuiceVector_IO.
function JuiceVector_IO_Callback(hObject, eventdata, handles)
global TC TP
[TC.BDM.RewardIDs, TC.BCb.RewardIDs] = JuiceBlockType(TP.BDM.JuiceSet,TP.BCb.JuiceSet,TC.BDM.BlockType,TC.BCb.BlockType,TP.BDM.JBlockS,TP.BCb.JBlockS);
handles.JuiceBlock_IO.BackgroundColor = [0 1 0];
handles.Comments_Text.String = 'Juice vectors set';
% hObject    handle to JuiceVector_IO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Data_IO.
function Set_DataCell_Callback(hObject, eventdata, handles)
% hObject    handle to Data_IO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TC

if isfield(TC.All,'MonkeyID')
% Prepare title and run function to set-up cell:
    MonkeyName          = TC.All.MonkeyID;
    Time                = datestr(now);
    Time                = Time(end-7:end);
    Time(Time == ':')   = '_';
    TC.All.DataTitle    = strcat(MonkeyName,'_BDM_BC_',Time(end-7:end),'_');
    PrepareDataCell(3,TC.All.DataTitle);

    % Set the colour of the marker to indicate 'ON' state:
    handles.Data_IO.BackgroundColor = [0 1 0];
    handles.Comments_Text.String = 'Data cell set-up';
else
    handles.Comments_Text.String = 'Must set a monkeyID first!';
end


%% JOYSTICK SETTINGS:
function Joy_Centre_E_Callback(hObject, eventdata, handles)
global TG IO
Input = str2double(get(hObject,'String'));
if Input == 1 || Input == 0
IO.Input.joy.DefCentreFix = Input;
set(TG.BDM_BC_GUI.Handles.Joy_Centre,'String',num2str(IO.Input.joy.DefCentreFix));
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
handles.Comments_Text.String = 'Joy centre requirement set';
else
    handles.Comments_Text.String = 'Joy centre value must be 0 or 1';
end
% function Joy_Centre_E_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

function Joy_Centre_Threshold_E_Callback(hObject, eventdata, handles)
global TG IO
Input = str2double(get(hObject,'String'));
if Input <= 0.5 && Input >= 0
IO.Input.joy.Centre_Threshold = Input;
set(TG.BDM_BC_GUI.Handles.Joy_Centre_Threshold,'String',num2str(IO.Input.joy.Centre_Threshold));
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
handles.Comments_Text.String = 'Joy centre threshold set';
else
    handles.Comments_Text.String = 'Joy centre threshold must be between 0 and 0.5';
end
% function Joy_Centre_Threshold_E_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

function Joy_Sensitivity_Threshold_E_Callback(hObject, eventdata, handles)
global TG IO
Input = str2double(get(hObject,'String'));
if Input <= 0.1 && Input >= 0
IO.Input.joy.Sensitivity_Threshold = Input;
set(TG.BDM_BC_GUI.Handles.Joy_Sensitivity_Threshold,'String',num2str(IO.Input.joy.Sensitivity_Threshold));
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
handles.Comments_Text.String = 'Joy sensitivity threshold set';
else
handles.Comments_Text.String = 'Joy sensitivity threshold must be between 0 and 0.1';
end
% function Joy_Sensitivity_Threshold_E_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

function Joy_Use_E_Callback(hObject, eventdata, handles)
global IO TG
Input = str2double(get(hObject,'String'));
if Input == 1 || Input == 0
IO.Input.joy.monitor = Input;
set(TG.BDM_BC_GUI.Handles.Joy_Use,'String',num2str(IO.Input.joy.monitor));
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
handles.Comments_Text.String = 'Joystick monitor set';
else
    handles.Comments_Text.String = 'Joystick monitor value must be 0 or 1';
end

% --- Executes during object creation, after setting all properties.
function Set_Parameters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Set_Parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Set_DataCell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Set_DataCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Joy_Use_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joy_Use_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Joy_Sensitivity_Threshold_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joy_Sensitivity_Threshold_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Joy_Centre_Threshold_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joy_Centre_Threshold_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Joy_Centre_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joy_Centre_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Joy_Window_E_Callback(hObject, eventdata, handles)
% hObject    handle to Joy_Window_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Joy_Window_E as text
%        str2double(get(hObject,'String')) returns contents of Joy_Window_E as a double
global TP TG
Input = str2double(get(hObject,'String'));
if Input <= 100 && Input >= 1 && floor(Input) == Input
TP.BDM.Joy.Window = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.Joy_Window,'String',num2str(TP.BDM.Joy.Window));
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
handles.Comments_Text.String = 'Joystick window set';
else
    handles.Comments_Text.String = 'Joystick window must be an integer between 1 and 100';
end

% --- Executes during object creation, after setting all properties.
function Joy_Window_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joy_Window_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% SESSION SETTINGS:

function MonkeyID_E_Callback(hObject, eventdata, handles)
% hObject    handle to MonkeyID_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TC TG TP TO IO
Input = get(hObject,'String');
if strcmpi(Input,'U') || strcmpi(Input,'V')
    TC.All.MonkeyID = Input;
    set(TG.BDM_BC_GUI.Handles.MonkeyID,'String',TC.All.MonkeyID);
    guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
    handles.Comments_Text.String = 'Monkey ID set';
else
    handles.Comments_Text.String = 'Monkey ID must be either (U)lysses or (V)icer';
end

%% DEFAULTS FOR EACH MONKEY:
if strcmpi(TC.All.MonkeyID,'U') %% ULYSSES
    
    U_BDMBC_DEFAULTS
    
elseif strcmpi(TC.All.MonkeyID,'V') %% VICER
    
    V_BDMBC_DEFAULTS

end
% Hints: get(hObject,'String') returns contents of MonkeyID_E as text
%        str2double(get(hObject,'String')) returns contents of MonkeyID_E as a double


% --- Executes during object creation, after setting all properties.
function MonkeyID_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MonkeyID_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% BIDDING SETTINGS:

function C_Dist_E_Callback(hObject, eventdata, handles)
% hObject    handle to C_Dist_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'String');
if strcmpi(Input,'U') || strcmpi(Input,'P') || strcmpi(Input,'C')
    TP.BDM.CDistType = Input;
    set(TG.BDM_BC_GUI.Handles.C_Dist,'String',TP.BDM.CDistType);
    guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
    handles.Comments_Text.String = 'Computer distribution set';
else
    handles.Comments_Text.String = 'Distribution must be "(U)niform","(P)eaked" OR "(C)ustom"!';
end
% Hints: get(hObject,'String') returns contents of C_Dist_E as text
%        str2double(get(hObject,'String')) returns contents of C_Dist_E as a double


% --- Executes during object creation, after setting all properties.
function C_Dist_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C_Dist_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bidding_Type_E_Callback(hObject, eventdata, handles)
% hObject    handle to Bidding_Type_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'String');
if strcmpi(Input,'C') || strcmpi(Input,'D')
    TP.BDM.BiddingType = Input;
    set(TG.BDM_BC_GUI.Handles.Bidding_Type,'String',TP.BDM.BiddingType);
    guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
    handles.Comments_Text.String = 'Bidding type set';
else
    handles.Comments_Text.String = 'Bidding type must be "(C)ontinuous" OR "(D)iscrete"';
end
% Hints: get(hObject,'String') returns contents of Bidding_Type_E as text
%        str2double(get(hObject,'String')) returns contents of Bidding_Type_E as a double


% --- Executes during object creation, after setting all properties.
function Bidding_Type_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bidding_Type_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fixed_Alpha_E_Callback(hObject, eventdata, handles)
% hObject    handle to Fixed_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
% Hints: get(hObject,'String') returns contents of Fixed_Alpha_E as text
%        str2double(get(hObject,'String')) returns contents of Fixed_Alpha_E as a double
TP.BDM.FixedAlpha = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.Fixed_Alpha,'String',num2str(TP.BDM.FixedAlpha));
handles.Comments_Text.String = 'Fixed Alpha value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);


% --- Executes during object creation, after setting all properties.
function Fixed_Alpha_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fixed_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fixed_Beta_E_Callback(hObject, eventdata, handles)
% hObject    handle to Fixed_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
TP.BDM.FixedBeta = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.Fixed_Beta,'String',num2str(TP.BDM.FixedBeta));
handles.Comments_Text.String = 'Fixed Beta value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of Fixed_Beta_E as text
%        str2double(get(hObject,'String')) returns contents of Fixed_Beta_E as a double


% --- Executes during object creation, after setting all properties.
function Fixed_Beta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fixed_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BH_Alpha_E_Callback(hObject, eventdata, handles)
% hObject    handle to BH_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.B_High.PCoeffs(1) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.BH_Alpha,'String',num2str(TO.Rewards.B_High.PCoeffs(1)));
handles.Comments_Text.String = 'BH Alpha value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);

% --- Executes during object creation, after setting all properties.
function BH_Alpha_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BH_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BH_Beta_E_Callback(hObject, eventdata, handles)
% hObject    handle to BH_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.B_High.PCoeffs(2) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.BH_Beta,'String',num2str(TO.Rewards.B_High.PCoeffs(2)));
handles.Comments_Text.String = 'BH Beta value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);

% --- Executes during object creation, after setting all properties.
function BH_Beta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BH_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BM_Alpha_E_Callback(hObject, eventdata, handles)
% hObject    handle to BM_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.B_Mid.PCoeffs(1) = str2double(get(hObject,'String'));
handles.Comments_Text.String = 'BM Alpha value set';
set(TG.BDM_BC_GUI.Handles.BM_Alpha,'String',num2str(TO.Rewards.B_Mid.PCoeffs(1)));
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);

% --- Executes during object creation, after setting all properties.
function BM_Alpha_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BM_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BM_Beta_E_Callback(hObject, eventdata, handles)
% hObject    handle to BM_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.B_Mid.PCoeffs(2) = str2double(get(hObject,'String'));
handles.Comments_Text.String = 'BM Beta value set';
set(TG.BDM_BC_GUI.Handles.BM_Beta,'String',num2str(TO.Rewards.B_Mid.PCoeffs(2)));
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);


% --- Executes during object creation, after setting all properties.
function BM_Beta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BM_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BL_Alpha_E_Callback(hObject, eventdata, handles)
% hObject    handle to BL_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.B_Low.PCoeffs(1) = str2double(get(hObject,'String'));
handles.Comments_Text.String = 'BL Alpha value set';
set(TG.BDM_BC_GUI.Handles.BL_Alpha,'String',num2str(TO.Rewards.B_Low.PCoeffs(1)));
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);


% --- Executes during object creation, after setting all properties.
function BL_Alpha_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BL_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BL_Beta_E_Callback(hObject, eventdata, handles)
% hObject    handle to BL_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.B_Low.PCoeffs(2) = str2double(get(hObject,'String'));
handles.Comments_Text.String = 'BL Beta value set';
set(TG.BDM_BC_GUI.Handles.BL_Beta,'String',num2str(TO.Rewards.B_Low.PCoeffs(2)));
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);


% --- Executes during object creation, after setting all properties.
function BL_Beta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BL_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BDM_BH_Set.
function BDM_BH_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_BH_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BDM.JuiceSet(1) = 1;
    handles.Comments_Text.String = 'BH in BDM';
else
    TP.BDM.JuiceSet(1) = 0;
    handles.Comments_Text.String = 'BH excluded from BDM';
end

handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);

% --- Executes on button press in BDM_BM_Set.
function BDM_BM_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_BM_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BDM.JuiceSet(2) = 1;
    handles.Comments_Text.String = 'BM in BDM';
else
    TP.BDM.JuiceSet(2) = 0;
    handles.Comments_Text.String = 'BM excluded from BDM';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);


% --- Executes on button press in BDM_BL_Set.
function BDM_BL_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_BL_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BDM.JuiceSet(3) = 1;
    handles.Comments_Text.String = 'BL in BDM';
else
    TP.BDM.JuiceSet(3) = 0;
    handles.Comments_Text.String = 'BL excluded from BDM';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);


% --- Executes on button press in BDM_Only.
function BDM_Only_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_Only (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BDM_Only


% --- Executes when Session_Type is resized.
function Session_Type_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Session_Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in Session_Type.
function Session_Type_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Session_Type 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG TC
Selection = get(eventdata.NewValue,'Tag');

switch Selection
    case 'BDM_Only'
        TC.All.SessionType = 'BDM';
        handles.Comments_Text.String = 'BDM only session';
    case 'BCb_Only'
        TC.All.SessionType = 'BCb';
        handles.Comments_Text.String = 'BCb only session';
    case 'Both_Only'
        TC.All.SessionType = 'BDM/BCb';
        handles.Comments_Text.String = 'Both BDM and BCb in session';
end

handles.Parameters_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);


% --- Executes when selected object is changed in Juice_Blocking.
function Juice_Blocking_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Juice_Blocking 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG TC
Selection = get(eventdata.NewValue,'Tag');

switch Selection
    case 'BDM_Random_JBlocks'
        TC.BDM.BlockType = 'R';
        handles.Comments_Text.String = 'BDM juice blocks random';
    case 'BDM_Blocked_JBlocks'
        TC.BDM.BlockType = 'B';
        handles.Comments_Text.String = 'BDM juice in blocks';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);



function BDM_Block_Length_E_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_Block_Length_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG TP
handles.Comments_Text.String = 'BDM block length set';
TP.BDM.BlockS = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.BDM_Block_Length,'String',num2str(TP.BDM.BlockS));
handles.Parameters_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);

% Hints: get(hObject,'String') returns contents of BDM_Block_Length_E as text
%        str2double(get(hObject,'String')) returns contents of BDM_Block_Length_E as a double


% --- Executes during object creation, after setting all properties.
function BDM_Block_Length_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BDM_Block_Length_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BCb_BL_Set.
function BCb_BL_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_BL_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BCb.JuiceSet(3) = 1;
    handles.Comments_Text.String = 'BL in BCb';
else
    TP.BCb.JuiceSet(3) = 0;
    handles.Comments_Text.String = 'BL excluded from BCb';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BCb_BL_Set


% --- Executes on button press in BCb_BM_Set.
function BCb_BM_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_BM_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BCb.JuiceSet(2) = 1;
    handles.Comments_Text.String = 'BM in BCb';
else
    TP.BCb.JuiceSet(2) = 0;
    handles.Comments_Text.String = 'BM excluded from BCb';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BCb_BM_Set


% --- Executes on button press in BCb_BH_Set.
function BCb_BH_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_BH_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BCb.JuiceSet(1) = 1;
    handles.Comments_Text.String = 'BH in BCb';
else
    TP.BCb.JuiceSet(1) = 0;
    handles.Comments_Text.String = 'BH excluded form BCb';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BCb_BH_Set



function BCb_Block_Length_E_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_Block_Length_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG TP

TP.BCb.BlockS = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.BCb_Block_Length,'String',num2str(TP.BCb.BlockS));
handles.Comments_Text.String = 'BCb block length set';
handles.Parameters_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);

% Hints: get(hObject,'String') returns contents of BCb_Block_Length_E as text
%        str2double(get(hObject,'String')) returns contents of BCb_Block_Length_E as a double


% --- Executes during object creation, after setting all properties.
function BCb_Block_Length_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BCb_Block_Length_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in Juice_Blocking_BCB.
function Juice_Blocking_BCB_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Juice_Blocking_BCB 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG TC
Selection = get(eventdata.NewValue,'Tag');

switch Selection
    case 'BCb_Random_JBlocks'
        TC.BCb.BlockType = 'R';
        handles.Comments_Text.String = 'BCb juice blocks random';
    case 'BCb_Blocked_JBlocks'
        TC.BCb.BlockType = 'B';
        handles.Comments_Text.String = 'BCb juice in blocks';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);



function BDM_JBlock_Length_E_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_JBlock_Length_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG TP
handles.Comments_Text.String = 'BDM juice block length set';
TP.BDM.JBlockS = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.BDM_JBlock_Length,'String',num2str(TP.BDM.JBlockS));
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of BDM_JBlock_Length_E as text
%        str2double(get(hObject,'String')) returns contents of BDM_JBlock_Length_E as a double


% --- Executes during object creation, after setting all properties.
function BDM_JBlock_Length_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BDM_JBlock_Length_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BCb_JBlock_Lenth_E_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_JBlock_Lenth_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG TP
handles.Comments_Text.String = 'BCb juice block length set';
TP.BCb.JBlockS = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.BCb_JBlock_Length,'String',num2str(TP.BCb.JBlockS));
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of BCb_JBlock_Lenth_E as text
%        str2double(get(hObject,'String')) returns contents of BCb_JBlock_Lenth_E as a double


% --- Executes during object creation, after setting all properties.
function BCb_JBlock_Lenth_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BCb_JBlock_Lenth_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BM_Control.
function BM_Control_Callback(hObject, eventdata, handles)
% hObject    handle to BM_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG
if length(TO.Rewards.B_Mid.PCoeffs) == 2
if isfield(TG.BDM_BC_GUI.Handles,'BMP')
    delete(TG.BDM_BC_GUI.Handles.BMP)
end
x = [0:0.01:1];
y = betapdf(x,TO.Rewards.B_Mid.PCoeffs(1),TO.Rewards.B_Mid.PCoeffs(2));
TG.BDM_BC_GUI.Handles.BMP = plot(handles.BDM_Axes,x,y, 'g');
hold(handles.BDM_Axes,'on')
end

% --- Executes on button press in BL_Control.
function BL_Control_Callback(hObject, eventdata, handles)
% hObject    handle to BL_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Graph distribution:
global TO TG
if length(TO.Rewards.B_Low.PCoeffs) == 2
if isfield(TG.BDM_BC_GUI.Handles,'BLP')
    delete(TG.BDM_BC_GUI.Handles.BLP)
end
x = [0:0.01:1];
y = betapdf(x,TO.Rewards.B_Low.PCoeffs(1),TO.Rewards.B_Low.PCoeffs(2));
TG.BDM_BC_GUI.Handles.BLP = plot(handles.BDM_Axes,x,y, 'b');
hold(handles.BDM_Axes,'on')
end

% --- Executes on button press in BH_Control.
function BH_Control_Callback(hObject, eventdata, handles)
% hObject    handle to BH_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG
if length(TO.Rewards.B_High.PCoeffs) == 2
if isfield(TG.BDM_BC_GUI.Handles,'BHP')
    delete(TG.BDM_BC_GUI.Handles.BHP)
end
x = [0:0.01:1];
y = betapdf(x,TO.Rewards.B_High.PCoeffs(1),TO.Rewards.B_High.PCoeffs(2));
TG.BDM_BC_GUI.Handles.BHP = plot(handles.BDM_Axes,x,y, 'r');
hold(handles.BDM_Axes,'on')
end



function Marker_Pos_Callback(hObject, eventdata, handles)
% hObject    handle to Marker_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TP

Input = str2double(get(hObject,'String'));
if Input > 1
    Input = 1;
elseif Input < 0
    Input = 0;
end

handles.Current_MP.String           = num2str(Input);

if ~TP.BDM.VaryMarkerPos

TO.Rewards.Water.BDM.RelMPos        = Input;
TO.Rewards.Water.BDM.MMDefPos(2)    = TO.Rewards.Water.BDM.MMIniPos(2) - (Input*TO.Params.BDM.BarRange);
TO.Rewards.Water.BDM.MMDefPos(4)    = TO.Rewards.Water.BDM.MMIniPos(4) - (Input*TO.Params.BDM.BarRange);
TO.Rewards.Water.BDM.MMPos          = TO.Rewards.Water.BDM.MMDefPos;

TO.Rewards.Water.BDM.VarID          = ceil(Input*TO.Params.BDM.D_nDivs);

if TO.Rewards.Water.BDM.VarID == 0
    TO.Rewards.Water.BDM.VarID = 1;
end

TO.Rewards.Water.BDM.DMMDefPos      = TO.Stimuli.BDM.D_PosMat(TO.Rewards.Water.BDM.VarID,:);
TO.Rewards.Water.BDM.DMMDefPos(3)   = TO.Rewards.Water.BDM.DMMDefPos(3) + TO.Stimuli.BDM.D_MBidEdge;
    
handles.Comments_Text.String = strcat('Marker position changed to:',num2str(Input));

else
    
    handles.Comments_Text.String = 'Marker position not changed, using random MMPOS';

end
    
% Hints: get(hObject,'String') returns contents of Marker_Pos as text
%        str2double(get(hObject,'String')) returns contents of Marker_Pos as a double


% --- Executes during object creation, after setting all properties.
function Marker_Pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Marker_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in Marker_Rand_Group.
function Marker_Rand_Group_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Marker_Rand_Group 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'Rand_Marker'
        TP.BDM.VaryMarkerPos = true;
    case 'Set_Marker'
        TP.BDM.VaryMarkerPos = false;
end



function Marker_Var_Callback(hObject, eventdata, handles)
% hObject    handle to Marker_Var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TP

Input = str2double(get(hObject,'String'));
if Input > 1
    Input = 1;
elseif Input < 0
    Input = 0;
end

handles.Current_MV.String  = num2str(Input);
if TP.BDM.VaryMarkerPos
    TO.Rewards.Water.BDM.MMVar = Input;
    handles.Comments_Text.String = strcat('Marker variability changed to:',num2str(Input));
    TO.Rewards.Water.BDM.VarRelPos = zeros(1,1000);
    for k = 1:1000
        TO.Rewards.Water.BDM.VarRelPos(k) = TO.Rewards.Water.BDM.MMVar*rand;
    end
else
    handles.Comments_Text.String = 'Marker variability not changed, currently using set values';
end


% Hints: get(hObject,'String') returns contents of Marker_Var as text
%        str2double(get(hObject,'String')) returns contents of Marker_Var as a double


% --- Executes during object creation, after setting all properties.
function Marker_Var_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Marker_Var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function JGain_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to JGain_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP

Input = str2double(get(hObject,'String'));

if Input < 1
    Input = 1;
end

handles.JGain_Current.String= num2str(Input);
handles.Comments_Text.String = strcat('Joystick gain set to:',num2str(Input));

TP.BDM.Joy.Gain = Input;
% TP.BCb.Joy.Gain = Input;

% Hints: get(hObject,'String') returns contents of JGain_Edit as text
%        str2double(get(hObject,'String')) returns contents of JGain_Edit as a double


% --- Executes during object creation, after setting all properties.
function JGain_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JGain_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in Currency_Select.
function Currency_Select_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Currency_Select 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TO VisParam

switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'Water_Currency'
        TP.BDM.CurrencyType = 'W';
        TO.Rewards.Water.Type                                                                = 'Water';
        [TO.Rewards.Water.BDM.Bar, TO.Rewards.Water.BDM.Border, Pos]                         = MakeBDMBar('Right', VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, TO.Stimuli.Bar.Lc, TO.Stimuli.Bar.Rc, TO.Params.BDM.DBarRange, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
        [TO.Rewards.Water.BCb.BarLeftPosition, TO.Rewards.Water.BCb.BarLBorder, BarLPos_b]   = MakeBDMBar('Left',VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, TP.BCb.LeftLimit, TP.BCb.LeftLimit, TO.Params.BDM.DBarRange, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
        [TO.Rewards.Water.BCb.BarRightPosition, TO.Rewards.Water.BCb.BarRBorder, BarRPos_b]  = MakeBDMBar('Right',VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, TP.BCb.RightLimit, TP.BCb.RightLimit, TO.Params.BDM.DBarRange, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
        TO.Stimuli.BDM.Fixation                                                              = MakeFixation('Cross',VisParam.scr_handle, [250 250 0]); %Y
        TO.Stimuli.BCb.Fixation                                                              = MakeFixation('Square',VisParam.scr_handle, [250 250 0]); %Y
    case 'Blackcurrant_Currency'
        TP.BDM.CurrencyType = 'B';
        TO.Rewards.Water.Type                                                                = 'Blackcurrant';
        [TO.Rewards.Water.BCb.BarLeftPosition, TO.Rewards.Water.BCb.BarLBorder, BarLPos_b]   = MakeBDMBar('Left',VisParam.scr_handle, TO.Stimuli.Bar.Juice_Color, TP.BCb.LeftLimit, TP.BCb.LeftLimit, TO.Params.BDM.DBarRange, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
        [TO.Rewards.Water.BCb.BarRightPosition, TO.Rewards.Water.BCb.BarRBorder, BarRPos_b]  = MakeBDMBar('Right',VisParam.scr_handle, TO.Stimuli.Bar.Juice_Color, TP.BCb.RightLimit, TP.BCb.RightLimit, TO.Params.BDM.DBarRange, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
        [TO.Rewards.Water.BDM.Bar, TO.Rewards.Water.BDM.Border, Pos]                         = MakeBDMBar('Right', VisParam.scr_handle, TO.Stimuli.Bar.Juice_Color, TO.Stimuli.Bar.Lc, TO.Stimuli.Bar.Rc, TO.Params.BDM.DBarRange, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance); % Light pink bar for blackcurrant.
        TO.Stimuli.BDM.Fixation                                                              = MakeFixation('Cross',VisParam.scr_handle, [250 0 0]); %RED
        TO.Stimuli.BCb.Fixation                                                              = MakeFixation('Square',VisParam.scr_handle, [250 0 0]);%RED
end


% --- Executes on button press in BDM_OH_Set.
function BDM_OH_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_OH_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BDM.JuiceSet(7) = 1;
    handles.Comments_Text.String = 'OH in BDM';
else
    TP.BDM.JuiceSet(7) = 0;
    handles.Comments_Text.String = 'OH excluded from BDM';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BDM_OH_Set


% --- Executes on button press in BDM_OM_Set.
function BDM_OM_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_OM_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BDM.JuiceSet(8) = 1;
    handles.Comments_Text.String = 'OM in BDM';
else
    TP.BDM.JuiceSet(8) = 0;
    handles.Comments_Text.String = 'OM excluded from BDM';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BDM_OM_Set


% --- Executes on button press in BDM_OL_Set.
function BDM_OL_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_OL_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BDM.JuiceSet(9) = 1;
    handles.Comments_Text.String = 'OL in BDM';
else
    TP.BDM.JuiceSet(9) = 0;
    handles.Comments_Text.String = 'OL excluded from BDM';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BDM_OL_Set


% --- Executes on button press in BDM_WH_Set.
function BDM_WH_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_WH_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BDM.JuiceSet(4) = 1;
    handles.Comments_Text.String = 'WH in BDM';
else
    TP.BDM.JuiceSet(4) = 0;
    handles.Comments_Text.String = 'WH excluded from BDM';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BDM_WH_Set


% --- Executes on button press in BDM_WM_Set.
function BDM_WM_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_WM_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BDM.JuiceSet(5) = 1;
    handles.Comments_Text.String = 'WM in BDM';
else
    TP.BDM.JuiceSet(5) = 0;
    handles.Comments_Text.String = 'WM excluded from BDM';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BDM_WM_Set


% --- Executes on button press in BDM_WL_Set.
function BDM_WL_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_WL_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BDM.JuiceSet(6) = 1;
    handles.Comments_Text.String = 'WL in BDM';
else
    TP.BDM.JuiceSet(6) = 0;
    handles.Comments_Text.String = 'WL excluded from BDM';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BDM_WL_Set


% --- Executes on button press in BCb_OH_Set.
function BCb_OH_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_OH_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BCb.JuiceSet(7) = 1;
    handles.Comments_Text.String = 'OH in BCb';
else
    TP.BCb.JuiceSet(7) = 0;
    handles.Comments_Text.String = 'OH excluded from BCb';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BCb_OH_Set


% --- Executes on button press in BCb_OM_Set.
function BCb_OM_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_OM_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BCb.JuiceSet(8) = 1;
    handles.Comments_Text.String = 'OM in BCb';
else
    TP.BCb.JuiceSet(8) = 0;
    handles.Comments_Text.String = 'OM excluded from BCb';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BCb_OM_Set


% --- Executes on button press in BCb_OL_Set.
function BCb_OL_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_OL_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BCb.JuiceSet(9) = 1;
    handles.Comments_Text.String = 'OL in BCb';
else
    TP.BCb.JuiceSet(9) = 0;
    handles.Comments_Text.String = 'OL excluded from BCb';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BCb_OL_Set


% --- Executes on button press in BCb_WH_Set.
function BCb_WH_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_WH_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BCb.JuiceSet(4) = 1;
    handles.Comments_Text.String = 'WH in BCb';
else
    TP.BCb.JuiceSet(4) = 0;
    handles.Comments_Text.String = 'WH excluded from BCb';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BCb_WH_Set


% --- Executes on button press in BCb_WM_Set.
function BCb_WM_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_WM_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BCb.JuiceSet(5) = 1;
    handles.Comments_Text.String = 'WM in BCb';
else
    TP.BCb.JuiceSet(5) = 0;
    handles.Comments_Text.String = 'WM excluded from BCb';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BCb_WM_Set


% --- Executes on button press in BCb_WL_Set.
function BCb_WL_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_WL_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BCb.JuiceSet(6) = 1;
    handles.Comments_Text.String = 'WL in BCb';
else
    TP.BCb.JuiceSet(6) = 0;
    handles.Comments_Text.String = 'WL excluded from BCb';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BCb_WL_Set



function OH_Alpha_E_Callback(hObject, eventdata, handles)
% hObject    handle to OH_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.O_High.PCoeffs(1) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.OH_Alpha,'String',num2str(TO.Rewards.O_High.PCoeffs(1)));
handles.Comments_Text.String = 'OH Alpha value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of OH_Alpha_E as text
%        str2double(get(hObject,'String')) returns contents of OH_Alpha_E as a double


% --- Executes during object creation, after setting all properties.
function OH_Alpha_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OH_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OM_Alpha_E_Callback(hObject, eventdata, handles)
% hObject    handle to OM_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.O_Mid.PCoeffs(1) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.OM_Alpha,'String',num2str(TO.Rewards.O_Mid.PCoeffs(1)));
handles.Comments_Text.String = 'OM Alpha value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of OM_Alpha_E as text
%        str2double(get(hObject,'String')) returns contents of OM_Alpha_E as a double


% --- Executes during object creation, after setting all properties.
function OM_Alpha_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OM_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OL_Alpha_E_Callback(hObject, eventdata, handles)
% hObject    handle to OL_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.O_Low.PCoeffs(1) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.OL_Alpha,'String',num2str(TO.Rewards.O_Low.PCoeffs(1)));
handles.Comments_Text.String = 'OL Alpha value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of OL_Alpha_E as text
%        str2double(get(hObject,'String')) returns contents of OL_Alpha_E as a double


% --- Executes during object creation, after setting all properties.
function OL_Alpha_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OL_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OH_Beta_E_Callback(hObject, eventdata, handles)
% hObject    handle to OH_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.O_High.PCoeffs(2) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.OH_Beta,'String',num2str(TO.Rewards.O_High.PCoeffs(2)));
handles.Comments_Text.String = 'OH Beta value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of OH_Beta_E as text
%        str2double(get(hObject,'String')) returns contents of OH_Beta_E as a double


% --- Executes during object creation, after setting all properties.
function OH_Beta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OH_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OM_Beta_E_Callback(hObject, eventdata, handles)
% hObject    handle to OM_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.O_Mid.PCoeffs(2) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.OM_Beta,'String',num2str(TO.Rewards.O_Mid.PCoeffs(2)));
handles.Comments_Text.String = 'OM Beta value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of OM_Beta_E as text
%        str2double(get(hObject,'String')) returns contents of OM_Beta_E as a double


% --- Executes during object creation, after setting all properties.
function OM_Beta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OM_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OL_Beta_E_Callback(hObject, eventdata, handles)
% hObject    handle to OL_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.O_Low.PCoeffs(2) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.OL_Beta,'String',num2str(TO.Rewards.O_Low.PCoeffs(2)));
handles.Comments_Text.String = 'OL Beta value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of OL_Beta_E as text
%        str2double(get(hObject,'String')) returns contents of OL_Beta_E as a double


% --- Executes during object creation, after setting all properties.
function OL_Beta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OL_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OL_Control.
function OL_Control_Callback(hObject, eventdata, handles)
% hObject    handle to OL_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG
if length(TO.Rewards.O_Low.PCoeffs) == 2
if isfield(TG.BDM_BC_GUI.Handles,'OLP')
    delete(TG.BDM_BC_GUI.Handles.OLP)
end
x = [0:0.01:1];
y = betapdf(x,TO.Rewards.O_Low.PCoeffs(1),TO.Rewards.O_Low.PCoeffs(2));
TG.BDM_BC_GUI.Handles.OLP = plot(handles.BDM_Axes,x,y, '--b');
hold(handles.BDM_Axes,'on')
end

% --- Executes on button press in OM_Control.
function OM_Control_Callback(hObject, eventdata, handles)
% hObject    handle to OM_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG
if length(TO.Rewards.O_Mid.PCoeffs) == 2
if isfield(TG.BDM_BC_GUI.Handles,'OMP')
    delete(TG.BDM_BC_GUI.Handles.OMP)
end
x = [0:0.01:1];
y = betapdf(x,TO.Rewards.O_Mid.PCoeffs(1),TO.Rewards.O_Mid.PCoeffs(2));
TG.BDM_BC_GUI.Handles.OMP = plot(handles.BDM_Axes,x,y, '--g');
hold(handles.BDM_Axes,'on')
end

% --- Executes on button press in OH_Control.
function OH_Control_Callback(hObject, eventdata, handles)
% hObject    handle to OH_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG
if length(TO.Rewards.O_High.PCoeffs) == 2
if isfield(TG.BDM_BC_GUI.Handles,'OHP')
    delete(TG.BDM_BC_GUI.Handles.OHP)
end
x = [0:0.01:1];
y = betapdf(x,TO.Rewards.O_High.PCoeffs(1),TO.Rewards.O_High.PCoeffs(2));
TG.BDM_BC_GUI.Handles.OHP = plot(handles.BDM_Axes,x,y, '--r');
hold(handles.BDM_Axes,'on')
end



function Fetch_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Fetch_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
Input = get(hObject,'String');
TG.BDM.FetchStart = str2double(Input);
handles.Comments_Text.String = ['Fetch start set to:' Input];

% Hints: get(hObject,'String') returns contents of Fetch_Start as text
%        str2double(get(hObject,'String')) returns contents of Fetch_Start as a double


% --- Executes during object creation, after setting all properties.
function Fetch_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fetch_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fetch_End_Callback(hObject, eventdata, handles)
% hObject    handle to Fetch_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
Input = get(hObject,'String');
TG.BDM.FetchEnd = str2double(Input);
handles.Comments_Text.String = ['Fetch end set to:' Input];
% Hints: get(hObject,'String') returns contents of Fetch_End as text
%        str2double(get(hObject,'String')) returns contents of Fetch_End as a double


% --- Executes during object creation, after setting all properties.
function Fetch_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fetch_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fetch_RCode_Callback(hObject, eventdata, handles)
% hObject    handle to Fetch_RCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
Input   = get(hObject,'String');
TG.BDM.FetchRCode = str2double(Input);
handles.Comments_Text.String = ['Fetch reward set to:' Input];
% Hints: get(hObject,'String') returns contents of Fetch_RCode as text
%        str2double(get(hObject,'String')) returns contents of Fetch_RCode as a double


% --- Executes during object creation, after setting all properties.
function Fetch_RCode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fetch_RCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Fetch_Set.
function Fetch_Set_Callback(hObject, eventdata, handles)
% hObject    handle to Fetch_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG

switch TG.BDM.FetchRCode
    case 1
        RID = 'BH';
        BidVec = TG.BDM.BH_MBidVec;
    case 2
        RID = 'BM';
        BidVec = TG.BDM.BM_MBidVec;
    case 3
        RID = 'BL';
        BidVec = TG.BDM.BL_MBidVec;
    case 4
        RID = 'WH';
        BidVec = TG.BDM.WH_MBidVec;
    case 5
        RID = 'WM';
        BidVec = TG.BDM.WM_MBidVec;
    case 6
        RID = 'WL';
        BidVec = TG.BDM.WL_MBidVec;
    case 7
        RID = 'OH';
        BidVec = TG.BDM.OH_MBidVec;
    case 8
        RID = 'OM';
        BidVec = TG.BDM.OM_MBidVec;
    case 9
        RID = 'OL';
        BidVec = TG.BDM.OL_MBidVec;
    case 10
        RID = 'NR';
        BidVec = TG.BDM.NR_MBidVec;
end

handles.Fetch_RID.String = RID;

if TG.BDM.FetchEnd > length(BidVec)
    TG.BDM.FetchEnd = length(BidVec);
    handles.Comments_Text.String = 'Fetch end longer than bid vector, setting to end of vector';
end

Fetched     = BidVec(TG.BDM.FetchStart:TG.BDM.FetchEnd);
nFetched    = Fetched(~isnan(Fetched));
handles.Fetch_N.String          = num2str(length(nFetched), '%.3g');
handles.Fetch_Mean.String       = num2str(nanmean(Fetched), '%.3g');
handles.Fetch_Var.String        = num2str(nanvar(Fetched), '%.3g');
handles.Fetch_Median.String     = num2str(nanmedian(Fetched), '%.3g');


% --- Executes on button press in Bias_Fix_Mode.
function Bias_Fix_Mode_Callback(hObject, eventdata, handles)
% hObject    handle to Bias_Fix_Mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP
Input = get(hObject,'Value');
if Input
    TP.BCb.BiasFix = 1;
    handles.Comments_Text.String = 'Bias fix switched on';
else
    TP.BCb.BiasFix = 0;
    handles.Comments_Text.String = 'Bias fix switched off';
end
% Hint: get(hObject,'Value') returns toggle state of Bias_Fix_Mode



function Fix_Bias_Offset_Callback(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_Offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP

RawInput    = get(hObject,'String');
DataInput   = str2double(RawInput);

if DataInput > (TP.BCs.CenterPos - 25)
    TP.BCb.MarkerOffset = TP.BCs.CenterPos - 25;
    handles.Comments_Text.String = 'Offset puts marker off the end of the screen, setting to right limit!';
    handles.Fix_Bias_Offset.String = num2str(TP.BCb.MarkerOffset);
elseif DataInput < -(TP.BCs.CenterPos - 25)
    TP.BCb.MarkerOffset = -(TP.BCs.CenterPos - 25);
    handles.Comments_Text.String = 'Offset puts marker off the end of the screen, setting to left limit!';
    handles.Fix_Bias_Offset.String = num2str(TP.BCb.MarkerOffset);
else
    TP.BCb.MarkerOffset = DataInput;
    handles.Comments_Text.String = strcat('Offset at:',RawInput);
    handles.Fix_Bias_Offset.String = num2str(TP.BCb.MarkerOffset);
end


% --- Executes during object creation, after setting all properties.
function Fix_Bias_Offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_Offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Fix_Bias_Reset.
function Fix_Bias_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG

TG.BCb.BiasFix_LN = 0;
TG.BCb.BiasFix_RN = 0;
TG.BCb.BiasFix_RDom = 0;
TG.BCb.BiasFix_Good = 0;
TG.BCb.BiasFix_LDom = 0;
handles.Comments_Text.String = 'Bias-fix side counters have been reset to zero';
handles.Fix_Bias_LN.String = '0';
handles.Fix_Bias_RN.String = '0';
handles.Fix_Bias_LDom.String = '0';
handles.Fix_Bias_RDom.String = '0';
handles.Fix_Bias_Good.String = '0';



function Fix_Bias_LGB_Callback(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_LGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP

RawInput    = get(hObject,'String');
Input       = str2double(RawInput);

if Input < 0.05
    Input = 0.05;
    handles.Comments_Text.String    = 'Minimum adjustment factor is 0.05, setting to 0.05';
    handles.Fix_Bias_LGB.String     = '0.05';
elseif Input > 3
    Input = 3;
    handles.Comments_Text.String    = 'Minimum adjustment factor is 3, setting to 3';
    handles.Fix_Bias_LGB.String     = '3';
else
    handles.Comments_Text.String    = ['Setting left side adjustment factor to:', RawInput];
end

TP.BCb.LGainBias = Input;
% Hints: get(hObject,'String') returns contents of Fix_Bias_LGB as text
%        str2double(get(hObject,'String')) returns contents of Fix_Bias_LGB as a double


% --- Executes during object creation, after setting all properties.
function Fix_Bias_LGB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_LGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fix_Bias_RGB_Callback(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_RGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP

RawInput    = get(hObject,'String');
Input       = str2double(RawInput);

if Input < 0.05
    Input = 0.05;
    handles.Comments_Text.String    = 'Minimum adjustment factor is 0.05, setting to 0.05';
    handles.Fix_Bias_RGB.String     = '0.05';
elseif Input > 3
    Input = 3;
    handles.Comments_Text.String    = 'Minimum adjustment factor is 3, setting to 3';
    handles.Fix_Bias_RGB.String     = '3';
else
    handles.Comments_Text.String    = ['Setting right side adjustment factor to:', RawInput];
end

TP.BCb.RGainBias = Input;

% Hints: get(hObject,'String') returns contents of Fix_Bias_RGB as text
%        str2double(get(hObject,'String')) returns contents of Fix_Bias_RGB as a double


% --- Executes during object creation, after setting all properties.
function Fix_Bias_RGB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_RGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fix_Bias_LSO_Callback(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_LSO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TP VisParam
handles.StimulusChange_IO.BackgroundColor = [1 0 0];
RawInput    = get(hObject,'String');
Input       = str2double(RawInput);

PosLimit       = (VisParam.scr_rect(3)/12) - 10; 
NegLimit       = -(VisParam.scr_rect(3)/12);

if Input > PosLimit
    Input = PosLimit;
    handles.Comments_Text.String    = ['Maximum left offset to the left is:', num2str(PosLimit),' Setting to:',num2str(PosLimit)];
    handles.Fix_Bias_LSO.String     = num2str(PosLimit);
elseif Input < NegLimit;
    Input = NegLimit;
    handles.Comments_Text.String    = ['Maximum left offset to the right is:', num2str(NegLimit),' Setting to:',num2str(NegLimit)];
    handles.Fix_Bias_LSO.String     = num2str(NegLimit);
else
    handles.Comments_Text.String    = ['Left offset set to:',RawInput];
end

TP.BCb.LSO = Input;

% Set new fractal positions:
NewPos = TP.BCb.LeftLimit1 - Input;

[TO.Rewards.B_Low.BCb.LeftPosition, TO.Rewards.B_Low.BCb.LeftPositionFrame]     = MakeBCFrac('Left', 'B10', 17, NewPos, NewPos);
[TO.Rewards.B_Mid.BCb.LeftPosition, TO.Rewards.B_Mid.BCb.LeftPositionFrame]     = MakeBCFrac('Left', 'B20', 13, NewPos, NewPos);
[TO.Rewards.B_High.BCb.LeftPosition, TO.Rewards.B_High.BCb.LeftPositionFrame]   = MakeBCFrac('Left', 'B30', 9, NewPos, NewPos);

[TO.Rewards.W_High.BCb.LeftPosition, TO.Rewards.W_High.BCb.LeftPositionFrame]   = MakeBCFrac('Left', 'W30', 21, NewPos, NewPos);
[TO.Rewards.W_Mid.BCb.LeftPosition, TO.Rewards.W_Mid.BCb.LeftPositionFrame]     = MakeBCFrac('Left', 'W20', 25, NewPos, NewPos);
[TO.Rewards.W_Low.BCb.LeftPosition, TO.Rewards.W_Low.BCb.LeftPositionFrame]     = MakeBCFrac('Left', 'W10', 29, NewPos, NewPos);

[TO.Rewards.O_High.BCb.LeftPosition, TO.Rewards.O_High.BCb.LeftPositionFrame]   = MakeBCFrac('Left', 'O30', 34, NewPos, NewPos);
[TO.Rewards.O_Mid.BCb.LeftPosition, TO.Rewards.O_Mid.BCb.LeftPositionFrame]     = MakeBCFrac('Left', 'O20', 39, NewPos, NewPos);
[TO.Rewards.O_Low.BCb.LeftPosition, TO.Rewards.O_Low.BCb.LeftPositionFrame]     = MakeBCFrac('Left', 'O10', 44, NewPos, NewPos);

[TO.Rewards.NR.BCb.LeftPosition, TO.Rewards.NR.BCb.LeftPositionFrame]     = MakeBCFrac('Left', 'NR', 46, NewPos, NewPos);

% Set new bar positions:
NewPos = TP.BCb.LeftLimit - Input;

Water_ValueMarker_Height    = 10;

if strcmp(TP.BDM.CurrencyType,'W')
    [TO.Rewards.Water.BCb.BarLeftPosition, TO.Rewards.Water.BCb.BarLBorder, TO.Stimuli.BarLPos_b]   = MakeBDMBar('Left',VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, NewPos, NewPos, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
elseif strcmp(TP.BDM.CurrencyType,'B')
    [TO.Rewards.Water.BCb.BarLeftPosition, TO.Rewards.Water.BCb.BarLBorder, TO.Stimuli.BarLPos_b]   = MakeBDMBar('Left',VisParam.scr_handle, TO.Stimuli.Bar.Juice_Color, NewPos, NewPos, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
end

[~, TO.Rewards.Water.BCb.BlackoutL, ~]   = MakeBDMBar2('Left',VisParam.scr_handle, [0 0 0], NewPos, NewPos, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, [0 0 0], TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);


if TO.Stimuli.Control.MainScale
    TO.Rewards.Water.BCb.LScale                         = MakeScale(VisParam.scr_handle, TO.Stimuli.Bar.Water_SColor, TO.Stimuli.Bar.Water_SLines, TO.Stimuli.BarLPos_b, TO.Stimuli.Bar.Water_SWidth);
else
     TO.Rewards.Water.BCb.LScale                        = ' ';
end

if TO.Stimuli.Control.FineScale
    TO.Rewards.Water.BCb.LFineScale                     = MakeFineScale(VisParam.scr_handle, TO.Stimuli.Bar.Water_SColor, TO.Stimuli.Bar.Water_fSLines, TO.Stimuli.BarLPos_b, TO.Stimuli.Bar.Water_fSWidth);
else
    TO.Rewards.Water.BCb.LFineScale = ' ';
end

TO.Rewards.Water.BCb.DefMarkerLeftPosition          = [TO.Stimuli.BarLPos_b(1), TO.Stimuli.BarLPos_b(4)- Water_ValueMarker_Height, TO.Stimuli.BarLPos_b(3), TO.Stimuli.BarLPos_b(4)];
TO.Stimuli.BCb.PayRect.LDefPos                      = [TO.Stimuli.BarLPos_b(1), TO.Stimuli.BarLPos_b(4), TO.Stimuli.BarLPos_b(3), TO.Stimuli.BarLPos_b(4)];

DiscreteBar(TO.Params.BDM.D_nDivs,TO.Stimuli.BDM.D_DivSpacing,TO.Stimuli.BDM.D_MBidEdge,TO.Stimuli.BDM.D_CBidEdge);

handles.StimulusChange_IO.BackgroundColor = [0 1 0]; %%%%%% DONE!

% --- Executes during object creation, after setting all properties.
function Fix_Bias_LSO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_LSO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fix_Bias_RSO_Callback(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_RSO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TP VisParam
handles.StimulusChange_IO.BackgroundColor = [1 0 0];
RawInput    = get(hObject,'String');
Input       = str2double(RawInput);

PosLimit       = (VisParam.scr_rect(3)/12) - 10; 
NegLimit       = -(VisParam.scr_rect(3)/12);

if Input > PosLimit
    Input = PosLimit;
    handles.Comments_Text.String    = ['Maximum right offset to the right is:', num2str(PosLimit),' Setting to:',num2str(PosLimit)];
    handles.Fix_Bias_LSO.String     = num2str(PosLimit);
elseif Input < NegLimit;
    Input = NegLimit;
    handles.Comments_Text.String    = ['Maximum right offset to the left is:', num2str(NegLimit),' Setting to:',num2str(NegLimit)];
    handles.Fix_Bias_LSO.String     = num2str(NegLimit);
else
    handles.Comments_Text.String    = ['Right offset set to:',RawInput];
end

TP.BCb.RSO = Input;

% Set new fractal positions:
NewPos = TP.BCb.RightLimit2 + Input;

[TO.Rewards.B_Low.BCb.RightPosition, TO.Rewards.B_Low.BCb.RightPositionFrame]   = MakeBCFrac('Right', 'B10', 18, NewPos, NewPos);
[TO.Rewards.B_Mid.BCb.RightPosition, TO.Rewards.B_Mid.BCb.RightPositionFrame]   = MakeBCFrac('Right', 'B20', 14, NewPos, NewPos);
[TO.Rewards.B_High.BCb.RightPosition, TO.Rewards.B_High.BCb.RightPositionFrame] = MakeBCFrac('Right', 'B30', 10, NewPos, NewPos);

[TO.Rewards.W_High.BCb.RightPosition, TO.Rewards.W_High.BCb.RightPositionFrame] = MakeBCFrac('Right', 'W30', 22, NewPos, NewPos);
[TO.Rewards.W_Mid.BCb.RightPosition, TO.Rewards.W_Mid.BCb.RightPositionFrame]   = MakeBCFrac('Right', 'W20', 26, NewPos, NewPos);
[TO.Rewards.W_Low.BCb.RightPosition, TO.Rewards.W_Low.BCb.RightPositionFrame]   = MakeBCFrac('Right', 'W10', 30, NewPos, NewPos);

[TO.Rewards.O_High.BCb.RightPosition, TO.Rewards.O_High.BCb.RightPositionFrame] = MakeBCFrac('Right', 'O30', 35, NewPos, NewPos);
[TO.Rewards.O_Mid.BCb.RightPosition, TO.Rewards.O_Mid.BCb.RightPositionFrame]   = MakeBCFrac('Right', 'O20', 40, NewPos, NewPos);
[TO.Rewards.O_Low.BCb.RightPosition, TO.Rewards.O_Low.BCb.RightPositionFrame]   = MakeBCFrac('Right', 'O10', 45, NewPos, NewPos);

[TO.Rewards.NR.BCb.RightPosition, TO.Rewards.NR.BCb.RightPositionFrame]   = MakeBCFrac('Right', 'NR', 47, NewPos, NewPos);

% Set new bar positions:
NewPos = TP.BCb.RightLimit + Input;

Water_ValueMarker_Height    = 10;

if strcmp(TP.BDM.CurrencyType,'W')
    [TO.Rewards.Water.BCb.BarRightPosition, TO.Rewards.Water.BCb.BarRBorder, TO.Stimuli.BarRPos_b]  = MakeBDMBar('Right',VisParam.scr_handle, TO.Stimuli.Bar.Water_Color, NewPos, NewPos, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
elseif strcmp(TP.BDM.CurrencyType,'B')
    [TO.Rewards.Water.BCb.BarRightPosition, TO.Rewards.Water.BCb.BarRBorder, TO.Stimuli.BarRPos_b]  = MakeBDMBar('Right',VisParam.scr_handle, TO.Stimuli.Bar.Juice_Color, NewPos, NewPos, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, TO.Stimuli.Bar.Water_BColor, TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
end

[~, TO.Rewards.Water.BCb.BlackoutR, ~]   = MakeBDMBar2('Right',VisParam.scr_handle, [0 0 0], NewPos, NewPos, TO.Stimuli.BDM.BarHeight, TO.Stimuli.BDM.BarWidth, [0 0 0], TO.Stimuli.Bar.Water_BWidth, TO.Stimuli.Bar.Base_Distance);
if TO.Stimuli.Control.MainScale
    TO.Rewards.Water.BCb.RScale                         = MakeScale(VisParam.scr_handle, TO.Stimuli.Bar.Water_SColor, TO.Stimuli.Bar.Water_SLines, TO.Stimuli.BarRPos_b, TO.Stimuli.Bar.Water_SWidth);
else
    TO.Rewards.Water.BCb.RScale = ' ';
end

if TO.Stimuli.Control.FineScale
    TO.Rewards.Water.BCb.RFineScale                     = MakeFineScale(VisParam.scr_handle, TO.Stimuli.Bar.Water_SColor, TO.Stimuli.Bar.Water_fSLines, TO.Stimuli.BarRPos_b, TO.Stimuli.Bar.Water_fSWidth);
else
    TO.Rewards.Water.BCb.RFineScale     = ' ';
end
    
TO.Rewards.Water.BCb.DefMarkerRightPosition         = [TO.Stimuli.BarRPos_b(1), TO.Stimuli.BarRPos_b(4)- Water_ValueMarker_Height, TO.Stimuli.BarRPos_b(3), TO.Stimuli.BarRPos_b(4)];
TO.Stimuli.BCb.PayRect.RDefPos                      = [TO.Stimuli.BarRPos_b(1), TO.Stimuli.BarRPos_b(4), TO.Stimuli.BarRPos_b(3), TO.Stimuli.BarRPos_b(4)];

DiscreteBar(TO.Params.BDM.D_nDivs,TO.Stimuli.BDM.D_DivSpacing,TO.Stimuli.BDM.D_MBidEdge,TO.Stimuli.BDM.D_CBidEdge);

handles.StimulusChange_IO.BackgroundColor = [0 1 0]; %%%%%% DONE!
% Hints: get(hObject,'String') returns contents of Fix_Bias_RSO as text
%        str2double(get(hObject,'String')) returns contents of Fix_Bias_RSO as a double


% --- Executes during object creation, after setting all properties.
function Fix_Bias_RSO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_RSO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fix_Bias_LPH_Callback(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_LPH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP

RawInput    = get(hObject,'String');
Input       = str2double(RawInput);

if Input > 1
    Input = 1;
    handles.Comments_Text.String    = ['Maximum probability is 1, setting to 1.'];
    handles.Fix_Bias_LPH.String     = '1';
elseif Input < 0
    Input = 0;
    handles.Comments_Text.String    = ['Minimum probability is 0, setting to 0.'];
    handles.Fix_Bias_LPH.String     = '0';
else
    handles.Comments_Text.String    = ['Setting probability of high-value reward on LHS to:', RawInput];
end

TP.BCb.BiasFix_LPH = Input;
% Hints: get(hObject,'String') returns contents of Fix_Bias_LPH as text
%        str2double(get(hObject,'String')) returns contents of Fix_Bias_LPH as a double


% --- Executes during object creation, after setting all properties.
function Fix_Bias_LPH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_LPH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fix_Bias_RPH_Callback(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_RPH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP

RawInput    = get(hObject,'String');
Input       = str2double(RawInput);

if Input > 1
    Input = 1;
    handles.Comments_Text.String    = ['Maximum probability is 1, setting to 1.'];
    handles.Fix_Bias_RPH.String     = '1';
elseif Input < 0
    Input = 0;
    handles.Comments_Text.String    = ['Minimum probability is 0, setting to 0.'];
    handles.Fix_Bias_RPH.String     = '0';
else
    handles.Comments_Text.String    = ['Setting probability of high-value reward on RHS to:', RawInput];
end

TP.BCb.BiasFix_RPH = Input;
% Hints: get(hObject,'String') returns contents of Fix_Bias_RPH as text
%        str2double(get(hObject,'String')) returns contents of Fix_Bias_RPH as a double


% --- Executes during object creation, after setting all properties.
function Fix_Bias_RPH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_RPH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Fix_Bias_LV_Callback(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_LV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP

RawInput    = get(hObject,'String');
Input       = str2double(RawInput);

if Input > 1
    Input = 1;
    handles.Comments_Text.String    = ['Maximum value is 1, setting to 1.'];
    handles.Fix_Bias_LV.String     = '1';
elseif Input < 0
    Input = 0;
    handles.Comments_Text.String    = ['Minimum value is 0, setting to 0.'];
    handles.Fix_Bias_LV.String     = '0';
else
    handles.Comments_Text.String    = ['Setting value of low-value reward to:', RawInput];
end

TP.BCb.BiasFix_LV = Input;

% --- Executes during object creation, after setting all properties.
function Fix_Bias_LV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_LV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fix_Bias_HV_Callback(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_HV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP

RawInput    = get(hObject,'String');
Input       = str2double(RawInput);

if Input > 1
    Input = 1;
    handles.Comments_Text.String    = ['Maximum value is 1, setting to 1.'];
    handles.Fix_Bias_HV.String     = '1';
elseif Input < 0
    Input = 0;
    handles.Comments_Text.String    = ['Minimum value is 0, setting to 0.'];
    handles.Fix_Bias_HV.String     = '0';
else
    handles.Comments_Text.String    = ['Setting value of high-value reward to:', RawInput];
end

TP.BCb.BiasFix_HV = Input;
% Hints: get(hObject,'String') returns contents of Fix_Bias_HV as text
%        str2double(get(hObject,'String')) returns contents of Fix_Bias_HV as a double


% --- Executes during object creation, after setting all properties.
function Fix_Bias_HV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fix_Bias_HV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BCb_Fetch_RCode_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_Fetch_RCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
Input   = get(hObject,'String');
TG.BCb.FetchRCode = str2double(Input);
handles.Comments_Text.String = ['Fetch BC reward set to:' Input];
% Hints: get(hObject,'String') returns contents of BCb_Fetch_RCode as text
%        str2double(get(hObject,'String')) returns contents of BCb_Fetch_RCode as a double


% --- Executes during object creation, after setting all properties.
function BCb_Fetch_RCode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BCb_Fetch_RCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BCb_Fetch_Set.
function BCb_Fetch_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_Fetch_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG

switch TG.BCb.FetchRCode
    case 0
        RID = 'All';
    case 1
        RID = 'BH';
    case 2
        RID = 'BM';
    case 3
        RID = 'BL';
    case 4
        RID = 'WH';
    case 5
        RID = 'WM';
    case 6
        RID = 'WL';
    case 7
        RID = 'OH';
    case 8
        RID = 'OM';
    case 9
        RID = 'OL';
    case 10
        RID = 'NR';
end

if TG.BCb.FetchEnd > length(TG.BCb.RSet)
    TG.BCb.FetchEnd = length(TG.BCb.RSet);
    handles.Comments_Text.String = 'Fetch end longer than choice vector, setting to end of vector';
end

Fetched     = zeros(1,length(TG.BCb.RSet));
Fetched(TG.BCb.FetchStart:TG.BCb.FetchEnd)     = TG.BCb.RSet(TG.BCb.FetchStart:TG.BCb.FetchEnd);

handles.BCb_RName.String = RID;

if TG.BCb.FetchRCode ~= 0
    SampleIX    = Fetched == TG.BCb.FetchRCode;
else
    SampleIX    = Fetched ~= 0;
end

SampleSet   = TG.BCb.SSet(SampleIX);
    
nL          = length(SampleSet(SampleSet == 1));
nR          = length(SampleSet(SampleSet == 2));
T           = nL + nR;
LFrac       = round(100*(nL/T));
RFrac       = 100 - LFrac;

[~, Bias, ~] = BernoulliTest(nL,nR,0.1,'Left','Right');

handles.BCb_RS_LC.String = num2str(nL);
handles.BCb_RS_RC.String = num2str(nR);
handles.BCb_RS_Ratio.String = strcat(num2str(LFrac,'%.2g'),':',num2str(RFrac,'%.2g'));
handles.BCb_RS_Bias.String = Bias;

if TG.BCb.FetchRCode ~= 0
GUI_Logit(TG.BCb.BundleCurrency(SampleIX),TG.BCb.BundleReward(SampleIX),TG.BCb.Choices(SampleIX),TG.BCb.FetchRCode,TG.BCb.Logit_Mode,handles)
end



% --- Executes on button press in BM_BCb_Control.
function BM_BCb_Control_Callback(hObject, eventdata, handles)
% hObject    handle to BM_BCb_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
GUI_Logit(TG.BCb.BundleCurrency,TG.BCb.BundleReward,TG.BCb.Choices,2,TG.BCb.Logit_Mode,handles)

% --- Executes on button press in BL_BCb_Control.
function BL_BCb_Control_Callback(hObject, eventdata, handles)
% hObject    handle to BL_BCb_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
GUI_Logit(TG.BCb.BundleCurrency,TG.BCb.BundleReward,TG.BCb.Choices,3,TG.BCb.Logit_Mode,handles)

% --- Executes on button press in BH_BCb_Control.
function BH_BCb_Control_Callback(hObject, eventdata, handles)
% hObject    handle to BH_BCb_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
GUI_Logit(TG.BCb.BundleCurrency,TG.BCb.BundleReward,TG.BCb.Choices,1,TG.BCb.Logit_Mode,handles)

% --- Executes on button press in OL_BCb_Control.
function OL_BCb_Control_Callback(hObject, eventdata, handles)
% hObject    handle to OL_BCb_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
GUI_Logit(TG.BCb.BundleCurrency,TG.BCb.BundleReward,TG.BCb.Choices,9,TG.BCb.Logit_Mode,handles)

% --- Executes on button press in OM_BCb_Control.
function OM_BCb_Control_Callback(hObject, eventdata, handles)
% hObject    handle to OM_BCb_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
GUI_Logit(TG.BCb.BundleCurrency,TG.BCb.BundleReward,TG.BCb.Choices,8,TG.BCb.Logit_Mode,handles)

% --- Executes on button press in OH_BCb_Control.
function OH_BCb_Control_Callback(hObject, eventdata, handles)
% hObject    handle to OH_BCb_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
GUI_Logit(TG.BCb.BundleCurrency,TG.BCb.BundleReward,TG.BCb.Choices,7,TG.BCb.Logit_Mode,handles)


% --- Executes on button press in BCb_Logit_Type.
function BCb_Logit_Type_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_Logit_Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG

Test = get(hObject,'Value');

if Test
    TG.BCb.Logit_Mode = 'NoDom';
else
    TG.BCb.Logit_Mode = 'All';
end

handles.Comments_Text.String = ['Logit mode set to:' TG.BCb.Logit_Mode];
% Hint: get(hObject,'Value') returns toggle state of BCb_Logit_Type



function BCb_Fetch_Start_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_Fetch_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
Input = get(hObject,'String');
TG.BCb.FetchStart = str2double(Input);
handles.Comments_Text.String = ['Fetch start set to:' Input];
% Hints: get(hObject,'String') returns contents of BCb_Fetch_Start as text
%        str2double(get(hObject,'String')) returns contents of BCb_Fetch_Start as a double


% --- Executes during object creation, after setting all properties.
function BCb_Fetch_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BCb_Fetch_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BCb_Fetch_End_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_Fetch_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
Input = get(hObject,'String');
TG.BCb.FetchEnd = str2double(Input);
handles.Comments_Text.String = ['Fetch end set to:' Input];
% Hints: get(hObject,'String') returns contents of BCb_Fetch_End as text
%        str2double(get(hObject,'String')) returns contents of BCb_Fetch_End as a double


% --- Executes during object creation, after setting all properties.
function BCb_Fetch_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BCb_Fetch_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit45 as text
%        str2double(get(hObject,'String')) returns contents of edit45 as a double


% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit46 as text
%        str2double(get(hObject,'String')) returns contents of edit46 as a double


% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in Effector.
function Effector_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Effector 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG TP
Selection = get(eventdata.NewValue,'Tag');

switch Selection
    case 'Joystick'
        SetJoyParams(1,1,0.2,0.01);
        TP.Effector = 'Joy';
        handles.Comments_Text.String = 'Using joystick!';
    case 'Touchscreen'
        SetJoyParams(0,0,0,0);
        TP.Effector = 'Touch';
        handles.Comments_Text.String = 'Using touchscreen!';
end
UpdateSettings('SetUp');
handles.Parameters_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);


% --- Executes on button press in AT_BDM.
function AT_BDM_Callback(hObject, eventdata, handles)
% hObject    handle to AT_BDM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AT_BDM


% --- Executes on button press in AT_BDM_PAV.
function AT_BDM_PAV_Callback(hObject, eventdata, handles)
% hObject    handle to AT_BDM_PAV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AT_BDM_PAV


% --- Executes when selected object is changed in Auction_Type.
function Auction_Type_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Auction_Type 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG TP
Selection = get(eventdata.NewValue,'Tag');

switch Selection
    case 'AT_First'
        TP.BDM.AuctionType = 'First';
        handles.Comments_Text.String = 'Using first price auction!';
    case 'AT_BDM'
        TP.BDM.AuctionType = 'BDM';
        handles.Comments_Text.String = 'Using BDM!';
    case 'AT_BDM_PAV'
        TP.BDM.AuctionType = 'BDM_PAV';
        handles.Comments_Text.String = 'Using pavlovian BDM!';
    case 'AT_BDM_Forced'
        TP.BDM.AuctionType = 'BDM_Forced';
        handles.Comments_Text.String = 'Using forced bid BDM!';
end

handles.Parameters_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);



function NDIVS_Callback(hObject, eventdata, handles)
% hObject    handle to NDIVS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TP

InputVal = str2double(get(hObject,'String'));
TO.Params.BDM.D_nDivs = InputVal;

UpdateBDMBar

handles.Current_NDIVS.String = get(hObject,'String');
handles.Comments_Text.String = ['Number of discrete divisions set to:',get(hObject,'String')];

TP.BDM.PAV_BidsC            = (randi(TO.Params.BDM.D_nDivs+1,1,1000)-1)/TO.Params.BDM.D_nDivs;
% Hints: get(hObject,'String') returns contents of NDIVS as text
%        str2double(get(hObject,'String')) returns contents of NDIVS as a double


% --- Executes during object creation, after setting all properties.
function NDIVS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NDIVS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Stim_Edit.
function Stim_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Stim_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
StimulusEditGUI


% --- Executes during object creation, after setting all properties.
function BDM_WH_Set_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BDM_WH_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function WH_Alpha_E_Callback(hObject, eventdata, handles)
% hObject    handle to WH_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.W_High.PCoeffs(1) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.WH_Alpha,'String',num2str(TO.Rewards.W_High.PCoeffs(1)));
handles.Comments_Text.String = 'WH Alpha value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of WH_Alpha_E as text
%        str2double(get(hObject,'String')) returns contents of WH_Alpha_E as a double


% --- Executes during object creation, after setting all properties.
function WH_Alpha_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WH_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WH_Beta_E_Callback(hObject, eventdata, handles)
% hObject    handle to WH_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.W_High.PCoeffs(2) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.WH_Beta,'String',num2str(TO.Rewards.W_High.PCoeffs(2)));
handles.Comments_Text.String = 'WH Beta value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of WH_Beta_E as text
%        str2double(get(hObject,'String')) returns contents of WH_Beta_E as a double


% --- Executes during object creation, after setting all properties.
function WH_Beta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WH_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WM_Alpha_E_Callback(hObject, eventdata, handles)
% hObject    handle to WM_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.W_Mid.PCoeffs(1) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.WM_Alpha,'String',num2str(TO.Rewards.W_Mid.PCoeffs(1)));
handles.Comments_Text.String = 'WM Alpha value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of WM_Alpha_E as text
%        str2double(get(hObject,'String')) returns contents of WM_Alpha_E as a double


% --- Executes during object creation, after setting all properties.
function WM_Alpha_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WM_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WL_Alpha_E_Callback(hObject, eventdata, handles)
% hObject    handle to WL_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.W_Low.PCoeffs(1) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.WL_Alpha,'String',num2str(TO.Rewards.W_Low.PCoeffs(1)));
handles.Comments_Text.String = 'WL Alpha value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of WL_Alpha_E as text
%        str2double(get(hObject,'String')) returns contents of WL_Alpha_E as a double


% --- Executes during object creation, after setting all properties.
function WL_Alpha_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WL_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NR_Alpha_E_Callback(hObject, eventdata, handles)
% hObject    handle to NR_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.NR.PCoeffs(1) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.NR_Alpha,'String',num2str(TO.Rewards.NR.PCoeffs(1)));
handles.Comments_Text.String = 'NR Alpha value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of NR_Alpha_E as text
%        str2double(get(hObject,'String')) returns contents of NR_Alpha_E as a double


% --- Executes during object creation, after setting all properties.
function NR_Alpha_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NR_Alpha_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WM_Beta_E_Callback(hObject, eventdata, handles)
% hObject    handle to WM_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.W_Mid.PCoeffs(2) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.WM_Beta,'String',num2str(TO.Rewards.W_Mid.PCoeffs(2)));
handles.Comments_Text.String = 'WM Beta value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of WM_Beta_E as text
%        str2double(get(hObject,'String')) returns contents of WM_Beta_E as a double


% --- Executes during object creation, after setting all properties.
function WM_Beta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WM_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WL_Beta_E_Callback(hObject, eventdata, handles)
% hObject    handle to WL_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.W_Low.PCoeffs(2) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.WL_Beta,'String',num2str(TO.Rewards.W_Low.PCoeffs(2)));
handles.Comments_Text.String = 'WL Beta value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of WL_Beta_E as text
%        str2double(get(hObject,'String')) returns contents of WL_Beta_E as a double


% --- Executes during object creation, after setting all properties.
function WL_Beta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WL_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NR_Beta_E_Callback(hObject, eventdata, handles)
% hObject    handle to NR_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TO TG

TO.Rewards.NR.PCoeffs(2) = str2double(get(hObject,'String'));
set(TG.BDM_BC_GUI.Handles.NR_Beta,'String',num2str(TO.Rewards.NR.PCoeffs(2)));
handles.Comments_Text.String = 'NR Beta value set';
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hints: get(hObject,'String') returns contents of NR_Beta_E as text
%        str2double(get(hObject,'String')) returns contents of NR_Beta_E as a double


% --- Executes during object creation, after setting all properties.
function NR_Beta_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NR_Beta_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over BCb_WL_Set.
function BCb_WL_Set_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to BCb_WL_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in BCb_NR_Set.
function BCb_NR_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_NR_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BCb.JuiceSet(10) = 1;
    handles.Comments_Text.String = 'NR in BCb';
else
    TP.BCb.JuiceSet(10) = 0;
    handles.Comments_Text.String = 'NR excluded from BCb';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BCb_NR_Set


% --- Executes on button press in BDM_NR_Set.
function BDM_NR_Set_Callback(hObject, eventdata, handles)
% hObject    handle to BDM_NR_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TP TG
Input = get(hObject,'Value');
if Input == 1
    TP.BDM.JuiceSet(10) = 1;
    handles.Comments_Text.String = 'NR in BDM';
else
    TP.BDM.JuiceSet(10) = 0;
    handles.Comments_Text.String = 'NR excluded from BDM';
end
handles.JuiceBlock_IO.BackgroundColor = [1 0 0];
guidata(TG.BDM_BC_GUI.Fig,TG.BDM_BC_GUI.Handles);
% Hint: get(hObject,'Value') returns toggle state of BDM_NR_Set


% --- Executes on button press in AT_BDM_Forced.
function AT_BDM_Forced_Callback(hObject, eventdata, handles)
% hObject    handle to AT_BDM_Forced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AT_BDM_Forced


% --- Executes on button press in WL_BCb_Control.
function WL_BCb_Control_Callback(hObject, eventdata, handles)
% hObject    handle to WL_BCb_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
GUI_Logit(TG.BCb.BundleCurrency,TG.BCb.BundleReward,TG.BCb.Choices,6,TG.BCb.Logit_Mode,handles)


% --- Executes on button press in WM_BCb_Control.
function WM_BCb_Control_Callback(hObject, eventdata, handles)
% hObject    handle to WM_BCb_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
GUI_Logit(TG.BCb.BundleCurrency,TG.BCb.BundleReward,TG.BCb.Choices,5,TG.BCb.Logit_Mode,handles)


% --- Executes on button press in WH_BCb_Control.
function WH_BCb_Control_Callback(hObject, eventdata, handles)
% hObject    handle to WH_BCb_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TG
GUI_Logit(TG.BCb.BundleCurrency,TG.BCb.BundleReward,TG.BCb.Choices,4,TG.BCb.Logit_Mode,handles)


% --- Executes on button press in Rand_Marker.
function Rand_Marker_Callback(hObject, eventdata, handles)
% hObject    handle to Rand_Marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Rand_Marker


% --- Executes on button press in BCb_Only.
function BCb_Only_Callback(hObject, eventdata, handles)
% hObject    handle to BCb_Only (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BCb_Only
