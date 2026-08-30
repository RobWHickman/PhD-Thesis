function cb = ModigSetTimer(timer_category,timer_name)
% cb = ModigSetTimer(timer_category,timer_name)
%
%   Set timer properties for 'timer_name' which belongs to the
%   'timer_category'. 
%
% timer_categories: Input, Output, Event.
% 
%           the only input timer is 'monitor_behavior', it needs
%           any value in the global IO.Input.behavior.sampling_rate
%
% the output will be found in the global Timers
%
% SK wrote it
% RBM 08.07 commented out ExtDevice, no buffered DIO for getty handshake
%           Depracated calls to SetTimerProperty and used instead typical
%           variable assignment calls (which are of course faster)
% rbm 09.07 deleted getty bits for clearer reading and changed 'juice'
%           timers to DIOjuice using WaitSecs instead of the very
%           unreliable timers from Matlab. juice is juicy!
% rbm 12.07 arms behavioral timer for MoDoubleMonitorBehavior and juice
%           delivery in 'otherUS' events.

global IO Tbl Task UserInfo ExtDevice Timers Stim
cb = 1;

% check input
cats = {'Event','Input','Output'};
if any(strcmp(timer_category,cats))==0,
    error('ModigSetTimer returned. Unrecognized 1st argument')
end
 
cur_tag = strcat('TIMER_',upper(timer_category),'_',upper(timer_name));

% destroy existing timers with the same Tag to avoid confusion
timer_found = timerfind('Tag',cur_tag);
if ~isempty(timer_found)
    if isvalid(timer_found)
        stop(timer_found);
        delete(timer_found);
    end
end
    
% initalize timer creation
field_name = strcat(timer_category,'.',timer_name);
timer_obj_name = strcat('Timers.',field_name);
eval(strcat(timer_obj_name,'= timer;'));
cur_timer = eval(timer_obj_name);
if isvalid(cur_timer)
%         if strcmpi(get(cur_timer,'Running'),'off')
    % now it gets interesting and messy... we have Output, Input
    % and Event categories
    switch timer_category
        case 'Output'  
            [THtimer CurTimerProp EMPTY_timer] = isfield_sk(IO, field_name);
            if EMPTY_timer
                disp(sprintf('empty field: IO.%s', field_name));
                delete(cur_timer)
                Timers.Output = rmfield(Timers.Output,'field_name');
                return
            else
                if UserInfo.lab_connection
                    juicedur = (round(CurTimerProp.dur)/1000)-0.005;
                    start_fcn = '';
                    timer_fcn = ['DIOjuice(',num2str(juicedur),')'];
                    % DIOcallback has been deprecated 1.08
%                     stop_fcn  = {@DIOcallback,0}; % in case it doesn't stops
                    stop_fcn = '';
                else
                    start_fcn = 'ModigMessage(''c'',''DBG: timer.Output start'',1)';
                    timer_fcn = 'ModigMessage(''c'',''DBG: timer.Output timer'',1)';
                    stop_fcn  = 'ModigMessage(''c'',''DBG: timer.Output stop'',1)';
                end
                set(cur_timer, 'StartDelay', 0);
                set(cur_timer, 'ExecutionMode','singleShot');
                set(cur_timer, 'BusyMode','queue');                      
            end
        case 'Event' 
            % NOTE, does it makes sense to define an output
            % structure in the "event" case? 
            field_name = strcat('Task.',timer_name);
            [TH_event EventStruct EMPTY_event] = isfield_sk(Tbl,field_name);
            if ~EMPTY_event
                prev_evnt_id = num2str(EventStruct.id);
                if strcmpi(EventStruct.evnt_name,'us') || strcmpi(EventStruct.evnt_name,'otherUS')
                    % time_beh (called by timer or behavioral
                    % event. 1: called by timer)
                    shift_str = strcat('ModigShiftEvent(''shift'',1,',prev_evnt_id,');');
                    if UserInfo.lab_connection
                        juicedur = (round(Task.us.time_base)/1000)-0.0045;
                        start_fcn = {@timerTimeStamper, ['DIOjuice(',num2str(juicedur),')']};
                        timer_fcn = {@timerTimeStamper, shift_str};
                        stop_fcn  = '';
                    else % if lab not connected
                        Fs = 8192;
                        array_size = round(Fs/Task.us.time_base);
                        juice_on_str = strcat('sound(rand(',num2str(array_size),',1),8192)');

                        start_fcn = {@timerTimeStamper, juice_on_str};
                        timer_fcn = {@timerTimeStamper, shift_str};
                        stop_fcn = '';
                    end
%                     start_delay = round(Task.us.time_base)/1000;
%                     set(cur_timer, 'startdelay', start_delay);
                    set(cur_timer, 'StartDelay', 0);
                    set(cur_timer, 'ExecutionMode','singleShot');
                    set(cur_timer, 'BusyMode','queue');
                    
                elseif strcmpi(EventStruct.evnt_name,'ITI')
                    start_fcn = @timerTimeStamper;
                    timer_fcn = @timerTimeStamper;
                    stop_fcn  = '';

                    field_name = strcat(timer_name,'.time_randomized');
                    [TH_time start_delay EMPTY_time] = isfield_sk(Task,field_name);
                    if ~EMPTY_time
                        set(cur_timer, 'StartDelay', round(start_delay)/1000);
                    end
                    set(cur_timer, 'ExecutionMode','singleShot');
                    set(cur_timer, 'BusyMode','queue');                    
                else
                    % time_beh (called by timer or behavioral event. 1: called by timer)
                    shift_str = strcat('ModigShiftEvent(''shift'',1,',prev_evnt_id,');');
                    start_fcn = @timerTimeStamper;
                    timer_fcn = {@timerTimeStamper, shift_str};
                    stop_fcn  = '';

                    field_name = strcat(timer_name,'.time_randomized');
                    [TH_time start_delay EMPTY_time] = isfield_sk(Task,field_name);
                    if ~EMPTY_time
                        set(cur_timer, 'StartDelay',round(start_delay)/1000);
                    end
                    set(cur_timer, 'ExecutionMode','singleShot');
                    set(cur_timer, 'BusyMode','queue');
                end
            end
        case 'Input'
            switch timer_name
                case 'behavior_monitor'
                    if strcmp(Tbl.MenuTbl{1,1}, 'ModigMonitorTable')
                        start_fcn = 'ModigDoubleMonitorBehavior(''start'')';
                        timer_fcn = 'ModigDoubleMonitorBehavior(''sample'')';
                        stop_fcn  = 'ModigDoubleMonitorBehavior(''stop'')';
                    else
                        start_fcn = 'ModigMonitorBehavior(''start'')';
                        timer_fcn = 'ModigMonitorBehavior(''sample'')';
                        stop_fcn  = 'ModigMonitorBehavior(''stop'')';
                    end
                    set(cur_timer, 'StartDelay', 0);
                    % 'fixedDelay' samples at tops 60Hz, though the call is
                    % not in "overdrive". 
                    % 'fixedRate' samples at very irregular intervals, but
                    % at the required speed
                    % 'fixedSpacing', by design, samples very regularly
                    % but with the execution time added in to the sample.
                    % It tops at about 60Hz
                    set(cur_timer, 'ExecutionMode', 'fixedrate');
                    p = round(1000/IO.Input.behavior.sampling_rate)/1000;
                    set(cur_timer, 'Period',p);
                    % 'queue' provides the mean period, but with higher 
                    % variability as 'drop'.
                    % 'drop' trumps sampling at about 65Hz
                    set(cur_timer, 'BusyMode','queue');                    
            end
    end 
%     error_fcn = 'global breaksession; breaksession = 1; rethrow(lasterror); return';
    error_fcn = 'ModigCommand(''stop_session''),rethrow(lasterror)';

    set(cur_timer, 'StartFcn' , start_fcn);
    set(cur_timer, 'TimerFcn' , timer_fcn);
    set(cur_timer, 'StopFcn'  , stop_fcn);
    set(cur_timer, 'ErrorFcn' , error_fcn);

    set(cur_timer, 'Name', strcat(timer_category,'_',timer_name));
    set(cur_timer, 'Tag' , cur_tag);
else
    warning('MODIG:MoSetTimer','invalid timer')
    cb = 0;
end