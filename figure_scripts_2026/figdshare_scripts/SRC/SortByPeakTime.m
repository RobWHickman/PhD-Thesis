function [sortedMatrix,sort_index] = SortByPeakTime(M,optIndex,peak_trough,sort_by)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M: the matrix to be sorted 
% optIndex: a column index from which to take the peak in M (usually some
% time period after an event). e.g., 500:1000 (ms).
% peak_trough: sort by the peak or by the trough
% sort_by: determines wheter to sort by peak time, peak size, or both. The
% order of (time then peak size or peak size then time ) is denoted as it 
% is in 'sortrows.m': sort by time then peak size is [1 2]. Sort by peak 
% size then time is [2 1].
% 
% 
% sortedMatrix: the sorted version of M.
%
% written by: DHill April 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin <2
    [~,w] = size(M);
    optIndex = [1:w];
end
if nargin <3
    peak_trough = 'peak';
end
if nargin <4
    sort_by = [1 2];
end


sb=sort_by;

if strcmp(peak_trough,'peak')
    [sz,tm] = max(M(:,optIndex),[],2);
else
    [sz,tm] = min(M(:,optIndex),[],2);
end
    

srtix = [];
if all(sb==1)
    [~,srtix]=sort(tm);
elseif all(sb==2)
    [~,srtix]=sort(sz);
else 
    [~,srtix] = sortrows([tm sz],sb);
end
sortedMatrix = M(srtix,:);
sort_index = srtix;
