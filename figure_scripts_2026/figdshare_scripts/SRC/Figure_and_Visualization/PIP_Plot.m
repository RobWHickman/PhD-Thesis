function PIP_Plot(position,ax)

%PIP stand for 'plot in plot'. 

%INPUT:
%position should be specified as a proportion of the total plot area of the
%larger plot specified as [left bottom width height]

if nargin < 1
    position = [.85 .8 .125 .15];
end    
if nargin < 2
    ax = gca;
end

p = ax.Position;


new_axes_position = ...
    [p(1)+(p(3)*position(1))...
    p(2)+(p(4)*position(2))...
    (position(3)*p(3))...
    (position(4)*p(4))];

axes('Position',new_axes_position);
pipax = gca;
set(pipax,'Color',[1 1 1 0.5])
