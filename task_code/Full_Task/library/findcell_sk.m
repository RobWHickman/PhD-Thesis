function y=findcell_sk(x,s)
    % search specific string/num in cell array x.
    % return address (row column)
    % skoba 2004.10.7
    % wild card function added 2005.05.04

if iscell(x) & (ischar(s)|isnumeric(s))
    [r c]=size(x);
    y=[];
    for rr=1:r
        for cc=1:c
            if iscell(x(rr,cc))
                buf=cell2mat(x(rr,cc));
                if ischar(s) & ischar(buf)
                    if strcmp(s,'*'),
                        y=[y;[rr cc]]; % take everything
                    else
                        if strcmp(buf,s),y=[y;[rr cc]];end
                    end
                elseif isnumeric(s) & isnumeric(buf)
                    if s==buf,y=[y;[rr cc]];end
                end
            end
        end
    end
    
else 
    y=-1;sprintf('function findcell takes a set of input (cell array, string/nuÇç'); return
end