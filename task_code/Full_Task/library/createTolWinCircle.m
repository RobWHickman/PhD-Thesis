function [eyeLim tolWinHdl] = createTolWinCircle(center,radius)
%
%   [eyeLim tolWinHdl] = createTolWinCircle(center,radius)
%
% generates n circles with "center" and radiuse
% "tolWinSize" and passess it to "eyeLim".
% 'n' is determined by the rows on "center". Deletes any previous tolWinHdl
% found on the current monitor and creates a new 'invisible' object.
%
%
% center is a n-by-2 matrix with coordinates of the center(s) of the
% tolerance window [x y]
%
% tolWinHdl is a handle or vector of the object(s) in the current monitor 
% that illustrate the tolerance window. they are passed to MENUs
%
% See also createTolWin2 
%
% rbm   7.12 from createTolWin2.m

global Tbl MENUs VisParam

%% delete tolerance windows
% find which current monitor is being used.
curMon = Tbl.MenuTbl{1}; 

curActHdl = 'MONITOR_AXIS';
stem = MENUs.(curMon).handles;
if isempty(stem), error('Monitor GUI is off, please turn it on'),end
if sum(strcmp(fields(stem),'tolWinHdl'))>0 && sum(ishandle(stem.tolWinHdl)),
   delete(MENUs.(curMon).handles.tolWinHdl)
end

%% generate tolerance windows
eyeLim    = [center(:,1), VisParam.scr_rect(4)-center(:,2), repmat(radius,size(center,1),1)];
tolWinHdl = zeros(size(center,1),1);

% generate tolerance windows for all targets in display
for i = 1:size(center,1),
    % circle variables
    theta = linspace(0,2*pi,1000);
    rho   = ones(1,1000)* radius;
    [X,Y] = pol2cart(theta,rho); % polar to cartesian
    X     = X + center(i,1);
    Y     = Y + VisParam.scr_rect(4)-center(i,2);

    tolWinHdl(i) = plot(X,Y,...
       'Color',[0 0.957 0],...
       'Parent',MENUs.(curMon).handles.(curActHdl),...
       'lineWidth',2,...
       'Visible', 'off');
end
