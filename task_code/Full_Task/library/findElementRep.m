function elRep = findElementRep(list)
% elRep = findElementRep(list)
%
%   counts element repetitions in the vector 'list'
%
%   elRep: [elements count]
%  
%  RBM 10.08

el = unique(list);

el = reshape(el,length(el),1);

% haven't found a vectorized way to do this...
rep = zeros(numel(el),1);
for i = 1:numel(el),
    rep(i) = sum(list==el(i));
end
elRep = [el rep];