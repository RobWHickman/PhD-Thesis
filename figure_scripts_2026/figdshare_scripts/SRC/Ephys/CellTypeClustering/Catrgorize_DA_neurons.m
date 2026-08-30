cluster_anal(:,1) = cell2mat(AmpRatio_and_HalfWidth_ms(:,1));
cluster_anal(:,2) = cell2mat(AmpRatio_and_HalfWidth_ms(:,2));


ctr = 1;
for iAH = 1:length(cluster_anal)
    first_chnk = cluster_anal(1:iAH-1,1:2);
    second_chnk = cluster_anal(iAH+1:end,1:2);
    clust_tmp = [first_chnk; second_chnk];
    
    % clusterdata(cluster_anal,2)
    [idx,C,sumd,D] = kmeans(clust_tmp,2,'Distance','sqeuclidean','MaxIter',1000000); %idx = cluster_index, C = centroid, sumd = sum distances, D = distances from centroid
%     [idx,C,sumd,D] = kmeans(cluster_anal,2,'Distance','sqeuclidean','MaxIter',10000); %idx = cluster_index, C = centroid, sumd = sum distances, D = distances from centroid

    clust1_D = D(idx==1);
    clust2_D = D(idx==2);
    
    mc1D = nanmean(clust1_D);
    mc2D = nanmean(clust2_D);
    
    sc1D = nanstd(clust1_D);
    sc2D = nanstd(clust2_D);
    
%         [idx_all,C_all,sumd_all,D_all] = kmeans(cluster_anal,2,'Distance','sqeuclidean','MaxIter',1000000);
    
    dist_fr_c1 = pdist([cluster_anal(iAH,:);C(1,:)]);
    dist_fr_c2 = pdist([cluster_anal(iAH,:);C(2,:)]);
    if dist_fr_c1 < 3*sc1D
        cell_type(iAH) = idx_all(iAH);
    elseif dist_fr_c2 < 3*sc2D
        cell_type(iAH) = idx_all(iAH);
    else
        cell_type(iAH) = NaN;
    end
    
    if cell_type(iAH)==1
        plot(cluster_anal(iAH,1),cluster_anal(iAH,2),'LineStyle','none','Marker','o','MarkerFaceColor','r','MarkerEdgeColor','none')
        AmpRatio_and_HalfWidth_ms{iAH,4} = 1;
    elseif cell_type(iAH)==2
        plot(cluster_anal(iAH,1),cluster_anal(iAH,2),'LineStyle','none','Marker','o','MarkerFaceColor','b','MarkerEdgeColor','none')
        AmpRatio_and_HalfWidth_ms{iAH,4} = 2;
    elseif isnan(cell_type(iAH))
        nan_count = ctr;
        AmpRatio_and_HalfWidth_ms{iAH,4} = NaN;

        ctr=ctr+1;
    end
    hold on
   
    
end
%%
 plot(C_all(:,1),C_all(:,2),'LineStyle','none','Marker','o','MarkerFaceColor',[1 0 .5])
%  plot(cluster_anal(:,1),cluster_anal(:,2),'LineStyle','none','Marker','o')
%  hold on
%  plot(cluster_anal(iAH,1),cluster_anal(iAH,2),'LineStyle','none','Marker','o','MarkerFaceColor','r')

    
% AmpRatio_and_HalfWidth_ms{:,4} = 