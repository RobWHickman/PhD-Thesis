function [rectStr rectHdl] = drawRectangle_RBM(clr,pos,parentAxisHdl, axisKids)
% [rectStr rectHdl] = drawRectangle_RBM(clr,pos,parentAxisHdl, axisKids)
%
% drawRectangle_RBM is used to create the strings for drawing rectangles in the
% experimenter's screen and in the subject's. It needs several inputs:
%
% inputs:
%   clr
%   pos 
%   parentAxisHdl
%   axisKids
%
% outputs:
%   [rectStr rectHdl]
%
% See also DRAWRINGS, DRAWCIRCLES
%
% rbm 3.08
global VisParam TaskOp MENUs

% amount of rectangles to be created... 
rects = size(pos,1);

% size and position variables
rectsz = pos(:,3:4)-pos(:,1:2);
rectCtr = pos(:,1:2) + (rectsz/2);

% intialize outputs
rectStr = [];
rectHdl = zeros(size(rectCtr,1),axisKids);

% frameOval and plotting don't accept matrices, we need to loop them
for i = 1:rects,
    if sum(pos(i,:))>0
        c = ['[',num2str(clr),']'];
        p = ['[',num2str(pos(i,:)),']'];
        preStr = 'Screen(''FillRect'', VisParam.scr_handle,';
        rectStr = [rectStr, preStr,c,',',p,');'];
    end
end

% Correct position if using split window
rectWholeWin = Screen('Rect',1);
split = sum(VisParam.scr_rect==rectWholeWin)~=4;
if split && isfield(MENUs, 'ModigMonitorTable') && strcmp(TaskOp.curSetup,'A'),
    pos(:,[1 3]) =  round(pos(:,[1 3]))+VisParam.scr_rect(3);
end
rectSz = pos(:,3:4)-pos(:,1:2);
rectCtr = pos(:,1:2) + (rectSz/2);

for k = 1:size(rectCtr,1),
    if rectsz(k,:)>0
        for  j = 1:axisKids,
            init = [pos(k,1), VisParam.scr_rect(4)-pos(k,4)];
            rectHdl(k,j) = rectangle(...
                'Position', [init rectsz(k,:)],...
                'FaceColor',clr./256,...
                'Parent',parentAxisHdl,...
                'Visible', 'off');
        end
    end
end

