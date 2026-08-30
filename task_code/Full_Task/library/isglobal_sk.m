function [TF value] = isglobal_sk(var)
gblist = whos('global');
if isstr(var)
        [TF LOC] = ismember(var,{gblist.name});
        if TF
           value = gblist(LOC);
        else
            value = [];
        end
end
