function [TF,value empty] = isfield_sk(stem, fullname)
% [TF value empty] = isfield_sk(stem, fullname)
%
%   isfield_sk extracts values from field(s) found in the structure given
%   as input. 
%
%   In: stem, structure with field of interest
%       fullname, field of interest in the structure -struct or char-
%
%   Out: TF, sort of flow controller
%        value, the value of interest in stem
%        empty, emptiness of the value?
%

if isstruct(stem) && ischar(fullname)
    find_dot = findstr(fullname,'.');
    if ~isempty(find_dot)
        field_name(1) = {fullname(1:find_dot(1)-1)};
        for dd = 1:length(find_dot)-1
            field_name(dd+1) =  {fullname(find_dot(dd)+1:find_dot(dd+1)-1)};
        end
        field_name(length(field_name)+1) = {fullname(find_dot(end)+1:end)};
        main_name = 'stem';
        TF = 1;
        for ff = 1:length(field_name)
            if TF == 1 
                field_name_str = cell2mat(field_name(ff));
                bracket_left = strfind(field_name_str,'(');
                bracket_right = strfind(field_name_str,')');
                if ~isempty(bracket_left) & ~isempty(bracket_right)
                    cell_index = field_name_str(bracket_left(1)+1:bracket_right(1)-1);
                    if isnumeric(str2double(cell_index))
                        real_field_name_str = field_name_str(1:bracket_left-1);
                        cell_index = str2double(cell_index);
                        fld(ff) = isfield(eval(main_name),real_field_name_str);
                        if fld(ff) == 1
                            buf = eval(strcat('length(stem.',real_field_name_str,')'));
                            if buf>=cell_index
                                main_name =  strcat(main_name,'.',field_name_str);
                            else
                                TF = 0;
                            end
                        end
                    else
                        TF = 0;
                    end
                else
                    fld(ff) = isfield(eval(main_name),cell2mat(field_name(ff)));
                    if fld(ff) == 1
                        main_name = strcat(main_name,'.',cell2mat(field_name(ff)));
                    else
                        TF = 0;
                    end
                end
            end
        end
        if TF == 1
            value =  eval(main_name);
        else
            value = [];
        end
    else
        TF = isfield(stem,fullname);
        if TF ==1
            main_name = strcat('stem.',fullname);
            value = eval(main_name);
        else
            value = [];
        end
    end
else
    TF = 0;
    value = [];
    
end
empty = isempty(value);