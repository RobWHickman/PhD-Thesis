function [avg_waveform,spike_duration] = SpikeWidth(spike_times,raw_data,sample_frequency)

%% Get waveform and spike width

sf_ms = sample_frequency/1000;

prespk = 2;
postspk = 5.5;
spkix = round(spike_times*sf_ms);
inc=1;imp=[];imps=[];

if numel(spkix)>10000
    inc = 100;
end
for iS = 2:inc:length(spkix)-1
    imp = raw_data(spkix(iS)-round(prespk*22):spkix(iS)+(postspk*sf_ms));
    imps(iS,:)=imp;
end

imps = smoothdata(imps,2,'gaussian',7);

mimps = mean(nanmean(imps(:,1:(prespk*sf_ms))));
simps = std(nanmean(imps(:,1:(prespk*sf_ms))));
up =0;smult=3;
while up < sf_ms*1
    up = find(nanmean(imps)>mimps+(simps*smult),1,'first')-1;
    smult=smult+1;
end
dwn=0;smult=3;
while dwn < sf_ms*1
    dwn = find(nanmean(imps)<mimps-(simps*smult),1,'first')-1;
    smult=smult+1;
end
strt = ((min(up,dwn))/sf_ms)-prespk;
if isempty(strt)
    strt = -3;
end

up =0;dwn=0;smult=3;
fimps = fliplr(imps);
mfimps = mean(nanmean(fimps(:,1:((2)*sf_ms))));
sfimps = std(nanmean(fimps(:,1:((2)*sf_ms))));
% dwn = find(nanmean(fimps)<mfimps-(sfimps*8),1,'first')-1;
while up < sf_ms*1.5
    up = find(nanmean(fimps)>mfimps+(sfimps*smult),1,'first')-1;
    smult=smult+1;
end
stp = postspk-((min(up)-6)/sf_ms);
spkdur = stp-strt;

%%
if 1%spkdur>3.5 || spkdur<1  || strt==-3     
    disp('Bad spike dur');
    figure;
    plot(((1:length(imps(1,:)))/22)-prespk,nanmean(imps));
    hold on
    g=gca;
    line([strt strt],g.YLim);
    line([stp stp],g.YLim);
    title(stp-strt);
    uiSW = ginput(2);
    strt = uiSW(1,1);
    stp = uiSW(2,1);
    ca
end

spkdur = stp-strt;

avg_waveform = nanmean(imps(:,(strt+prespk)*22:(stp+prespk)*22));
spike_duration = stp-strt;

