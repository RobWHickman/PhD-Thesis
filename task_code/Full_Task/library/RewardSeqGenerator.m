function [rnd_seq]=RewardSeqGenerator(prob,seqLength)
%generate pseudorandom reward sequences that fulfill their mean frequncy
%over a shorter number of trials than a true random sequence, "without 
% having a predictible hazard function".
% 
% in: prob, reward probability. Integer
%     seqLength, sequence length 
%
% out, rnd_seq
%
% bill
% rbm -introduced flexibility in the sequences & moving average probability

if nargin==1 || isnan(seqLength)
    seqLength=300;
end

% prob MUST be an integer
if mod(prob, round(prob))>0,
    warning('Input "prob" MUST be integer!')
    prob = round(prob);
end
    
if prob == 0
    rnd_seq=zeros(seqLength,1);
else
    % generate a vector with 1/0 corresponding to reward probability
    prob = prob/100;
    p = ceil(seqLength*prob);
    q = seqLength-p;
    seed_matrix = [ones(1,p) zeros(1,q)];

    % shuffle the generated sequence until a moving average of "windowSize"
    % is always\pm "tolerance" of the intended reward probability
    imnothappy =1;
    tolerance = 0.25;    
    windowSize = 15;
    pad = ones(1,windowSize) * prob;
    loops = 0;
    maxIterations = 1000;
    while imnothappy,
        loops = loops + 1;
        rnd_seq = Shuffle(seed_matrix);
        movAverage = filter(ones(1,windowSize)/windowSize,1, [pad rnd_seq]);
        movAverage(1:windowSize) = [];
        aboveLimits = sum(movAverage > (prob+tolerance));
        belowLimits = sum(movAverage < (prob-tolerance));
        imnothappy = (aboveLimits+belowLimits)~=0;
        if loops>maxIterations, 
            warning('Needed to break rw list generation'), break,end
    end
%     fprintf('RewardSeqGenerator looped: %d time(s)\n',loops)

    % ouput is always [n x 1]
    rnd_seq = rnd_seq(:);
end
 
