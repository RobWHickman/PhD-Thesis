function indices = findIndicesInVector(lookHere,forThis)
% 
% indices = findIndicesInVector(lookHere,forThis)
%
% helper function,
%   lookHere = vector where indices will be found
%   forThis = vector of possible matches
%
%   indices = logical vector of length(lookHere) with matches
%
% rbm 

if length(lookHere)==numel(lookHere) && length(forThis)==numel(forThis),
    lookHere = lookHere(:);
    forThis  = forThis(:);
    myA = repmat(lookHere, 1, length(forThis));
    myB = repmat(forThis(:), 1, length(lookHere))';
    indices = sum(myA==myB,2)==1;
else
    error('Inputs need to be vectors')
end
