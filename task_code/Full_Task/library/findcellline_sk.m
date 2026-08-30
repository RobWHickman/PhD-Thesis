function y=findcellline_sk(x,s,ss)
% x: cell table
% First row of x is presumed to be title of each column. [eg. 'company'     'model'    'weight'  'color']
% s is one of these title names. [eg. 'company']
% ss is specific item belongs to s. [eg. 'JAGUAR']
% this function searchs specific item [eg JAGUAR] in the specific column [eg. company]
% and makes a structure constructed of the specific row
% [eg. y.company='JAGUAR', y.model='XJ6', x.weight=2160kg, x.color='British Racing Green']

% In case multiple lines are relevant,
% struct_JAGUAR(1).model='XJ6', struct_JAGUAR(1).weight=2160kg, struct_JAGUAR(1).color='British Racing Green'
% struct_JAGUAR(2).model='XJ12',struct_JAGUAR(1).weight=2580kg, struct_JAGUAR(2).color='Maloon'
% etc.
% skoba 2004.10.7
buf=findcell_sk(x,s);
if size(buf,1)>1
    sprintf('multiple columns for the category name in the cell table');return
end
if ~isempty(buf)
    CategoryColumn=buf(2);
    OutName=strcat('struct_',s);
    space_pos=findstr(OutName,' ');% space makes problem ->replaced with underbar
    OutName(space_pos)='_';
    eval(strcat(OutName,'=[];'));
    buf2=x(:,CategoryColumn);
    buf3=findcell_sk(buf2,ss);
    ItemRow=buf3(:,1);
    for item=1:length(ItemRow)
        for cc=1:size(x,2)
            if cc~=CategoryColumn,
                FieldName=cell2mat(x(1,cc));
                if ~isempty(FieldName)
                    if isnumeric(FieldName)
                        FieldName=num2str(FieldName);
                    elseif ischar(FieldName)
                        space_pos=findstr(FieldName,' ');% space makes problem ->replaced with underbar
                        FieldName(space_pos)='_';
                    end
                    
                    buf4=cell2mat(x(ItemRow(item),cc));
                    if isnumeric(buf4) & ~isempty(buf4),
                        eval(strcat(OutName,'(',num2str(item),')','.',FieldName,'=',num2str(cell2mat(x(ItemRow(item),cc))),';'));
                    elseif ischar(buf4) & ~isempty(buf)
                        eval(strcat(OutName,'(',num2str(item),')','.',FieldName,'=','''',cell2mat(x(ItemRow(item),cc)),''';'));
                    end
                end
            end
        end
    end
end
y=eval(OutName);