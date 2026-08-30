
function LongFig(fig)
if nargin<1
    fig = gcf;
end
    
h = get(0,'Children');
scrnsize = get( groot, 'Screensize' );




pos = [scrnsize(1,1)+(scrnsize(1,3)*.34) scrnsize(1,2)+(scrnsize(1,4)*.05)...
    scrnsize(1,3)*.34 scrnsize(1,4)*.85];

set(fig,'Position',pos);

end
    

% fig.Position = [scrnsize(1,1)+(vscrnchunk*(iCls-1)) scrnsize(1,2)+(hscrnchunk*(iRws-1))...
%         scrnsize(1,3)/cls (scrnsize(1,4)/rws)-(scrnsize(1,4)/rws*.23)];
     




    