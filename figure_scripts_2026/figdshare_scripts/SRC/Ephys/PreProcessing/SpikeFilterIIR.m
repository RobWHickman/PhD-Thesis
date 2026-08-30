function filtered_data = SpikeFilterIIR(data,sFreq,freq_range,order)

if nargin < 4
    order = 10;
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

%%
     filt_range = [low high];
        Wp = [low  high] * 2 / sFreq;
        Ws = [low-round(low*.3) high+round(high*.3)] * 2 / sFreq;
        [ord,rip] = buttord( Wp, Ws, 3, 20);
        [d,a] = butter(ord,rip);
        
         fvtool(d,a)
%%

% d = designfilt('bandpassiir', ...       % Response type
%        'FilterOrder',20, ...         % Filter order
%        'StopbandFrequency1',low, ...    % Frequency constraints
%        'StopbandFrequency2',high, ...       
%        'SampleRate',sFreq);             % Sample rate
%    fvtool(d)
   %%
% %    
%    d = designfilt('bandpassiir', ...       % Response type
%        'StopbandFrequency1',low, ...    % Frequency constraints
%        'PassbandFrequency1',low+50, ...
%        'PassbandFrequency2',high-50, ...
%        'StopbandFrequency2',high, ...
%        'StopbandAttenuation1',40, ...   % Magnitude constraints
%        'PassbandRipple',1, ...
%        'StopbandAttenuation2',50, ...
%        'DesignMethod','butter', ...      % Design method
%        'MatchExactly','passband', ...   % Design method options
%        'SampleRate',sFreq);               % Sample rate
%    
%       fvtool(d)

   %%
   data = double(data);
   filtered_data = filtfilt(d,a,data);
   
   
   
   
   
   