function [response,resp_verbose,cvu,cvd] = Shuffle_PETH(spike_times_ms,alignments,pre,post,bin_ms,plot_it)
if nargin < 6
    plot_it =0;
end

numshuf = 500;
zs=0;
for iTx = 1:length(alignments)
    aligned_spikes_tmp = spike_times_ms>alignments(iTx)-pre & spike_times_ms<alignments(iTx)+post;
    ast = spike_times_ms(aligned_spikes_tmp)-(alignments(iTx)-pre); %this aligns the spike times so that 0 is now [wind] milliseconds before the transient time
    edges = 0:bin_ms:(pre+post)+1;
    binned_spikes(iTx,:) = histcounts(ast,edges);
end
bs = binned_spikes;
bsFR = nanmean(bs)/bin_ms*1000;
smthbsFR = smoothdata(bsFR,'gaussian',5);
% sbs_shuf = zeros(numshuf,(pre+post)/bin_ms);
for iShuf = 1:numshuf
    shuffled_alignments = Shuffle_Event_Times(alignments);
    for iTx = 1:length(shuffled_alignments)
        aligned_spikes_tmp = spike_times_ms>shuffled_alignments(iTx)-pre &...
            spike_times_ms<shuffled_alignments(iTx)+post;
        ast = spike_times_ms(aligned_spikes_tmp)-(shuffled_alignments(iTx)-pre); %this aligns the spike times so that 0 is now [wind] milliseconds before the transient time
        edges = 0:bin_ms:(pre+post)+1;
        binned_spikes_shuf(iTx,:) = histcounts(ast,edges);
        bss_FR(iTx,:) = binned_spikes_shuf(iTx,:)/bin_ms*1000;
    end
    
    sbss_FR = smoothdata(bss_FR,2,'gaussian',5);

    bs_shuf = binned_spikes_shuf;
    
%     sbs_shuf(iShuf,:) = sum(bs_shuf);
    
    mFR(iShuf,:) = nanmean(sbss_FR);
    ciFR(iShuf,:) = ci(sbss_FR);
end
msbsFR = nanmean(mFR);
ebFR = nanmean(ciFR);

mci = nanmean(msbsFR);
msig = nanmean(smthbsFR);
dm = diff([mci,msig]);
mean_adjusted_sig = smthbsFR-dm;

[~,pix] = findpeaks(mean_adjusted_sig,'MinPeakProminence',2);
[~,tix] = findpeaks(mean_adjusted_sig*-1,'MinPeakProminence',2);

if plot_it
    xax = (-pre:bin_ms:post)+(bin_ms*.5);
    xaxt = (0:bin_ms:(pre+post))-(pre);
    
    plot(xax,msbsFR,'color','k')
    hold on
    plot(xax,msbsFR+(ebFR),'color',[.7 .7 .7])
    hold on
    plot(xax,msbsFR-(ebFR),'color',[.7 .7 .7])
    hold on
    plot(xax,mean_adjusted_sig,'color',lines(1))
    hold on
    plot(xax(pix),mean_adjusted_sig(pix),'LineStyle','none','Marker','o','MarkerEdgeColor','r')
    hold on
    plot(xax(tix),mean_adjusted_sig(tix),'LineStyle','none','Marker','o','MarkerEdgeColor','b')
    
    xlim([xaxt(1) xaxt(end)])
    x0 = mod(xaxt,500);
    x0ix = find(x0==0);
    xticks(xaxt(x0ix));
    xticklabels(xaxt(x0ix));
    xlabel('Time (ms)')
    
    ylabel('Count (spikes/bin)')
    g = gca();
    line([0 0], [g.YLim],'LineStyle',':','color','r');
    
    pubify_figure_axis_robust
end

ups = find(mean_adjusted_sig>(msbsFR+(ebFR)));
dwns = find(mean_adjusted_sig<(msbsFR-(ebFR)));

cvu = Consecutive_Values(ups,'max');
cvd = Consecutive_Values(dwns,'max');

% sigix = find(sbs>msbs+eb*2);
sigvals_up = bsFR(ups)-msbsFR(ups);
sigvals_dwn = bsFR(dwns)-msbsFR(dwns);

auc_sigvals_ups = trapz(sigvals_up);
auc_sigvals_dwns = trapz(sigvals_dwn);

if length(ups)>1 && length(dwns)>1
    response = 2;
    resp_verbose = 'Upper and downer';
elseif length(ups)>1 && length(dwns)<1
    response = 1;
    resp_verbose = 'Upper';
elseif length(ups)<1 && length(dwns)>1
    response = -1;
    resp_verbose = 'Downer';
else
    response = 0;
    resp_verbose = 'No reponse';
end


shuf_pth = bsFR;