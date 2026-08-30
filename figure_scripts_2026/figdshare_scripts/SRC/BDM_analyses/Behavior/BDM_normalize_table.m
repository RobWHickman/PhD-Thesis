function [zBDM] = BDM_normalize_table(BDM)
[C,ia,ic] = unique(BDM.session_number);
vnam = BDM.Properties.VariableNames;

nanBDM = nan(size(BDM));
zBDM = array2table(nanBDM);
zBDM.Properties.VariableNames = vnam;
for iPw = 1:width(BDM)
    if isnumeric(BDM.(vnam{iPw}))
        disp(vnam{iPw})
        for i = 1:length(C)
            ix = find(BDM.session_number==C(i));
            zBDM.(vnam{iPw})(ix) = normalize(BDM.(vnam{iPw})(ix));
%             zBDM.(vnam{iPw})(ix) = MinMaxFS(BDM.(vnam{iPw})(ix));
        end
    else
        zBDM.(vnam{iPw}) = BDM.(vnam{iPw});
    end
end
zBDM.session_number = BDM.session_number;
end