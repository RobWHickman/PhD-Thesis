function OriginateFigureAxis(axis)

if nargin < 1 
    ax = findall(gca,'Type','Axes');
end


ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';



