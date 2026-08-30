clear;ca;
% pd = 'C:\Users\dfhil\Dropbox\Schultz_Lab\Vicer\BX\BC_data\FirstWeek\';
% pd = 'C:\Users\dfhil\Dropbox\Schultz_Lab\Vicer\BX\BC_data\SecondWeek\';

pd = 'C:\Users\dfhil\Dropbox\Schultz_Lab\Vicer\BX\BC_data\';

fn = dir([pd,'*COMP*']);
for i = 1:length(fn)
    tbl = readtable([pd,fn(i).name]);
    if ~isa(tbl.date(1),'datetime')
        dt = cellfun(@(x) datetime(x,'Format','yyyy-dd-MM'),tbl.date);
        tbl.date = dt;
    end         

    if i==1
        BCv= tbl;
    else
        BCv = [BCv;tbl];
    end
end