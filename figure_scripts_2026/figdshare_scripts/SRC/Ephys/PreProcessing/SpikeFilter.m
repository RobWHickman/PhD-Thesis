function filtered_data = SpikeFilter(data,sFreq,freq_range,order)

if nargin < 4
    order = 1000;
    disp(['Filter order set to: ',num2str(order)]);
end

if nargin < 3
    freq_range = [300 3000];
    disp('Frequency constraints set to: [300 3000]');
end

if nargin < 2
    sFreq = 22000;
    disp('Sampling frequency set to: 22000');
end


low = freq_range(1);
high = freq_range(2);


d = designfilt('bandpassfir', ...       % Response type
       'FilterOrder',order, ...         % Filter order
       'StopbandFrequency1',low, ...    % Frequency constraints
       'PassbandFrequency1',low+50, ...
       'PassbandFrequency2',high-50, ...
       'StopbandFrequency2',high, ...
       'DesignMethod','equiripple', ... % Design method
       'StopbandWeight1',1, ...         % Design method options
       'PassbandWeight', 2, ...
       'StopbandWeight2',3, ...
       'SampleRate',sFreq);             % Sample rate
   
%    
%    d = designfilt('bandpassiir', ...       % Response type
%        'StopbandFrequency1',low, ...    % Frequency constraints
%        'PassbandFrequency1',low+50, ...
%        'PassbandFrequency2',high-50, ...
%        'StopbandFrequency2',high, ...
%        'StopbandAttenuation1',40, ...   % Magnitude constraints
%        'PassbandRipple',1, ...
%        'StopbandAttenuation2',50, ...
%        'DesignMethod','ellip', ...      % Design method
%        'MatchExactly','passband', ...   % Design method options
%        'SampleRate',22000);               % Sample rate
   
   data = double(data);
   filtered_data = filtfilt(d,data);
   
   
   
   
   
   