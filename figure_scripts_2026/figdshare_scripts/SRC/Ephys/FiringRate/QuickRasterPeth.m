function QuickRasterPeth(raster_matrix,bin,smoothwindow)

if nargin<2
    bin = 1;
    warning('bin set to 1 ms')
end
if nargin <3 
    smoothwindow = 50;
    warning('smoothing with %d ms window',smoothwindow/bin)
end
figure
subplot(7,1,1:5)
PlotTrueRaster(raster_matrix)
pubify_figure_axis_robust
subplot(7,1,6:7)
plot(1:length(raster_matrix(1,:)),mean(smoothdata(raster_matrix,2,'movmean',smoothwindow)))
xlim([0 length(raster_matrix(1,:))])
pubify_figure_axis_robust