function Alert(sound_type)
if nargin<1
    sound_type = 'quack';
end


dbx = DropboxDir;
if strcmp(sound_type,'quack')
[y, Fs] = audioread([dbx,'\CODE\SRC\Sounds\quack.mp3']);
end
sound(y, Fs);

% clear sound;
