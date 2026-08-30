function runTCPHandshake(dioIn,dioOut,varToGetty)

global breaksession

TCPHandshakeModig(varToGetty);


%Put the hard trigger out bit up and wait for the hand shake in bit to
%go up - this is to synchronise to Getty.

% Hard Trigger Out UP
ModigBitSender(dioOut.HardTriggerOut.Index, 1);

% Wait for handshake In UP
portval=0;
 while portval==0
    %is handshake up
    portval=getvalue(dioIn.HandShakeIn);    

    %x pressed
    abort=press();
    if abort==1
        ModigBitSender(1:length(dioOut.Line),zeros(length(dioOut.Line),1))
        breaksession = 1;
        warning('modig:handshake','Aborted handshake while waiting for synch'),return
    end
end

% Reset all output bits to 0
ModigBitSender(1:length(dioOut.Line),zeros(length(dioOut.Line),1));
