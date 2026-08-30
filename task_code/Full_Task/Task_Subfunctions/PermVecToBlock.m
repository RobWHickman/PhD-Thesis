function BlockVec = PermVecToBlock(Vec, BlockNumber, BlockSize)
% Randomises the order in which blocks of elements in vec will appear. But
% they are orderly within the block.

    L           = length(Vec);
    HolderVec   = [];
    BlockVec    = [];
    
    if rem(BlockNumber,L) ~= 0
        error('BlockNumber/length(vector) must leave no remainder')
    end
    
    for k = 1:(BlockNumber/L)
        
        PermVec = Vec(randperm(L));
        
        for j = 1:L
            ID = PermVec(j);
            Holder = repmat(ID,1,BlockSize);
            HolderVec = [HolderVec, Holder];
        end
        
        BlockVec = [BlockVec, HolderVec];
        
    end
    
end