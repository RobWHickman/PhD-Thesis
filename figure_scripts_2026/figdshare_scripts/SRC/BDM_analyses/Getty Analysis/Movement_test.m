clear;ca;

%
d = DropboxDir;
dt = date;

monk='Vic';

RES = LoadMonkDataBDM(monk);
RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
RES=RES(RESix);
%%
%%
ca
clearvars -except RES monk d dt

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
sigbit = bit;

sigOnly = 0;
wl=2;
testSit = 1:3;
nq=10;

saveIt = 1;

pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];

bin=1;

% sitCols = [232/255 156/255 18/255;
% 0 114/255 206/255;
% 192/255 0 0;];
% sitCols = CB_reds(3);
sitCols = CB_blues(5);


if strcmp(monk,'Uly')
    cc1=180;
    cc2=340;
    %     cc1=180;
    %     cc2=340;
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    CHANGED on 01Feb2022   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     cc1=145;
    %     cc2=395;
end

nanix=zeros(length(RES),1);
p=[];r=[];n2=0;
for i = 1:length(RES)
    if isnan(RES(i).rast.(bit))
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double(RES(i).event.monkeybid);
        cb = double(RES(i).event.computerbid);
        pcb = double(RES(i).event.previouscomputerbid_same_RV);
        sit = double(RES(i).event.situations);
        wltr = double(RES(i).event.previouswinlose);
        tl = double(RES(i).event.previoustotalliquid);
        sb = double(RES(i).event.startingbid);
        
        rst = RES(i).rast.(bit);
        %         rst = zscore(RES(i).rast.(bit),0,[2]);
        %         rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);

        fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;


        if strcmp(bit,'RewardTapUp')
            fr = fr(mb>cb,:);
            mb = mb(mb>cb);
        end
        X = [ones(length(mb),1),mb];
        %         X = [ones(length(mb),1),mb,sit];
        %         X = [ones(length(mb),1),mb,sit,sb,pcb,wltr,tl];

        [bta,~,~,~,stats] = regress(fr,X);
        p(i) = stats(3);
        r2(i) = stats(1);
        b(i)=BetaNormalization(bta(2),mb,fr);
        %         if p(i)<.05 && b(i)<0
        %             QuickRasterPeth(rst)
        %             figure;scatter(mb,fr)
        %             ca
        %         end

        mnmb = min(mb);mxmb=max(mb);
        edgs = linspace(mnmb,mxmb,nq+1);
        %         edgs=linspace(min(mb)-(std(mb)*1),max(mb)+(std(mb)*1),nq+1);
        %         edgs=quantile(mb,nq+1);
        edgs(1)=0; edgs(end)=100;
        [~,~,bix] = histcounts(mb,edgs);
        frb = nan(1,nq);
        ubix = unique(bix);
        for ib = 1:length(ubix)
            iBfr = ubix(ib);
            frb(iBfr) = nanmean(fr(bix==iBfr));
            mbb(iBfr) = nanmean(mb(bix==iBfr));
        end
        bds = mbb;
        badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);
        X = [ones(length(bds),1),bds'];
        [bb,~,~,~,stats_bin] = regress(frb',X);
        p_bin(i) = stats_bin(3);
        r2_bin(i) = stats_bin(1);
        b_bin(i)=BetaNormalization(bb(2),mbb,frb);
        %terc
        X = [ones(length(bix),1),bix];
        [bt,~,~,~,stats_terc] = regress(fr,X);
        p_terc(i) = stats_terc(3);
        r2_terc(i) = stats_terc(1);
        b_terc(i) = BetaNormalization(bt(2),bix,fr);
    end
end
% sigix = p<0.05&p~=0&b>0 | p_bin<0.05&p_bin~=0&b_bin>0;

% sigix = p<0.05&b>0;
% sigix =  p_bin<0.05&b_bin>0;
sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;%%%% | psr<0.05&posSR;


% sigix = p<0.05&b<0 | p_bin<0.05&b_bin<0; %% negative correlation
% sigix = p<0.05 | p_bin<0.05;

% sigix = p_bin<0.05&p_bin~=0&b_bin>0;
sum(sigix)
%
ca
clearvars -except RES monk d dt sigix

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
sigbit = bit;

sigOnly = 0;
wl=2;
testSit = 1:3;
nq=10;

saveIt = 1;

pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];

bin=1;

sitCols = CB_blues(5);


if strcmp(monk,'Uly')
    cc1=180;
    cc2=340;
    %     cc1=180;
    %     cc2=340;
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    CHANGED on 01Feb2022   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     cc1=145;
    %     cc2=395;
end

nanix=zeros(length(RES),1);
p=[];r=[];n2=0;
FR = []; MB = [];VEL = [];SVEL=[];VELAV = [];ABSM = [];SABSM=[];
for iR = 1:length(RES)
    if isnan(RES(iR).rast.(bit))
        nanix(iR,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
%         mb = double(RES(iR).event.monkeybid);
%         cb = double(RES(iR).event.computerbid);
%         pcb = double(RES(iR).event.previouscomputerbid_same_RV);
%         sit = double(RES(iR).event.situations);
%         wltr = double(RES(iR).event.previouswinlose);
%         tl = double(RES(iR).event.previoustotalliquid);
%         sb = double(RES(iR).event.startingbid);
%         
        rst = RES(iR).rast.(bit);
        %         rst = zscore(RES(i).rast.(bit),0,[2]);
        %         rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
        nfr = zscore(fr);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %     clearvars -except RES d dt monk
        js = RES(iR).joystick_rast.BidStartUp;
        %     mb = RES(iR).event.monkeybid;
        
        jsm = mode(js(:,1:200),2);
        jsnrm = js-jsm;
        
        vel =[];svel=[];velav =[];absm=[];sabsm=[];mb=[];
        for iJ = 1:length(jsnrm(:,1))
            absm(iJ) = trapz(jsnrm(iJ,:));
            sabsm(iJ) = trapz(abs(jsnrm(iJ,:)));
            vel(iJ) = trapz(diff(jsnrm(iJ,:)));
            svel(iJ) = trapz(abs(diff(jsnrm(iJ,:))));
            velav(iJ) = mean(diff(jsnrm(iJ,:)));

            mb(iJ) = double(RES(iR).event.monkeybid(iJ));
        end
        
        [r.abs(1,iR),r.abs(2,iR)] = corr(absm(~isnan(absm))',mb(~isnan(absm))')
        [r.absfr(1,iR),r.absfr(2,iR)] = corr(absm(~isnan(absm))',fr(~isnan(absm)))
        
        [r.sabs(1,iR),r.sabs(2,iR)] = corr(sabsm(~isnan(sabsm))',mb(~isnan(sabsm))')
        [r.sabsfr(1,iR),r.sabsfr(2,iR)] = corr(sabsm(~isnan(sabsm))',fr(~isnan(sabsm)))
        
        [r.vel(1,iR),r.vel(2,iR)] = corr(vel(~isnan(vel))',mb(~isnan(vel))')
        [r.velfr(1,iR),r.velfr(2,iR)] = corr(vel(~isnan(vel))',fr(~isnan(vel)))
        
        [r.svel(1,iR),r.svel(2,iR)] = corr(svel(~isnan(svel))',mb(~isnan(svel))')
        [r.svelfr(1,iR),r.svelfr(2,iR)] = corr(svel(~isnan(svel))',fr(~isnan(svel)))
        
        [r.velav(1,iR),r.velav(2,iR)] = corr(velav(~isnan(velav))',mb(~isnan(velav))')
        [r.velavfr(1,iR),r.velavfr(2,iR)] = corr(velav(~isnan(velav))',fr(~isnan(velav)))
        
      
        
        [r.mbfr(1,iR),r.mbfr(2,iR)] = corr(mb(~isnan(mb))',fr(~isnan(mb)))

        FR = [FR;nfr];
        MB = [MB;mb'];
        VEL = [VEL;vel'];
        SVEL = [SVEL;svel'];
        VELAV = [VELAV;velav'];
        ABSM = [ABSM;absm'];        
        SABSM = [SABSM;sabsm'];
        
        
    end
end
%%
ca
figure
x = 1:length(r.velfr(1,:));y=ones(1,length(r.velfr(1,:)));
plot(r.velfr(1,:),'r- .')
hold on
sigix_1 = r.velfr(2,:)<0.05&r.velfr(1,:)>0;
plot(x(sigix_1),y(sigix_1)*-.36,'r*')
plot(x(sigix_1),r.velfr(1,sigix_1),'r*')


% % ca
% figure
x = 1:length(r.absfr(1,:));y=ones(1,length(r.absfr(1,:)));
plot(r.absfr(1,:),'b- .')
hold on
sigix_2 = r.absfr(2,:)<0.05&r.absfr(1,:)>0;
plot(x(sigix_2),y(sigix_2)*-.38,'b*')
plot(x(sigix_2),r.absfr(1,sigix_2),'b*')

% % figure
x = 1:length(r.mbfr(1,:));y=ones(1,length(r.mbfr(1,:)));
plot(r.mbfr(1,:),'c- .')
hold on
% sigix_2 = r.mbfr(2,:)<0.05;
plot(x(sigix),y(sigix)*-.4,'c*')
plot(x(sigix),r.mbfr(1,sigix),'c*')
% 
% 
% x = 1:length(r.mbfr(1,:));y=ones(1,length(r.mbfr(1,:)));
% % plot(r.mbfr(1,:))
% % hold on
% almost_sig = r.mbfr(2,:)<0.1;
% plot(x(almost_sig),y(almost_sig)*-.42,'c*')
% 
pubify_figure_axis_robust
WideFig
%%
figure
x = 1:length(r.svelfr(1,:));y=ones(1,length(r.svelfr(1,:)));
plot(r.svelfr(1,:),'- .')
hold on
sigix_1 = r.svelfr(2,:)<0.05&r.svelfr(1,:)>0;
plot(x(sigix_1),y(sigix_1)*-.36,'r*')
plot(x(sigix_1),r.svelfr(1,sigix_1),'r*')


% % ca
% figure
x = 1:length(r.sabsfr(1,:));y=ones(1,length(r.sabsfr(1,:)));
plot(r.sabsfr(1,:),'- .')
hold on
sigix_2 = r.sabsfr(2,:)<0.05&r.sabsfr(1,:)>0;
plot(x(sigix_2),y(sigix_2)*-.38,'b*')
plot(x(sigix_2),r.sabsfr(1,sigix_2),'b*')

% % figure
x = 1:length(r.mbfr(1,:));y=ones(1,length(r.mbfr(1,:)));
plot(r.mbfr(1,:),'- .')
hold on
% sigix_2 = r.mbfr(2,:)<0.05;
plot(x(sigix),y(sigix)*-.4,'c*')
plot(x(sigix),r.mbfr(1,sigix),'c*')
% 
% 
% x = 1:length(r.mbfr(1,:));y=ones(1,length(r.mbfr(1,:)));
% % plot(r.mbfr(1,:))
% % hold on
% almost_sig = r.mbfr(2,:)<0.1;
% plot(x(almost_sig),y(almost_sig)*-.42,'c*')
% 
pubify_figure_axis_robust
WideFig