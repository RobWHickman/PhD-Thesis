function [p,h,pre_FR,post_FR]= Compare_Firing_Rate_Single_Event(spike_times,event,bin,pre,post)


disp('stop')


pre_ix = find(spike_times>event-pre&spike_times<event);
post_ix = find(spike_times>event&spike_times<event+post);

pre_spks = spike_times(pre_ix);
post_spks = spike_times(post_ix);

for iShf =1:1000
    pre_shf(iShf,:) =Shuffle_Spike_Times(pre_spks);
end 



tot_time = pre+post;
edges= 0:bin:tot_time;
bnd_spks =histcounts(spike_times,edges);
bnd_times = bin:bin:tot_time;

plot(bnd_times,bnd_spks)
hold on
line([event event],[0 max(bnd_spks)],'color','r')

pre_ix = find(bnd_times>event-pre&bnd_times<event);
post_ix = find(bnd_times>event&bnd_times<event+post);

R1 = bnd_spks(pre_ix);
R2 = bnd_spks(post_ix);

medR1 = nanmean(R1);
medR2 = nanmean(R2);

R1(end+length(R2)-length(R1))=nan
Plot_Mean_SEM_All_Points([R1;R2])

median



