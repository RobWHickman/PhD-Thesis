function [shuffled_times] = Shuffle_Spike_Times(spike_times)

if isempty(spike_times)
    shuffled_times = [];
else
    ISI = diff(spike_times);
    
    [m,~] = size(ISI) ;
    idx = randperm(m) ;
    b = ISI ;
    b(idx) = ISI;
    first_time = spike_times(1);
    shuffled_times = [first_time; first_time+cumsum(b)];
end