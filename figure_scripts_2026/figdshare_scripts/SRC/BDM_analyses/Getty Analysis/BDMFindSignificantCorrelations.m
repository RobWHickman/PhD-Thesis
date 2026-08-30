% function sigix = BDMFindSignificantCorrelations(RES)

%%
ca;clear;
monk= 'Uly';
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

cc1=40;
cc2=540;

bw = 200;
iter = 100;
nitr = (range([cc1,cc2]))/iter;

bgs=0;
zsc=0;

bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
testBit = 'FixationCrossUp';

regressors = {'monkeybid' 'situations' 'computerbid' 'previouscomputerbid_same_RV',...
    'previouswinlose' 'previoustotalliquid' 'startingbid' };

sigbit = testBit;
nq=10;

nanix=zeros(length(RES),1);
p=[];r=[];sigix = zeros(length(RES),1);p_ix=zeros(length(RES),nitr);
for iii = 1:length(bits)
    bt = bits{iii};
    for ii = 1:length(regressors)
        reg = regressors{ii};
        for i = 1:length(RES)
            mb=[];fr=[];frb=[];mmb=[];bix=[];iv=[];
            %         mb = double(RES(i).event.monkeybid);
            %         cb = double(RES(i).event.computerbid);
            %         pcb = double(RES(i).event.previouscomputerbid_same_RV);
            %         ptl = double(RES(i).event.previoustotalliquid);
            iv = double(RES(i).event.(reg));
            if strcmp(reg,'previouscomputerbid_same_RV') ||strcmp(reg,'computerbid')
                iv = 1-(iv/100);
            end

            %         fr = RES(i).FR.(sigbit);
            rst = RES(i).rast.(bt);
            crst = RES(i).rast.FixationCrossUp;
            if bgs
                rst=rst-mean(crst(:,pre-1000+1:pre),2,'omitnan');
            end
            if zsc
                rst = zscore(RES(i).rast.(testBit),0,[2]);
            end


            for ii = 1:nitr
                fr=[];
                ix = (iter*ii)-iter+1:(iter*ii)-iter+bw;
                fr = mean(rst(:,pre+cc1+ix),2,'omitnan');

                %         fr = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
                %         fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;

                if strcmp(testBit,'RewardTapUp')
                    fr = fr(iv>cb,:);
                    iv = iv(iv>cb);
                end
                X = [ones(length(iv),1),iv];
                [bta,~,~,~,stats] = regress(fr,X);
                p(ii) = stats(3);
                r2(ii) = stats(1);
                b(ii)=BetaNormalization(bta(2),iv,fr);
%                 mnmb = min(iv);mxmb=max(iv);
%                 edgs = linspace(mnmb,mxmb,nq+1);
%                 %         edgs=linspace(min(mb)-(std(mb)*1),max(mb)+(std(mb)*1),nq+1);
%                 %         edgs=quantile(mb,nq+1);
%                 if strcmp(reg,'monkeybid')
%                     edgs(1)=0; edgs(end)=100;
%                 end
%                 [~,~,bix] = histcounts(iv,edgs);
%                 frb = nan(1,nq);
%                 ubix = unique(bix>0);
%                 for ib = 1:length(ubix)
%                     iBfr = ubix(ib);
%                     frb(iBfr) = nanmean(fr(bix==iBfr));
%                     mbb(iBfr) = nanmean(iv(bix==iBfr));
%                 end
%                 bds = mbb;
%                 badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);
%                 X = [ones(length(bds),1),bds'];
%                 [bb,~,~,~,stats_bin] = regress(frb',X);
%                 p_bin(ii) = stats_bin(3);
%                 r2_bin(ii) = stats_bin(1);
%                 b_bin(ii)=BetaNormalization(bb(2),mbb,frb);
            end
            p_bin=1;b_bin=0;
            p = HolmSidak(p,.05);p_bin = HolmSidak(p_bin,.05);
            %         p = HolmBonferroni(p,.05);p_bin = HolmBonferroni(p_bin,.05);

            if any(p<.05&b>0)||any(p_bin<.05&b_bin>0)
                p_ix(i,:) = p<.05|p_bin<.05;
                r2_all(i,:) = r2;
                sigix(i)=1;
            end
        end
        % sigix = p<0.05&p~=0&b>0 | p_bin<0.05&p_bin~=0&b_bin>0;

        % sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;
        % sigix = p<0.05 | p_bin<0.05;

        sgx.(bt).(reg)=sigix;
        sigix_neuron.(bt).(reg)= p_ix;


        sum(sigix)
        sum(p_ix)
    end
end

