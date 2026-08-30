
sFreq = 22000;
load('D:\Dropbox\Schultz_Lab\Uly_Data\20190905_M75\w075-0002.mat')
wvmf = load('D:\Dropbox\Schultz_Lab\Uly_Data\20190905_M75\w075-0002-04-wavemark.mat');
wf = fields(wvmf);
wvm = wvmf.(wf{1});
uniq_codes = unique([wvm.codes]);
uniq_codes = uniq_codes(uniq_codes~=0);% 0 should always be noise
cix = [wvm.codes(:,1)]==uniq_codes(1);
spks = wvm.times(cix,:)*1000;

cix2 = [wvm.codes(:,1)]==uniq_codes(2);
spks2 = wvm.times(cix2,:)*1000;

RADdur = 'D:\Dropbox\Schultz_Lab\Uly_Data\20190905_M75\r075-0002.radDURATION';
trial_durations_ms = GETTYANALYSIS_Get_RAD_Trial_Durations(RADdur,sFreq);
trial_durations_ms_0 = [0;cumsum(trial_durations_ms)];

bincells = {savefile.trial.neuron};
% bc.bindata = bincells;
bcspks = [];
for i=2:length(bincells)
    lbc = length(bcspks);
    tmpspks = bincells{i-1}+trial_durations_ms_0(i-1);
    bcspks(lbc+1:lbc+length(tmpspks)) = tmpspks;
    
    rtspks_tmp = spks(spks>trial_durations_ms_0(i-1)&spks<trial_durations_ms_0(i));
    
end

%%

xax = 1:trial_durations_ms_0(end);
bcr = round(bcspks);
t1 = 20*60*1000;
t2 = 25*60*1000;


figure
line([bcr(bcr>t1&bcr<t2)' bcr(bcr>t1&bcr<t2)'],[0 1],'color','b');
hold on
line([spks(spks>t1&spks<t2) spks(spks>t1&spks<t2)],[1 2],'color','r');
% hold on
% line([spks2(spks2>t1&spks2<t2) spks2(spks2>t1&spks2<t2)],[1 2],'color','g');
% [x,y] = ginput(2);
% diff(x)
