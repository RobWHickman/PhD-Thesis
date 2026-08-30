function [BDMR, BCbR] = JuiceBlockType(BDMJ,BCbJ,BDMB,BCbB,BDMs,BCbs)

BDMJ = double(BDMJ);
BCbJ = double(BCbJ);

BDM_JVec = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].*BDMJ;
BDM_JVec(BDM_JVec == 0) = [];

BDM_JVec = double(BDM_JVec);
BCb_JVec = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].*BCbJ;

BCb_JVec(BCb_JVec == 0) = [];
BCb_JVec = double(BCb_JVec);

switch BDMB
    case 'B'
        BDMR = JBlock(BDM_JVec,BDMs,40);
    case 'R'
        BDMR = repmat(BDM_JVec,1,330);
        BDMR = BDMR(randperm(length(BDMR)));
end

switch BCbB
    case 'B'
        BCbR = JBlock(BCb_JVec,BCbs,40);
    case 'R'
        BCbR = repmat(BCb_JVec,1,330);
        BCbR = BCbR(randperm(length(BCbR)));
end


function Vec = JBlock(Jvector,BlockSize, N)
Holder = [];
Vec = [];
for j = 1:N
    Input = Jvector(randperm(length(Jvector)));
for k = 1:length(Input)
    Part = Input(k)*ones(1,BlockSize);
    Holder = [Holder, Part];
end
    Vec = [Vec, Holder];
end
