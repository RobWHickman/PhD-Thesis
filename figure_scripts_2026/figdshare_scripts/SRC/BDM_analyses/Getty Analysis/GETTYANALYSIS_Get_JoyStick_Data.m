function GETTYANALYSIS_Get_JoyStick_Data(path_and_file_getty_data)

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
dsf = 100; %freq to downsample to in Hz
% dsd = downsample(sd,sFreq/dsf);
ds = downsample(yf,sFreq/dsf);
dsd = smoothdata(ds,'gaussian',10);
%%%%%%%%%%%% velocity %%%%%%%%%%%%%%%%%%%%%%%%%%%
v = diff(dsd)./diff((1:length(dsd))'/dsf);
v_sfreq = interp1((1:length(v))'/dsf,v,(1:length(y))/sFreq);
%%%%%%%%%%%% acceleration %%%%%%%%%%%%%%%%%%%%%%
a = diff(v)./diff((1:length(v))'/dsf);
a_sfreq = interp1((1:length(a))'/dsf,a,(1:length(y))/sFreq);

%%

RADdur = [pth,'r',fl(2:end-4),'.radDURATION'];
trial_durations_ms = GETTYANALYSIS_Get_RAD_Trial_Durations(RADdur,sFreq);
trial_durations_ms_0 = [0;cumsum(trial_durations_ms)];

%         nsix = FindNonStationarities(round(spks),trial_durations_ms_0(end));
for iT = FRix:length(trial_durations_ms_0)-2 % -2 because the last trial wont have monkey bid addvals (-1) and because trial_durations is 0 indexed (time)(also -1)
    %% Trial start bid position
    if ~isempty(savefile.trial(iT).bit(14).upat)
        continue
    end
    
    start_position = savefile.trial(iT).addvals(11);
    end_position = savefile.trial(iT+1).addvals(18);
    
    ca
    bd_s = double(savefile.trial(iT).bit(4).upat)+trial_durations_ms_0(iT);%bit(4) is bid start
    if isempty(bd_s)
        bd_s = 1212; %% this was determined empirically from data where the bit was there. Should be accurate to +/-20 ms.
    end
        
    bd_e = double(savefile.trial(iT).bit(5).upat)+trial_durations_ms_0(iT);%bit(5) is bid stable
       
    if isempty(bd_e)
        %There is no end time. Rob must have goofed becuase this should
        %never be the case. This trial should have been an error.
        warning(sprintf('There was no bit for BidStable. This should have been an error trial. Trial No.: %g',iT));
        continue
    end
    
    % %     bid_start = double(savefile.trial(iT-1).addvals(11)); %% was thinking about puting these measurements in units of 'bid space' but I can't figure out how to do it...
    
    bd_s_ix_sf = round(bd_s*22); %sample freq index
    bd_e_ix_sf = round(bd_e*22);
    
    bd_s_ix_dsf = round(bd_s*22/sFreq*dsf); %down-sampled freq index
    bd_e_ix_dsf = round(bd_e*22/sFreq*dsf);
    
    yf_dcoff = yf(bd_s_ix_sf:bd_e_ix_sf)-yf(bd_s_ix_sf);
    %     y_dcoff = y(bd_s_ix_sf:bd_e_ix_sf)-y(bd_s_ix_sf);
    
    v_sftr =     v_sfreq(bd_s_ix_sf:bd_e_ix_sf);% velocity for trial iT in sFreq
    a_sftr =     a_sfreq(bd_s_ix_sf:bd_e_ix_sf);% acceleration for trial iT in sFreq
    
    v_tr =     v(bd_s_ix_dsf:bd_e_ix_dsf);% velocity for trial iT in sFreq
    a_tr =     a(bd_s_ix_dsf:bd_e_ix_dsf);% acceleration for trial iT in sFreq
    
    
    v_av = mean(abs(v_tr));
    a_av = mean(abs(a_tr));
    
    tr_displacement = yf_dcoff;
    
    norm_dis = MinMaxFS(tr_displacement);
    rect_tr_displacement = abs(tr_displacement);
    norm_rect_tr_displacement = MinMaxFS(rect_tr_displacement);
    znd = norm_dis-norm_dis(1);
    
    max_position = max(tr_displacement);
    min_position = min(tr_displacement);
    
    negative_absement = trapz(znd(znd<0));
    positive_absement = trapz(znd(znd>0));
    total_absement = trapz(znd);
    total_rectified_absement = trapz(abs(znd));
    
%     figure
%     plot(znd)
%     title(sprintf('start:%d end:%d absement:%d',start_position,end_position,total_absement))
    
    %% find lever-move change points.
    
    dsd_tr = dsd(bd_s_ix_dsf:bd_e_ix_dsf);
    %     dsd_tr_dcoff = dsd_tr-dsd_tr(1);
    dsd_tr_fs = MinMaxFS(dsd_tr);
    dsd_tr_dcoff = dsd_tr_fs-dsd_tr_fs(1);
    thrsh = std([dsd_tr_dcoff(1:20);dsd_tr_dcoff(end-10:end)])*3;
    %     thrsh = std(dsd_tr_dcoff)*.25;
    
    above_thrsh = dsd_tr_dcoff>thrsh;
    below_thrsh = dsd_tr_dcoff<thrsh*-1;
    
    thrsh_crossings = diff(above_thrsh)|diff(below_thrsh);
    
    thrsh_crossings_sf = (find(thrsh_crossings))*(sFreq/dsf);% -2 becuase the downsampling removes 1100 points from beginning and
    
    %     [~,pks] = findpeaks(MinMaxFS(dsd_tr),'MinPeakProminence',.25);
    %     [~,trghs] = findpeaks(MinMaxFS(dsd_tr.*-1),'MinPeakProminence',.25);
    ThCrix = [];
    ThCrix = find(thrsh_crossings);
    
    if isempty(ThCrix)
        thrsh = std(dsd_tr_dcoff(1:20))*10;
        above_thrsh = dsd_tr_dcoff>thrsh;
        below_thrsh = dsd_tr_dcoff<thrsh*-1;
        thrsh_crossings = diff(above_thrsh)|diff(below_thrsh);
        ThCrix = [];
        ThCrix = find(thrsh_crossings);
    end
    
    while sum(diff(ThCrix)<=10)>0
        badix = [0;(diff(ThCrix)<=10)];
        fb = find(badix);
        rm =fb(1);
        ThCrix(rm)=[];
    end

    if isempty(ThCrix)
        warning('No infelctions found; this trial likely should have been an error');
        ThCrix = find(ischange(dsd_tr_dcoff));
        continue
    end
           
    if length(thrsh_crossings)- ThCrix(end)<=10
        ThCrix(end)=[];
    end
      
    sb = 10;
    sa = 10;
    InflectionPoints =[];
    for iTc = 1:length(ThCrix)
        %         dtc = diff(dsd_tr_dcoff(tcix(iT)-5:tcix(iT))); %diff of thrsh crossings
        le  = length(dsd_tr_dcoff);
        
        if ThCrix(iTc)-sb < 1
            sb = ThCrix(iTc)-1;
        elseif ThCrix(iTc)+sa > le
            sa = le-ThCrix(iTc);
        end
        
        tc = dsd_tr_dcoff(ThCrix(iTc)-sb:ThCrix(iTc)+sa); % five points preceding and following thrsh crossing
        
        ftc = flip(tc);
        
        if iTc==1
            chng = ischange(tc,'variance');
            tcix = find(chng,1,'first');
        else
            chng = ischange(tc,'variance','MaxNumChanges',1);
            tcix = find(chng);
            
        end
        if isempty(tcix)
            if ftc(1)>0
                %                 scix = find(ftc<0,1,'first'); %sign change index
                [mn,scix] = min(ftc); %sign change index
                if iTc~=1 && mn < dsd_tr_dcoff(ThCrix(iTc-1))
                    scix = find(ftc<0,1,'first');
                end
            else
                %                 scix = find(ftc>0,1,'first');
                [mx,scix] = max(ftc);
                if iTc~=1 && mx > dsd_tr_dcoff(ThCrix(iTc-1))
                    scix = find(ftc>0,1,'first');
                end
            end
            lftc = length(ftc);
            tcix = lftc-scix;
        end
        
        nThCrix = ThCrix(iTc)-sb+tcix+1;% add sb to get to the end of the
        % sequence where inflection was found; subtract the index of the
        % inflection; add 1 because we want the ix mmediately after
        
        if isempty(nThCrix) || nThCrix>length(dsd_tr_dcoff)-10
            continue
        end
        
        if iTc>1 && length(InflectionPoints)>1 && nThCrix < InflectionPoints(end-1)+10
            cix = find(ischange(dsd_tr_dcoff(ThCrix(iTc):end),'MaxNumChanges',1));
            nThCrix = ThCrix(iTc)+cix;
            if nThCrix>length(dsd_tr_dcoff)-10
                continue
            end
        end
        
        InflectionPoints(iTc) = nThCrix;
        
    end
    if length(InflectionPoints)<2
        nip = find(ischange(dsd_tr_dcoff(InflectionPoints(1)+1:end),'MaxNumChanges',1));
        if isempty(nip)
            nip = dsd_tr_dcoff(end-1);
        end
        InflectionPoints(2)=nip+InflectionPoints(1)+1;
    end
    badix = find(diff(InflectionPoints)<20);
    InflectionPoints(badix+1)=[];
    
    IP = [];
    IP(:,1) = InflectionPoints;
    
% %     
%     figure
%     plot(dsd_tr_dcoff)
%     g = gca;
%     hold on
%     line([find(thrsh_crossings) find(thrsh_crossings)],[0 g.YLim(2)],'color','b')
%     hold on
%     line([IP IP],[g.YLim(1) 0],'color','r')
%     hold on
%     line([0 50],[0 0],'color','k')



    %%
        lever.start_position = start_position;
        lever.end_position = end_position;
    
        lever.velocity = v_sftr;
        lever.avg_velocity = v_av;
    
        lever.acceleration = a_sftr;
        lever.avg_acceleration = a_av;
    
        lever.max_position = max_position;
        lever.min_position = min_position;
    
        lever.negative_absement = negative_absement;
        lever.positive_absement = positive_absement;
        lever.total_absement = total_absement;
        lever.total_rectified_absement = total_rectified_absement;
    
        lever.reaction_time_s = (IP(1))/dsf;%epoch defined by bid_start:bid_end IP(1) and the ix of rxn time
        lever.total_movement_time_s = (length(dsd_tr_dcoff)-IP(1))/dsf;%the end of the epoch is bid_stable when movement stops--I need to double check how Rob did this
    
        savefile.trial(iT).lever=lever;
        
end

ca
% save([pth,fl],'savefile');
end








