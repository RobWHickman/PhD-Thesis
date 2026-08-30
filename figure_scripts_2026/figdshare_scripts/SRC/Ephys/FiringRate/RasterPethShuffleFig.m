function [fig,rast] = RasterPethShuffleFig(spike_times_ms,alignments,pre,post,bin_ms,waveform,sFreq)

fig = figure;
tx_dif_sort = alignments(:,3)-alignments(:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(8,1,1:4);
[rast] = Raster(spike_times_ms,alignments,pre,post,bin_ms);
hold on
for iTx = 1:length(alignments)
    line([tx_dif_sort(iTx,:) tx_dif_sort(iTx)],[iTx-.5 iTx+.5],'LineWidth',1,'color',[1 0 0])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin > 5
    if nargin < 7
        sFreq = 30000;
        warning('Sampling frequency of 30k used for waveform')
    end
    PIP_Plot
    wv=waveform;
    xwv = (1:length(wv))/(sFreq/1000);
    plot(xwv,wv/1000);
    xlabel('Time (ms)')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(8,1,7:8);
[~,~,cvuO,cvdO] = Shuffle_PETH(spike_times_ms,alignments(:,1),pre,bin_ms);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(8,1,5:6);
[FR,~,~] = Peri_Event_Firing_Rate(rast,bin_ms);
hold on
xax = (1:length(FR))*bin_ms-((length(FR)*bin_ms)/2);
plot(xax(cvuO),FR(cvuO),'color','r','LineWidth',2)
hold on
plot(xax(cvdO),FR(cvdO),'color','r','LineWidth',2)
xlabel([])
xticklabels([])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LongFigs