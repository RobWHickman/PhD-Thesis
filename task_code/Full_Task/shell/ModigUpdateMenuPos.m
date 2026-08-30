function ModigUpdateMenuPos
% Store position of present GUIs -found in MENUs- in global "MenuPos"
%
% rbm 06.08 before only when global MenuPos wasn't empty did this fx eval.

global MenuPos MENUs %TaskOp

menus= fields(MENUs);
for mm = menus'
    h_menu = findobj('Tag',cell2mat(mm));
    if ~isempty(h_menu)
        if strcmp(get(h_menu,'Type'),'figure')
            set(h_menu,'Unit','pixel');
        end
        menu_position = get(h_menu,'position');
        eval(strcat('MenuPos.',cell2mat(mm),'.position = menu_position;'));
    end
end
