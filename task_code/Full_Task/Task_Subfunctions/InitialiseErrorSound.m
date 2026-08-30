% InitialiseErrorSound

global Stim

InitializePsychSound
[sounddata,soundfreq] = audioread('Error_Tone.wav');
sounddata = sounddata';
Stim.ErrorSound = PsychPortAudio('Open',[],[],0,soundfreq,1);
PsychPortAudio('FillBuffer',Stim.ErrorSound, sounddata);