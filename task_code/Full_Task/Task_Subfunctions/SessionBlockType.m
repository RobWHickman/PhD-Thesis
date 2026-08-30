function [Block, BDMBlocks, BCbBlocks] = SessionBlockType(SessionType, BDMBS, BCbBS)

switch SessionType
    case 'BDM'
        Block = ones(1,1000);
        BDMBlocks = ones(1,1000);
        BCbBlocks = ones(1,1000);
    case 'BCb'
        Block = 3*ones(1,1000);
        BDMBlocks = ones(1,1000);
        BCbBlocks = ones(1,1000);
    case 'BDM/BCb'
        A = ones(1,BDMBS);
        B = 3*ones(1,BCbBS);
        X = [A, B];
        Block = repmat(X,60);
        BCbBlocks = sort(repmat(1:60,1,BCbBS));
        BDMBlocks = sort(repmat(1:60,1,BDMBS));
end