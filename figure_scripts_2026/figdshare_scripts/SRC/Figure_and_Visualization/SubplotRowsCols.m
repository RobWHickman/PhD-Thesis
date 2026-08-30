function s = SubplotRowsCols(fig_rows,fig_cols,plot_rows,plot_cols)
% fig_rows and fig_cols should be entered just like the first two arguments
% of subplot. plot_rows plot_cols should be the number of 'rows' and
% 'columns' of the figure you want the plot to fill. 
strt = (plot_rows(1)*fig_cols)-fig_cols+plot_cols;
sp = strt;
for iR = 1:length(plot_rows)-1
    lsp = length(sp);
   sp(lsp+1:lsp+length(plot_cols)) = strt + (fig_cols*iR);
end
    
s=subplot(fig_rows,fig_cols,sp);
    

