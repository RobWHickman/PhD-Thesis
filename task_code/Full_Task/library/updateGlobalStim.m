function updateGlobalStim
% Updates MENU tab with STIM fields. 
% 
% 
% See also ModigChangeTask ModigMainMenu
%
% TODO: it calls irrelevant guis?

global MENUs Tbl TaskOp Stim ModigPrj

% update global Tbl.Stim
% create dialogues to change Stim properties under STIM menu
xx=get(MENUs.ModigMainMenu.handles.MENU_SET_STIM,'children');
if ~isempty(xx)
    delete(xx);    % delete existing submenus
end

% create calls
if ~isempty(Stim),
    stimFld = fields(Stim);
    CALLS = cell(length(stimFld),1);
    TAGS  = cell(length(stimFld),1);
    LABELS = stimFld;
    for i = 1:length(stimFld),
        if isempty(Stim.(stimFld{i}))
            CALLS{i} = 'warndlg(''empty!'')';
        else
            CALLS{i} = ['global Stim, Stim.',(stimFld{i}),' = (StructDlg(Stim.',(stimFld{i}),')); clear Stim'];
        end
        TAGS{i}  = ['MENU_Stim_', stimFld{i}];   
    end
    % put new submenus
    menu_handles=makemenu(MENUs.ModigMainMenu.handles.MENU_SET_STIM,...
        str2mat(LABELS),str2mat(CALLS),str2mat(TAGS)); 
end

% update handles for ModigMainMenu
MENUs.ModigMainMenu.handles = guihandles(MENUs.ModigMainMenu.handles.ModigMainMenu);
guidata(MENUs.ModigMainMenu.handles.ModigMainMenu, MENUs.ModigMainMenu.handles);

% prepare Menu submenu under 'TAB' in the main menu
% labels that show up on the submenu
eval(strcat('LABELS=ModigPrj.',TaskOp.prj,'.MenuTbl(:,Tbl.MenuTblColumnID.tab_name);')); 

 % labels that show up on the submenu
eval(strcat('FUNCTION_NAME=ModigPrj.',TaskOp.prj,'.MenuTbl(:,Tbl.MenuTblColumnID.function_name);'));

% call back function in the format of ModigMenuControl(gui_name)
CALLS=strcat('ModigMenuControl(','''',FUNCTION_NAME,'''',');'); 
TAGS=strcat('MENU_',FUNCTION_NAME);

% delete existing submenu
xx=get(MENUs.ModigMainMenu.handles.MENU_TAB,'children');
if ~isempty(xx)
    delete(xx);    
end

% put new submenus
menu_handles=makemenu(MENUs.ModigMainMenu.handles.MENU_TAB,str2mat(LABELS),str2mat(CALLS),str2mat(TAGS)); 

% update handles
MENUs.ModigMainMenu.handles = guihandles(MENUs.ModigMainMenu.handles.ModigMainMenu);
guidata(MENUs.ModigMainMenu.handles.ModigMainMenu, MENUs.ModigMainMenu.handles);

[TH_default, default_id, EMPTY_default] = isfield_sk(Tbl,'MenuTblColumnID.default_on');
if ~EMPTY_default
    default_on = Tbl.MenuTbl(:,default_id);
end
num_row = size(Tbl.MenuTbl,1);
for rr = 1:num_row
    if cell2mat(default_on(rr))
        eval(cell2mat(CALLS(rr)));
    end
end
MENUs.ModigMainMenu.handles = guihandles(MENUs.ModigMainMenu.handles.ModigMainMenu);
guidata(MENUs.ModigMainMenu.handles.ModigMainMenu, MENUs.ModigMainMenu.handles);