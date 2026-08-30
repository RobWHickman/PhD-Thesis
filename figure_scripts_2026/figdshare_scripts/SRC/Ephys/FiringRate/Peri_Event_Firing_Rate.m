function [FR,sem,peak_time,trough_time] = Peri_Event_Firing_Rate(raster_matrix,bin_size,pre,col)
% % raster matrix can be generated using PETH_raster, Rasetr, or
% Raster_PETH

if isempty(raster_matrix)
    warning('raster empty')
    FR = [];sem=[];peak_time=[];trough_time=[];
    return
end
if nargin < 3
    pre = bin_size*numel(raster_matrix(1,:))/2;    
end

post = (length(raster_matrix(1,:))*bin_size)-pre;

if nargin < 4
    col = [0 0 0];
end
FRrast = (raster_matrix./bin_size).*1000;




FR =  nanmean(FRrast,1);
[pk,imxmM] = max(smooth(FR((length(FR)/2)-(length(FR)*.2):(length(FR)/2)+(length(FR)*.2))));
imxmM = imxmM+((length(FR)/2)-(length(FR)*.2));
pk = (pk/bin_size)*1000;
[trgh,imnmM] = min(smooth(FR((length(FR)/2)-(length(FR)*.2):(length(FR)/2)+(length(FR)*.2))));
imnmM = imnmM+((length(FR)/2)-(length(FR)*.2));
trgh = (trgh/bin_size)*1000;

xax = (-pre:bin_size:post-bin_size)+(bin_size*.5);
xaxt = -pre:bin_size:post;
% xax = (1:length(FR))-(length(FR)/2)
peak_time = xax(round(imxmM))/1000;
trough_time = xax(round(imnmM))/1000;

sem = Sem(((raster_matrix./bin_size).*1000));
M_Hz = (raster_matrix./bin_size).*1000;
% 
% [r,c] = size(raster_matrix);
% M_Hz_os=(sum(raster_matrix)/r)/bin_size*1000

plot_error_lines(M_Hz,'SEM',xax,col)
yl = [min(nanmean(M_Hz)-(Sem(M_Hz))) max(nanmean(M_Hz)+(Sem(M_Hz)))];
if yl(1)==yl(2)
    yl(2) = yl(1)+.1;
end
ylim(yl)
xlim([xaxt(1) xaxt(end)])
x0 = mod(xaxt,500);
x0ix = find(x0==0);
xticks(xaxt(x0ix));
xticklabels(xaxt(x0ix));
g=gca;
line([0 0],[g.YLim],'LineStyle',':','color','r')
% hold on 
% plot(imxmM,pk,'LineStyle','none','Marker','o')
% hold on 
% plot(imnmM,trgh,'LineStyle','none','Marker','o')
% axis tight
xlabel('Time (ms)');
ylabel('Firing rate (Hz)');
pubify_figure_axis_robust
