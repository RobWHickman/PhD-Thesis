fldr = 'D:\GoogleDrive\VICER_BX_ONLY_2020';

cd(fldr);
fl = dir('*.csv*');
fln = {fl.name};
%%

for iF = 1:length(fln)
    tbl = readtable(fln{iF},'DatetimeType','text');
    
    CT(iF).date = datestr(datetime(tbl.date(1),'InputFormat','yyyy-dd-MM'));
    CT(iF).start_time = tbl.time(1);
%         CT(iF).start_time = duration(tbl.time(1),'Format','hh:mm:ss');

    
    CT(iF).end_time = tbl.finish(end);
    CT(iF).total_time = tbl.finish(end)-tbl.time(1);
    
    CT(iF).correct = nansum(tbl.paid==1|tbl.paid==0);
    CT(iF).errors = sum(isnan([tbl.paid]));
    
    CT(iF).win = sum(tbl.paid==1);
    CT(iF).lose = sum(tbl.paid==0);
    
    CT(iF).juice = (tbl.juice(end));
    CT(iF).water = (tbl.water(end));
end

CT_tbl = struct2table(CT);

[C,iv,ic] = unique(CT_tbl.date);
ix = sort(iv);
zs = ones(1,length(CT_tbl.date));
zs(ix) = 0;
dups = find(zs);

if ~isempty(dups)
    ds = [1,diff(dups)];
    de = [diff(dups),2];
    startix = [dups(1)-1,dups(ds>1)-1];
    stopix = dups(de>1);
    
    
    for iD = 1:length(startix)
        dupix = startix(iD):stopix(iD);
        old_table_vals = CT_tbl(dupix,:);
        new_row_vals.date = old_table_vals.date(1);
        new_row_vals.start_time = old_table_vals.start_time(1);
        new_row_vals.end_time = old_table_vals.end_time(end);
        new_row_vals.total_time = new_row_vals.end_time-new_row_vals.start_time;
        
        new_row_vals.correct = nansum(old_table_vals.correct);
        new_row_vals.errors = sum(old_table_vals.errors);
        
        new_row_vals.win = sum(old_table_vals.win);
        new_row_vals.losw = sum(old_table_vals.lose);
        
        new_row_vals.juice = sum(old_table_vals.juice);
        new_row_vals.water = sum(old_table_vals.water);
        
        CT_tbl(startix(iD),:) = struct2table(new_row_vals);
    end
    CT_tbl(dups,:) = [];
end

% writetable(CT_tbl,'C:\Users\GETTY324\Dropbox\Schultz_Lab\Vicer\HO\Vicer_BX.csv')    
writetable(CT_tbl,'D:\Dropbox\Schultz_Lab\Vicer\HO\Vicer_BX.csv')    


