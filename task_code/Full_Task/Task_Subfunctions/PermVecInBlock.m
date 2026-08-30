function BlockVec = PermVecInBlock(Vec, BlockNumber)
% Randomises the order of a vector for each block, and uses each element of
% the vector once per block.

    L           = length(Vec);
    HolderVec   = [];
    BlockVec    = [];
    
    for k = 1:BlockNumber
        
        PermVec = Vec(randperm(L));
        BlockVec = [BlockVec, PermVec];
        
    end
    
end