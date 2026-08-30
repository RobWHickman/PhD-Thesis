clear
ca 

mydir = uigetdir('F:\DANA_Acute\DAN_WORKING\AmpRatio_and_Halfwidth','Where is the folder containing the Amp-ratio and half-width data');

cd(mydir)
load('AmpRatio_and_HalfWidth_ms.mat');
cluster_anal(:,1) = [AmpRatio_and_HalfWidth_ms.Amp_ratio];
cluster_anal(:,2) = [AmpRatio_and_HalfWidth_ms.Half_width];
FR = [AmpRatio_and_HalfWidth_ms.FiringRate];

%   cluster_anal(isoutlier(cluster_anal),'grubbs')=NaN;

fca = find(cluster_anal(:,1)>1.5);
    figure
    plot(cluster_anal(fca,1),cluster_anal(fca,2),'LineStyle','none','Marker','o')
    
    huge = find(cluster_anal(:,1)>20);
    AmpRatio_and_HalfWidth_ms(huge).Unique_name
    

% cluster_anal(cluster_anal(:,1)>1.5,:) = []; 
% cluster_anal(cluster_anal(:,2)>2,:) = []; 

%%
ctr = 1;
ctr1 = 1;
ctr2 = 1;

for iAH = 1:length(cluster_anal)
%     if isnan(cluster_anal(iAH,1)) || isnan(cluster_anal(iAH,2))
%         AmpRatio_and_HalfWidth_ms(iAH).Cell_type=NaN;
%         continue
%     end


    first_chnk = cluster_anal(1:iAH-1,:);
    second_chnk = cluster_anal(iAH+1:end,:);
    clust_tmp = [first_chnk; second_chnk];
    
%         [idx,C,sumd,D] = kmeans(clust_tmp,2,'Distance','sqeuclidean','Start','sample','Replicates',20,'MaxIter',10000000); %idx = cluster_index, C = centroid, sumd = sum distances, D = distances from centroid
%         
% 
%     if C(1,1)>C(2,1)
%         C = flipud(C);
%         clust1_D = D(idx==2);
%         clust2_D = D(idx==1);
%     else
%         clust1_D = D(idx==1);
%         clust2_D = D(idx==2);
%     end



% %     z = linkage(clust_tmp,'ward','euclidean');
% % %     z = linkage(clust_tmp,'ward','minkowski');
%         z = linkage(clust_tmp,'ward','euclidean');
%     
%     T = cluster(z,'Maxclust',4);

T = clusterdata(clust_tmp,'linkage','ward','distance','euclidean','Maxclust',2);

    C(1,:) = nanmean(clust_tmp(T==1,:)); % find the mean of all amp_ratio and HW values belonging to cluster 1
    C(2,:) = nanmean(clust_tmp(T==2,:)); % find the mean of all amp_ratio and HW values belonging to cluster 2
    
    for iC = 1:length(clust_tmp)
        D(iC,1) = pdist([clust_tmp(iC,:);C(1,:)],'euclidean'); % find the distance of all values of cluster 1 to the centroid C(1,:)
        D(iC,2) = pdist([clust_tmp(iC,:);C(2,:)],'euclidean'); % find the distance of all values of cluster 2 to the centroid C(2,:)
    end
    
    clust1_D = D(T==1);
    clust2_D = D(T==2);

    mc1D = nanmean(clust1_D); % mean euclidean distance
    mc2D = nanmean(clust2_D);
    
    sc1D = nanstd(clust1_D);
    sc2D = nanstd(clust2_D);
    
    dist_fr_c1 = pdist([cluster_anal(iAH,:);C(1,:)],'euclidean');
    dist_fr_c2 = pdist([cluster_anal(iAH,:);C(2,:)],'euclidean');

    
    if dist_fr_c1 < 3*sc1D && dist_fr_c2 < 3*sc2D
        nan_count = ctr;
        plot(cluster_anal(iAH,1),cluster_anal(iAH,2),'LineStyle','none','Marker','o','MarkerEdgeColor',[.5 .5 .5])
%         AmpRatio_and_HalfWidth_ms{iAH,4} = 2;
        AmpRatio_and_HalfWidth_ms(iAH).Cell_type = NaN;
        C1_all(ctr2,:) = C(1,:);
        C2_all(ctr2,:) = C(2,:);
        S1_all(ctr2,:) = sc1D;
        S2_all(ctr2,:) = sc2D;
        ctr2 = ctr2 + 1;
        cell_type(iAH) = NaN;
        ctr=ctr+1;
    elseif dist_fr_c1 < 3*sc1D && cluster_anal(iAH,1) < C(2,1) 
%         && FR(iAH) < 10 % if we want to reject based on FR, we should add
%         this to the above line
        cell_type(iAH) = 2;
        plot(cluster_anal(iAH,1),cluster_anal(iAH,2),'LineStyle','none','Marker','o','MarkerFaceColor','r','MarkerEdgeColor','k')
        AmpRatio_and_HalfWidth_ms(iAH).Cell_type = 'DA';
        C1_all(ctr2,:) = C(1,:);
        C2_all(ctr2,:) = C(2,:);
        S1_all(ctr2,:) = sc1D;
        S2_all(ctr2,:) = sc2D;
        ctr2 = ctr2 + 1;
    elseif cluster_anal(iAH,2) > 2 || cluster_anal(iAH,1)<0.16 %%shitty workaround--says to inlcude all cells with large HW and Amp ratio less than .16 (established emperically from plot)
        cell_type(iAH) = 2;
        plot(cluster_anal(iAH,1),cluster_anal(iAH,2),'LineStyle','none','Marker','o','MarkerFaceColor','r','MarkerEdgeColor','k')
        AmpRatio_and_HalfWidth_ms(iAH).Cell_type = 'DA';
        C1_all(ctr2,:) = C(1,:);
        C2_all(ctr2,:) = C(2,:);
        S1_all(ctr2,:) = sc1D;
        S2_all(ctr2,:) = sc2D;
        ctr2 = ctr2 + 1;
    elseif dist_fr_c2 < 3*sc2D 
        cell_type(iAH) = 1;
        plot(cluster_anal(iAH,1),cluster_anal(iAH,2),'LineStyle','none','Marker','o','MarkerEdgeColor',[.5 .5 .5])
        AmpRatio_and_HalfWidth_ms(iAH).Cell_type = 'other';
        C1_all(ctr1,:) = C(1,:);
        C2_all(ctr1,:) = C(2,:);
        S1_all(ctr1,:) = sc1D;
        S2_all(ctr1,:) = sc2D;
        ctr1 = ctr1 + 1;
  
    else
        plot(cluster_anal(iAH,1),cluster_anal(iAH,2),'LineStyle','none','Marker','o','MarkerEdgeColor',[.5 .5 .5])
        AmpRatio_and_HalfWidth_ms(iAH).Cell_type = NaN;
        C1_all(ctr2,:) = C(1,:);
        C2_all(ctr2,:) = C(2,:);
        S1_all(ctr2,:) = sc1D;
        S2_all(ctr2,:) = sc2D;
        ctr2 = ctr2 + 1;
        nan_count = ctr;
        cell_type(iAH) = NaN;
        ctr=ctr+1;
    end  
        hold on
end


%%

mC1 = nanmean(C1_all);
mC2 = nanmean(C2_all);
msc1D = nanmean(S1_all);
msc2D = nanmean(S2_all);

hold on
plot(mC1(:,1),mC1(:,2),'LineStyle','none','Marker','+','MarkerEdgeColor','k','MarkerSize',8)
hold on
plot(mC2(:,1),mC2(:,2),'LineStyle','none','Marker','+','MarkerEdgeColor','k','MarkerSize',8)
hold on
circ = linspace(0,2*pi); % this is here for when I figure out the 3 standard deviation calculation...gonna circle the clusters
xp=msc1D*3*cos(circ);
yp=msc1D*3*sin(circ);
plot(mC1(1,1)+xp,mC1(1,2)+yp,'color','r');
hold on
circ = linspace(0,2*pi); % this is here for when I figure out the 3 standard deviation calculation...gonna circle the clusters
xp=msc2D*3*cos(circ);
yp=msc2D*3*sin(circ);
plot(mC2(1,1)+xp,mC2(1,2)+yp,'color',[.5 .5 .5]);


xlabel('Amplitude ratio ((n-p)/(n+p))')
ylabel('Half-width (ms)')
title('Amplitude ratio vs half-width')
set(gca,'TickDir','out');

pubify_figure_axis_robust
%%

if 0
    plot(cluster_anal(T==1,1),cluster_anal(T==1,2),'LineStyle','none','Marker','o','MarkerFaceColor','r')
    hold on
    plot(cluster_anal(T==2,1),cluster_anal(T==2,2),'LineStyle','none','Marker','o','MarkerFaceColor','g')
    hold on
    plot(cluster_anal(T==3,1),cluster_anal(T==3,2),'LineStyle','none','Marker','o','MarkerFaceColor','b')
end


DA_ctr = 0;
for iC = 1:length(AmpRatio_and_HalfWidth_ms)
    if strcmp(AmpRatio_and_HalfWidth_ms(iC).Cell_type,'DA')
        DA_ctr = DA_ctr+1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cell responses must be coded by the variable 'resps' below with same structure as AmpRatio_and_HalfWidth_ms 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
hold on
for i = 1:length(resps)
    if resps(i).Response==1
        plot(resps(i).Amp_ratio,resps(i).Half_width,'LineStyle','none','Marker','o','MarkerFaceColor','g')
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msgbox(sprintf('%d cells were categorized as dopaminergic by hierarchical clustering.',DA_ctr));
%  plot(cluster_anal(:,1),cluster_anal(:,2),'LineStyle','none','Marker','o')
%  hold on
%  plot(cluster_anal(iAH,1),cluster_anal(iAH,2),'LineStyle','none','Marker','o','MarkerFaceColor','r')

    
% AmpRatio_and_HalfWidth_ms{:,4} = 








% 
% z = linkage(cluster_anal,'median','cityblock');
% %
% 
% T = cluster(z,'Maxclust',3);
% 
% 
% 
% plot(cluster_anal(T==1,1),cluster_anal(T==1,2),'LineStyle','none','Marker','o','MarkerFaceColor','b')
% hold on
% plot(cluster_anal(T==2,1),cluster_anal(T==2,2),'LineStyle','none','Marker','o','MarkerFaceColor','r')
