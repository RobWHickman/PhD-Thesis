function TCPSendMessage(dioIn,dioOut,valToGetty)
% TCPSendMessage(dioIn,dioOut,valToGetty)
%
% 
%complete handshake.
%
% Helen 11.12 original
% rbm 11.12 Handshake piece and adaptation to ModigHandshake style
global d_output_stream breaksession

%% Create bin vector
valToGetty = fix(double(valToGetty));
if any(valToGetty>255) || any(valToGetty<0),
    warning('TCPSendMessage:ValToGetty','ValToGetty needs to be between 0 and 255')
    valToGetty(valToGetty>255) = 255;
    valToGetty(valToGetty<0) = 0;
elseif valToGetty(1)~=numel(valToGetty)
    error('TCPSendMessage needs that the first element of the vector equals the number of elements in the vector')
end

%% output the data over the DataOutputStream
% Convert to stream of bytes
for i = 1:valToGetty(1),
   d_output_stream.writeInt(valToGetty(i));
end
% d_output_stream.writeBytes(char(valToGetty));
d_output_stream.flush;

%% test that the handshake is on until it is (Wait for Getty to give go-ahead)
n=0;
while n==0
%     n=n+1;    
    %is handshake up
    portval = getvalue(dioIn.HandShakeIn);
    if portval==1,
        fprintf(1,'HS up\n');
        break
    end
    if n==1,
        fprintf(1,'Waiting for Getty to set HS up\n');
    end

    %x pressed
    abort=local_press();
    if abort==1
        ModigBitSender(1:length(dioOut.Line),zeros(length(dioOut.Line),1))
        breaksession = 1;
        warning('Modig:AbortedHandshake','Aborted while waiting for Getty'),
        return
    end
end

%% set the hardtrigger up+down
ModigBitSender([dioOut.HardTriggerOut.Index dioOut.HandShakeOut.Index], [1 0]);
fprintf('TCPSendMEssage: pause\n')
% pause(0.1)
pause(0.5)
fprintf('TCPSendMessage: end of pause\n')
% set the hardtrigger down
ModigBitSender([dioOut.HardTriggerOut.Index dioOut.HandShakeOut.Index], [0 0]);

function yes=local_press()
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