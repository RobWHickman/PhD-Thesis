function [y_trial] = GETTYANALYSIS_Get_JoyStick_Data_YmovementOnly(path_and_file_getty_data)

if nargin < 1
    [fl,pth] = uigetfile('D:\Dropbox\Schultz_Lab\Uly_Data\*.mat');
    path_and_file_getty_data = [pth,fl];
else
    [pth,fil,ext]=fileparts(path_and_file_getty_data);
    fl = [fil,ext];
    pth = [pth,'\'];
end

gd = load(path_and_file_getty_data);
f = fields(gd);
savefile = gd.(f{1});

%%
jsf{1} = ['r',fl(2:9),'-01.rad'];
jsf{2} = ['r',fl(2:9),'-02.rad'];
jsf{3} = ['r',fl(2:9),'-03.rad'];

for ij = 1:3
    Do = fopen([pth,jsf{ij}],'r');
    d = fread(Do,inf,'int16');
    % D = fread(Do,inf,'int16');
    D{ij} = int16(d);
    fclose(Do);
    
    Dnh = D{ij}(10000:end); %everything up to 10000 is header
    sFreq = typecast(D{ij}(40:43),'double');    
end


%% find last FR trial
FRix = find([savefile.trial.situation]~=4,1,'first');
% sumdur = sum([savefile.trial(FRix-1).duration]);

%% %%%%%%%% Lowpass Filter data %%%%%%%%%%%%%%%%%%
y=double(D{1});% lever y should always be on the first channel
yf = lowpass(y,200,sFreq);
%%%%%%%%%%%% smooth data %%%%%%%%%%%%%%%%%%%%%%%%
% sd = smoothdata(yf,'gaussian',20);
%%%%%%%%%%%% downsample %%%%%%%%%%%%%%%%%%%%%%%%%
dsf = 100; %freq to downsample to in Hz. Set to 'sFreq' to bypass.
% dsd = downsample(sd,sFreq/dsf);
ds = downsample(yf,sFreq/dsf);
dsd = smoothdata(ds,'gaussian',10);
%%%%%%%%%%%% velocity %%%%%%%%%%%%%%%%%%%%%%%%%%%
% v = diff(dsd)./diff((1:length(dsd))'/dsf);
% v_sfreq = interp1((1:length(v))'/dsf,v,(1:length(y))/sFreq);
% %%%%%%%%%%%% acceleration %%%%%%%%%%%%%%%%%%%%%%
% a = diff(v)./diff((1:length(v))'/dsf);
% a_sfreq = interp1((1:length(a))'/dsf,a,(1:length(y))/sFreq);

%%

RADdur = [pth,'r',fl(2:end-4),'.radDURATION'];
trial_durations_ms = GETTYANALYSIS_Get_RAD_Trial_Durations(RADdur,sFreq);
trial_durations_ms_0 = [0;cumsum(trial_durations_ms)];

%         nsix = FindNonStationarities(round(spks),trial_durations_ms_0(end));
y_trial = nan(length(trial_durations_ms_0)-2,round((max(trial_durations_ms)+1)/(1000/dsf)));
for iT = FRix:length(trial_durations_ms_0)-1 % -2 because the last trial wont have monkey bid addvals (-1) and because trial_durations is 0 indexed (time)(also -1)
    ix = (round(trial_durations_ms_0(iT)./(1000/dsf)):round(trial_durations_ms_0(iT+1)./(1000/dsf)));
    y_trial(iT,1:numel(ix)) = dsd(ix+1);
end


%%
% figure
% for i = 1:length(y_trial(:,1))
%     plot(y_trial(i,:)+(i*75))
% %     frc = savefile.trial(i).bit(3).upat;
% %     line([frc/(1000/dsf) frc/(1000/dsf)],[y_trial(i,1)-100+(i*75) y_trial(i,1)+100+(i*75)])
% %     strt = savefile.trial(i).bit(1).upat;
% %     line([strt/(1000/dsf) strt/(1000/dsf)],[y_trial(i,1)-100+(i*75) y_trial(i,1)+100+(i*75)])
% %     fix = savefile.trial(i).bit(2).upat;
% %     line([fix/(1000/dsf) fix/(1000/dsf)],[y_trial(i,1)-100+(i*75) y_trial(i,1)+100+(i*75)])
%     hold on
% end
% 
% figure
% imagesc(y_trial)
% colormap('jet')
% ca
end






