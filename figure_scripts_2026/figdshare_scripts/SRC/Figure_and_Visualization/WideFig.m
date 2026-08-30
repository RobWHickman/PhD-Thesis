function WideFig(fig)
if nargin<1
    fig = gcf;
end
scrnsize = get( groot, 'Screensize' );

pos = [scrnsize(1,1)+(scrnsize(1,3)*.05) scrnsize(1,2)+(scrnsize(1,4)*.3)...
    scrnsize(1,3)*.90 scrnsize(1,4)*.4];

set(fig,'Position',pos);

end




