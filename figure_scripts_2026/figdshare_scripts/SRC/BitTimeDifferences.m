justopenfile_DH
savefile = ans;
%%

UPsA = zeros(1,14);
for iT= 1:length(savefile.trial)
    UPs = cellfun(@isempty,{savefile.trial(iT).bit.upat});
    UPsA = UPsA+double([~UPs]);
    
    
end
UPsA = UPsA';