m = zeros(200,16000);
mc = zeros(200,16000);
x = 1:16000;
figure
for i = 1:200 
    st = savefile.trial(i).neuron;
    stc = round(savefile.trial(i).Clust1_SpikeTimesMs);
    stc2 = round(savefile.trial(i).Clust3_SpikeTimesMs);

    m(i,st)=1;
    mc(i,stc)=1;
    mc(i,stc2)=1;

    mtr = m(i,:)+i-.1;
    mtr(m(i,:)==0)=nan;
    mctr = mc(i,:)+i;
    mctr(mc(i,:)==0)=nan;

    plot(x,mtr,'bo')
    hold on
    plot(x,mctr,'ro')
end
