function varargout = REWARD_CAL(varargin)
% varargout = REWARD_CAL(varargin)
%
% m-file controlling REWARD_CAL.fig/GUI
%

% SK wrote it

if nargin == 0,  % LAUNCH GUI
    h_menu = openfig(mfilename,'new');
    handles = guihandles(h_menu);
    guidata(h_menu, handles);
    REWARD_CAL_OpeningFcn(h_menu,[],handles);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargout > 0,
        varargout{1} = h_menu;
    end
elseif ischar(varargin{1}), % INVOKE NAMED SUBFUNCTION OR CALLBACK
    try
        [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
    catch
        disp(lasterr);
    end
end


% --- Executes just before REWARD_CAL is opened.
function REWARD_CAL_OpeningFcn(hObject, eventdata, handles, varargin)
%%%
global IO

set(handles.EDIT_FREE_RWD, 'String', IO.Output.free_juice.dur)
set(handles.EDIT_FREE_RWD, 'Value', IO.Output.free_juice.dur)
set(handles.EDIT_TASK_RWD, 'String', IO.Output.task_juice.dur)
set(handles.EDIT_TASK_RWD, 'Value', IO.Output.task_juice.dur)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PUSH_CANCEL_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ModigMenuControl('REWARD_CAL','OFF');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PUSH_SUBMIT_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global IO Timers
GUI_info = get_menu_contents(handles.REWARD_CAL);

% set free reward bit and duration updated to menu.
IO.Output.free_juice.dur = GUI_info.CONTENTS.EDIT_FREE_RWD.numerical;
ModigSetTimer('Output','free_juice');

% set task reward bit and duration updated to menu.
IO.Output.task_juice.dur = GUI_info.CONTENTS.EDIT_TASK_RWD.numerical;
ModigSetTimer('Output','task_juice');

% close GUI
ModigMenuControl('REWARD_CAL','OFF');

