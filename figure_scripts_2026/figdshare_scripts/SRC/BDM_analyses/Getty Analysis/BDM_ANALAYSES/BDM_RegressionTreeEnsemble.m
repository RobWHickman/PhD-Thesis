[RES,MonkeyBid,Predictors,ZMonkeyBid,ZPredictors] = GenerateBDMTable(RES);


% ix = Predictors.Fractal==2;
% X = ZPredictors{ix,:};
X = [ZPredictors{:,1:16},Predictors{:,17:20}];
vn = ZPredictors.Properties.VariableNames;
rng(1); % For reproducibility
% Mdl = fitrensemble(X,MonkeyBid,'Learners',t,'CrossVal','on');
t = templateTree('MaxNumSplits',5);
ens = fitrensemble(X,MonkeyBid,'Method','LSboost','Learners',t);

[imp,ma] = predictorImportance(ens);

% Sem(ma)
%%
figure
ax = bar(1:20,imp);
xticks(1:20)
xticklabels(vn)
xtickangle(45)
pubify_figure_axis_robust
% MedFigs


% kflc = kfoldLoss(Mdl,'Mode','cumulative');
% figure;
% plot(kflc);
% ylabel('10-fold cross-validated MSE');
% xlabel('Learning cycle');
%%
% rng(1) % For reproducibility
% MdlDeep = fitrtree(X,MonkeyBid,'CrossVal','on','MergeLeaves','off', ...
%     'MinParentSize',1,'Surrogate','on');
% MdlStump = fitrtree(X,MonkeyBid,'MaxNumSplits',1,'CrossVal','on', ...
%     'Surrogate','on');
% 
% 
% 
% n = size(X,1);
% m = floor(log2(n - 1));
% learnRate = [0.1 0.25 0.5 1];
% numLR = numel(learnRate);
% maxNumSplits = 2.^(0:m);
% numMNS = numel(maxNumSplits);
% numTrees = 150;
% Mdl = cell(numMNS,numLR);
% 
% ctr=1;
% for k = 1:numLR
%     for j = 1:numMNS
%         t = templateTree('MaxNumSplits',maxNumSplits(j),'Surrogate','on');
%         Mdl{j,k} = fitrensemble(X,MonkeyBid,'NumLearningCycles',numTrees, ...
%             'Learners',t,'KFold',5,'LearnRate',learnRate(k));
%         disp(num2str(ctr));
%         ctr = ctr+1;
%     end
% end
% 
% kflAll = @(x)kfoldLoss(x,'Mode','cumulative');
% errorCell = cellfun(kflAll,Mdl,'Uniform',false);
% error = reshape(cell2mat(errorCell),[numTrees numel(maxNumSplits) numel(learnRate)]);
% errorDeep = kfoldLoss(MdlDeep);
% errorStump = kfoldLoss(MdlStump);
% mnsPlot = [1 round(numel(maxNumSplits)/2) numel(maxNumSplits)];
% figure;
% for k = 1:3
%     subplot(2,2,k)
%     plot(squeeze(error(:,mnsPlot(k),:)),'LineWidth',2)
%     axis tight
%     hold on
%     h = gca;
%     plot(h.XLim,[errorDeep errorDeep],'-.b','LineWidth',2)
%     plot(h.XLim,[errorStump errorStump],'-.r','LineWidth',2)
%     plot(h.XLim,min(min(error(:,mnsPlot(k),:))).*[1 1],'--k')
%     h.YLim = [10 50];    
%     xlabel('Number of trees')
%     ylabel('Cross-validated MSE')
%     title(sprintf('MaxNumSplits = %0.3g', maxNumSplits(mnsPlot(k))))
%     hold off
% end
% hL = legend([cellstr(num2str(learnRate','Learning Rate = %0.2f')); ...
%         'Deep Tree';'Stump';'Min. MSE']);
% hL.Position(1) = 0.6;
% 
% [minErr,minErrIdxLin] = min(error(:));
% [idxNumTrees,idxMNS,idxLR] = ind2sub(size(error),minErrIdxLin);
% fprintf('\nMin. MSE = %0.5f',minErr)
% fprintf('\nOptimal Parameter Values:\nNum. Trees = %d',idxNumTrees);
% fprintf('\nMaxNumSplits = %d\nLearning Rate = %0.2f\n',...
%     maxNumSplits(idxMNS),learnRate(idxLR))
%%
% tFinal = templateTree('MaxNumSplits',maxNumSplits(idxMNS),'Surrogate','on');
% MdlFinal = fitrensemble(X,MonkeyBid,'NumLearningCycles',idxNumTrees, ...
%     'Learners',tFinal,'LearnRate',learnRate(idxLR))
%%
[imp,ma] = predictorImportance(MdlFinal);
% 
% figure
% bar(imp)
% line([0 21],[.05 .05],'color','r','LineStyle',':')


%%

rng('default'); % For reproducibility
t = templateTree('PredictorSelection','curvature','Surrogate','on', ...
    'Reproducible',true); % For reproducibility of random predictor selections
Mdl = fitrensemble(X,MonkeyBid,'Method','bag','NumLearningCycles',500, ...
    'Learners',t);
options = statset('UseParallel',true);
imp = oobPermutedPredictorImportance(Mdl,'Options',options);
% imp = [ 1.1765
%     3.4064
%     0.9181
%     1.6809
%     0.5596
%     0.1800
%     0.8186
%     0.9382
%     1.3541
%     3.2803
%     0.7470
%     1.6033
%     0.4774
%     2.1408
%     2.9561
%     0.9134
%     1.4616
%          0
%          0
%          0];
% % 2,4,10,12,14,15 are most important