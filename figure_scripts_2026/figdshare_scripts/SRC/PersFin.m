tbl = StatementDownload2021Apr23230003;



sbix = tbl.Description=='SAINSBURY''S S/MKTS CAMBRIDGE EDD GB'|tbl.Description=='SAINSBURYS S/MKTS CAMBRIDGE GB';
groc = tbl(sbix,:);

dt = datetime(strrep(string(groc.Date),' ','-'));

[ym(:,1),ym(:,2)] = ymd(dt);

[c,ia,ic] = unique(ym,'rows');


boxplot(groc.Paidout,ic);

grpstats(groc.Paidout,ic)

gs = groupsummary(groc.Paidout,ic,'sum')