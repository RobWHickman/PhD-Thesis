ca
clear

num_trans = 20; % this produces a nice clean STA
% num_trans = 60; % this produces an STA that looks like it dips substantially before increasing
total_time_sec = 60;
pre = 5000;
post = 5000;

for iS = 1:500 % run 500 fake STAs 
    
    x = rand(1,300);
%     rn =randi(300,num_trans);
%     rn = 1:300/num_trans:300;
rn = round(300/num_trans);
for iN = 2:num_trans
    int = randi([round(300/num_trans)-(round(300/num_trans/3)) round(300/num_trans)]);  % this is probably not the best way to do this but it generates a somewhat evenly-spaced transients that look kinda like our DA data
    rn(iN) = rn(iN-1)+int(1);
end
    ixs = rn(1,:);
    s = zeros(1,total_time_sec*1000);
    
    for i = 1:num_trans
        y = exp(rand(3,1))*randi(5);
        x(ixs(i):ixs(i)+2) = y;        
        s((ixs(i)*200)-randi(500):randi([500]):(ixs(i)*200)) = 1; %this assumes the spikes precede the transient by somewhere between 1 and 500 ms; 500 was chosen arbitrarily
    end
    x = x(1:300);
    xax = [1*200:200:300*200];

%
    sig = [xax;x]';
    spks = find(s==1);
    % figure
    sta = SpikeTriggeredAverage(spks,sig,pre,post);
    
    STA_all(iS,:) = nanmean(sta);
end
figure
subplot(5,1,1:4)
imagesc(STA_all)
xticklabels('');
subplot(5,1,5)
ax = (1:length(STA_all(1,:))).*200-pre;
plot(ax,nanmean(STA_all))
xlabel('Time (ms)')
FigureTitle('500 fake STAs and average with 20 transients over 60 seconds')
% FigureTitle('500 fake STAs and average with 60 transients over 60 seconds')

figure
plot(xax,x)
hold on
line([find(s==1)' find(s==1)'],[0 1])
xlabel('Time (ms)')
title('Example trace of DA and spikes')
tilefigs
