function errorSound(buzzsound)
% errorSound(buzzsound)
%
% Plays buzz sound after an error.
%
% in: 'sound', user-defined error-related sound
%
% Execution is slow because all operations are performed in one go.
%
% See also beepAsJuice, ModigRunTrial
%
% rbm 3.14

global AudParam 

if nargin==0,
    buzzsound = repmat(tan(-pi:0.1:pi),1,20);
    buzzsound = max(-1,min(buzzsound,1));
end

PsychPortAudio('DeleteBuffer');

% Fill the audio playback buffer with buzzsoound            
PsychPortAudio('FillBuffer', AudParam.pahandle, buzzsound);            

% Start audio playback for 'repetitions' repetitions of the sound data,
% start it immediately (0) and wait for the playback to start,
PsychPortAudio('Start', AudParam.pahandle, 1, 0, 1);
        
