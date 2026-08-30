function Plot_Mean_SEM_All_Points(data_matrix,colo,err_bar)
% data matrix must be formatted so that each column is a group 
%err_bar can be 'sem', 'sd', or 'ci'
if nargin < 3
    err_bar = 'sem';
end
if nargin < 2
    colo = lines(length(data_matrix(1,:)));
end

mDM = nanmean(data_matrix);
% semDM =(nanstd(data_matrix))/(sqrt(length(data_matrix(:,1))));

for iM = 1:length(data_matrix(1,:))
    
    %     chnk = .5/length(data_matrix(~isnan(data_matrix(:,iM))));
    %     xax = iM-.25+(chnk:chnk:.5);
    l = length(data_matrix(~isnan(data_matrix(:,iM))));
    rnd = randperm(l);
    nrnd = .6*((rnd-min(rnd))/(max(rnd)-min(rnd)))-.3;
    xax = nrnd+iM;

    
    inDM = data_matrix(~isnan(data_matrix(:,iM)));
    %     semDM(iM) =(nanstd(data_matrix(:,iM)))/(sqrt(length(inDM)));
    if strcmp(err_bar,'sem')
        ebDM(iM) = Sem(data_matrix(:,iM));
    elseif strcmp(err_bar,'sd')
        ebDM(iM) = nanstd(data_matrix(:,iM),[],1);
    elseif strcmp(err_bar,'ci')
        ebDM(iM) = ci(data_matrix(:,iM));
    end


        
    %     semDM(iM) = ci(data_matrix(:,iM));
    col = colo(iM,:);
    plot(xax,data_matrix(~isnan(data_matrix(:,iM)),iM),'LineStyle','none','Marker','o','MarkerSize',8,'MarkerFaceColor',col,'MarkerEdgeColor','none')
    hold on
%     oxax(:,iM) = xax;    
%     if iM>1
%         line([oxax(:,iM-1) xax'],[data_matrix(~isnan(data_matrix(:,iM-1)),iM-1) data_matrix(~isnan(data_matrix(:,iM)),iM)])
%     end
%     
    xaxl = [iM-.175 iM+.175];
    line([iM-.15 iM+.15],[mDM(iM) mDM(iM)],'color','k','LineWidth',1.5)
%     line(xaxl,[mDM(iM)+ebDM(iM) mDM(iM)+ebDM(iM)],'color','k','LineWidth',1.5)
%     line(xaxl,[mDM(iM)-ebDM(iM) mDM(iM)-ebDM(iM)],'color','k','LineWidth',1.5)
    line([iM iM],[mDM(iM)-ebDM(iM) mDM(iM)+ebDM(iM)],'color','k','LineWidth',1.5)
end

xticks(1:length(data_matrix(1,:)));
xticklabels([])