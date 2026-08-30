clear
monk = 'Vic';
td = ['C:\Users\hilld\Dropbox\Schultz_Lab\BDM_Data\Manuscript\BDM da NatComm\' ...
    'Referee_revisions\BDM_Source_code\DATA\' ...
    'Neural data reformatted for SVR code\Final_Figs\']; % this will need to be 
% modified to reflect the location of the 'Final_Figs' folder on the users computer.
figure
ana = {'random','startMax','startMin'};
eb=2;
cl=2;

for iA = 1:length(ana)
    subplot(3,1,iA)
    prs = ana{iA};
    dr = dir([td,monk,'*',prs,'*.mat']);
    
    
    nonDA = contains({dr.name},'nonDA');
    nonCoding = contains({dr.name},'nonCoding');
    coding = contains({dr.name},'coding');
    cnc = contains({dr.name},'coding')&contains({dr.name},'nonCoding');
    
    allU = contains({dr.name},'AllUnits');
    daU = contains({dr.name},'DAunits');
    
    smldr = dr(~nonDA&~allU&~cnc);
    % smldr = dr(~nonDA&~allU);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if cl==1
        col = Reds_and_Blacks(length(smldr));
    else
        col = CB_blues(5);col = flipud(col([1,3,5],:));
    end

    ebl=.25;
    lw = 1.5;
    os = [0 -.3 +.3];
    % I = flip([1:length(smldr)]);
    for i=1:length(smldr)
        %     i = I(j);
        load([smldr(i).folder,'\', smldr(i).name])
        x = [1:13,16:3:13+(length(R2N)-13)*3]-os(i);
        plot(x,R2N,'-','Color',col(i,:),'LineWidth',lw)
        hold on
        scatter(x,R2N,'MarkerFaceColor',col(i,:),'MarkerEdgeColor','none')%,'MarkerFaceAlpha',.5)
        if eb == 1
            plot(x,R2N+SVMstructC1vsC2_SEM,':','Color',col(i,:),'LineWidth',lw)
            plot(x,R2N-SVMstructC1vsC2_SEM,':','Color',col(i,:),'LineWidth',lw)
        elseif eb==2
            ls = '-';
            for ii = 1:length(R2N)
                line([x(ii) x(ii)],[R2N(ii)-SVMstructC1vsC2_SEM(ii) R2N(ii)+SVMstructC1vsC2_SEM(ii)],'color',col(i,:),'LineWidth',lw)
                line([x(ii)-ebl x(ii)+ebl],[R2N(ii)-SVMstructC1vsC2_SEM(ii) R2N(ii)-SVMstructC1vsC2_SEM(ii)],'color',col(i,:),'LineWidth',lw,'Linestyle',ls)
                line([x(ii)-ebl x(ii)+ebl],[R2N(ii)+SVMstructC1vsC2_SEM(ii) R2N(ii)+SVMstructC1vsC2_SEM(ii)],'color',col(i,:),'LineWidth',lw,'Linestyle',ls)
            end
        end
        
        plot(x,R2N_shuf,'-','Color',col(i,:),'LineWidth',lw)
        hold on
        scatter(x,R2N_shuf,'MarkerFaceColor',col(i,:),'MarkerEdgeColor','none')%,'MarkerFaceAlpha',.5)
        if eb==1
            plot(x,R2N_shuf+SVMstructC1vsC2_SEM_shuf,':','Color',col(i,:),'LineWidth',lw)
            plot(x,R2N_shuf-SVMstructC1vsC2_SEM_shuf,':','Color',col(i,:),'LineWidth',lw)
        elseif eb==2
            for ii = 1:length(R2N)
                line([x(ii) x(ii)],[R2N_shuf(ii)-SVMstructC1vsC2_SEM_shuf(ii) R2N_shuf(ii)+SVMstructC1vsC2_SEM_shuf(ii)],'color',col(i,:),'LineWidth',lw)
                line([x(ii)-ebl x(ii)+ebl],[R2N_shuf(ii)-SVMstructC1vsC2_SEM_shuf(ii) R2N_shuf(ii)-SVMstructC1vsC2_SEM_shuf(ii)],'color',col(i,:),'LineWidth',lw)
                line([x(ii)-ebl x(ii)+ebl],[R2N_shuf(ii)+SVMstructC1vsC2_SEM_shuf(ii) R2N_shuf(ii)+SVMstructC1vsC2_SEM_shuf(ii)],'color',col(i,:),'LineWidth',lw)
            end
        end
    end
    % lg = legend({smldr.name},'Interpreter','none');
    
    pubify_figure_axis_robust
    ylabel('Accuracy (R2)')
    %     title(prs)
end
xlabel('Number of neurons')
LongFigs
FigureTitle(monk)