function [RES,MonkeyBid,Predictors,ZMonkeyBid,ZPredictors] = GenerateBDMTable(RES)

[C,ia,ic] = unique({RES.day});

for iT = 1:length(RES)
end

for iT = 1:length(RES)
    od = RES(iT).day(1:8);
    %     nd = [od(1:4),'-',od(5:6),'-',od(7:8)]
    nd = datetime(od,'InputFormat', 'yyyyMMdd');
    datnum = (datenum(nd));
    if iT==1
        dn1 = datnum;
    end
    RES(iT).SessionNumber = ic(iT);
    RES(iT).DateNumber = datnum-dn1+1;
    [DayNum,DayNam] = weekday(nd);
    RES(iT).DayOfWeek = DayNum;
end


P = struct2table(RES);
MonkeyBid = P{:,1};
Predictors = removevars(P,{'MonkeyBid','day'});
%%
[C,ia,ic] = unique(Predictors.SessionNumber);
vn = Predictors.Properties.VariableNames;
svn = join(vn);
for iPw = 1:width(Predictors)
    for i = 1:length(C)
        ix = find(ic==C(i));
        z_data(ix) = normalize([Predictors{ix,iPw}]);
        ZMonkeyBid(ix,1)=normalize(MonkeyBid(ix));
    end
    ZP(:,iPw)=z_data;
end
ZPredictors = array2table(ZP,'VariableNames',vn);