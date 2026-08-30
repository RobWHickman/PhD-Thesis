function rowIndex =  findVectorInMatrix(matrix,vector)
% rowIndex =  findVectorInMatrix(matrix,vector)
%
% finds the index of the row in "matrix" that matches "vector". 
%
% rbm 08.09

if size(matrix,2) ~= size(vector,2)
    error('inputs matrix and vector need to be of the same length')
end

% handle an input "vector" of row size >1
vr = size(vector,1);
vc = size(vector,2);
rowIndex = zeros(vr,1);

for i = 1:vr,
    matchingMat = matrix == repmat(vector(i,:),size(matrix,1),1);
    prelim = find(sum(matchingMat,2) == vc);  
    if ~isempty(prelim)
        if numel(prelim) == 1,
            rowIndex(i) = prelim;
        else
            warning('findVectorInMatrix found more than one matching row')
            return
        end
    end
end
