% Modig/LIBRARY
%
% Revision $78 | Author $RBM | Date $05/03/2013
%
% Files
%   adaptiveError          - adaptive error when running Getty, so to reflect time that
%   adjustSolenoidOpenTime - openTime = adjustSolenoidOpenTime(betas, target, pulses, interpulse)
%   beepAsJuice            - beepAsJuice(typeOfCall,setup)
%   calibrateJuiceDelivery - jCurTime = calibrateJuiceDelivery(targetEpoch,targetInMl,interPulseDelay,pulses)
%   checkreps              - called by ModigRandSeq.... check repetitions in a random sequence???
%   checkTimerTiming       - 
%   createTolWin2          - [eyeLim tolWinHdl] = createTolWin2(center,tolWinSize)
%   createTolWinCircle     - [eyeLim tolWinHdl] = createTolWinCircle(center,radius)
%   deg2rad                - radians = deg2rad(degrees)
%   dioAutoTest            - result = dioAutoTest(dio)
%   DIOjuice               - DIOjuice(time,line)
%   drawCircles            - [circusStr circusHdl]  = drawCircles(clr,pos,parentAxisHdl, axisKids)
%   drawFrameRect          - [frameStr frameHdl] = drawFrameRect(clr,pos,penWidth,parentAxisHdl, axisKids)
%   drawImages             - [imgStr imgHdl] = drawImages(fname, pos, parentAxisHdl, axisKids,rotation)
%   drawRectangle_RBM      - [rectStr rectHdl] = drawRectangle_RBM(clr,pos,parentAxisHdl, axisKids)
%   drawRewardBarStims     - 
%   drawRings              - [ringStr ringHdl]  = drawRings(clr,pos,parentAxisHdl, axisKids)
%   drawTriangle           - [triStr triHdl]  = drawTriangle(clr,pos,parentAxisHdl, axisKids, varargin)
%   drawValueBar           - [valBarStr valBarHdl]=drawValueBar(reward_mag, border_color,
%   DrawValuebarFunction   - 
%   findcell_sk            - search specific string/num in cell array x.
%   findcellline_sk        - x: cell table
%   findIndicesInVector    - indices = findIndicesInVector(lookHere,forThis)
%   findreps               - z=findreps(x,reps)
%   get_GUI_value          - 
%   get_menu_contents      - get gui information
%   isfield_sk             - [TF value empty] = isfield_sk(stem, fullname)
%   isglobal_sk            - 
%   judgeSituationRecover  - params = judgeSituationRecover(param, Tbl,Timers);
%   KeyPressed             - KeyPressed(src, evnt)
%   limitRandSeq           - sequence = limitRandSeq(conditions, minTimesRepeat, condTimesRepeat,
%   mltable                - function data = mltable(fig, hObj, action, columnInfo, rowHeight, cell_data, gFont)
%   ModigSetWhileTimer     - 
%   MovieDemo              - MovieDemo uses Screen.mex to make and show a movie.
%   noKeyRelease_module    - noKeyRelease_module(rowNoToUpdate, nameOfEpoch) 
%   PESTgui                - Pest = PESTgui(Pest)
%   press                  - 
%   rad2deg                - degrees = rad2deg(radians)
%   randomizeStimPosition  - [position iterations] = randomizeStimPosition(rect, tp, stimSz, sp, pulses, bIsActive, stimOnLeft, evaluate)
%   REWARD_CAL             - varargout = REWARD_CAL(varargin)
%   RewardSeqGenerator     - generate pseudorandom reward sequences that fulfill their mean frequncy
%   runED                  - runED(a,monitors)
%   runhandshake           - runhandshake(VarToGetty, statusFlag)
%   runTCPHandshake        - 
%   ScreenWarmer           - ScreenWarmer(scrHdl,scrRect,warmTime)
%   screenWarmerColor      - screenWarmerColor(win,screenRect)
%   set_GUI_value          - get values of a GUI object
%   shiftSetupMoMaMe       - varargout = shiftSetupMoMaMe(varargin)
%   sort_structure         - structure_out = sort_structure(structure)
%   TCPCloseConnection     - 
%   TCPOpenConnection      - 
%   TCPSendMessage         - TCPSendMessage(dioIn,dioOut,valToGetty)
%   timerTimeStamper       - timerTimeStamper(obj, event, varargin)
%   trialRecon             - out = trialRecon(option)
%   typeHandshakeSelection - typeHandshakeSelection(source, eventdata)
