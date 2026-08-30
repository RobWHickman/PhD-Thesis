function [frameStr frameHdl] = drawFrameRect(clr,pos,penWidth,parentAxisHdl, axisKids)
% [frameStr frameHdl] = drawFrameRect(clr,pos,penWidth,parentAxisHdl, axisKids)
%
% drawRings is used to create the strings for drawing rings in the
% experimenter's screen and in the subject's. It needs several inputs:
%
% inputs:
%   clr
%   pos 
%   parentAxisHdl
%   axisKids
%
% outputs:
%   [frameStr frameHdl]
%
% See also DRAWRINGS, DRAWCIRCLES
%
% rbm 3.09
global VisParam TaskOp MENUs

% amount of frameangles to be created... 
frames = size(pos,1);

% size and position variables
framesz = pos(:,3:4)-pos(:,1:2);
frameCtr = pos(:,1:2) + (framesz/2);

% intialize outputs
frameStr = [];
frameHdl = zeros(size(frameCtr,1),axisKids);

% frameOval and plotting don't accept matrices, we need to loop them
% 
% Screen('FrameRect', windowPtr [,color] [,rect] [,penWidth]);
pw = num2str(penWidth);
for i = 1:frames,
    if sum(pos(i,:))>0
        c = ['[',num2str(clr),']'];
        p = ['[',num2str(pos(i,:)),']'];
        preStr = 'Screen(''FrameRect'', VisParam.scr_handle,';
        frameStr = [frameStr, preStr,c,',',p,',',pw,');'];
    end
end

% To use with momoTbl
if isfield(MENUs, 'ModigMonitorTable') && strcmp(TaskOp.curSetup,'A'),
    pos(:,[1 3]) =  round(pos(:,[1 3]))+VisParam.scr_rect(3);
end
frameSz = pos(:,3:4)-pos(:,1:2);
frameCtr = pos(:,1:2) + (frameSz/2);

for k = 1:size(frameCtr,1),
    if framesz(k,:)>0
        for  j = 1:axisKids,
            init = [pos(k,1), VisParam.scr_rect(4)-pos(k,4)];
            frameHdl(k,j) = rectangle(...
                'Position', [init framesz(k,:)],...
                'FaceColor',clr./256,...
                'Parent',parentAxisHdl,...
                'Visible', 'off');
        end
    end
end

% clean figure handles...
% frameHdl(frameHdl(:,1)==0,:) = [];

