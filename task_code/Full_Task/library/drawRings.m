function [ringStr ringHdl]  = drawRings(clr,pos,parentAxisHdl, axisKids)
% [ringStr ringHdl]  = drawRings(clr,pos,parentAxisHdl, axisKids)
%
% drawRings is used to create the strings for drawing rings in the
% experimenter's screen and in the subject's. It needs several inputs:
%
% inputs:
%   clr '1 x 3 rgb'
%   pos 'Rings x 3'
%   parentAxisHdl '1x1'
%   axisKids 'copies of rings'
%
% outputs:
%   [ringStr ringHdl]
%
% it is recommended that stimulus drawing is done by a single function with
% clear inputs and outputs so that you don't need to re write your stimulus
% code for every different project and you don't need to remember where in
% that bloody global your variables are stored.
%
% See Also DRAWRECTANGLE_RBM, DRAWCIRCLES 
%
% rbm 03.08
%       4.14 bug with corrected horizontal position
%       
global VisParam TaskOp MENUs

% amount of rings to be created... 
rings = size(pos,1);

% more size and position variables
ringSz = pos(:,3:4)-pos(:,1:2);
ringCtr = pos(:,1:2) + (ringSz/2);

% intialize outputs
ringStr = [];
ringHdl = zeros(size(ringCtr,1),axisKids);

% frameOval and plotting don't accept matrices, we need to loop them
for i = 1:rings,
    if sum(pos(i,:))>0
        c = ['[',num2str(clr),']'];
        p = ['[',num2str(pos(i,:)),']'];
        preStr = 'Screen(''FrameOval'', VisParam.scr_handle,';
        ringStr = [ringStr, preStr,c,',',p,',5);'];
    end
end

% Correct position if using split window
rectWholeWin = Screen('Rect',1);
split = sum(VisParam.scr_rect==rectWholeWin)~=4;
if split && isfield(MENUs, 'ModigMonitorTable') && strcmp(TaskOp.curSetup,'A'),
    pos(:,[1 3]) =  round(pos(:,[1 3]))+VisParam.scr_rect(3);
end
ringSz = pos(:,3:4)-pos(:,1:2);
ringCtr = pos(:,1:2) + (ringSz/2);


for k = 1:size(ringCtr,1),
    if ringSz(k,:)>0
        % circle variables
        theta = linspace(0,2*pi,1000);
        rho   = ones(1,1000)* ringSz(k,1)/2;
        [X,Y] = pol2cart(theta,rho); % polar to cartesian
        X     = X + ringCtr(k,1);
        Y     = Y + VisParam.scr_rect(4)-ringCtr(k,2);

        for j = 1:axisKids
            ringHdl(k,j) = plot(X,Y,...
               'Color',clr./256,...
               'Parent',parentAxisHdl,...
               'lineWidth',3,...
               'Visible', 'off');
        end
    end
end

% clean figure handles...
ringHdl(ringHdl(:,1)==0,:) = [];

