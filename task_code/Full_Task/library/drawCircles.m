function [circusStr circusHdl]  = drawCircles(clr,pos,parentAxisHdl, axisKids)
% [circusStr circusHdl]  = drawCircles(clr,pos,parentAxisHdl, axisKids)
%
% drawCircles is used to create the strings for drawing circles in the
% experimenter's screen and in the subject's. It needs several inputs:
%
% inputs:
%   clr
%   pos 
%   parentAxisHdl
%   axisKids
%
% outputs:
%   [circusStr circusHdl]
%
% it is recommended that stimulus drawing is done by a single function with
% clear inputs and outputs so that you don't need to re write your stimulus
% code for every different project and you don't need to rememebr where in
% that bloody global your variables are stored.
%
% See Also DRAWRECTANGLE_RBM, DRAWRINGS 
%
% rbm 06.08 based on drawrings
global VisParam

% amount of circles to be created... 
circus = size(pos,1);

% more size and position variables
circusSz = pos(:,3:4)-pos(:,1:2);
circusCtr = pos(:,1:2) + (circusSz/2);

% intialize outputs
circusStr = [];
circusHdl = zeros(size(circusCtr,1),axisKids);

% although looping isn't 'efficient', we need to, to avoid null strings
for i = 1:circus,
    if sum(pos(i,:))>0
        c = ['[',num2str(clr),']'];
        p = ['[',num2str(pos(i,:)),']'];
        preStr = 'Screen(''FillOval'', VisParam.scr_handle,';
        circusStr = [circusStr, preStr,c,',',p,');'];
    end
end

for k = 1:size(circusCtr,1),
    if circusSz(k,:)>0
        % circle variables
        theta = linspace(0,2*pi,1000);
        rho   = ones(1,1000)* circusSz(k,1)/2;
        [X,Y] = pol2cart(theta,rho); % polar to cartesian
        X     = X + circusCtr(k,1);
        Y     = Y + VisParam.scr_rect(4)-circusCtr(k,2);

        for j = 1:axisKids
            circusHdl(k,j) = fill(X,Y,...
                clr./256,...
               'Parent',parentAxisHdl,...
               'Visible', 'Off');
        end
    end
end

% clean figure handles...
circusHdl(circusHdl(:,1)==0,:) = [];

