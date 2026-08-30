function varargout = ModigHandshake(dioIn, dioOut, valToGetty)
% varargout = ModigHandshake(dioIn, dioOut, valToGetty)
%
% benchmark transmission time is 2.82 seconds 10.01.08
% 1.85 ms with 80 values 10.06.08
%
% rbm 01.08
%      6.08 changed abort key from 'x' to 'q', replaced error for warning
%
% superseded by ModhandshakeR --> 170ms transmission time
%
% use this code to check how the handshake works, debugging and testing

%Getty sends out 252! - if we check the *top* two bits we should detect
%1s, old bott checks *bottom* two bits to detect 0s but this card reads
%0 if not connected.
%
% 7.12 breaksession

global breaksession

if nargin ~= 3,
    %invent some addvals to transmit if none provided
    valToGetty = [10,2,3,4,5,6,7,8,9,255];
end

%is getty here?
answer = 0;
while answer==0,
    answer = gettyHere(dioIn, dioOut);
    if answer==0,
        abort = press;    
        if abort,
            breaksession = 1;
            return,
        end
    end
end

% Wait for Getty to give go-ahead
n=0;
while n==0
    %is handshake up
    portval = getvalue(dioIn.HandShakeIn);
    if portval==1
        break
    end

    %x pressed
    abort=press();
    if abort==1
        ModigBitSender(1:length(dioOut.Line),zeros(length(dioOut.Line),1))
        breaksession = 1;
        warning('Modig:AbortedHandshake','Aborted while waiting for Getty'),
        return
    end
end

ts = GetSecs;
ModigBitSender(dioOut.HardTriggerOut.Index, 1)

while n==0
    %is handshake down
    portval = getvalue(dioIn.HandShakeIn);
    if portval==0
        break
    end

    %x pressed
    abort=press();
    if abort==1
        ModigBitSender(1:length(dioOut.Line),zeros(length(dioOut.Line),1))
        breaksession = 1;
        warning('modig:handshake','badshake 2'),return
    end
end

ModigBitSender(1:length(dioOut.Line),zeros(length(dioOut.Line),1));
et = zeros(1,size(valToGetty,2));
 valToGetty = fix(double(valToGetty));
 valToGetty(valToGetty>255) = 255;
 valToGetty(valToGetty<0) = 0; 
for i=1:size(valToGetty,2),
   
    %write addvals
    binVec = dec2binvec(valToGetty(i),8); 
    ModigBitSender(cell2mat(dioOut.dirConnOut.Index), binVec)
    
    ModigBitSender(dioOut.HandShakeOut.Index, 1);
    
    while n==0
        %is handshake up
        portval=getvalue(dioIn.HandShakeIn);
        if portval==1
            break
        end
        
        %x pressed
        abort=press();
        if abort==1
            ModigBitSender(1:length(dioOut.Line),zeros(length(dioOut.Line),1))
            breaksession = 1;
            warning('modig:handshake','badshake 3'),return
        end
    end
    
    ModigBitSender([dioOut.HardTriggerOut.Index dioOut.HandShakeOut.Index], [1 0]);

    while n==0
        %is handshake down
        portval=getvalue(dioIn.HandShakeIn);
        if portval==0
            break
        end

        %is getty here?
%         gettyHere(dioIn, dioOut);
        
        %x pressed
        abort=press();
        if abort==1
            ModigBitSender(1:length(dioOut.Line),zeros(length(dioOut.Line),1))
            breaksession = 1;
            warning('modig:handshake','badshake 4'),return
        end
    end
    et(i) = GetSecs;
end
if nargout > 0
    varargout = {et};
end
%reset
ModigBitSender(1:length(dioOut.Line),zeros(length(dioOut.Line),1));

waitTime=GetSecs-ts;
sendTime = diff(et);
fprintf('\n MATLAB-based Handshake took: %0.3g s. Each bit took: %0.3g s \n',waitTime, mean(sendTime))
%%
function yes=press()
keydown=0;

[keydown,keysecs, keyCode]=KbCheck;
if keydown~=0
    keyname = KbName(keyCode);

    if size(keyname,2)==1
        if keyname=='q'
            yes=1;
        else
            yes=0;
        end
    elseif size(keyname,2)==3
        if char(keyname(2))=='q'
            yes=1;
        else
            yes=0;
        end
    else
        yes=0;
    end
else
    yes=0;
end

%% is getty here?
function answer = gettyHere(dioIn, dioOut)
portval = getvalue(dioIn.dirConnIn);
if binvec2dec(portval)~=252
    ModigBitSender(1:length(dioOut.Line),zeros(length(dioOut.Line),1));
%     warning('modig:handshake','Getty not connected')   
    answer = 0;
else
    answer = 1;
end

