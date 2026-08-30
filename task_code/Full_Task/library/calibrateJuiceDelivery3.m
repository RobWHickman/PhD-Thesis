function [juiceStr jCurTime, fullUStime] = calibrateJuiceDelivery(targetEpoch,targetInMl,interPulseDelay,pulses)
% [juiceStr jCurTime, fullUStime] = calibrateJuiceDelivery(targetEpoch,targetInMl,interPulseDelay,pulses)
%
% calibrateJuiceDelivery uses calibration data to deliver the "target"
% amount of juice
%
% It can take input target(in ml) or, alternatively it reads Stim.us.target
%
% Output: assigns input target to Stim.us.target
%         juiceStr, string to deliver reinforcer (open solenoid or generate
%         beep)
%           jCurTime: calibrated time for each pulse
%           fullUStime: all time it will take to evaluate
% See also adjustSolenoidOpenTime
% rbm 3.12 
% rbm 4.12 Output fullUStime used to adjust inter-reward delay
%     7.12  changed 'sound' to psychPortAudio for low latency
%     2.13 Uses the best equation depending on the amouint of juice pulses
%     2.14 No timer output.  

global UserInfo TaskOp ExtDevice Stim AudParam TP
jCurTime = 0;
fullUStime = 0;
upDownDelay = 0.001; % latest latency measurements =1ms
if nargin == 1,
    error('calibrateJuiceDelivery needs at least 2 inputs')
elseif nargin == 2,
    interPulseDelay = 0;
    pulses = 1;
elseif isempty(interPulseDelay),
    interPulseDelay = 0;
end
ipd = num2str(interPulseDelay);

% return empty string if no juice is requested
if targetInMl==0 || pulses==0,
    juiceStr = [];
    return
end

% retrieve current juice line
bIsActive = strcmp(TaskOp.curSetup,'B');

if UserInfo.lab_connection
    if strcmpi(targetEpoch,'WaterDelivery') || strcmpi(targetEpoch,'WaterDelivery_BC')
            jCurTime = (PolyWaterOT(targetInMl))/1000;
            if strcmp(TP.BDM.CurrencyType,'W')
                curLine = ExtDevice.outputDio.juice2.Index;
            elseif strcmp(TP.BDM.CurrencyType,'B')
                curLine = ExtDevice.outputDio.juice1.Index;
            end
    elseif strcmpi(targetEpoch,'JuiceDelivery') || strcmpi(targetEpoch,'JuiceDelivery_BC')
        if targetInMl > 0
            jCurTime = (PolyJuice1OT(targetInMl))/1000;
        else
            jCurTime = 0;
        end
            if strcmp(TP.Reward.Type,'Juice')
                curLine = ExtDevice.outputDio.juice1.Index;
            elseif strcmp(TP.Reward.Type,'Water')
                curLine = ExtDevice.outputDio.juice2.Index;
            end
    end
    
    if jCurTime<0,
%         warning('AdjustSolenoidOpenTime suggested opening time < 0 with ml=%0.3g, time=%0.3g, pulses=%d',targetInMl,interPulseDelay,pulses)
        jCurTime = 0.015;
    end

    jCurTime = jCurTime-upDownDelay; % DIO up/down adjustment
    curJuiceCall = ['DIOjuice(',num2str(jCurTime),',',num2str(curLine),');'];    
    if pulses>1,
        juiceStr = [repmat([curJuiceCall,'WaitSecs(',ipd,');'],1,pulses-1) curJuiceCall];
    else
        juiceStr = curJuiceCall;
    end
else
    
    curLine = 10;
   time = targetInMl*2;
   beepAsJuice('init',curLine,time);
   juiceStr = sprintf('beepAsJuice(''play'',%d);', curLine);
end

fullUStime = (jCurTime*pulses)+(str2double(ipd)*(pulses-1));
