function ScreenWarmer(scrHdl,scrRect,warmTime)
% ScreenWarmer(scrHdl,scrRect,warmTime)
%
% "warms up" display window(s). Warming a monitor, especially a CRT
% improves the accuracy of stimulus timing -this I tested some time ago
% with a Cambridge research System. Future tests will be made...
%
% In:   scrHdl, screen handle.
%       scrRect: rectangle of the screen -the code will try to generate the
%               best texture to fit in the screen 
%               (leave empty, runs w/ 2^11 mesh!)
%       warmTime: warming time, defaults to 5 minutes [300 s]
%
% example call:
%
%   global VisParam
%   ScreenWarmer(VisParam.scr_handle,VisParam.scr_rect)
%
% adapted from driftdemo3 
%
% rbm 6.08

if nargin == 2,
    warmTime = Inf;
end

visiblesize= 2^11;%32^2;%1024;%1280;%512;        
p = 2^5;%64;
cyclespersecond = 1;
% 
if rem(visiblesize, p)~=0 
  error('Period p must divide visiblesize without remainder for this demo to work!');
end;

% This script calls Psychtoolbox commands available only in OpenGL-based 
% versions of the Psychtoolbox. The Psychtoolbox command AssertPsychOpenGL will issue
% an error message if someone tries to execute this script on a computer without
% an OpenGL Psychtoolbox.
AssertOpenGL;

% Find the color values which correspond to white and black.  Though on OS
% X we currently only support true color and thus, for scalar color
% arguments, black is always 0 and white 255, this rule is not necessarily
% true on other platforms and will not remain true after we add other color depth modes.  
white=WhiteIndex(scrHdl);
black=BlackIndex(scrHdl);
gray=(white+black)/2;
if round(gray)==white
	gray=black;
end
inc=white-gray;

% Flip buffer to show initial gray background:
Screen('Flip', scrHdl);

% Calculate parameters of the grating:
f  = 1/p;
fr = f*2*pi;    % frequency in radians.

% Create one single static grating image:
% [x,y]   = meshgrid(0:scrRect(3)-1, 0:scrRect(4)-1);
[x,y] = meshgrid(0:visiblesize-1, 0:visiblesize-1);
grating = gray + inc*cos(fr*y);

% Store grating in texture: Set the 'enforcepot' flag to 1 to signal
% Psychtoolbox that we want a special scrollable power-of-two texture:
gratingtex=Screen('MakeTexture', scrHdl, grating, [], 1);
% gratingtex=Screen('MakeTexture', scrHdl, grating);

% Query duration of monitor refresh interval:
ifi          = Screen('GetFlipInterval', scrHdl);    
waitframes   = 3;
waitduration = waitframes * ifi;

% Translate requested speed of the grating (in cycles per second)
% into a shift value in "pixels per frame", assuming given
% waitduration: This is the amount of pixels to shift our srcRect at
% each redraw:
shiftperframe = cyclespersecond * p * waitduration;

% Perform initial Flip to sync us to the VBL and for getting an initial
% VBL-Timestamp for our "WaitBlanking" emulation:
vbl=Screen('Flip', scrHdl);

% We run at most 'movieDurationSecs' seconds if user doesn't abort via keypress.
vblendtime = vbl + warmTime;
yoffset = 0;
xoffset = 0;
disp(sprintf('running ScreenWarmer for %d s... press a key to abort',...
    warmTime))

oldPr = Priority(2);
% Animationloop:
while(vbl < vblendtime)
   % Shift the grating by "shiftperframe" pixels per frame:
%    xoffset = xoffset + shiftperframe;
    yoffset = yoffset + shiftperframe;
    
   % Define shifted srcRect that cuts out the properly shifted rectangular
   % area from the texture:
%    srcRect=[xoffset 0 xoffset + visiblesize visiblesize];
%     srcRect = [0 yoffset scrRect(3) scrRect(4)+yoffset];
    srcRect = [0 yoffset visiblesize visiblesize+yoffset];
   % Draw grating texture: Only show subarea 'srcRect', center
   % texture in the onscreen window.
   Screen('DrawTexture', scrHdl, gratingtex,srcRect);

   % Flip 'waitframes' monitor refresh intervals after last redraw.
   vbl = Screen('Flip', scrHdl, vbl + (waitframes - 0.5) * ifi);

   % Abort demo if any key is pressed:
   if KbCheck
       disp('aborted ScreenWarmer')
      break;
   end;
end;
Priority(oldPr);
% Flip buffer to show initial gray background:
Screen('Flip', scrHdl);




