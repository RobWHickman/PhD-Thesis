% Modig/SHELL
%
% revision 75 | author RBM | date 05/03/2013
%
% Files
%   Modig                      - A function called to start "Modig", our on-line task control program
%   ModigArrangeMenuPosition   - Adjust menu position depending on PC
%   ModigChangeTask            - ModigChangeTask(prj)
%   ModigCommand               - Collection of callback subroutines for commands from ModigMainMenu
%   ModigCommentLevel          - Change Comment level (on Modig main menu & command line)
%   ModigCopyParam             - cb = ModigCopyParam(space1,space2)
%   ModigCreateAnalogInput     - 
%   ModigCreateDio             - dioObject = ModigCreateDio(type)
%   ModigDeleteSavedParams     - Delete saved project parameters saved in a file
%   ModigGlobalReference       - ModigGlobalReference
%   ModigHard                  - Hardware setting menu
%   ModigInitialize            - ModigInitialize
%   ModigInputMenu             - M-file for ModigInputMenu.fig
%   ModigLoadBitAsignTbl       - BitAsign = ModigLoadBitAsignTbl(prj,animal_ID)
%   ModigLog                   - ModigLog(option)
%   ModigLogIn                 - Log in menu
%   ModigMainMenu              - MODIGLIANI Application M-file for ModigMainMenu.fig
%   ModigMakeGettyArray        - valToGetty = ModigMakeGettyArray
%   ModigMenuControl           - Control Menu On Off and check and uncheck the menu status on the Modig Main Menu
%   ModigMessage               - ModigMessage(msg_where,msg_what,msg_level,option)
%   ModigMonitor               - subroutines for experimenter's screen
%   ModigMonitorBehavior       - [] = ModigMonitorBehavior(varargin)
%   ModigOutputMenu            - varargout = ModigOutputMenu(varargin)
%   ModigPrepareTiming         - Prepare timing setting before every trial
%   ModigPriority              - 
%   ModigRandSeq               - A code to generate random sequence
%   ModigRandTime              - Randomly pick a time random between t1 and t2
%   ModigRwdMenu5by5           - Dialog box to set stimulus and reward conditions
%   ModigSetPriority           - 
%   ModigSetTimer              - cb = ModigSetTimer(timer_category,timer_name)
%   ModigShiftEvent            - Shift task event
%   ModigStimDlg               - M file for a figure to select fixation point (circle, square, cross)
%   ModigStimMenuControl       - reply=ModigStimMenuControl(gui_name,stim_name,option)
%   ModigStimSetUp_A           - varargout = ModigStimSetUp_A(varargin)
%   ModigStimSetUp_B           - MODIGLIANI Application M-file for ModigStimSetUp_B.fig
%   ModigStimSetUp_bk          - MODIGLIANI Application M-file for ModigStimSetUp.fig
%   ModigStimSetUp_CS          - CS property setting dialog box
%   ModigTaskLoop              - varargout = ModigTaskLoop(varargin)
%   ModigTestVisualPage        - varargout = ModigTestVisualPage(varargin)
%   ModigTimingMenu            - Make a dialog menu to set timing of each event.
%   ModigUpdateMenuPos         - Store position of present GUIs -found in MENUs- in global "MenuPos"
%   ModigVisDistConvert        - convert between mm, pixel, and viusal angle (degree, not radian)
%   CalibrateSolenoidGUI       - M-file for CalibrateSolenoidGUI.fig
%   ModigBitMonitor            - M-file for ModigBitMonitor.fig
%   ModigBitSender             - ModigBitSender(lines, values)
%   ModigDoubleMonitor         - M-file for ModigDoubleMonitor.fig
%   ModigDoubleMonitorBehavior - A routine to sample behavior: eye movements and key touch.
%   ModigHandshake             - varargout = ModigHandshake(dioIn, dioOut, valToGetty)
%   ModigMonitorBehavior2      - [] = ModigMonitorBehavior(varargin)
%   ModigMonitorTable          - M-file for ModigMonitorTable.fig
%   ModigPESTroutine           - ModigPESTRoutine. function that works as a script
%   ModigRunTrial              - TODO: test timing in setup
%   ModigRunTrial_backup       - 
%   activeSetupChange          - changed = activeSetupChange
%   myTimerMonitorBehavior     - runTime, [s]
%   paramGui_StimSelection     - M-file for paramGui_StimSelection.fig
