% % ModigGlobalReference
% % 
% % This reference file explicits (some of) the global variables used in
% % Modig. 
% %
%
% ExtDevice = 
% 
%     CurDevice: 'ITC'
%           ITC: 
%               product_name: 'ITC-1600'
%               dev_handle: []
%                 com_open: 0
%                 LatestInData: []
%                 analog_range: 32768
%           Cur:     
%           product_name: 'ITC-1600'
%           dev_handle: []
%         com_open: 0
%         LatestInData: []
%         analog_range: 32768
% UserDataBase.(users)
%                count: 174
%           login_time: [174x6 double]
%                   PC:  macintosh: 0
%                       windows: 1
%                           osx: 0
%                         linux: 0
%        default_param: (PRJ)
%        current_param: []
%            animal_ID: 53
%     use_touch_screen: 0
%       lab_connection: 0
% 
% % MENUs = 
% % 
% %     ModigMainMenu: [1x1 struct]
% %           tag: 'ModigMainMenu'
% %           handles: [1x1 struct]
% %           handle: 157.0038
% %           status: 'ON'
% % 
% % TaskOp = 
% % 
% %     priority_level: 0
% %      message_level: 3
% %       running_mode: 'infinite'
% %           EvntHist: [1x1 struct]
% %               mode: 'debug'
% %         eye_handle: []
% %                Cal: [1x1 struct]
% %              count: [1x1 struct]
% %              Trial: [1x1 struct]
% %         task_juice: [1x1 struct]
% %         free_juice: [1x1 struct]
% %                log: [1x1 struct]
% %                
% % MenuPos = 
% % 
% %     ModigMainMenu: [1x1 struct]
% % 
% % ModigDir = 
% % 
% %     MainCode: 'C:\Program Files\MATLAB\R2006a\work\Modig\shell'
% %     Projects: 'C:\Program Files\MATLAB\R2006a\work\Modig\projects'
% %       Images: 'C:\Program Files\MATLAB\R2006a\work\Modig\images'
% %          Log: 'C:\Program Files\MATLAB\R2006a\work\Modig\log'
% %
% % ModigPrj = 
% % 
% %             CAL:                 
% %                 TaskTbl: {5x4 cell}
% %           TaskTblColumn: {'evnt_name'  'vis_page'  'function_name'  'tab_name'}
% %                 MenuTbl: {3x3 cell}
% %           MenuTblColumn: {'function_name'  'tab_name'  'default_on'}
% %                 StimTbl: {'fix_spot'  'fixed'  'fixed'  'fixed'  'fixed'  'draw_by_function'  [1x16 char]}
% %           StimTblColumn: {1x7 cell}
% %         TaskTblColumnID: [1x1 struct]
% %         MenuTblColumnID: [1x1 struct]
% %         StimTblColumnID: [1x1 struct]
% %        FIXATION: [1x1 struct]
% %     FREE_REWARD: [1x1 struct]
% %          PAVLOV: [1x1 struct]
% %
% % VisParam = 
% % 
% %            scr_num: 2
% %         scr_handle: 10
% %           scr_rect: [0 0 1280 960]
% %       scr_center_x: 640
% %       scr_center_y: 480
% %          view_dist: 500
% %       scr_width_mm: 308
% %      scr_height_mm: 231
% %      scr_width_pix: 1280
% %     scr_height_pix: 960
% %        pix_per_deg: 40.4640
% %        deg_per_pix: 0.0247
% %       draw_eye_pos: 1
% %       draw_stimuli: 1
% %              iscan: [1x1 struct]
%
% VisStat = 
% 
%            num_test: 10
%       page_interval: 1
%     randomize_trial: 0
%                page: []
%            num_page: 0
%               pages: [2x1 double]
%                 prj: 'FIXATION'
%                 Tbl: [1x1 struct]
%     make_correction: 0
% %
% 
% %
% % inside_session =
% %      0
% % 
% % inside_task =
% %      0
% % 
% % BehaveData = 
% %        Tbl: []
% %     Column: [1x1 struct]
% %           time: 1
% %       eye_x_raw: 2
% %         eye_y_raw: 3
% %     eye_x_cal: 4
% %     eye_y_cal: 5
% %
% % VisStat = 
% %     make_correction: 1
% %            num_test: 10
% %                 prj: []
% %                page: []
% %            num_page: 0
% %       page_interval: 1
% %     randomize_trial: 1
% % IO = 
% %     Input: [1x1 struct]
% %         IO.Input
% %         ans = 
% %                  eye: [1x1 struct]
% %                 hand: [1x1 struct]
% %               tongue: [1x1 struct]
% %             behavior: [1x1 struct]
% %
% % Timers = 
% %     Output: [1x1 struct]
% %         Timers.Output
% %         ans = 
% %             free_juice: [1x1 timer]
% %             task_juice: [1x1 timer]
% %             Timers.Output.free_juice
% %                Timer Object: Output_free_juice
% %                Timer Settings
% %                   ExecutionMode: singleShot
% %                          Period: 1
% %                        BusyMode: queue
% %                         Running: off
% %                Callbacks
% %                        TimerFcn: 'ITC_SetDigitalOutput(4,0);toc;'
% %                        ErrorFcn: 'ITC_SetDigitalOutput(4,0);toc;'
% %                        StartFcn: 'tic;ITC_SetDigitalOutput(4,1);'
% %                         StopFcn: 'ITC_SetDigitalOutput(4,0);'
% %             Timers.Output.task_juice
% %                Timer Object: Output_task_juice
% %                Timer Settings
% %                   ExecutionMode: singleShot
% %                          Period: 1
% %                        BusyMode: queue
% %                         Running: off
% %                Callbacks
% %                        TimerFcn: 'ITC_SetDigitalOutput(4,0);toc;'
% %                        ErrorFcn: 'ITC_SetDigitalOutput(4,0);toc;'
% %                        StartFcn: 'tic;ITC_SetDigitalOutput(4,1);'
% %                         StopFcn: 'ITC_SetDigitalOutput(4,0);'
% %
% % Tbl = 
% % 
% %             TaskTbl: {5x4 cell}
% %       TaskTblColumn: {'evnt_name'  'vis_page'  'function_name'  'tab_name'}
% %     TaskTblColumnID: [1x1 struct]
% %                Task: [1x1 struct]
% %                 prj: 'CAL'
% %            BitAsign: [1x1 struct]
% %              BitTbl: {13x4 cell}
% %        BitTblColumn: {'bit_event_name'  'bit_asignment'  'initial_value'  'comment'}
% %      BitTblColumnID: [1x1 struct]
% %                 Bit: [1x1 struct]
% %
% % Stim = 
% %     fix_spot: [1x1 struct]
% %          stim_name: 'fix_spot'
% %           prj_name: 'CAL'
% %         image_type: 'draw_by_function'
% %          menu_type: 'A'
% %             policy: [1x1 struct]
% %             CurSet: [1x1 struct]
% %           CurTrial: [1x1 struct]
% %                pos: 'center'
