function GUI_Info = get_menu_contents(h)
% get gui information

if ishandle (h)
    if strcmp(get(h,'type'),'figure')
        handles = guidata(h);
        if ~isempty(handles)
        items = fields(handles);
        for hh = 1: length(items)
            h_item = eval(strcat('handles.',cell2mat(items(hh))));
            item_contents = get(h_item);
            temp = get_GUI_value(h_item);
            if h_item == h,
                eval(strcat('GUI_Info.MENU = temp;'));
                if isfield(item_contents,'Units')
                    GUI_Info.MENU.unit = get(h_item,'Units');
                end
                if isfield(item_contents,'Name')
                    GUI_Info.MENU.name = get(h_item,'Name');
                end

            else
                if ~isempty(temp)
                    eval(strcat('GUI_Info.CONTENTS.',cell2mat(items(hh)), '= temp;'));
                    clear temp
                end
            end
        end
        else
            GUI_Info.note = 'handle does not contain any object';
        end
    else
        GUI_Info.note = 'handle is not a figure';
    end
    GUI_Info.MENU.date = clock;

else GUI_Info.note = 'handle does not exist';
end

