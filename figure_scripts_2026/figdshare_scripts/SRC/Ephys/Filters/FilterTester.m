noise = rand(1,30000);
noise = noise-.5;

 

data = zeros(1,30000);
data = data+noise;

data(100:160) = 3;
data(5000:5060) = 3;
data(8000:8060) = 3;
data(3000:3060) = 3;

d = designfilt('bandpassiir', ...       % Response type
       'StopbandFrequency1',low, ...    % Frequency constraints
       'PassbandFrequency1',low+50, ...
       'PassbandFrequency2',high-50, ...
       'StopbandFrequency2',high, ...
       'StopbandAttenuation1',40, ...   % Magnitude constraints
       'PassbandRipple',1, ...
       'StopbandAttenuation2',50, ...
       'DesignMethod','ellip', ...      % Design method
       'MatchExactly','passband', ...   % Design method options
       'SampleRate',22000)               % Sample rate
     
% d = designfilt('bandpassfir', ...       % Response type
%        'FilterOrder',3, ...         % Filter order
%        'StopbandFrequency1',low, ...    % Frequency constraints
%        'PassbandFrequency1',low+50, ...
%        'PassbandFrequency2',high-50, ...
%        'StopbandFrequency2',high, ...
%        'DesignMethod','equiripple', ... % Design method
%        'SampleRate',sFreq);             % Sample rate
%    
%         'StopbandWeight1',1, ...         % Design method options
%        'PassbandWeight', 2, ...
%        'StopbandWeight2',3, ...
%        
   fvtool(d);
   
   df = filtfilt(d,data);
   
   
   figure
   plot(data)
   hold on
   plot(df)