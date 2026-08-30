function [AmpRatio_and_HalfWidth_ms] = AmplitudeRatio_HalfWidth_Cluster_Analysis(Cluster_struct,region,sFreq)

if nargin < 1
    warning('No cluster data, please load the CI files')
    mydir = uigetdir('F:\DANA_Acute\DAN_WORKING','Where is the directory with the CI files?');
    [Cluster_struct] = DANA_Load_CI_Struct('VTA',mydir,1);
end
if nargin < 2
    reg = inputdlg('What region are these data from? (e.g., VTA)','Region',1,{'VTA'});
    region = reg{1};
end
if nargin < 3
    sFreq = 30000;
    warning(['Sampling frequency hard-coded: ',num2str(sFreq)]);
end
savefiles = 1;
if ~savefiles
    warning('The file was not saved because you have turned off file saving')
end
SpikeDir = pwd;
dirstr = fullfile(pwd);

%% find the amp_hw file and cd to that folder
parent_ix = strfind(dirstr,'WORKING');
slashes = length(strfind(dirstr(parent_ix:end),'\'));
updir    = cell(1, slashes);
updir(:) = {'..\'};
Amp_HW_dir = [updir{1:slashes},'AmpRatio_and_HalfWidth'];
cd(Amp_HW_dir)

load('AmpRatio_and_HalfWidth_ms.mat') 
if ~exist('AmpRatio_and_HalfWidth_ms.mat','file')
    error('There is no AmAmpRatio_and_HalfWidth_ms.mat file...you fucked up royally...')
end

%%
rix = strfind(dirstr,'_R');
date_rat = dirstr(rix-10:rix+4);%%%%get data and rat number
file_spec_ix = max(strfind(dirstr,'\'));
file_spec = dirstr(file_spec_ix+1:end);
%% get the half width and amp ratio
ctr = length(AmpRatio_and_HalfWidth_ms)+1;
% ctr = 1;

%%
fnamClst = fieldnames(Cluster_struct);
for iSter = 1:length(fnamClst)
    for iClst = 1:length(Cluster_struct.(fnamClst{iSter}))
            p=0;
            nam = strrep(fnamClst{iSter},'_','-');
%             region = strfind(
            num = [region,(nam),' | cluster: ',num2str(iClst)];
            spike_times_ms = (Cluster_struct.(fnamClst{iSter})(iClst).TimeInSec)*1000;
            spike_FR = Cluster_struct.(fnamClst{iSter})(iClst).FiringRateHz;
            wv = Cluster_struct.(fnamClst{iSter})(iClst).MeanWaveform*.195/10;
            
            clusty = Cluster_struct.(fnamClst{iSter})(iClst).ClustID;
            
            newx = linspace(1,length(wv),200);
            newv = interp1(1:length(wv),wv,newx,'spline');
            itrpl_points = length(wv)/length(newv):length(wv)/length(newv):length(wv);
            xax_full = itrpl_points/sFreq*1000; % put in ms
            
            mxwv = max(newv);
            mnwv = min(newv)*-1;
            
            [peaks,pix] = findpeaks(newv);
            [troughs,tix] = findpeaks(newv*-1);
            fv = find(troughs==mnwv);
            negix = tix(fv);
            posix = pix(find(pix>tix(fv),1,'first'));
            if isempty(posix)
                fg = figure;
                plot(newv)
                title('Click the maxima of the hyperpolarization after the depolarization')
                psx = ginput(1);
                posix = round(psx(1));
                close(fg)
            end
            p1 = find(pix<negix,1,'last');
            if ~isempty(p1)&&peaks(p1)>(4*std(newv(1:10))+mean(newv(1:10)))&&peaks(p1)>0&&pix(p1)>5 %this is a shoddy workaround but as long as you check each plotted waveform, you can still make sure it's catching the right points
                mxwv = peaks(p1);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            fpixmx = pix(peaks==mxwv);
            if isempty(fpixmx)
                Amp_Ratio = NaN;
                half_width_ms = NaN;
            else
                Amp_Ratio = (mnwv-mxwv)/(mnwv+mxwv);
                half_width_ms = xax_full(posix)- xax_full(negix);
            end
            AmpRatio_and_HalfWidth_ms(ctr).Amp_ratio = Amp_Ratio;
            AmpRatio_and_HalfWidth_ms(ctr).Half_width = half_width_ms;
            AmpRatio_and_HalfWidth_ms(ctr).FiringRate = spike_FR;
            AmpRatio_and_HalfWidth_ms(ctr).Response = cell_resp;
            unique_name = [date_rat,'_',file_spec,'_',fnamClst{iSter},'_cluster-',num2str(clusty)];
            AmpRatio_and_HalfWidth_ms(ctr).Unique_name = unique_name;
            ctr = ctr+1;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            fig = figure;
            plot(xax_full,newv)
            hold on
            fc = 'none';
% % % %             if cell_resp = 1
% % % %                 fc = 'r';
% % % %             else
% % % %                 fc = 'none';
% % % %             end
            plot(xax_full(negix),mnwv*-1,'LineStyle','none','Marker','o','MarkerEdgeColor','r','MarkerFaceColor',fc)
            hold on
            if ~isempty(fpixmx)
                plot(xax_full(fpixmx),mxwv,'LineStyle','none','Marker','o','MarkerEdgeColor','r')
                hold on
            end
            g = gca;
            if ~isempty(posix)
                line([xax_full(posix) xax_full(posix)],[g.YLim(1)*.25 g.YLim(2)*.25],'color','m')
                hold on
            end
            line([xax_full(negix) xax_full(negix)],[g.YLim(1)*.25 g.YLim(2)*.25],'color','m')
            hold on
            line([0 max(xax_full)],[mxwv mxwv],'Linestyle',':','color','r');
            hold on
            line([0 max(xax_full)],[mnwv*-1 mnwv*-1],'Linestyle',':','color','r');
            hold on
            line([0 max(xax_full)],[0 0],'Linestyle',':','color','b');
            title(unique_name, 'interpreter', 'none');
            xlabel('Time (ms)')
            %             set(gca, 'YTick', []);
            ylabel('Amplitude (uV)')
            if savefiles
                saveas(fig,unique_name,'png')
                close(fig)
            end
    end
end

%% plot it
% col 1 is amp ratio
% col 2 is half width
figure
amp_rat = [AmpRatio_and_HalfWidth_ms.Amp_ratio];
haf_wid = [AmpRatio_and_HalfWidth_ms.Half_width];
plot(amp_rat,haf_wid,'LineStyle','none','Marker','o')
xlabel('Amplitude ratio ((n-p)/(n+p))')
ylabel('Half-width (ms)')
title('Amplitude ratio vs half-width')

% circ = linspace(0,2*pi) % this is here for when I figure out the 3 standard deviation calculation...gonna circle the clusters
% plot(4*cos(circ),4*sin(circ))

%% check for duplicates and save if there are none
if savefiles
    mycell = {AmpRatio_and_HalfWidth_ms.Unique_name};
    [un,~,irep] = unique(mycell);
    h = histc(irep,1:numel(un));
    duplicates = sum(h>1);
    if duplicates == 0
        save('AmpRatio_and_HalfWidth_ms','AmpRatio_and_HalfWidth_ms')
    else
        warning('There were duplicates in the AmpRatio data; file was not saved')
    end
end


%% cd back to the folder with the data
cd(SpikeDir)


