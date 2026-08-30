% ModigPrepareVariables_BDM_BC

% Initialise session:
CleanVisParamTextures;          % Wipes textures if there were any.
PrepareDataCell(3,'BDM_BC_');   % Saves empty 1000x3 'DATACELL' to directory.
InitialiseErrorSound;           % Initialises error sound object in 'Stim'.
SetJoyParams(1,1,0.05,0.01);    % Sets joystick parameters - (monitor, CentreFix, CentreThreshold, SensitivityThreshold).

% Initialise Task Parameters:
Task_Parameters
Task_Objects

% Generate GUI and related handles:
Initialise_GUI