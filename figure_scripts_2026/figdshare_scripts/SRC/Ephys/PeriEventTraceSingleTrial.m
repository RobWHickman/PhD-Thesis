function [Aligned_Trace,bin_centers] = PeriEventTraceSingleTrial(trace,alignment_ms,pre,post,sample_freq)

al_sfreq = alignment_ms/(1000/sample_freq);
pre_sfreq = pre/(1000/sample_freq);
post_sfreq = post/(1000/sample_freq);
trace_time = 1:length(trace); %in same units as sample_freq
ix1 = trace_time>al_sfreq-pre_sfreq & trace_time<al_sfreq; 
ix2 = trace_time>al_sfreq & trace_time<al_sfreq+post_sfreq;
% alix = find(ix>0&ix<numel(trace));
% ix = ix(ix>0&ix<numel(trace));


Aligned_Trace = nan(1,pre_sfreq+post_sfreq);
Aligned_Trace(pre_sfreq-sum(ix1)+1:pre_sfreq) = trace(ix1);
Aligned_Trace(pre_sfreq+1:pre_sfreq+sum(ix2)) = trace(ix2);

bin_centers = (-pre_sfreq:post_sfreq-1)+.5;