function [] = Make_ppt
SpikeDir = uigetdir('E:\DANA_Acute\DAN_WORKING','Where is the folder containing the VTA figures?');
display(['VTA SpikeDir = ',SpikeDir]);
FSCVdir = uigetdir('E:\DANA_Acute\DAN_WORKING','Where is the folder containing the FSCV figures?');
display(['FSCVdir = ',FSCVdir]);

%% find the date and rat number
cd(SpikeDir)
SpikeDir = pwd;
dirstr = fullfile(pwd);
rix = strfind(dirstr,'_R');
date_rat = dirstr(rix-10:rix+4);%%%%get data and rat number
iix = strfind(dirstr,'Intan\');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uiSTR = inputdlg('Type the region');
% reg_str = uiSTR{1};
reg_str = 'VTA';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
depth = [reg_str,'_',dirstr(iix+10:iix+15)];


%%
import mlreportgen.ppt.*
slidesFile = ['DANA_summary_',date_rat,'_',depth,'.pptx'];
slides = Presentation(slidesFile);

TitleSlide = add(slides,'Title Slide');
replace(TitleSlide,'Title',date_rat)
replace(TitleSlide,'Subtitle',depth)

open(slides);

%% add transient characteristics fig 
cd(FSCVdir)

DataSlide = add(slides,'Blank');

figg = Picture(which('Transient_characteristics.emf'));
w = str2double(figg.Width(1:end-2));
h = str2double(figg.Height(1:end-2));
rat = h/720;
figg.Width = [num2str(w/rat),'px'];
figg.Height = [num2str(h/rat),'px'];
xpos = (1280-(w/rat))/2;
figg.X = [num2str(xpos),'px'];

add(DataSlide,figg)


%%
cd(SpikeDir)
hist_fig_nams = dir(['HIST_',reg_str,'_a*']);
peth_fig_nams = dir(['PETH_',reg_str,'_a*']); 

for inam = 1:length(hist_fig_nams)
    tmp_nam = peth_fig_nams(inam).name(10:end);
    
    DataSlide = add(slides,'Blank');
    
    fig1 = Picture(which(['PETH_VTA_',tmp_nam]));
    w = str2double(fig1.Width(1:end-2));
    h = str2double(fig1.Height(1:end-2));
    rat = h/720;
    fig1.Width = [num2str(w/rat),'px'];
    fig1.Height = [num2str(h/rat),'px'];
%     xpos = (1280-(w/rat))/2;
% %     fig1.X = [num2str(xpos),'px'];
    
    fig2 = Picture(which(['HIST_VTA_',tmp_nam]));
    w = str2double(fig2.Width(1:end-2));
    h = str2double(fig2.Height(1:end-2));
    rat = h/720;
    fig2.Width = [num2str(w/rat),'px'];
    fig2.Height = [num2str(h/rat),'px'];
    xpos = (1280-(w/rat));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig2.X = [num2str(xpos),'px'];
    
    add(DataSlide,fig1)
    add(DataSlide,fig2)
    
    clear DataSlide
end

clear DataSlide fig1 fig2 hist_fig_nams hnams
hist_fig_nams = dir(['HIST_',reg_str,'_B*']);
peth_fig_nams = dir(['PETH_',reg_str,'_B*']); 

for inam = 1:length(hist_fig_nams)
    tmp_nam = peth_fig_nams(inam).name(10:end);
    
    DataSlide = add(slides,'Blank');
    
    fig1 = Picture(which(['PETH_VTA_',tmp_nam]));
    w = str2double(fig1.Width(1:end-2));
    h = str2double(fig1.Height(1:end-2));
    rat = h/720;
    fig1.Width = [num2str(w/rat),'px'];
    fig1.Height = [num2str(h/rat),'px'];
%     xpos = (1280-(w/rat))/2;
%     fig1.X = [num2str(xpos),'px'];
    
    fig2 = Picture(which(['HIST_VTA_',tmp_nam]));
    w = str2double(fig2.Width(1:end-2));
    h = str2double(fig2.Height(1:end-2));
    rat = h/720;
    fig2.Width = [num2str(w/rat),'px'];
    fig2.Height = [num2str(h/rat),'px'];
    xpos = (1280-(w/rat));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig2.X = [num2str(xpos),'px'];
    
    add(DataSlide,fig1)
    add(DataSlide,fig2)
    
    clear DataSlide
end

ptb_fig_nams = dir(['Peri_t*',reg_str,'*']);

for inam = 1:length(ptb_fig_nams)
    tmp_nam = ptb_fig_nams(inam).name;
    
    DataSlide = add(slides,'Blank');
    
    fig = Picture(which(tmp_nam));
    w = str2double(fig.Width(1:end-2));
    h = str2double(fig.Height(1:end-2));
    rat = h/720;
    fig.Width = [num2str(w/rat),'px'];
    fig.Height = [num2str(h/rat),'px'];
    xpos = (1280-(w/rat))/2;
    fig.X = [num2str(xpos),'px'];

    add(DataSlide,fig)
    
    clear DataSlide
end
close(slides);

load train.mat
soundsc(y)


    

