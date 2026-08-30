function legend_for_error_lines(label_cell, line_colors)
hold on
g=gca;
for i = 1:length(label_cell)
    line([g.XLim(2)*.85 g.XLim(2)*.9], [g.YLim(2)-(g.YLim(2)*.05*i) g.YLim(2)-(g.YLim(2)*.05*i)],'color',line_colors(i,:),'LineWidth',3);
    text(g.XLim(2)*.83,g.YLim(2)-(g.YLim(2)*.05*i), label_cell{i},'HorizontalAlignment','right','VerticalAlignment','middle')
end
    
