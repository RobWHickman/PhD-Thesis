function beepAsJuice(typeOfCall,line,time)
% beepAsJuice(typeOfCall,setup)
%
% Plays beep instead of juice delivery. Used when lab isn't connected.
%
% type of Call: 'init', initialize beep sound
%               'play', play beep sound
%
% See also DIOjuice, calibrateJuiceDelivery
%
% rbm 7.12
%     4.14 Commented out most of it since PsychPortAudio doesn't work
%       in the experimental setup. It uses "sound", which is pretty slow
%       (long latency).

global AudParam TaskOp
persistent haveInit
if isempty(haveInit) , 
    haveInit = 0; 
end
% fprintf('Audio disabled momentyarily r.202\n')
% return
switch typeOfCall,
    case 'init'
        if haveInit == 0,
%             PsychPortAudio('DeleteBuffer');
            % Fill the audio playback buffer with a beep            
            hz = 500+(1000*mod(line,12));            
            wavedata = MakeBeep(hz,time,AudParam.fs);
%             PsychPortAudio('FillBuffer', AudParam.pahandle, wavedata);
            haveInit = wavedata;
        end
    case 'play'
        % Start audio playback for 'repetitions' repetitions of the sound data,
        % start it immediately (0) and wait for the playback to start,
%         PsychPortAudio('Start', AudParam.pahandle, 1, 0, 1);
        
        sound(haveInit, AudParam.fs);
        % update reward history counter !
        TaskOp.reward(line) = TaskOp.reward(line)+1;
end