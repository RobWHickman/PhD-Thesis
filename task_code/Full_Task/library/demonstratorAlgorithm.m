function [choice, oQA, oQB] = demonstratorAlgorithm(class, theta, action, reward, QA, QB)
% [choice, oQA, oQB] = demonstratorAlgorithm(class, theta, action, reward, QA, QB)
%
%   input:
% class, {'random','qlearn','qlearn-forgetfull'}
% theta, vector of parameters
% action, vector of previous actions
% reward, vector of previous rewards (presence or absence)
% QA, Q(A) value vector
% QB, Q(B) value vector
%
%   output:
% choice is 1 or 2
% oQA, updated Q(A) value vector
% oQB, updated Q(B) value vector
%
% rbm 7.14



% selection of algorithms
switch class
    case {0, 'random'},
        choice = 1 + (rand(1)>0.5);
    case {1, 'qlearn'},
        % if no previous action, select randomly
        if nargin==2 || isempty(action) || action(end)==0,
            choice = 1 + (rand(1)>0.5);
            oQA = QA;
            oQB = QB;
            return
        end
        
        alpha = theta(1);
        beta = theta(2);
        i = numel(action)+1;
        
        % update Q-values with delta rule
        if action(i-1) == 1 
            delta = reward(i-1)-QA(i-1);
            QA(i) = QA(i-1) + alpha*delta; 
            QB(i) = QB(i-1); 
        elseif action(i-1)==2 
            delta = reward(i-1)-QB(i-1);
            QB(i) = QB(i-1) + alpha*delta; 
            QA(i) = QA(i-1);               
        end
        
        % obtain choice probability
        deltaQ = QA(i)-QB(i);
        p = 1/(1+exp(beta*deltaQ));
        
        % implement choice
        choice = 1 + (p>0.5); % choice purely determined by 'delta'
%         choice = 1 + (p>rand(1)); % stochastic choice
    
    case {2, 'qlearn-forgetfull'},
        % if no previous action, select randomly
        if nargin==2 || isempty(action) || action(end)==0,
            choice = 1 + (rand(1)>0.5);
            oQA = QA;
            oQB = QB;
            return
        end
        
        alpha = theta(1);
        beta = theta(2);
        kappa = theta(3);
        i = numel(action)+1;
        
        % update Q-values with delta rule
        if action(i-1) == 1 
            delta = reward(i-1)-QA(i-1);
            QA(i) = QA(i-1) + alpha*delta; 
            QB(i) = QB(i-1) + (1-kappa)*(QB(1) - QB(i-1)); 
        elseif action(i-1)==2 
            delta = reward(i-1)-QB(i-1);
            QB(i) = QB(i-1) + alpha*delta; 
            QA(i) = QA(i-1) + (1-kappa)*(QA(1) - QA(i-1));                
        end
        
        % obtain choice probability
        deltaQ = QA(i)-QB(i);
        p = 1/(1+exp(beta*deltaQ));
        
        % implement choice
%         choice = 1 + (p>0.5); % choice purely determined by 'delta'
        choice = 1 + (p>rand(1)); % stochastic choice

end
oQA = QA;
oQB = QB;