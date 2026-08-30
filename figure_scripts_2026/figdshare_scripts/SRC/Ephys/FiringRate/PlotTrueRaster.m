function PlotTrueRaster(bs,col)

if nargin<2
    col = [0 0 0];
end

[Rs,Cs] = size(bs);
binarast = bs>0;
for iR = 1:Rs
    ticks = find(binarast(iR,:)>0);
    if ~isempty(ticks)
        if length(ticks)~=2
            line([ticks' ticks'],[iR-1 iR],'color',col,'linewidth',1.2)
        else
            for i = 1:2
                line([ticks(i) ticks(i)],[iR-1 iR],'color',col,'linewidth',1.2)
            end
        end
    end
end
xlim([0 length(bs(1,:))])