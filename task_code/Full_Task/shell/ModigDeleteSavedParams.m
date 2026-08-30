function h = ModigDeleteSavedParams(varargin)
% Delete saved project parameters saved in a file
h = [];
if nargin == 0
    global UserInfo
    h = figure;
    bgcolor = get(h,'Color');
    set(h,'Position',[0 0 300 100],'MenuBar','none','name','Delete saved params','NumberTitle','off','tag','DeleteSavedParams');
    h_TEXT_USER_ID =   uicontrol(h,'Style','text','position',[10 80 50 10],'BackgroundColor',bgcolor,'string','USER:');
    h_EDIT_USER_ID =   uicontrol(h,'Style','text','position',[60 80 100 10],'BackgroundColor',bgcolor,'string',UserInfo.username,'HorizontalAlignment','left');
    cb = strcat('ModigDeleteSavedParams(''cb_pop_param_type'',',num2str(h),');');
    h_POP_PARAM_TYPE = uicontrol(h,'Style','popupmenu','position',[10 50 100 20],'tag','POP_PARAM_TYPE','callback',cb,'BackgroundColor',bgcolor,'string',{'default param','current param'},'HorizontalAlignment','left','value',2);
    h_POP_PRJ = uicontrol(h,'Style','popupmenu','position',[120 50 100 20],'tag','POP_PRJ','BackgroundColor',bgcolor,'HorizontalAlignment','left','str','xxx');
    cb = strcat('ModigDeleteSavedParams(''cb_push_delete'',',num2str(h),');');
    h_PUSH_DELETE = uicontrol(h,'Style','pushbutton','position',[10 20 100 20],'tag','PUSH_DELETE','callback',cb,'BackgroundColor',bgcolor,'HorizontalAlignment','center','str','DELETE');
    cb = strcat('ModigDeleteSavedParams(''cb_push_check'',',num2str(h),');');
    h_PUSH_DELETE = uicontrol(h,'Style','pushbutton','position',[120 20 100 20],'tag','PUSH_CHECK','callback',cb,'BackgroundColor',bgcolor,'HorizontalAlignment','center','str','CHECK');

    handles = guihandles(h);
    guidata(h,handles);
    
    ModigDeleteSavedParams('cb_pop_param_type',h);
else
    if strcmp(varargin(1),'cb_pop_param_type')
        cb_pop_param_type(varargin(2));
    elseif strcmp(varargin(1),'cb_pop_prj')
        cb_pop_prj(varargin(2));
    elseif strcmp(varargin(1),'cb_push_delete')
        cb_push_delete(varargin(2));     
    elseif strcmp(varargin(1),'cb_push_check')
        cb_push_check(varargin(2));        
    end
end

function cb_pop_param_type(h)
global UserInfo
handles = guidata(cell2mat(h));
buf = get_GUI_value(handles.POP_PARAM_TYPE);
if strcmp(buf.cur_name,'default param')
        [THdp default_param EMPTYdp] = isfield_sk(UserInfo,'default_param');
        if ~EMPTYdp
            str = fieldnames(default_param);
            cb = strcat('ModigDeleteSavedParams(''cb_pop_prj'',',num2str(cell2mat(h)),')');
            set(handles.POP_PRJ,'string',str,'callback',cb);
        else
            set(handles.POP_PRJ,'string','no params saved');
        end
elseif strcmp(buf.cur_name,'current param')
        [THcp current_param EMPTYcp] = isfield_sk(UserInfo,'current_param');
        if ~EMPTYcp
            str = fieldnames(current_param);
            cb = strcat('ModigDeleteSavedParams(''cb_pop_prj'',',num2str(cell2mat(h)),')');
            set(handles.POP_PRJ,'string',str,'callback',cb);
        else
            set(handles.POP_PRJ,'string','no params saved');
        end
end
    
function cb_pop_prj(h)

function cb_push_delete(h)
global UserInfo
handles = guihandles(cell2mat(h));
prj = get_GUI_value(handles.POP_PRJ);
param_type = get_GUI_value(handles.POP_PARAM_TYPE);
if ~strcmp(prj.cur_name,'no params saved')
    if strcmp(param_type.cur_name,'current param')
        eval(strcat('UserInfo.current_param = rmfield(UserInfo.current_param,','''',cell2mat(prj.cur_name),'''',');'));
        if isempty(fieldnames (UserInfo.current_param))
            UserInfo.current_param = [];
        end
    elseif strcmp(param_type.cur_name,'default param')
        eval(strcat('UserInfo.default_param = rmfield(UserInfo.default_param,','''',cell2mat(prj.cur_name),'''',');'));
        if isempty(fieldnames (UserInfo.default_param))
            UserInfo.default_param = [];
        end
    end
end
cb_pop_param_type(h);

function cb_push_check(h)
global UserInfo
handles = guihandles(cell2mat(h));
prj = get_GUI_value(handles.POP_PRJ);
param_type = get_GUI_value(handles.POP_PARAM_TYPE);
if ~strcmp(prj.cur_name,'no params saved')
    if strcmp(param_type.cur_name,'current param')
        global cur_info
        cur_info = eval(strcat('UserInfo.current_param.',cell2mat(prj.cur_name)));
        str = '%%%%%%%%%%%%%%%%%%%%%';
        fprintf('%s\n',str);
        str = 'current_param -> cur_info';
        fprintf('%s\n',str);
        str = '%%%%%%%%%%%%%%%%%%%%%';
        fprintf('%s\n',str);
        cur_info.SavedParam

    elseif strcmp(param_type.cur_name,'default param')
        global cur_info
        cur_info = eval(strcat('UserInfo.default_param.',cell2mat(prj.cur_name)));
        str = '%%%%%%%%%%%%%%%%%%%%%';
        fprintf('%s\n',str);
        str = 'current_param -> cur_info';
        fprintf('%s\n',str);
        str = '%%%%%%%%%%%%%%%%%%%%%';
        fprintf('%s\n',str);
        cur_info.SavedParam
    end
end
