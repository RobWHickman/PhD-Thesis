% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')
clear;ca;

%
d = DropboxDir;
dt = date;

monk='Vic';

RES = LoadMonkDataBDM(monk);
ngt = sum([RES.numTrGood]);

RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
numDA = sum(RESix);
numnDA = ngt-numDA;
RES=RES(RESix);
%%
% 
ca
clearvars -except RES monk d dt H

bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
sigbit = bit;

sigOnly = 0;
wl=2;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        cb = 100-double(RES(i).event.computerbid);
        pcb = double(RES(i).event.previouscomputerbid_same_RV);
        sit = double(RES(i).event.situations);
        wltr = double(RES(i).event.previouswinlose);
        tl = sqrt(double(RES(i).event.previoustotalliquid));
        sb = double(RES(i).event.startingbid);
        tn =  double(RES(i).event.trialnums);
         

        rst = RES(i).rast.(bit);
        %         rst = zscore(RES(i).rast.(bit),0,[2]);
        %         rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);

        fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;

        if strcmp(bit,'RewardTapUp')
            fr = fr(mb>cb,:);
            mb = mb(mb>cb);
        end
        X = [ones(length(mb),1),mb,sit,tl,pcb,wltr,sb, tn];
        %         X = [ones(length(mb),1),mb,sit];
        %         X = [ones(length(mb),1),mb,sit,sb,pcb,wltr,tl];

        [bta,~,~,~,stats] = regress(fr,X);
        p(i) = stats(3);
        r2(i) = stats(1);
        b(i)=BetaNormalization(bta(2),tl,fr);
        %         if p(i)<.05 && b(i)<0
        %             QuickRasterPeth(rst)
        %             figure;scatter(mb,fr)
        %             ca
        %         end
        tbl = array2table([fr,X(:,2:end)]);
        tbl.Properties.VariableNames = {'fr' 'mb'  'sit' 'tl' 'pcb' 'wltr' 'sb' 'tn'};

        if numel(unique(sit))>1
            %         mdlStr = 'fr~mb+sit+tl+pcb+wltr+sb+(1|tn)' ;
%             mdlStr = 'fr~tl+pcb+wltr+sb+(1|tn)' ;
%             mdlStr = 'fr~1+(mb|sit)+(1|tn)';%tl+pcb+wltr+sb+
            mdlStr = 'fr~mb+(mb|sit)';%tl+pcb+wltr+sb+
%             mdlStr = 'fr~mb+(1|pcb)+(1|wltr)+(1|sb)+(1|sit)+(tl|tn)';%tl+pcb+wltr+sb+

%             mdlStr = 'fr~1+mb+sit+(1|tn)';%tl+pcb+wltr+sb+

%             mdlStr = 'fr~1+sit';%tl+pcb+wltr+sb+

            mdl = fitlme(tbl,mdlStr);
        if any([mdl.Coefficients.pValue]<.05)
            s_ix = [mdl.Coefficients.pValue] <.05;
            sigVar(i,:) = s_ix;
            r2(i) = mdl.Rsquared.Adjusted;
%             scatter3(mb,tn,fr)
%             ca
        end
        

        end
%         mnmb = 0;mxmb=1;
%         edgs = linspace(mnmb,mxmb,nq+1);
%         %         edgs=linspace(min(mb)-(std(mb)*1),max(mb)+(std(mb)*1),nq+1);
%         %         edgs=quantile(mb,nq+1);
%         edgs(1)=0; edgs(end)=100;
%         [~,~,bix] = histcounts(tl,edgs);
%         frb = nan(1,nq);
%         ubix = unique(bix);
%         for ib = 1:length(ubix)
%             iBfr = ubix(ib);
%             frb(iBfr) = nanmean(fr(bix==iBfr));
%             mbb(iBfr) = nanmean(l(bix==iBfr));
%         end
%         bds = mbb;
%         badix = isnan(frb);bds=bds(~badix);frb=frb(~badix);
%        
    end
end
% sigix = p<0.05&p~=0&b>0 | p_bin<0.05&p_bin~=0&b_bin>0;

sigix = p<0.05&b>0;
% sigix =  p_bin<0.05&b_bin>0;
% sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;%%%% | psr<0.05&posSR;


% sigix = p<0.05&b<0 | p_bin<0.05&b_bin<0; %% negative correlation
% sigix = p<0.05 | p_bin<0.05;

% sigix = p_bin<0.05&p_bin~=0&b_bin>0;
sum(sigix)
% sigix = p<0.05&p~=0&b>0 | p_bin<0.05&p_bin~=0&b_bin>0;
