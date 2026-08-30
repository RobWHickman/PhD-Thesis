function rand_time = ModigRandTime(t1,t2,type,SD)
% Randomly pick a time random between t1 and t2
% t1: first time
% t2: second time
% type: distribution "flat", "gauss", or truncated gauss"
% SD: SD for "gauss" and "truncated gauss" options
%
% rbm 6.2013 'truncated exp' 

switch type
    
    case 'flat'
        if t1>t2
            temp = t1;
            t1 = t2;
            t2 = temp;
            clear temp;
        end

        rand_time = t1 + rand(1)*(t2-t1);
    
    case 'gauss'
        rand_time = randn(1)*SD + (t1 + t2)/2;
    
    case 'truncated gauss'  
        % strictly between t1 and t2, if SD is large, peak at mean
        buf = randn(1)*SD + (t1 + t2)/2;
        if buf >= t1 && buf <= t2
            rand_time = buf;
        else
            rand_time = (t1 + t2)/2;
        end
        
    case 'truncated exp'
        if t2 ~= 0                  % If we have non-zero variability, then we want to add/subtract some random time from the base.
            f1          = makedist('exponential','mu',t2/3);        % We want to truncate at 3x the mean.
            f2          = truncate(f1,0,t2);                        % Truncate the distribution.
            rand_time   = t1 + (random(f2,1,1));                    % A random time is selected from the truncated distribution, this is added to the lower limit.
        else
            rand_time   = t1;       % If we do not have any variability, then the base-time is all we need.
        end       
end


% MATLAB timers complain of sub-ms precision...
rand_time = round(rand_time);
