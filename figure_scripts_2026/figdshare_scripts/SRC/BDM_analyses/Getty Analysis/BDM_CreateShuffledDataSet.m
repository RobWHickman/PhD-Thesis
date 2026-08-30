ca;clear;
monk= 'Vic';
% d = DropboxDir;
% if strcmp(monk,'Uly')
% load([d,'\Schultz_Lab\BDM_Data\Uly_Data\ANALYSIS_25-Nov-2021\GettyBidRegressionWithClustersRobust\Uly_cells_sits_1  2  3.mat'])
% elseif strcmp(monk,'Vic')
% load([d,'\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_29-Nov-2021\GettyBidRegressionWithClustersRobust\Vic_cells_sits_1  2  3.mat'])
% end

RES = LoadMonkDataBDM(monk);
RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
RES=RES(RESix);

%%
clearvars -except RES monk 
% ca
pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];
% 
bin=1;

if strcmp(monk,'Uly')
    cc1=180;
    cc2=340;
%     cc1=60;
%     cc2=180;
%     cc1=340;
%     cc2=500;
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%    CHANGED 01Feb2022   %%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     cc1=150;
%     cc2=360;
%     cc1=360;
%     cc2=500;

    %         cc1=145;
%         cc2=395;
end
% cc1=80;
% cc2=500;

% % % Vic alt win 140:230

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
testBit = 'FractalDisplayUp';
sigbit = testBit;
nq=10;

nanix=zeros(length(RES),1);
p=[];r=[];
for i = 1:length(RES)
    if isnan(RES(i).rast.(sigbit)) 
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double(RES(i).event.monkeybid);
        cb = double(RES(i).event.computerbid);
        %         mb = MinMaxFS(1-cb);
        % mb = double(RES(i).event.situations);
        % mb = [nan;mb(1:end-1)];
        % mb = double(RES(i).event.previoustotalliquid);


%         fr = RES(i).FR.(sigbit); 
        rst = RES(i).rast.(testBit);
%         rst = zscore(RES(i).rast.(testBit),0,[2]);

        fr = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
%         fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;

        if strcmp(testBit,'RewardTapUp')
            fr = fr(mb>cb,:);
            mb = mb(mb>cb);
        end
        X = [ones(length(mb),1),mb];
        [bta,~,~,~,stats] = regress(fr,X);
        p(i) = stats(3);
        r2(i) = stats(1);
        b(i)=BetaNormalization(bta(2),mb,fr);
        mnmb = min(mb);mxmb=max(mb);
        edgs = linspace(mnmb,mxmb,nq+1);
%         edgs=linspace(min(mb)-(std(mb)*1),max(mb)+(std(mb)*1),nq+1);
%         edgs=quantile(mb,nq+1);
        edgs(1)=0; edgs(end)=100;
        [~,~,bix] = histcounts(mb,edgs);
        frb = nan(1,nq);
        ubix = unique(bix);
        ubix=ubix(ubix>0);
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

sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;
% sigix = p<0.05 | p_bin<0.05;

% sigix = p<0.05 | p_bin<0.05;

sum(sigix)

%% Sliding Window
clearvars -except RES sigix bin cc1 cc2 testBit monk 
% ca
pre = 2000;
bin=1;
npre = 500;
npost = 1000;
bgs=1;
swFR = 1;
iter = 20; % iterate by iter milliseconds
bw = 40; % bin width
shuff = 0;
sigOnly = 0;

testSit =1:3;
% testBit = 'FractalDisplayUp';
testBit = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp',...
    'RewardTapUp' 'RewardEpochEndUp' 'BudgetTapUp'};

regressors = {'monkeybid' 'situations' 'computerbid' 'previouscomputerbid_same_RV',...
    'previouswinlose' 'previoustotalliquid' 'startingbid' };

if sigOnly
    sRES = RES(sigix);
else
    sRES = RES;
end
r2=[];bta=[];
for iR = 1:length(sRES)
    for iB = 1:length(testBit)
        for irg = 1:length(regressors)
            bt = testBit{iB};
            reg = regressors{irg};
            iv=[];
            if strcmp(reg,'previouscomputerbid_same_RV')||strcmp(reg,'computerbid')
                iv = 1-double(sRES(iR).event.(reg));
            else
                iv = double(sRES(iR).event.(reg));
            end
            
            sits = double(sRES(iR).event.situations);

            rst=[];crst=[];
            rst = double(sRES(iR).rast.(bt)(:,(pre-npre+1)/bin:(pre+npost)/bin));
            crst = double(sRES(iR).rast.FixationCrossUp(:,(pre-npre+1)/bin:(pre+npost)/bin));
            %     rst = double(sRES(iR).rast.(testBit));
            %     crst = double(sRES(iR).rast.FixationCrossUp);
            if sum(sum(rst))<10
                continue
            end                

            if swFR
                swRst=[];
                for j = 1:width(rst)-100
                    swRst(:,j) = (sum(rst(:,j:j+100),2,'omitnan')./100).*1000;
                end
                rst = swRst;
            end


            if bgs
                rst=rst-mean(crst(:,npre-npre+1:npre-50),2,'omitnan');
            end

            stix = ismember(sits,testSit);
            stiv = iv(stix);
            stst = sits(stix);

            sitRst = rst(stix,:);
            csitRst = crst(stix,:);
            if isempty(sitRst)
                continue
            end
            X = [ones(size(stiv)),stiv];

            %     X = [ones(size(stmb)),stmb,pcb(stix),sit(stix),wl(stix),tl(stix),sb(stix)];

            nitr = ((length(sitRst(1,:))-bw)/bin)/iter;
            for ii = 1:nitr
                fr=[];
                ix = (iter*ii)-iter+1:(iter*ii)-iter+bw;
                fr = mean(sitRst(:,ix),2,'omitnan');

                cfr = mean(csitRst(:,ix),2,'omitnan');
                stats=[];
                [b,bint,r,rint,stats]= regress(fr,X); %stats=[r2 F p var];
                
                if isnan(stats(1)) || stats(1)==0
                    regression.(bt).(reg).r2(iR,ii) = 0;
                    regression.(bt).(reg).pv(iR,ii) = 1;
                    regression.(bt).(reg).bta(iR,ii) = 0;
                else
                    regression.(bt).(reg).r2(iR,ii) = stats(1);
                    regression.(bt).(reg).pv(iR,ii) = stats(3);
                    regression.(bt).(reg).bta(iR,ii) = BetaNormalization(b(2),iv,fr);
                end                
            end           
        end
    end
    iR
end