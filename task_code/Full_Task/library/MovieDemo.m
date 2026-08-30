function MovieDemo
% MovieDemo uses Screen.mex to make and show a movie.
fprintf('MovieDemo.m is only 36 lines, plus comments.\n');
fprintf('Read it to see how easy it is to show movies.\n\n');

% Open a window in center of screen
screenNumber=1;
rect=CenterRect([0 0 200 200],Screen(screenNumber,'Rect'));
window=Screen(screenNumber,'OpenWindow',[],rect);

% Make a movie by drawing ovals into 101 offscreen windows.
fprintf('Computing the movie... ');
black=BlackIndex(window);
w=zeros(101,1);
for i=1:101
    w(i)=Screen(window,'OpenOffscreenWindow');
    r=[0 0 2 2]*(i-1);
    Screen(w(i),'FillOval',black,r);
end
fprintf('Done.\nRoll ''em!\n');

% Show the movie, first forwards, then backwards.
HideCursor;
rect=Screen(w(1),'Rect');
for i=[1:101 101:-1:1]
    Screen(window,'WaitBlanking');
    Screen('CopyWindow',w(i),window,rect,rect);
end

% Show the movie again, now using Rush to minimize interruptions.
loop={
    'for i=[1:101 101:-1:1];'
    'Screen(window,''WaitBlanking'');'
    'Screen(''CopyWindow'',w(i),window,rect,rect);'
    'end;'
    };
priorityLevel=MaxPriority(screenNumber,'WaitBlanking');
Rush(loop,priorityLevel);
ShowCursor;

%Close the on- and off-screen windows
Screen('CloseAll');

fprintf('The movie was shown twice. The first showing may have been jerky, due to\n');
fprintf('interruptions. The second showing used Rush to minimize interruptions, to\n');
fprintf('make the movie run smoothly. See MovieTearDemo and Rush.\n');