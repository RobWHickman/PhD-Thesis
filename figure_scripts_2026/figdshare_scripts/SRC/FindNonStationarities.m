function NSix = FindNonStationarities(spike_times_ms,max_time_ms)
% spike_times_ms = round(spike_times_ms);
[p,NS] = DetectNonStationarities(spike_times_ms,max_time_ms);

if p>0.05
    figure
    fr = Firing_Rate(round(spike_times_ms),1000);
    plot(fr)
    warndlg('Are you sure there are non-stationarities?')
end
%%
kernel_size=5000;
sdf = SpikeDensityFunction(spike_times_ms,kernel_size,max_time_ms);


ipt = findchangepts(sdf);


ms = nanmean(sdf(1:ipt));
me = nanmean(sdf(ipt:end));

if ms>me
    NSix = [ipt,max_time_ms];
else
    NSix = [1,ipt];
end

figure
findchangepts(sdf)
hold on
line([NSix(1) NSix(1)],[0 0.01],'color','r')
line([NSix(end) NSix(end)],[0 0.01],'color','r')


answ = questdlg('Remove non-stationary data?', ...
	'', ...
	'Yes','No','Score manually','Yes');
if strcmp(answ,'No')
    NSix = [];
elseif strcmp(answ,'Score manually')
    [x,~] = ginput(1);
    ms = nanmean(sdf(1:x));
    me = nanmean(sdf(x:end));
    if ms>me
        NSix = [x,max_time_ms];
    else
        NSix = [1,x];
    end    
end


ca
% 
% trunc = kernel_size*3;%round(length(sdf)*.05); %this cuts off 3% of the data at either end to avoid the roll off of the sdf
% badix = find(sdf(trunc:end-trunc) < mean(sdf(sdf>0))-(1.5*std(sdf)));% 1.25 determinded empirically. May not work for everything
% aNSix = badix;
% if isempty(aNSix)
%     NSix = [0,0];
% else
%     if max_time_ms-(trunc*3) < aNSix(end)
%     NSix = [aNSix(1),aNSix(end)];
% end
% 
% figure
% plot(sdf)
% hold on
% line([NSix(1) NSix(1)],[0 0.01],'color','r')
% line([NSix(end) NSix(end)],[0 0.01],'color','r')
% [x,~] = ginput(2)
% 
% diff(x)

% disp('n');