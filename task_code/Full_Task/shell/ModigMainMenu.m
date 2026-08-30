function varargout = ModigMainMenu(varargin)
% MODIGLIANI Application M-file for ModigMainMenu.fig
%    FIG = ModigMainMenu launch MODIGLIANI GUI.
%    ModigMainMenu('callback_name', ...) invoke the named callback.

% coded by skoba (skoba-tky@umin.ac.jp) 8 June 2005
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global UserInfo
if nargin == 0,                             % LAUNCH GUI
    h_menu = openfig(mfilename,'reuse');
    handles = guihandles(h_menu);
    guidata(h_menu, handles);
    if nargout > 0,
        varargout{1} = h_menu;
    end
elseif ischar(varargin{1}),       % INVOKE NAMED SUBFUNCTION OR CALLBACK
    try
        [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
    catch
        disp(lasterr);
    end
end

%%%
function runScreenWarmer

global VisParam,

ScreenWarmer(VisParam.scr_handle,[],Inf);

%%%
function runScreenWarmerColor

global VisParam,

screenWarmerColor(VisParam.scr_handle,VisParam.scr_rect,60);

%%%
function RepositionOpenGUIs

global MENUs

flds = fieldnames(MENUs);
for ii = 1:length(flds),
    if strcmp(MENUs.(flds{ii}).status,'ON'),
        cp = get(MENUs.(flds{ii}).handle,'Position');
        set(MENUs.(flds{ii}).handle, 'Position', [0 0 cp(3:4)]);
    end
end

%%%
function SetFreeJuice(time)

global Timers
DIOoffset = 5;
timer_fcn = ['DIOjuice(',num2str((time-DIOoffset)/1000),')'];
set(Timers.Output.free_juice,'TimerFcn', timer_fcn)