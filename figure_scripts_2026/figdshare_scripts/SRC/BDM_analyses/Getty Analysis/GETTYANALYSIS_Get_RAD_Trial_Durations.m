function durations_ms = GETTYANALYSIS_Get_RAD_Trial_Durations(file_path_and_name,sampling_freq)

fileID = fopen(file_path_and_name,'r');
radDurFile=fread(fileID,10000,'double');
fclose(fileID);
 if nargin < 2
     sampling_freq = 22000;
     an = questdlg('Sampling frequency set to 22000. Would you like to proceed?','Sample rate','Yes','No','Yes');
     if strcmp(an,'No')
         error('Sampling rate not accurate.')
     end
 end

durations_s = radDurFile./sampling_freq;
durations_ms = durations_s*1000;

