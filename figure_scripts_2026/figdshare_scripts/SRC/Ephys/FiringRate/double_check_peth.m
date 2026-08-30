

wind = 5000;
bin_ms = 50;
edges = 0:bin_ms:max(time);
Y = histcounts(spike_times_ms,edges);

for iTx = 1:length(Tx_Times)
    if Tx_Times(iTx)-wind>0 && Tx_Times(iTx)+wind<max(edges)
        r(iTx,:) = Y(find(edges>(round(Tx_Times(iTx))-wind),1,'first'):find(edges>(round(Tx_Times(iTx))+wind),1,'first'));
    end
end

sr = sum(r);

xax = (1:length(sr))*50;
xchnk = wind/bin_ms/2;
figure
subplot(6,1,1:5)
imagesc(r)
colormap('gray')
xticks([])
subplot(6,1,6)
bar(xax,sr,'FaceColor','k','EdgeColor','k')
xticks(xax(1:xchnk:end)-50)
xt = xax(1:xchnk:end)-wind-50;
for ixt = 1:length(xt)
    xtck{ixt} = num2str(xt(ixt));
end
xticklabels(xtck)
