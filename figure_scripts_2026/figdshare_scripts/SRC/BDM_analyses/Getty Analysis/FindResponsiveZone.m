clear;ca;
%
d = DropboxDir;
dt = date;

monk='Vic';

RES = LoadMonkDataBDM(monk);
RESix=[RES.isDA]&[RES.isResponsive]&[RES.numTrGood];
RES=RES(RESix);
%%
clearvars -except RES monk dt d
test_sit = [1:3];
ts = num2str(test_sit);

%%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%
if strcmp(monk,'Vic')
%     td = [d,'\Schultz_Lab\BDM_Data\Vicer_data\ANALYSIS_29-Nov-2021\GettyBidRegressionWithClustersRobust\'];
%     load([td,'Vic_cells_sits_1  2  3.mat'])
    savDir = We_want_dir_funk([d,'Schultz_Lab\BDM_Data\Manuscript\Misc Figs\Rasters by frac smooth\Vic\',dt,'\sit_',ts,'_nbs\']);
else strcmp(monk,'Uly')
%     td = [d,'\Schultz_Lab\BDM_Data\Uly_Data\ANALYSIS_25-Nov-2021\GettyBidRegressionWithClustersRobust\'];
%     load([td,'Uly_cells_sits_1  2  3.mat'])
    savDir = We_want_dir_funk([d,'\Schultz_Lab\BDM_Data\Manuscript\Misc Figs\Rasters by frac smooth\Uly\',dt,'\sit_',ts,'\']);
end

%%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%%% FILES %%

%%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%%
pre = 2000;
post = 2000;
num_msec = pre+post;

pop = 1;
bin = 1;
nq = 10;
num_splits = 5; %number of splits for PETH traces
sw = 200;
smeth = 'hamming';
bgs=0;
smoothit=1;
%%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% PARAMS %%%% 


%%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%%%%%
if strcmp(monk,'Uly')
    cc1=180;%%%%%%%%%%%%%%%%%%    CHANGE BACK   %%%%%%%%%%%%%%%%%
    cc2=340;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     cc1=180;
%     cc2=340;
elseif strcmp(monk,'Vic')
    cc1=180;%%%%%%%%%%%%%%%%%%    CHANGED 01Feb2022   %%%%%%%%%%%
    cc2=360;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     cc1=145;
%     cc2=395;
end
% Vic alt win 140:230
%%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%% ANALYSIS WINDOW %%%%%%%


%%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%
bits = {'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardTapUp' 'BudgetTapUp'};
testBit = 'FractalDisplayUp';
sigbit = testBit;
%%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%%% BITS %%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
col = CambridgeDark(3);

numBin = (pre+post)/bin;
x = (((1:numBin)-.5)*bin)-pre;

nanix=zeros(length(RES),1);
p=[];r=[];fr=[];zfr=[];
for i = 1:length(RES)
    if isnan(RES(i).rast.(sigbit))
        nanix(i,1) = 1;
    else
        mb=[];fr=[];frb=[];mmb=[];bix=[];
        mb = double(RES(i).event.monkeybid);
        cb = double(RES(i).event.computerbid);
        %         fr = RES(i).FR.(sigbit);
        sits = double(RES(i).event.situations);      
        
        rst = RES(i).rast.(testBit);
        ct_rst = RES(i).rast.FixationCrossUp;
        
        %         rst = zscore(RES(i).rast.(testBit),0,[2]);
        %         rst = Z_scores_control_data(rst,ct_rst(:,bin:(pre-500)/bin));
        
%         rst = rst-mean(ct_rst([1:pre,pre+1000:end]),2);
        
        
        figure
        subplot(7,1,1:5)
        imagesc(rst)
        subplot(7,1,6:7)
        for iSit=1:3
        plot(mean(smoothdata(rst(sits==iSit,:),2,'movmean',100)))
        hold on
        end
        
        ca
        
        mid_sits = ismember(sits,test_sit);
        rst = rst(mid_sits,:);
        ct_rst = ct_rst(mid_sits,:);
        mb =  mb(mid_sits);                   
        
        if isempty(mb)
            continue
        end
        

    end
    
end
