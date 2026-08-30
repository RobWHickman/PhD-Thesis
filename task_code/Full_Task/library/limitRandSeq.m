function sequence = limitRandSeq(conditions, minTimesRepeat, condTimesRepeat, limTimesRepeat)
%
% sequence = limitRandSeq(conditions, minTimesRepeat, condTimesRepeat,
% limTimesRepeat)
%
% we want a vector of random int with maximum timesRepeat for
% condTimesRepeat and overall miTimesRepeat,
%
% needs Modigrandseq_DICTATOR 
%
% In other words, it generates a pseudorandom sequence with 'conditions',
% size 'minTimesRepeat'*'conditions' where the condition(s)
% 'condTimesRepeat' can only repeat themselves 'limTimesRepeat'. 
%
% Importantly, this modifies the conditional probability of each trial
% condition.
%
% called in ModigPrepareTrial_(prj)
% 
% example inputs:
% conditions = 4;
% minTimesRepeat  = 4;
% condTimesRepeat = [3 4];
% limTimesRepeat = 1;
%
% rbm 06.09

noGo =1;
it=0;
% look for the good sequence
while noGo == 1,
    to = ModigRandSeq_DICTATOR(conditions, conditions*minTimesRepeat);
    a = findIndicesInVector(to(:,1),condTimesRepeat');
    noGo=0;
    for i=1:numel(a)-limTimesRepeat, 
        % ain't a good sequence if the values are repeating times we
        % don't want them to repeat
        if sum(a(i:i+limTimesRepeat))==1+limTimesRepeat; 
            noGo=1;
            break
        end 
    end
    it = it+1; % just a check for debugging
end
sequence = to;

