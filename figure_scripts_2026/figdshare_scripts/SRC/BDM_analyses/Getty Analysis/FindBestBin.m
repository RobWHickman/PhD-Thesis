ca;clear;load('Vic_cells_sits_1  2  3.mat')
bits = {'TrialOnsetUp' 'FixationCrossUp' 'FractalDisplayUp' 'BidStartUp' 'BidStableUp' 'WinLoseUp' 'RewardEpochEndUp' 'RewardTapUp' 'BudgetTapUp'};
testBit = 'BidStartUp';
ctr2=0;
%%
for iR = 1:length(RES)
    B=[];nB=[];
    r = RES(iR).rast.(testBit);
    mb = RES(iR).(testBit)(:,3);
    tic
    ctr=0;numComp =0;
    for i = 2050:10:2500
        for ii = 50:10:500
            ctr = ctr+1;
            fr=[];
            if i+ii>3000
                continue
            end
            fr = nanmean(r(:,i:i+ii),2);
            num = sum(fr>0);
            X = [ones(length(mb),1),mb];
            [b,~,~,~,stats] = regress(fr,X);
            B(ctr,1)=b(2);
            B(ctr,2)=stats(1);
            B(ctr,3)=stats(3);
            B(ctr,4) = i-2000;
            B(ctr,5) = ii+i-2000;
            B(ctr,6)=num;
            numComp = numComp+1;
        end
    end
    toc
    
    %     nB = MinMaxFS(B,2);
    badix = isnan(B(:,3))|B(:,3)==0;
    B = B(~badix,:);
    nB = zscore(B);
    
    sigix = B(:,3)<.05 & B(:,1)>0;
    B = B(sigix,:);
    nB = nB(sigix,:);
    
    if sum(sigix)>0 && max(B(:,6))>10
        ctr2 = ctr2+1;
        %         [~,ix]=max(B(:,2));
        %         [~,ix]=max(B(:,6));
        [~,ix]=max(nB(:,2).*nB(:,6));
        bestBin(ctr2,1) = B(ix,4);
        bestBin(ctr2,2) = B(ix,5);
        bestBin(ctr2,3) = B(ix,2);
        bestBin(ctr2,4) = B(ix,3);
        disp(iR)
        figure
        subplot(7,1,1:4)
        PlotTrueRaster(r)
        ShadedBox([2000+B(ix,4),2000+B(ix,4)+B(ix,5)])
        title(B(ix,3))
        subplot(7,1,5:7)
        fr2=[];
        fr2 = nanmean(r(:,2000+B(ix,4):2000+B(ix,4)+B(ix,5)),2);
        scatter(mb,fr2)
        title([num2str(B(ix,4)),'  ',num2str(B(ix,5))]);
        SkinnyFigs
        B = sortrows(B,3);
        ca
    end
end
bestBin = sortrows(bestBin,4);


hist(bestBin(:,1))
edges = 0:20:500
h = histcounts(bestBin(:,1),edges)
bar(h)
%%
ctr = 0;ctr2=0;

for i = 2040:50:4000
    tic
    for ii = 50:50:2000
        ctr = ctr+1; 
        for iR = 1:length(RES)
            B=[];nB=[];mb=[];fr=[];
            r = RES(iR).rast.(testBit);
            mb = RES(iR).(testBit)(:,3);
            fr=[];
            if i+ii>4000
                continue
            end
            fr = nanmean(r(:,i:i+ii),2);
            num = sum(fr>0);
            X = [ones(length(mb),1),mb];
            [b,~,~,~,stats] = regress(fr,X);         
            if stats(3)<.05
                p(iR) = stats(3);
                h(iR) = 1;
            else
                p(iR)=stats(3);
                h(iR)=0;
            end
        end
        numSig(ctr,1) = sum(h==1);
        numSig(ctr,2) = i;
        numSig(ctr,3) = i+ii;
    end
    toc
end
numSig = sortrows(numSig,1,'descend');
%%
ctr2=0;numSigCells=[];
for iR = 1:length(RES)
    B=[];nB=[];mb=[];fr=[];
    r = RES(iR).rast.(testBit);
    mb = RES(iR).(testBit)(:,3);
    fr=[];
    if i+ii>3000
        continue
    end
    fr = nanmean(r(:,numSig(1,2):numSig(1,3)),2);
    num = sum(fr>0);
    X = [ones(length(mb),1),mb];
    [b,~,~,~,stats] = regress(fr,X);
    if stats(3)<.05
        ctr2=ctr2+1;
        numSigCells(ctr2)=iR;
    end
end

%%
% numComp=0;
%   for i = 2000:10:3000
%         for ii = 50:5:500
%             ctr = ctr+1;
%             fr=[];
%             if i+ii>3000
%                 continue
%             end
%             numComp = numComp+1;
%         end
%     end
%%
%
%  B = B(~isnan(B(:,3)),:);
%     B = B(~B(:,3)==0,:);
%     nB(:,3)=(1./B(:,3));
%     nB = zscore(nB);
%     sigix = B(:,3)<.05 & B(:,1)>0;
%     B = B(sigix,:);
%     nB = nB(sigix,:);