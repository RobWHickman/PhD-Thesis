function varargout = paramGui_StimSelection(varargin)
% PARAMGUI_STIMSELECTION M-file for paramGui_StimSelection.fig
%
% 

% Last Modified by GUIDE v2.5 20-Feb-2013 11:32:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @paramGui_StimSelection_OpeningFcn, ...
                   'gui_OutputFcn',  @paramGui_StimSelection_OutputFcn, ...
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


% --- Executes just before paramGui_StimSelection is made visible.
function paramGui_StimSelection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to paramGui_StimSelection (see VARARGIN)

global Stim TaskOp ModigDir Timers
% Choose default command line output for paramGui_StimSelection
handles.output = hObject;

% load 'defaults' 
ModigTaskLoop('Initialize');

% set US variables: p(r) 
if ~isfield(Stim.us,'probability') || numel(Stim.us.probability)~=10,
    Stim.us.probability = [15 35 50 75 85 15 35 50 75 85];
end
if ~isfield(Stim.us,'probabilitySocial') || numel(Stim.us.probabilitySocial)~=10,
     Stim.us.probabilitySocial = [0 0 0 0 0 15 35 50 65 85];
end
if ~isfield(Stim.us,'probabilityBucket') || numel(Stim.us.probabilityBucket)~=10,
    Stim.us.probabilityBucket = [0 0 0 0 0 85 65 50 35 15];
end

% load default images for push buttons & activate checkboxes
if ~isfield(Stim.CS,'cs1name')
    Stim.CS.cs1name = [ModigDir.Images,'\Picture 000.jpg'];
    Stim.CS.cs2name = [ModigDir.Images,'\Picture 006.jpg'];
    Stim.CS.cs3name = [ModigDir.Images,'\picture 999.jpg'];
    Stim.CS.cs4name = [ModigDir.Images,'\Picture 003.jpg'];
    Stim.CS.cs5name = [ModigDir.Images,'\Picture 002.jpg'];
    Stim.CS.cs6name = [ModigDir.Images,'\Picture 007.jpg'];
    Stim.CS.cs7name = [ModigDir.Images,'\Picture 008.jpg'];
    Stim.CS.cs8name = [ModigDir.Images,'\Picture 009.jpg'];
    Stim.CS.cs9name = [ModigDir.Images,'\Picture 024.jpg'];
    Stim.CS.cs10name = [ModigDir.Images,'\Picture 025.jpg'];
end

if ~isfield(Stim.CS,'active') || numel(Stim.CS.active)~=10,
    Stim.CS.active      = [0 0 1 0 0 0 0 1 0 0 ];
end

% Load variables into GUI elements
for i = 1:10,
    thisName = eval(sprintf('Stim.CS.cs%dname',i));
    thisImage = imread(thisName);
    thisHdl = eval(sprintf('handles.axesCS%d',i));
    image(thisImage,'Parent',thisHdl)
    set(thisHdl,'Visible','off')
    thisStr = eval(sprintf('handles.textCS%d',i));
    strAnchor = strfind(thisName,'\');
    shortName = thisName(strAnchor(end)+1:end);
    set(thisStr,'String',shortName)
    
    % project-dependant choice to be written
    actStr = eval(sprintf('handles.checkboxCS1%d',i));
    set(actStr, 'Value', Stim.CS.active(i));
    
    % Probabilities...
    hdlSoc = eval(sprintf('handles.editCS%dpSocial',i));
    set(hdlSoc,'String',num2str(Stim.us.probabilitySocial(i)))
    
    hdlOwn = eval(sprintf('handles.editCS%dpOwn',i));
    set(hdlOwn,'String',num2str(Stim.us.probability(i)))
    
    hdlOther = eval(sprintf('handles.editCS%dpBucket',i));
    set(hdlOther,'String',num2str(Stim.us.probabilityBucket(i)))
end



% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = paramGui_StimSelection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialSeqType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in updateParams.
function updateParams_Callback(hObject, eventdata, handles)
% hObject    handle to updateParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TaskOp 
% TODO!
set(hObject,'String','updating...')

% if the CS is active evaluate edit boxes
checkbox_CS1_active_Callback(handles.checkbox_CS1_active)
checkbox_CS2_active_Callback(handles.checkbox_CS2_active)
checkbox_CS3_active_Callback(handles.checkbox_CS3_active)
checkbox_CS4_active_Callback(handles.checkbox_CS4_active)
checkbox_CS5_active_Callback(handles.checkbox_CS5_active)

% evaluate p(US|CS) edit boxes
editCS1pUS_Callback(handles.editCS1pSocial,[],handles)
editCS2pUS_Callback(handles.editCS2pSocial,[],handles)
editCS3pUS_Callback(handles.editCS3pSocial,[],handles)
editCS4pUS_Callback(handles.editCS4pSocial,[],handles)
editCS5pUS_Callback(handles.editCS5pSocial,[],handles)

% 
TaskOp.count.trialCounter = zeros(2,10);

% reset seq counterSSS! and generate a new seq
% update are in momame
eval(['updateMoMaMe_',TaskOp.prj, ' initialize']);

clear('activeSetupChange.m')

set(hObject,'String','Update Parameters')
set(hObject,'Value',0)

% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.paramGui_StimSelection)

% --- Executes on button press in pushbuttonCS1.
function pushbuttonCS_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Stim ModigDir

mycd = cd;
cd(ModigDir.Images)
[filename, pathname] = uigetfile('*.*','Pick an image');
cd(mycd)
if length(filename)>1,
    callerTag = get(hObject,'Tag');
    thisNumber =  callerTag(strfind(callerTag,'CS')+2:size(callerTag,2));
    
    name = sprintf('Stim.CS.cs%sname',thisNumber);
    eval([name '= [pathname,filename];']);
    cs = imread(eval(name));
    axHdl = eval(sprintf('handles.axesCS%s',thisNumber));
    image(cs,'Parent',axHdl);
    set(axHdl,'visible','off');
    set(eval(sprintf('handles.textCS%s',thisNumber)),'String',filename,'fontsize',8);
end


function editCSpSocial_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pSocial_Callback (see GCBO)

global Stim 
callerTag = get(hObject,'Tag');
thisNumber =  str2double(callerTag(strfind(callerTag,'CS')+2:strfind(callerTag,'p')-1));
no = str2double(get(hObject,'String'));
if isnan(no) || ~(no>=0 & no<=100)
    warning('MODIG:paramGui_stimSelection:isnan','invalid input! Reverting...')
    set(hObject,'String',Stim.us.probabilitySocial(thisNumber))
else
    
    Stim.us.probabilitySocial(thisNumber) = no;
end

function editCSpOwn_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pSocial_Callback (see GCBO)

global Stim 
callerTag = get(hObject,'Tag');
thisNumber =  str2double(callerTag(strfind(callerTag,'CS')+2:strfind(callerTag,'p')-1));
no = str2double(get(hObject,'String'));
if isnan(no) || ~(no>=0 & no<=100)
    warning('MODIG:paramGui_stimSelection:isnan','invalid input! Reverting...')
    set(hObject,'String',Stim.us.probability(thisNumber))
else    
    Stim.us.probability(thisNumber) = no;
end

function editCSpBucket_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pSocial_Callback (see GCBO)

global Stim 
callerTag = get(hObject,'Tag');
thisNumber =  str2double(callerTag(strfind(callerTag,'CS')+2:strfind(callerTag,'p')-1));
no = str2double(get(hObject,'String'));
if isnan(no) || ~(no>=0 & no<=100)
    warning('MODIG:paramGui_stimSelection:isnan','invalid input! Reverting...')
    set(hObject,'String',Stim.us.probabilityBucket(thisNumber))
else
    Stim.us.probabilityBucket(thisNumber) = no;
end

function checkboxCS_Callback(hObject,eventdata,handles)
global Stim
callerTag = get(hObject,'Tag');
thisNumber =  str2double( callerTag(strfind(callerTag,'CS')+3:size(callerTag,2)));
Stim.CS.active(thisNumber) = get(hObject,'Value');


