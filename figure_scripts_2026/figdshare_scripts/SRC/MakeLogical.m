function [lv] = MakeLogical(M,mat_size)

%this should do the inverse of find()...I hope

if nargin<2
    mat_size = [max(M),1];
end

lv = zeros(mat_size);

lv(M)=1;
lv=logical(lv);
end