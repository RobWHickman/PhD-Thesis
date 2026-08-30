function ModigPESTroutine(varargin)
% ModigPESTRoutine. function that works as a script
%
% Post-trial routine of a PEST procedure. 
% 1.Updates four values in global Pest:
%   Pest.testValueHistory, 
%    Pest.choiceHistory,
%    Pest.testValue,
%    Pest.epsilon, rate of change for next trial
% 2. checks if the exit rule has been reached and breaks session if it so
% 
% See also pestProofOfPrinciple
% 
% RBM 7.11 

global TaskOp Pest Stim %breaksession
persistent thisManyRuns

if nargin>=1 && ischar(varargin{1}), % INVOKE NAMED SUBFUNCTION OR CALLBACK
    try
        feval(varargin{:}); % FEVAL switchyard
    catch
        disp(lasterr);
    end
end 

if isempty(thisManyRuns),
    thisManyRuns = 1;
end

% check first of all if we're running a PEST procedure
if ~isfield(Pest,'doPest') || ~Pest.doPest,
    return
end

% update Pest procedure only in correct trials
if ~TaskOp.correct,
    return
end
% DEBUG:sometimes TaskOp.choice is erased 
if TaskOp.choice<1 || TaskOp.choice>2,
    fprintf('TaskOp.choice value=%0.3g',TaskOp.choice)
    return
end
%%% post-trial routine
% 0. assign current choice to choiceHistory 
% 1. adjustment of epsilon and testValue
% 2. check rules to terminate experiment.

%% update counters!
% testValueHistory is easy
Pest.testValueHistory = [Pest.testValueHistory, Pest.testValue];

% epsilon history also,
Pest.epsilonHistory = [Pest.epsilonHistory, Pest.epsilon];

% choice not so....    
[ref idx] = sort(Stim.us.pulsePos);
% what choice depends on setup
if strcmp(TaskOp.curSetup,'B'),
    upCol = Stim.us.pulsePos(TaskOp.choice);
else
    upCol = idx(TaskOp.choice);
end
Pest.choiceHistory = [Pest.choiceHistory, upCol];

%% adjust epsilon+testvalue depending on reversals, 
% adjust testValue. 
% if chose alterantive, diminish alternative
% if chose reference, increase alternative
curTrial = numel(Pest.choiceHistory);
if Pest.choiceHistory(curTrial)==1,
    Pest.testValue = Pest.testValue+Pest.epsilon;
elseif Pest.choiceHistory(curTrial)==2,
    Pest.testValue = Pest.testValue-Pest.epsilon;
end

% reversal->halve the step
% same-> double step
if curTrial>1 && Pest.choiceHistory(curTrial-1)~=Pest.choiceHistory(curTrial),
    Pest.epsilon = Pest.epsilon/2; 
elseif  curTrial>2 && Pest.choiceHistory(curTrial-1)==Pest.choiceHistory(curTrial),
    Pest.epsilon = Pest.epsilon*2;     
end

% detect cycling, change epsilon
if curTrial>7 
    last4 = curTrial-3:curTrial;
    first4 =curTrial-7:curTrial-4;
    if sum(Pest.epsilonHistory(first4)==Pest.epsilonHistory(last4))==4,
        disp('%%%%%%%%%%%%%%%%%%%%%%Detected cycling!')
        Pest.epsilon = Pest.epsilon*0.75;
    end
end

%% restrict test value within range
if Pest.testValue>Pest.range(2), 
    fprintf('*********************original test value: %0.3g\n',Pest.testValue) % DEBUG tool
    Pest.testValue=Pest.range(2);
elseif Pest.testValue<Pest.range(1), 
    Pest.testValue=Pest.range(1);    
end

%% stop testing if epsilon is smaller than exit rule and we've runned more
% than the minimum trials 
if curTrial>=Pest.minTrials && (Pest.epsilon<Pest.exitRule) 
    TaskOp.count.seq = 1;
    
    % communicate exit values
    s1=sprintf('PEST exit: eps =%0.2g ref=[%0.2g %0.2g]\n',...
        Pest.epsilon,Pest.reference(1),Pest.reference(2));
    s2=sprintf('ce=%0.3g',mean(Pest.testValueHistory(1,end-1:end)));
    ModigMessage('m&c',[s1,' ',s2])
    
    % plot figure
    if Pest.doFigure,
        plotPESTresult
    end
    
    % stop session if we've ran requested # of PESTs   
    thisManyRuns = thisManyRuns+1;
    fprintf('\n Reached %d of %d runs requested',...
            thisManyRuns-1,Pest.runThisManyRuns);
    if thisManyRuns > Pest.runThisManyRuns,
        clear ModigPESTroutine        
        ModigCommand('stop_session')
    end
end

%% make figure
function plotPESTresult

global Pest
% find figure where to plot
pestAxis = findobj('tag','PEST axis');
if isempty(pestAxis),
    pestFig = figure;
    set(pestFig,'tag','PEST result')
    myAX = gca;
    set(myAX,'tag','PEST axis')
else
    myAX = pestAxis;
end
% generateX
x = 1:size(Pest.testValueHistory,2);
hold(myAX,'off')

plot(myAX, x,Pest.testValueHistory(1,:),'k','linewidth',2,'displayname','Test Value')
altCho = find(Pest.choiceHistory==2);
refCho = find(Pest.choiceHistory==1);   
hold(myAX,'on')
% r = size(Pest.reference,1);
% plot(myAX,repmat(x([1 end])',1,r), [Pest.reference Pest.reference],'color',[.5 .5 .5],'displayname','Reference values')
plot(myAX,x([1 end]), [Pest.reference(1) Pest.reference(1)],':','linewidth',2,'color',[.5 .5 .5],'displayname','Ref Other')
plot(myAX,x([1 end]), [Pest.reference(2) Pest.reference(2)],'linewidth',2,'color',[.5 .5 .5],'displayname','Ref Self')
plot(myAX,x, Pest.epsilonHistory,'b','linewidth',2,'displayname','\epsilon')
scatter(myAX,altCho,Pest.testValueHistory(1,altCho),'sk','filled','displayname','Chose alt')
scatter(myAX,refCho,Pest.testValueHistory(1,refCho),'r','filled','displayname','Chose ref')
xlabel(myAX,'Trials','fontsize',14)
ylabel(myAX,'Juice volume (ml)','fontsize',14)
set(myAX,'tickdir','out');%,'xtick',1:numel(Pest.testValueHistory))
box off
ylim([0 1])
legend show
WaitSecs(1);
