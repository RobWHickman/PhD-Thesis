function cb = set_GUI_value(h,xx,yy)
% get values of a GUI object
% h: object handle
% xx: setting property type
% yy: setting property value
% e.g., set_GUI_value(h,'String','abc')

GUI_Info=get_GUI_value(h);
if isfield(GUI_Info,'Style')
    switch GUI_Info.Style
        case {'popupmenu','listbox'}
            switch xx
                case {'string','String'}
                    if isnumeric(yy),
                        yy = num2str(yy);
                    end
                    if isstr(yy)
                        if ismember(yy,GUI_Info.String)
                            val = findcell_sk(GUI_Info.String,yy);
                            set(h,'value',val(1));
                            cb = 1;
                        else
                            str = strcat(yy,' is not in the menu');
                            errordlg(str);
                            cb = 0;
                        end
                    else cb = 0;
                    end
                case {'value','Value'}
                    if isnumeric(yy)
                        if yy>0 & yy<=length(GUI_Info.String)
                            set(h,'value',yy);
                            cb = 1;
                        else
                            cb = 0;
                        end
                    else
                        cb = 0;
                    end
                otherwise
                    cb = 0;
            end
        case {'edit','text'}
            if isstr(yy)
            set(h,'string',yy);
            cd = 1;
            elseif isnumeric(yy)
                set(h,'string',num2str(yy));
                cb = 1;
            else
                errordlg('input is not appropriate'); 
                cb = 0;
            end
            cb = 1;
        otherwise
            cb = 0;
    end
else
    cb = 0;
end







