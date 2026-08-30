function ar = CellCat(cells)

ar = [];
for iC = 1:length(cells)
    c = cells{iC};
    lar = length(ar);
    lc = length(c);
    ar(lar+1:lar+lc) = c;
end
    
