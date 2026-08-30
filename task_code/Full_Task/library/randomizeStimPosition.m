function [position iterations] = randomizeStimPosition(rect, tp, stimSz, sp, pulses, bIsActive, stimOnLeft, evaluate)
%
% [position iterations] = randomizeStimPosition(rect, tp, stimSz, sp, pulses, bIsActive, stimOnLeft, evaluate)
%  
% rect, rectangle of screen
% tp, target perimeter --> limit where the stims can go
% stimSz, stimuli size
% sp, stimuli perimenter. note that <5 produces overlap since we draw with
%   a 5 px brush
% pulses, 2x1. passive, active.
% bIsActive, setup b is active.
% stimOnLeft, left is bottom for B and up for A -logical
% evaluate, run this function as script to debug
%
% out:
%   position, maximum pulses x 4 x 2 matrix with stim coords, pass to
%   Stim.CSon.position (pulses,coords,[passive active])
%
% rbm 7.09



% % position limits:
% global VisParam Stim
% rect = VisParam.scr_rect;
% tp = 125; % target perimeter

% default will be top half...here we only define a rectangle where the
% stimuli can be drawn...
pl = [0 0 rect(3)-tp rect(4)/2];

% nothing over monitor
% stimSz = Stim.CSon.size;
pl(3:4) = pl(3:4)-stimSz;

plx = pl(3)-pl(1);
ply = pl(4)-pl(2);

% stim perimeter
% sp = 5;
noOverlap = stimSz+sp;

% randomize stim positions with constraints
% pulses = [2;2];
stims = sum(pulses);
doRand = 1;
i=1;
while doRand==1 
    rdx = round(plx*rand(stims,1));
    rdy = round(ply*rand(stims,1));
    
    % check overlap, 
    myAx = repmat(rdx, 1, length(rdx));
    myBx = repmat(rdx', length(rdx), 1);    
    overlapX = abs(myAx-myBx)<noOverlap;
    ovx=triu(overlapX,1); % upper triangle above main diagonal
    
    myAy = repmat(rdy, 1, length(rdy));
    myBy = repmat(rdy', length(rdy), 1);
    overlapY = abs(myAy-myBy)<noOverlap;
    ovy=triu(overlapY,1);
    
    if all((ovx+ovy)~=2),    
      prePos = [rdx rdy rdx+stimSz rdy+stimSz];
%       disp(sprintf('iterations: %d',i))
       break
    end        
    i = i+1;
    if i>100000, 
        disp('broke at: 100K iterations!'),
        return,
    end
end
iterations = i;

% offset if it's for setup B
if bIsActive,
    prePos(:,[1 3]) = prePos(:,[1 3]) + tp;
    
    if stimOnLeft==0,
        % offset if we want bottom...
        prePos(:,[2 4]) = prePos(:,[2 4]) + rect(4)/2;
    end
elseif stimOnLeft==1,
    % offset if we want bottom...
    prePos(:,[2 4]) = prePos(:,[2 4]) + rect(4)/2;    
end


% pass to output
mxp = max(pulses);
position = repmat(-prePos(1,:),[mxp,1,2]);
first = prePos(1:pulses(1),:);
second = prePos(pulses(1)+1:end,:);
position(1:pulses(1),:,1) = first;
position(1:pulses(2),:,2) = second;

if evaluate,
    % evaluation to check quality...
    global Stim
    Stim.CSon.position = position;
    ModigPreparePages_IMP_GIVING;
    eval(VisParam.page(1).str)
    eval(VisParam.page(2).str)
end