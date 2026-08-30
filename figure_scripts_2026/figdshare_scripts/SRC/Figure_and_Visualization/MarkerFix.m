function MarkerFix(size)
if nargin<1
    size = 10;
end
lo = findobj('type','line');
% badix = class(lo)== 'matlab.graphics.primitive.Data';
% lo = lo(~badix);
% if isempty(lo)
%     return
% end
% mkix = categorical({lo.LineStyle})=='none';
set(lo,'MarkerSize',size)
c = get(lo,'Color');
for i = 1:length(c)
set(lo(i),'MarkerFaceColor',c{i})
set(lo(i),'MarkerEdgeColor','none')
end