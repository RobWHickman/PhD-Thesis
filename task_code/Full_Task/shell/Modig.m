function Modig(varargin)
% A function called to start "Modig", our on-line task control program
%
% It runs on Mac OSX or Win XP installed with psychophysics toolbox (PTB)
% This function opens Log-in menu.
% Then, if connected, initialize a data acquisition board NIDAQ-662.
%
% Exits Modigliani by typing 'Modig('exit')' or 'Modig exit' 
% you can also start a trial by typing 'Modig start' in the command window.
% 
% See also MODIGLOGIN, MODIGMENUCONTROL, MODIGINITIALIZE, MODIGCHANGETASK

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% coded by skoba (skoba-tky@umin.ac.jp) 13 June 2005
% last modified by skoba 13 June 2005
% rbm 6.07 included exit option from the command window
% rbm 9.07 cancel possibility, see changes in MoLoIn
% $Author: rbm $Date: 22/02/2013 $Revision: 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(0,'DefaultFigurePosition',[-1356,326,560,420]);

if nargin > 0
    ModigCommand(varargin{1});
else
    clear all
    close all
    loggedIn = ModigLogIn;
    if loggedIn,
        opened = ModigMenuControl('ModigMainMenu','On'); 
        if opened,
            ModigInitialize; 
            ModigChangeTask('BDM_BC');% First project to be loaded.
        end
    end
end