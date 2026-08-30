function STA_matrix = SpikeTriggeredAverage(Spike_times_ms, Signal_data_ms, Pre_time_ms, Post_time_ms, sRate_signal_data)

if nargin<3
    Pre_time_ms = 5000;
end
if nargin < 4
    Post_time_ms = 5000;
end
if nargin < 5
    sRate_signal_data = 5;
end

%%

signal_data_times = Signal_data_ms(:,1);
signal_data = Signal_data_ms(:,2);


for iS = 1:length(Spike_times_ms)
    
    DA_ix = find(signal_data_times>Spike_times_ms(iS)-Pre_time_ms & signal_data_times < Spike_times_ms(iS)+Post_time_ms);
    sig_data = signal_data(DA_ix);
    
    ldv = (Pre_time_ms+Post_time_ms)/(1000/sRate_signal_data);
    if isempty(DA_ix)
        continue
    else
        if length(sig_data)<ldv
           sig_data = nan_fill(sig_data,ldv);
        end
        STA_matrix(iS,1:ldv) = sig_data;
    end
end

STA = nanmean(STA_matrix);
sdSTA = std(STA_matrix);

xax = (1:200:ldv*200)-Pre_time_ms;

% figure
% plot_error_lines(STA_matrix,xax);

% %%
% clearvars -except PD
% Pre_time_ms = 5000;
% Post_time_ms = 5000;
% sRate_signal_data = 5;
% stm = PD.VTA_cluster.ampD_17_CI.TimeInSec
% Spike_times_ms = stm*1000;
% IT = PD.IT
% fe = PD.first_event_intan_time;
% 
% sd_vec = 1:200:(length(IT)*200);
% signal_data_times = sd_vec+fe-5000;
%     
% 
% Signal_data_ms(:,2) = IT
% Signal_data_ms(:,1) = signal_data_times
% 
