function theTimer = ModigSetWhileTimer(timer_name)

global Task Tbl

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
        start_delay = round(Task.us.time_base)/1000;
        set(cur_timer, 'startdelay', start_delay);
        set(cur_timer, 'ExecutionMode','singleShot');
        set(cur_timer, 'BusyMode','queue');
        %
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


