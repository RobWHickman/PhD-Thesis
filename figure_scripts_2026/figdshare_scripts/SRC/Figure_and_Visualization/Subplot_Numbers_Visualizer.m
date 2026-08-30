function Subplot_Numbers_Visualizer(rows,cols)

subplots = rows*cols;

figure
for isp = 1:subplots
    subplot(rows,cols,isp)
    plot(1,2)
    xlim([0 2])
    ylim([0 4])
    text(1,2,num2str(isp))
    xticklabels('')
    yticklabels('')
end
MedFigs