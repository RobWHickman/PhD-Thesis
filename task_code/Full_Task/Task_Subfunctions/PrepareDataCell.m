function PrepareDataCell(Cols,String)% PrepareDataCell

DATACELL = cell(1000,Cols);        % Column 1 contains the data structure, column 2 contains the indicator of trial type.
Filename = date;
Filename = strcat(String,Filename);
save(Filename,'DATACELL');
clear DATACELL