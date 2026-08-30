function [LV1,LV2,LVc,LVshf,p] = Compare_peri_event_LV(spike_times_ms,alignment1,alignment2,bin_ms,windw_s,stat_test)

if nargin < 6; stat_test = 'Wilcoxan'; end
if nargin < 5; windw_s = 2; end
if nargin < 4; bin_ms = 500; end
if nargin < 3; error('No alignment times'); end
%%
windw_ms = 1000*(windw_s);
pre = windw_ms/2;
post = windw_ms/2;

for iS = 1:500
    shf = Shuffle_Event_Times(alignment1);
    for iShf = 1:length(shf)
        lvs_ix1 = find(spike_times_ms>shf(iShf)-pre&spike_times_ms<shf(iShf)+post);
        isiShf = diff(spike_times_ms(lvs_ix1));
        LVs(iS,iShf) = LocalVariance(isiShf);
    end
end

LVshf = nanmean(LVs);
ciLVs = ci(LVs);
    

alignmentc = [alignment2+4000,alignment2+2000,alignment1-4000,alignment1-2000];

%%
for iA = 1:length(alignment1)
    lv_ix1 = find(spike_times_ms>alignment1(iA)-pre&spike_times_ms<alignment1(iA)+post);
    lv_ix2 = find(spike_times_ms>alignment2(iA)-pre&spike_times_ms<alignment2(iA)+post);
    for iC = 1:length(alignmentc(1,:))
        lv_ixc = find(spike_times_ms>alignmentc(iA,iC)-pre&spike_times_ms<alignmentc(iA,iC)+post);
        isic = diff(spike_times_ms(lv_ixc));
        LVc4(iC,iA) = LocalVariance(isic);
    end
    isi1 = diff(spike_times_ms(lv_ix1));
    isi2 = diff(spike_times_ms(lv_ix2));
    LV1(iA) = LocalVariance(isi1);
    LV2(iA) = LocalVariance(isi2);
end
LVc = nanmean(LVc4);


[p,~] = signrank(LV1,LV2);


disp('nope')

% Imagesc_for_rast(burst_rast)