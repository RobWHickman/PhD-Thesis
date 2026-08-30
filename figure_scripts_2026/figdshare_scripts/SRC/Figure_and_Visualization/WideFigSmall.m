function WideFigSmall(fig)
if nargin<1
    fig = gcf;
end
scrnsize = get( groot, 'Screensize' );

pos = [scrnsize(1,1)+(scrnsize(1,3)*.325) scrnsize(1,2)+(scrnsize(1,4)*.4)...
    scrnsize(1,3)*.35 scrnsize(1,4)*.2];

set(fig,'Position',pos);

end




