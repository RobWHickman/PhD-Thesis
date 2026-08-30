function ChangeMarkerSize(hndl,size)

lo = findobj(hndl,'type','line');
% badix = class(lo)== 'matlab.graphics.primitive.Data';
% lo = lo(~badix);
% if isempty(lo)
%     return
% end
% mkix = categorical({lo.LineStyle})=='none';
set(lo,'MarkerSize',size)
% set(lo,'MarkerEdgeColor','none')
