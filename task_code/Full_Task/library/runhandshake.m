function runhandshake(VarToGetty, statusFlag)
% runhandshake(VarToGetty, statusFlag)
% 
%   in, VarToGetty (float, i.e. double or single) is the vector'll send to 
%       getty 
%       statusFlag, 1 if you want cmdln output of badshake, 0 otherwise the
%           default
%
% HC
% rbm 08.08 statusFlag  and breaksession
% rbm 6.11 try again loop
% rbm 11.11 non-integer and >255 corrections/warnings
% global  breaksession
% persistent tries

s=sprintf('After updating to MATLAB 2011 and newest driver for NI, we can''t\n');
s=sprintf('%s have the MATLAB-based controller for the DAQ AND the C-based\n',s);
s=sprintf('%s controller at the same time. Therefore, this function is not .\n',s);
error(s)

if nargin == 0,
    VarToGetty=[10 9 8 7 6 5 4 3 2 1];
    statusFlag = 0;
elseif nargin == 1,
    statusFlag = 1;
end

if isempty(tries)
    tries = 1;
end

% check if the array is floating number
if ~isfloat(VarToGetty),
    VarToGetty = double(VarToGetty);
    warning('runhandshake:float','runhandshake needs an array in floating point!')
end

% check for noninteger elements
fixedVTG = fix(VarToGetty);
sumNotInt = sum(fixedVTG~=VarToGetty);
if sumNotInt>0,
    warning('runhandshake:notRound','runhandshake input array had %d non integers @ %d',sumNotInt,find(fixedVTG~=VarToGetty))
end

% check for elements above 255
aboveVTG = fixedVTG>255;
sumAboveVTG = sum(aboveVTG);
if sumAboveVTG>0,
    fixedVTG(aboveVTG) = 255;
    warning('runhandshake:notRound','runhandshake input array had %d elements> 255',sumAboveVTG)
end

% badshake=ModhandshakeRdebug2(fixedVTG);

ts = GetSecs;
% badshake=ModhandshakeRdebug2(fixedVTG);
% badshake=ModhandshakeRdebug(fixedVTG);
badshake=ModhandshakeR(fixedVTG);
% badshake=Modhandshake(fixedVTG);


breaksession = badshake>0;

if statusFlag
    if badshake==0
        fprintf('Handshake successful after %d tries\n',tries)
        te = GetSecs-ts;
        fprintf('Handshake took %0.3g s \n',te)
    elseif badshake==1
        tries = tries+1;
        if tries < 100,
            runhandshake(VarToGetty,statusFlag);  
        else
            fprintf('Tried %d times to run handshake. Mission aborted\n',tries)
        end
    else
        fprintf('handshake failed @ point %d\n',badshake)
    end
end
clear tries