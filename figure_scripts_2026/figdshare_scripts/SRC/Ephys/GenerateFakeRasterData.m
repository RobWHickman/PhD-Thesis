clear;ca;%rng(1);

freq = 5;
ev_freq = 8;
max_freq = ev_freq*2.5;

max_time_ms = 600000;

ev_dur = 200;
IEI = 5000;
num_events = 100;

ev_vec = [randi(100):5000:max_time_ms];
jit = randi(500,1,length(ev_vec));
ev_vec_jit = sort(ev_vec+jit);

ev = ev_vec_jit(sort(randperm(length(ev_vec_jit),num_events)));
st = sort(randperm(max_time_ms,max_time_ms/(1000/freq)));%make random spike times
% ev = sort(randperm(max_time_ms-5000,num_events)+2000); %make random events with 2 sec buffer in front and 3 sec on the back

for i=1:num_events
    extra_spikes = sort(randperm(ev_dur,ev_freq-freq))+ev(i);
    st = [st,extra_spikes];
end
st=sort(st);

st=st(~(diff(st)<(1000/max_freq)));
%
pre = 2000;
post = 3000;
bn = 1;
wn=80;
[rst,bc] = TrialRaster(st,ev,pre,post,bn);
rst(rst>1)=1;
xax = bc;

figure
subplot(7,1,1:5)
PlotTrueRaster(rst)
xticklabels([])
subplot(7,1,6:7)
% plot(xax,smoothdata(mean(rst),'movmean',wn/bn)/bn*1000)
plot(mean(rst)/bn*1000)