
function WideFigsMed

h = get(0,'Children');
scrnsize = get( groot, 'Screensize' );

numplots = 1:length(h);
rws = floor(sqrt(length(numplots)));
lcls = floor(length(numplots)/rws);
mcls = mod(length(numplots),rws);
cls = mcls+lcls;

for iNmplts = 1:length(h)
    vscrnchunk = scrnsize(1,3)/cls;
    hscrnchunk = scrnsize(1,4)/rws;
%     iCls = 1:cls;
    if iNmplts <= cls
       iRws = 1;
       iCls = iNmplts;
    elseif iNmplts <= cls*(iRws)
       iCls = iNmplts-(cls*(iRws-1));
    end
    
   
    pos = [scrnsize(1,1)+(scrnsize(1,3)*.25) scrnsize(1,2)+(scrnsize(1,4)*.15)...
        scrnsize(1,3)*.5 scrnsize(1,4)*.5];
    
    set(h(iNmplts,1),'Position',pos);

    if iRws*iCls==iNmplts
        iRws = iRws + 1;
    end
end
    

% fig.Position = [scrnsize(1,1)+(vscrnchunk*(iCls-1)) scrnsize(1,2)+(hscrnchunk*(iRws-1))...
%         scrnsize(1,3)/cls (scrnsize(1,4)/rws)-(scrnsize(1,4)/rws*.23)];
     




    