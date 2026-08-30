function x=get_GUI_value(h)
if ishandle(h)
    items = get(h);
    CopyList = {'Style','Position','Color','ForegroundColor','BackgroundColor','Visible','HandleVisibility',...
        'String','Value','Name','CData','UserData'};

    if isfield(items,'Style')
        x.Style = get(h,'Style');
        if ismember(x.Style,{'popupmenu','listbox'})
            str = get(h,'String');
            val = get(h,'Value');
            if iscell(str)
                x.cur_name = str(val);
            else x.cur_name = {str}; % this case happens when there is only one input in the list.
            end
            if ischar(cell2mat(x.cur_name))
                nvv = str2double(cell2mat(x.cur_name));
                if ~isempty(nvv)
                    eval(strcat('x.numerical = nvv;'));
                else
                    eval(strcat('x.numerical = [];'));
                end
            end
        end
    else
        x.Style = [];
    end
    for cc = CopyList
        if isfield(items,cell2mat(cc))
            vv =  get(h,cell2mat(cc));
            eval(strcat('x.',cell2mat(cc),'= vv;'));
            if strcmp(cell2mat(cc),'String')
                if ischar(vv)
                    nvv = str2num(vv);
                    if ~isempty(nvv)
                        eval(strcat('x.numerical = nvv;'));
                    else
                        eval(strcat('x.numerical = [];'));
                    end
                end
            end
        else
            eval(strcat('x.',cell2mat(cc),'= [];'));
        end
        x.Handle = h;
    end
else
    x = [];
end




