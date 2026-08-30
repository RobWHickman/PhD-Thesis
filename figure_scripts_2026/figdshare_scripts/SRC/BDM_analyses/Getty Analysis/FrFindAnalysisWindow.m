% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')
clear;ca;

%
d = DropboxDir;
dt = date;

monk='Vic';

RES = LoadMonkDataBDM(monk);
RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
RES=RES(RESix);
%% % def 180
figure
col=[1 0 0;
    0 0 1];
for iS = 1:2
AC=[];
ctr=1;
for i=1:length(RES)
    rst = RES(i).rast.FractalDisplayUp;
    rst=zscore(rst,[],2);
    ix =  ismember(RES(i).event.situations,[iS]);
    rst = rst(ix,:);
    if ~isempty(rst)
        AC(ctr,:)= mean(rst);
        ctr=ctr+1;
    end
end

AC=zscore(AC,[],[2,1]);
ctlix = [1:2000];

plot(mean(smoothdata(AC,2,'movmean',80),'omitnan'),'Color',col(iS,:))
sd = 0.5*std(mean(AC(:,ctlix),'omitnan'));
mn = mean(mean(AC(:,ctlix),'omitnan'));
g=gca;
% line(g.XLim,[mn+sd mn+sd],'color','r')

line(g.XLim,[mn mn],'color',col(iS,:))
line([2180 2180],g.YLim,'color','k')
MedFigs
hold on
end

%% def 340/360
windw = 3;t=[];
for i=1:length(RES)
    rst = RES(i).rast.FractalDisplayUp;
    ix =  ismember(RES(i).event.situations,[3]);
    rst = rst(ix,:);
    ctr=1;
    ctl = mean(rst(:,1500:1999),2,'omitnan');
    rst=zscore(rst,[],2);
    %     ctl=zscore(ctl,[],2);
    if ~isempty(rst)
        AC(i,:)= mean(rst);
        for iTm = 2000:windw:2600
            tst = mean(rst(:,iTm:iTm+windw),2,'omitnan');
            t(i,ctr) = signrank(tst);%,ctl);
            ctr = ctr+1;
        end
    end
end


xax = 0:windw:600;
figure;plot(mean(smoothdata(AC,2,'movmean',50),'omitnan'))

sd = .25*std(mean(AC,'omitnan'));
mn = mean(mean(AC,'omitnan'));
g=gca;
line(g.XLim,[mn+sd mn+sd],'color','r')
line(g.XLim,[mn-sd mn-sd],'color','r')


line(g.XLim,[mn mn])
line([2360 2360],g.YLim,'color','k')
MedFigs

%% High val
ca;

windw = 20;pv=.05;

t=[];AC=[];
for i=1:length(RES)
    rst = RES(i).rast.FractalDisplayUp;
%     rst=zscore(rst,[],2);
    ix =  ismember(RES(i).event.situations,[3]);
    rst = rst(ix,:);
    AC(i,:) = mean(rst,'omitnan');
end
AC = AC(~all(isnan(AC),2),:);
%
p=[];h=[];
zAC = zscore(AC,[],[2,1]);
mAC = mean(zAC,'omitnan');
ctl = mAC(:,[1:800]);
ctr=1;
for i=1:windw:length(mAC)-windw
    tst = mAC(i:i+windw);
%     [p(ctr),h(ctr)] = ranksum(tst,ctl,'alpha',pv,'tail','right');
        [p(ctr),h(ctr)] = signrank(tst,0,'alpha',pv,'tail','right');
    %     [h(i),p(i)] = ttest(tst);
    ctr=ctr+1;
end
np = HolmBonferroni(p(2000/windw:2500/windw),pv);
Np = ones(length(h),1);
Np(2000/windw:2500/windw)=np;
xax= 0:windw:length(mAC)-windw-1;
figure;plot(xax,h)
figure;plot(xax,smoothdata(Np*-1,'movmean',1))
g=gca;
line(g.XLim,[-pv -pv])

%% low val
t=[];AC=[];
for i=1:length(RES)
    rst = RES(i).rast.FractalDisplayUp;
    rst=zscore(rst,[],2);
    ix =  ismember(RES(i).event.situations,[1]);
    rst = rst(ix,:);
    AC(i,:) = mean(rst,'omitnan');
end
AC = AC(~all(isnan(AC),2),:);
%
p=[];h=[];
zAC = zscore(AC,[],[2,1]);
mAC = mean(zAC,'omitnan');
ctr=1;
for i=1:windw:length(mAC)-windw
    tst = mAC(i:i+windw);
%     [p(ctr),h(ctr)] = ranksum(ctl,tst,'alpha',.05);
        [p(ctr),h(ctr)] = signrank(tst,0,'alpha',.05,'tail','left');
    %     [h(i),p(i)] = ttest(tst);
    ctr=ctr+1;
end
xax= 0:windw:length(mAC)-windw-1;
figure;plot(xax,h)
figure;plot(xax,p*-1)

%%
p=[];r=[];
windw = 1;t=[];
for i=1:length(RES)
    rst = RES(i).rast.FractalDisplayUp;
    rst=zscore(rst,[],2);
    sits = double(RES(i).event.situations);

    ctr=1;
    ctl = mean(rst(:,1500:1999),2,'omitnan');
    %     %     ctl=zscore(ctl,[],2);
    if ~isempty(rst)
        AC(i,:)= mean(rst);
        for iTm = 2000:windw:2600
            tst = mean(rst(:,iTm:iTm+windw),2,'omitnan');
            [r(i,ctr),p(i,ctr)] = corr(sits,tst);
            ctr = ctr+1;
        end
    end
end
xax = 0:windw:600;
%
y=mean(r,'omitnan');
y=smoothdata(y,2,'movmean',20);
figure
plot(xax,y)
hold on
sig = smoothdata(sum(p<0.05),'movmean',10);
plot(xax,sig)
