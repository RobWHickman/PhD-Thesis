function updateMoMaMe_BDM_BC(option)
% updateMoMaMe_TOUCH_TRAINING(option)
%
% creates a project specific and totally modifiable update area in the
% MOMaMe figure using uicontrols. 
% 
% inputs: 'initialize' -->creates the uicontrols
%         'update' --> updates the counters.
%         'reset' --> resets the counters
%
% rbm 6.11
% rbm 3.14 MRT adaptation

global MENUs TaskOp BehaveData Task

figHdl = MENUs.ModigMainMenu.handle;
upArea = MENUs.ModigMainMenu.handles.prjUpArea;

%% Custom GUI

























%% ORIGINAL GUI ATTRIBUTES:
switch option,
    case 'initialize',
        
        % change Area name,
        set(upArea,'Units','pixels')
        set(upArea,'Title', TaskOp.prj)

        % delete previous data
        kids = get(upArea, 'children');
        delete(kids)
        

        % since the parent is the project update area the position values are in
        % reference to the ui control parent, *not* the figure itself
        uicontrol(upArea, 'style', 'text', 'units', 'pixels',...  
            'HorizontalAlignment','left',...
            'position', [1 1 120 135],... 
            'fontSize', 10,...
            'backgroundColor', [0.831 0.816 0.784],...
            'tag', 'optionsText', ...
            'string',{'Past trial RT (ms)';'Mean RT (ms)'})

        % for simpler updating use matrix
        uicontrol(upArea, 'style', 'text', 'units', 'pixels',...
            'position', [130 1 75 135],... 
            'HorizontalAlignment','left',...
            'fontSize', 10, ...
            'backgroundColor', [0.831 0.816 0.784],...
            'tag', 'counterValues',...
            'string',num2str(zeros(2,1)))      
        
        % error strings...
        uicontrol(upArea, 'style', 'text', 'units', 'pixels',...
            'position', [205 1 120 135],... 
            'HorizontalAlignment','right',...
            'fontSize', 10, ...
            'backgroundColor', [0.831 0.816 0.784],...
            'tag', 'errorStrings',...
            'string',{'Early KT release: ';'No touch: '; 'Errors in succesion: '});
        uicontrol(upArea, 'style', 'text', 'units', 'pixels',...
            'position', [325 1 50 135],... 
            'HorizontalAlignment','left',...
            'fontSize', 10, ...
            'backgroundColor', [0.831 0.816 0.784],...
            'tag', 'errorNos',...
            'string',num2str(zeros(3,1)));

        % update gui handles
        uih = guihandles(figHdl);
        guidata(figHdl, uih);

        % update our globals
        MENUs.ModigMainMenu.handles = sort_structure(uih);
        MENUs.ModigMainMenu.handle  = figHdl;

        TaskOp.count.earlyRelease   = 0; % here we save early key touch releases
        TaskOp.count.noTouch        = 0; % save no touches
        TaskOp.count.successiveError= 0;
        TaskOp.count.choiceRT       = []; 
        TaskOp.count.seq            = 0;
        
    case 'update',
        % variables can be undeclared,
        if ~isfield(TaskOp.count,'choiceRT') || ~isfield(TaskOp.count,'successiveError')
            updateMoMaMe_BDM_BC('initialize')
            updateMoMaMe_BDM_BC('update')
        end
       
        choiceRT = NaN;
        m = 0;

        % update counters
        if TaskOp.correct
       
        else
            TaskOp.count.successiveError = TaskOp.count.successiveError +1;
        end
        
        if ~isempty(TaskOp.count.choiceRT),
            m = round(mean(TaskOp.count.choiceRT)*1000);
        end              
        s = num2str([round(choiceRT*1000); m]);
        set(MENUs.ModigMainMenu.handles.counterValues, 'string', s)
        
        en = [TaskOp.count.earlyRelease; TaskOp.count.noTouch; TaskOp.count.successiveError];
        set(MENUs.ModigMainMenu.handles.errorNos, ...
            'string',num2str(en))       
    
    case 'reset',
        TaskOp.count.earlyRelease   = 0; % here we save early key touch releases
        TaskOp.count.noTouch        = 0; % save no touches
        TaskOp.count.successiveError= 0;
        TaskOp.count.choiceRT       = []; 
        TaskOp.count.seq            = 0;
        
        s = num2str([0; 0]);
        set(MENUs.ModigMainMenu.handles.counterValues, 'string', s)
        
        en = [TaskOp.count.earlyRelease; TaskOp.count.noTouch; TaskOp.count.successiveError];
        set(MENUs.ModigMainMenu.handles.errorNos, ...
            'string',num2str(en))     
end
