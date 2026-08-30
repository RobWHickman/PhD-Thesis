function [valBarStr valBarHdl]=drawValueBar(reward_mag, border_color, stim_distance, parentAxisHdl, axisKids, varargin)
% [valBarStr valBarHdl]=drawValueBar(reward_mag, border_color,
% stim_distance, parentAxisHdl, axisKids, varargin)
%
% drawValueBar is part of the family of functions that draw stimuli in
% Modig. It creates a "value bar" string for the PTB and a invisible handle
% to an equivalent figure at the experimenter's screen.
%
% inputs: 
%     reward_mag (in mL) 
%     border_color (rgb)
%     stim_distance (horizontal, vertical) stim center to screen center in
%               pixels
%     parentAxisHdl
%     axisKids
%       
%
%    varargin 
%     reward_range (two values in ML)
%      background_color (rgb)
%     bar_width (width) in pixels
%     size (width,height) in pixels
%     orientation (vertical or horizontal) as char -default horizontal
%     
%     style (rects/matrix) in char, either openGL or texture+matrix
%     
% outputs:
%     valBarStr, 
%     valBarHdl,
%
% Example:
%   % create a red bar representing 0.15 ml to the left of the screen
%   % center without any Y-axis offset
%   [valBarStr valBarHdl]= drawValueBar(0.15, [256 0 0], [-200 0], gca, 1);
%   eval(valBarStr), Screen('Flip',VisParam.scr_handle);  
%   set(valBarHdl,'Visible','on')
%   
%    
%
%
% See also drawImages drawRings drawRectangle_RBM drawCircles drawFrameRect
%
% WRS original code, matrix version (no output implemented in this ver)
% RBM 7.11

%%
global VisParam TaskOp

reward_range = [0 1];
background_color = [125 125 125];

bar_width = 20;
rect_size = [100 400];
orientation = 'vertical';
style = 'rects';

scrCenter = [640 400];

valBarStr = '';
valBarHdl = [];
%% deal with parameter-value pairs 
% I have the feeling this code is "inefficient" and prone to errors
k = 1;
while k <= length(varargin) && ischar(varargin{k})
    switch varargin{k}
        case 'reward_range'
            reward_range = varargin{k+1};
        case 'background_color'
            background_color = varargin{k+1};
        case 'bar_width'
            bar_width = varargin{k+1};
        case 'rect_size'
            rect_size = varargin{k+1};
        case 'orientation'
            orientation = varargin{k+1};
        case 'scrCenter'
            scrCenter = varargin{k+1};
        case 'style'
            style = varargin{k+1};
        otherwise
            error('drawValueBar: unrecognized input')
    end
    k = k+2;
end

%% input checks
if reward_mag>reward_range(2) || reward_mag<reward_range(1)
    error('drawValueBar: Reward magnitude should be within reward range')
end

%%
switch style
    case 'rects'
        switch orientation,
            case {'horizontal','h'},
                rect_position(1) = scrCenter(1)+stim_distance(1)-(max(rect_size)/2);
                rect_position(2) = scrCenter(2)+stim_distance(2)-(min(rect_size)/2);
                rect_position(3) = rect_position(1)+max(rect_size);
                rect_position(4) = rect_position(2)+min(rect_size);

                bar_symmetric_center = stim_distance(1)<0;
                proportion =  bar_symmetric_center - (reward_mag - reward_range(1)) / diff(reward_range);
                bar_position_in_rect = round(abs(proportion)*max(rect_size));

                bar_position = rect_position;
                bar_position(1) = rect_position(1)+(bar_position_in_rect-(bar_width/2));
                bar_position(3) = rect_position(1)+(bar_position_in_rect+(bar_width/2));
                
                myx = [rect_position([1 3]) bar_position(1)];
                x = [myx(1) myx(1) myx(2) myx(2) myx(1) myx(3) myx(3)];
                myy = VisParam.scr_rect(4)-rect_position([2 4]);
                y = [myy(1) myy(2) myy(2) myy(1) myy(1) myy(1) myy(2)];   
            case {'vertical','v'}
                rect_position(1) = scrCenter(1)-stim_distance(1)-(min(rect_size)/2);
                rect_position(2) = scrCenter(2)-stim_distance(2)-(max(rect_size)/2);
                rect_position(3) = rect_position(1)+min(rect_size);
                rect_position(4) = rect_position(2)+max(rect_size);

                % whenever the stim is above center, flip bar to
                % "bottom-top" orientation
                bar_symmetric_center = stim_distance(2)>0; 
                proportion =  bar_symmetric_center - (reward_mag - reward_range(1)) / diff(reward_range);

                bar_position_in_rect = round(abs(proportion)*max(rect_size));

                bar_position = rect_position;
                bar_position(2) = rect_position(2)+(bar_position_in_rect-(bar_width/2));
                bar_position(4) = rect_position(2)+(bar_position_in_rect+(bar_width/2));
                
                myx = rect_position([1 3]);
                x = [myx(1) myx(1) myx(2) myx(2) myx(1) myx(1) myx(2)];
                myy = VisParam.scr_rect(4)-[rect_position([2 4]), bar_position(2)];
                y = [myy(1) myy(2) myy(2) myy(1) myy(1) myy(3) myy(3)];

        end

        %%
        bStr = ['Screen(''FillRect'',VisParam.scr_handle,',mat2str(background_color),',',mat2str(rect_position),');'];
        rStr = ['Screen(''FillRect'',VisParam.scr_handle,',mat2str(border_color),',',mat2str(bar_position),');'];
        frameStr = ['Screen(''FrameRect'',VisParam.scr_handle,',mat2str(border_color),',',mat2str(rect_position),',5);'];
        valBarStr = [bStr,rStr,frameStr];
        
        %%
        % move stim to "setup A" if apropriate
%         x = x+(strcmp(TaskOp.curSetup,'A')*512);
        valBarHdl = zeros(1,axisKids);
        for  j = 1:axisKids,
%             valBarHdl(j) = plot(x,y,...
%                 'linewidth', 2, ...
%                 'Color',border_color./256,...
%                 'Parent',parentAxisHdl,...
%                 'Visible', 'off');
              valBarHdl(j) = plot(x,y,...
                'linewidth', 3, ...
                'Color',[125 125 125]./256,...
                'Parent',parentAxisHdl,...
                'Visible', 'off');
        end
    case matrix
        m=repmat(bg,[800 800 3]);
        magnitude = 0.5;% in ml
        number = 1;
        barcolor=[255 0 0];
        position=1;%[0 0 500 100];
        maximumopen=332;
        level=magnitude/number;
        levelp=(maximumopen-level)/maximumopen;
        
    level=round(800*levelp);
    %m = zeros(1000,1000,3);
    if level < 11
        bar=1:11;
    elseif level == 800
        bar = 789:800;
    else
        bar=level-5:level+5;
    end

    if position==2
        position=randsample([1,5],1);
    end
    switch position
        case(5)
            m(1:10,500:800,1)=barcolor(1);
            m(90:100,600:800,1)=barcolor(1);
            m(190:200,600:800,1)=barcolor(1);
            m(290:300,600:800,1)=barcolor(1);
            m(390:400,500:800,1)=barcolor(1);
            m(490:500,600:800,1)=barcolor(1);
            m(590:600,600:800,1)=barcolor(1);
            m(690:700,600:800,1)=barcolor(1);
            m(790:800,500:800,1)=barcolor(1);
            m(:,1:20,1)=barcolor(1);
            m(:,780:800,1)=barcolor(1);

            m(1:10,500:800,2)=barcolor(2);
            m(90:100,600:800,2)=barcolor(2);
            m(190:200,600:800,2)=barcolor(2);
            m(290:300,600:800,2)=barcolor(2);
            m(390:400,500:800,2)=barcolor(2);
            m(490:500,600:800,2)=barcolor(2);
            m(590:600,600:800,2)=barcolor(2);
            m(690:700,600:800,2)=barcolor(2);
            m(790:800,500:800,2)=barcolor(2);
            m(:,1:20,2)=barcolor(2);
            m(:,780:800,2)=barcolor(2);

            m(1:10,500:800,3)=barcolor(3);
            m(90:100,600:800,3)=barcolor(3);
            m(190:200,600:800,3)=barcolor(3);
            m(290:300,600:800,3)=barcolor(3);
            m(390:400,500:800,3)=barcolor(3);
            m(490:500,600:800,3)=barcolor(3);
            m(590:600,600:800,3)=barcolor(3);
            m(690:700,600:800,3)=barcolor(3);
            m(790:800,500:800,3)=barcolor(3);
            m(:,1:20,3)=barcolor(3);
            m(:,780:800,3)=barcolor(3);

        case(1)
            m(1:10,1:300,1)=barcolor(1);
            m(90:100,1:200,1)=barcolor(1);
            m(190:200,1:200,1)=barcolor(1);
            m(290:300,1:200,1)=barcolor(1);
            m(390:400,1:300,1)=barcolor(1);
            m(490:500,1:200,1)=barcolor(1);
            m(590:600,1:200,1)=barcolor(1);
            m(690:700,1:200,1)=barcolor(1);
            m(790:800,1:300,1)=barcolor(1);
            m(:,1:20,1)=barcolor(1);
            m(:,780:800,1)=barcolor(1);

            m(1:10,1:300,2)=barcolor(2);
            m(90:100,1:200,2)=barcolor(2);
            m(190:200,1:200,2)=barcolor(2);
            m(290:300,1:200,2)=barcolor(2);
            m(390:400,1:300,2)=barcolor(2);
            m(490:500,1:200,2)=barcolor(2);
            m(590:600,1:200,2)=barcolor(2);
            m(690:700,1:200,2)=barcolor(2);
            m(790:800,1:300,2)=barcolor(2);
            m(:,1:20,2)=barcolor(2);
            m(:,780:800,2)=barcolor(2);

            m(1:10,1:300,3)=barcolor(3);
            m(90:100,1:200,3)=barcolor(3);
            m(190:200,1:200,3)=barcolor(3);
            m(290:300,1:200,3)=barcolor(3);
            m(390:400,1:300,3)=barcolor(3);
            m(490:500,1:200,3)=barcolor(3);
            m(590:600,1:200,3)=barcolor(3);
            m(690:700,1:200,3)=barcolor(3);
            m(790:800,1:300,3)=barcolor(3);
            m(:,1:20,3)=barcolor(3);
            m(:,780:800,3)=barcolor(3);
    end
    m(bar,21:779,1) = barcolor(1);
    m(bar,21:779,2) = barcolor(2);
    m(bar,21:779,3) = barcolor(3);
    m=uint8(m);
end
