function [bPDF_Avg,bPDF_pop,dist_pop,bids]= Bids_pdf(RES,sit,dist_type)

bids = [];dist=nan(length(RES),100);
for i = 1:length(RES)
    bds=[];dst=[];
    ix = RES(i).event.situations==sit;
    bds(:,1)=RES(i).event.monkeybid(ix);
    %     bds(:,2)=repmat(RES(i).session,length(bds),1);
    if ~isempty(bds)
        dst = fitdist(bds(:,1),dist_type);
        dist(i,bds(1,1):bds(end,1))=pdf(dst,[bds(1,1):bds(end,1)]);
    end
    bids=[bids;bds];
end
dist_pop = fitdist(bids,dist_type);
bPDF_pop = pdf(dist_pop,0:100);

bPDF_Avg = mean(dist,'omitnan');

% figure;
% plot(dist')

