function y = checkreps(seq)
%
% called by ModigRandSeq.... check repetitions in a random sequence???
%
%
[r c] = size(seq);
if r>1 & c==1
    seq = seq';
    [r c] = size(seq);
elseif r>1 & c>1
    seq = reshape(seq',1,r*c);
    [r c] = size(seq);
end

xx =1;
repetition = [];
current_rep = 1;
for m = 2:c
    if seq(m)==seq(xx),
        current_rep = current_rep + 1;
    else
        repetition = [repetition current_rep];
        xx = m;
        current_rep = 1;
    end
    if m == c
        repetition = [repetition current_rep];
    end
end
y.reps = repetition;
y.unique = unique(seq);
y.hist = hist(seq,y.unique);