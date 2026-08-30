% clear;load('C:\Users\dfhil\Dropbox\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_14-Jul-2021\GettyCorrelateBidsFRClusters\Vic_cells_sits_3.mat')
clear;ca;


monk = 'Vic';
d = DropboxDir;

if strcmp(monk,'Vic')
    fn = [d,'\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_29-Nov-2021\GettyBidRegressionWithClustersRobust\Vic_cells_sits_1  2  3.mat'];
elseif strcmp(monk,'Uly')
    fn = [d,'\Schultz_Lab\BDM_Data\Uly_Data\ANALYSIS_25-Nov-2021\GettyBidRegressionWithClustersRobust\Uly_cells_sits_1  2  3.mat'];
end
load(fn);
%

tstbts = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp',...
    'WinLoseUp' 'RewardTapUp' 'BudgetTapUp'};
bit = 'FractalDisplayUp';
sigbit = bit;

sigOnly = 1;
wl=2;
testSit = 1:3;
nq=10;

saveIt = 1;

pre = 2000;
post = 2000;
num_msec = pre+post;
fr=[];zfr=[];

bin=1;

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

for iBt = 1:length(tstbts)
    bit = tstbts{iBt};
    nanix=zeros(length(RES),1);
    b=[];p=[];r=[];r2=[];;p_bin=[];b_bin=[];r2_bin=[]; n2=0;
    for i = 1:length(RES)
        if isnan(RES(i).rast.(bit))
            nanix(i,1) = 1;
        else
            mb=[];fr=[];frb=[];mmb=[];bix=[];
            mb = RES(i).event.monkeybid;
            cb = RES(i).event.computerbid;
            pcb = RES(i).event.previouscomputerbid_same_RV;
            sit = RES(i).event.situations;
            wltr = RES(i).event.previouswinlose;
            tl = RES(i).event.previoustotalliquid;
            sb = RES(i).event.startingbid;
            
            rst = RES(i).rast.(bit);
            %         rst = zscore(RES(i).rast.(bit),0,[2]);
            %         rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);
            
            fr = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
            
            if strcmp(bit,'RewardTapUp')
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
    
%     sigix = p<0.05&b>0;
    % sigix =  p_bin<0.05&b_bin>0;
    sigix = p<0.05&b>0 | p_bin<0.05&b_bin>0;%%%% | psr<0.05&posSR;
    
    
    % sigix = p<0.05&b<0 | p_bin<0.05&b_bin<0; %% negative correlation
    % sigix = p<0.05 | p_bin<0.05;
    
    % sigix = p_bin<0.05&p_bin~=0&b_bin>0;
    sigCell(1,iBt) = sum(sigix);
    
    
    BIDsig.(bit)=sigix';
    BIDS.(bit) = [r2',p',b'];
    BIDS_bin = [r2_bin',p_bin',b_bin'];
    BIDS_terc = [r2_terc',p_terc',b_terc'];
    %
    % sigcells(:,iB) = ~nanix;
    
    % for iB = 1:length(bits)
    % nanix=zeros(length(RES),1);
    % for i = 1:length(RES)
    %     if isnan(RES(i).(bits{iB}))
    %         nanix(i,1) = 1;
    %     end
    % end
    % sigcells(:,iB) = ~nanix;
    % end
    
    if sigOnly
        sRES = RES(~nanix & sigix');
    else
        sRES = RES(~nanix);
    end
    fr=[];cfr=[];nfr=[];mb=[];cb=[];sits=[];pctr = 0;ctr=0;cellnum=[];
    all_olix=0;
    for i = 1:length(sRES)
        nfrt=[];frt=[];mbt=[];cbt=[];sitt=[];p=[];r=[];evnts=[];nbitmat=[];
        evnts = sRES(i).event;
        if wl==0
            wlix = [evnts.monkeybid]<[evnts.computerbid];
            if strcmp(bit,'RewardTapUp')
                error('No reward in lost trial');
            end
        elseif wl==1 || strcmp(bit,'RewardTapUp')
            wlix = [evnts.monkeybid]>[evnts.computerbid];
        else
            wlix = ones(size([evnts.monkeybid]));
        end
        wlix = logical(wlix);
        
        mbt = evnts.monkeybid(wlix);
        cbt = evnts.computerbid(wlix);
        frt = sRES(i).FR.(bit)(wlix);
        rst = sRES(i).rast.(bit)(wlix,:);
        %     rst = zscore(RES(i).rast.(bit),0,[2]);
        %     rst = Z_scores_control_data(RES(i).rast.(bit),RES(i).rast.FixationCrossUp,[pre-500:pre-1]);
        
        %     frt = mean(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/bin*1000;
        frt = sum(rst(:,(pre+cc1)/bin:(pre+cc2)/bin),2)/((cc2-cc1)/bin)*1000;
        
        sitt = evnts.situations(wlix);
        cont = sRES(i).FR_control.(bit)(wlix);
        
        
        cfr = [cfr;cont];
        fr = [fr;frt];
        if sum(cont==0)==length(cont)
            continue
        end
        %         nfrt = (frt-nanmean(cont))./nanstd(cont);
        nfrt = zscore(frt);
        %         cont =  zscore(cont);
        %         nfrt = (frt-(cont))./(cont+.00000001)*100;
        %     nfrt = (frt-(cont));
        %         nfrt= MinMaxFS(frt);
        %         nfrt =frt;
        %
        
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %%%% Remove Outlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %     olix = isoutlier(nfrt,'grubbs');
        %     if sum(olix)>0
        %         all_olix = all_olix+1;
        %     end
        %     nfrt = nfrt(~olix);
        %     mbt = mbt(~olix);
        %     sitt = sitt(~olix);
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfr = [nfr;nfrt];
        mb = [mb;mbt];
        cb = [cb;cbt];
        sits = [sits;sitt];
        ctr=ctr+1;
        cctr = repmat(ctr,size(sitt));
        cellnum = [cellnum;cctr];
    end
    
    ix = ~isnan(nfr);
    
    mb = mb(ix);
    cb = 100-cb(ix);
    nfr = nfr(ix);
    cn = cellnum(ix);
    sits = sits(ix);
    
    Sitix = ismember(sits,testSit);
    nfr = nfr(Sitix);
    mb=mb(Sitix);
    cb=cb(Sitix);
    cn = cellnum(Sitix);
    
    cellcnt = numel(unique(cn));
    
    
    [sigCell(2,iBt),sigCell(3,iBt)] = corr(mb,nfr,'type','Pearson');
    disp('~~~~~~~~~~~~~~~~~~~~Robust~~~~~~~~~~~~~~~~~~~~')
    mdl=fitlm(mb,nfr,'RobustOpts','on')
    sum(~nanix)
end