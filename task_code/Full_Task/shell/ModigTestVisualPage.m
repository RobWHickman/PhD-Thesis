function varargout = ModigTestVisualPage(varargin)
% varargout = ModigTestVisualPage(varargin)
%
% Dialog menu to test/debug visual display from the current project. 
% The real output is written in the global VisStat. 
%

% SK  wrote it
% RBM comments Cell-style, re-created GUI for Window$, generated save and
%     cancel push-buttons callbacks, elapsed page time is evaluated using
%     GetSecs from the PTB, priority introduction, resize fcn from GUIDE
% rbm 6.11

if nargin == 0,
    % open or raise figure and give hdl
    h_menu = openfig(mfilename,'reuse');
    % obtain handles from all the UI controls in the GUI
    handles = guihandles(h_menu);
    % Store the UI handles as GUI data
    guidata(h_menu, handles)
%     arrange_menu(h_menu, [], handles)
    CurSetToMenu(h_menu,handles)
    if nargout > 0,
        varargout{1} = h_menu;
    end
elseif ischar(varargin{1}),                 % INVOKE NAMED SUBFUNCTION OR CALLBACK
    try
        [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
    catch
        disp(lasterr);
    end
end

%%
function varargout = ModigTestVisualPage_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%% Load variables stored in global VisStat into the GUI and inform about
% refresh rate
function CurSetToMenu(h_menu,handles)
global VisStat VisParam TaskOp
% measure (again) the presentation monitor refresh rate, and present it
refresh = Screen('GetFlipInterval', VisParam.scr_handle)*1000; 
set(handles.refreshText, 'String', ['Presentation Monitor Refresh Rate [ms]:', num2str(refresh)]);

if isfield(VisStat,'num_test')
    set(handles.EDIT_NUM_TRIAL,'string',num2str(VisStat.num_test));
end
if isfield(VisStat,'page_interval')
    set(handles.EDIT_PAUSE,'string',num2str(VisStat.page_interval));
end
if isfield(VisStat,'randomize_trial')
    set(handles.RADIO_RANDOMIZE,'value',VisStat.randomize_trial);
end
if isfield(VisStat,'make_correction')
   set(handles.RADIO_CORRECTION,'value',VisStat.make_correction);
end
if isfield(VisStat,'Tbl')
    data = mltable(h_menu, handles.AXES_SUMMARY, 'CreateTable',...
        VisStat.Tbl.columninfo, VisStat.Tbl.rowHeight, VisStat.Tbl.cell_data, VisStat.Tbl.gFont);
    delete(data.btnAdd);
    delete(data.btnDel);
end

% generate visual pages/update radio
eval(strcat('ModigPrepareTrial_',TaskOp.prj))
eval(strcat('ModigPreparePages_',TaskOp.prj));


myStr = {'off','on'};
for i = 1:10,
    myHdl = eval(sprintf('handles.radiobuttonPage_%d',i));
    set(myHdl,'Enable',myStr{1+(i<=VisParam.num_page)})
end
%% --- Executes on button press in PUSH_SAVE.
function PUSH_SAVE_Callback(hObject, eventdata, handles)
% hObject    handle to PUSH_SAVE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% overwrite global 'VisStat' according to the current menu settings and
% save it as current_param and default_param in UserInfo

global VisStat MENUs TaskOp
% get the values from mtltable and save them in the UserInfo global
VisStat = get(MENUs.ModigTestVisualPage.handles.AXES_SUMMARY,'userdata');
VisStat.make_correction = get(MENUs.ModigTestVisualPage.handles.RADIO_CORRECTION,'value');
eval(strcat('UserInfo.current_param.',TaskOp.prj,'.SavedParam.VisStat = VisStat;'));
eval(strcat('UserInfo.default_param.',TaskOp.prj,'.SavedParam.VisStat = VisStat;'));

% close GUI
% close(handles.ModigTestVisualPage)

%% --- Executes on button press in PUSH_CANCEL.
function PUSH_CANCEL_Callback(hObject, eventdata, handles)
% hObject    handle to PUSH_CANCEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global VisParam
% flip Monitor to black background
Screen('FillRect', VisParam.scr_handle, [0 0 0]);
Screen('Flip',VisParam.scr_handle);
% clear experimenter monitor
kids = get(VisParam.h_MONITOR_AXIS,'children');
delete(kids)

% Close GUI, remember, it doesn't makes sense to interrupt the visual
% evaluation while it should be running in maximum Priority  
close(handles.ModigTestVisualPage)

%% --- Executes on button press in PUSH_START.
function PUSH_START_Callback(hObject, eventdata, handles)
global TaskOp VisStat VisParam 

% feedback to the user...
set(hObject,'String','Busy')
pause(0.1)

vis_mfilename = strcat('ModigPreparePages_',TaskOp.prj);
if exist(vis_mfilename, 'file')
    cb = eval(vis_mfilename);
    if cb
        % obtain data from GUI
        VisData.delay = [];
        num_test = get_GUI_value(handles.EDIT_NUM_TRIAL);
        TempVisStat.num_test = num_test.numerical;
        page_interval = get_GUI_value(handles.EDIT_PAUSE);
        TempVisStat.page_interval = page_interval.numerical;
        
        refresh = Screen('GetFlipInterval', VisParam.scr_handle); 
        
        % TRIAL LOOP
        for tt = 1:TempVisStat.num_test
            infoStr = sprintf('ModigTestVisualPage testing page timing... %d of %d times',tt,TempVisStat.num_test);
            disp(infoStr)
            if get(handles.RADIO_RANDOMIZE,'value')
                TempVisStat.randomize_trial = 1;
                RandomizeTrial;
            else
                TempVisStat.randomize_trial = 0;
            end
            
            % PAGES LOOP
            Priority(2);           
            pp = 1;
            pastTS = GetSecs;
            eval(VisParam.page(pp).draw);
            while pp<numel(VisParam.pages)
                currentTS = eval(VisParam.page(pp).flip);
                VisData.delay(pp,tt) = currentTS-pastTS;
                pastTS = currentTS;
                pp = pp + 1;
                eval(VisParam.page(pp).draw);
                WaitSecs(TempVisStat.page_interval-refresh);
            end
            Priority(0);     

            TaskOp.count.seq = TaskOp.count.seq + 1;
            if TaskOp.count.seq > TaskOp.count.total_seq
                TaskOp.count.seq = 1;
            end
        end
        VisData.delay = round(VisData.delay*1000);
        cla,
        plot(handles.resultsAxes,VisData.delay(2:end,:))
        set(handles.resultsAxes,'xtick',1:size(VisData.delay,1))
        xlabel(handles.resultsAxes,'Page #')
        ylabel(handles.resultsAxes,'\delta time from last flip (ms)')
        
        
        % feedback to the user...
        set(hObject,'String','START')
        return
        
        % display results
        cell_data = {length(VisParam.pages),3};
        for pp = 1:size(VisData.delay,1),
            cell_data(pp,1) = {strcat('page_',num2str(pp))};
            cell_data(pp,2) = {mean(VisData.delay(pp,:))};
            cell_data(pp,3) = {std(VisData.delay(pp,:))};
            eval(strcat('TempVisStat.page(',num2str(pp),').mean=mean(VisData.delay(',num2str(pp),',:));'));
            eval(strcat('TempVisStat.page(',num2str(pp),').sd=std(VisData.delay(',num2str(pp),',:));'));
        end
        
        TempVisStat.num_page = length(VisParam.pages);
        TempVisStat.pages = VisParam.pages;
        % create output table 
        TempVisStat.prj = TaskOp.prj;
        columninfo.titles={'Page','Mean [ms]','SD [ms]'};
        columninfo.formats = {'%s','% 4.5g','% 4.5g'};
        columninfo.weight =      [ 1, .85, .85];
        columninfo.multipliers = [ 1, 1, 1];
        columninfo.isEditable =  [ 0, 0, 0];
        columninfo.isNumeric =   [ 0  1, 1];
        columninfo.withCheck = false;
        rowHeight  = 16;
        gFont.size = 9;
        gFont.name = 'Century';
        data = mltable(handles.ModigTestVisualPage, handles.AXES_SUMMARY, 'CreateTable', columninfo, rowHeight, cell_data, gFont);
        delete(data.btnAdd);
        delete(data.btnDel);
        TempVisStat.Tbl.columninfo = columninfo;
        TempVisStat.Tbl.rowHeight = rowHeight;
        TempVisStat.Tbl.cell_data = cell_data;
        TempVisStat.Tbl.gFont = gFont;
        set(handles.PUSH_CANCEL,'visible','on');
        set(handles.PUSH_SAVE,'visible','on');
        set(handles.RADIO_CORRECTION,'visible','on');
        set(handles.AXES_SUMMARY,'userdata',TempVisStat);
    else
        ModigMessage('m&c','visual test did not start because task parameters are not set properly', 8);
    end
end


%%
function RandomizeTrial
global TaskOp
code_name = strcat('ModigPrepareTrial_',TaskOp.prj);
if exist(code_name, 'file') % Set parameters in each trial
    cb_trial_param  = eval(code_name);
else
    cb_trial_param = 0;
end
code_name = strcat('ModigPreparePages_',TaskOp.prj);
if exist(code_name, 'file') %  Prepare graphic presentation in all the pages, by drawing onto off screen
    cb_visual_param = eval(code_name);
else
    cb_visual_param = 0;
end


% --- Executes on button press in pushbuttonShowPage.
function pushbuttonShowPage_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonShowPage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TaskOp

% I need to delcare some event name so that the visual page evaluation runs
% smoothly
TaskOp.cur_event_name = 'ITI';
Task.(TaskOp.cur_event_name).flipTimeStamp = 0;

% read selected page
selectedRadioHandle = get(handles.uipanelPageRadio,'SelectedObject');
radioString = get(selectedRadioHandle,'String');
page = str2double(radioString(6:end));

% evaluate ModigShiftEvent with this page...
ModigShiftEvent('ShowVisualPage',page, [], [])
ModigShiftEvent('ShowExpVisualPage',page)

% --- Executes on button press in pushbutton_reloadImages.
function pushbutton_reloadImages_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reloadImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TaskOp
% evaluate prepare trial and prepare pages scripts for the current project
eval(sprintf('ModigPrepareTrial_%s;',TaskOp.prj))
eval(sprintf('ModigPreparePages_%s;',TaskOp.prj))

