function [eyeLim tolWinHdl] = createTolWin2(center,tolWinSize)
%
%   [eyeLim tolWinHdl] = createTolWin2(center,tolWinSize)
%
% generates n squares with "center" and perimeter
% "tolWinSize" and passess it to "eyeLim".
% 'n' is determined by the rows on "center". Deletes any previous tolWinHdl
% found on the current monitor and creates a new 'invisible' object.
%
%
% tolWinSize can be a 1-element with equal sized tolerance windows or a 2-element 
% vector with the tolerance window being [x y].
%
% center is a n-by-2 matrix with coordinates of the center(s) of the
% tolerance window [x y]
%
% tolWinHdl is a handle or vector of the object(s) in the current monitor 
% that illustrate the tolerance window. they are passed to MENUs
%
% 
% rbm   2.09 from createTolWin.m
%
% See also createTolWinCircle


global Tbl MENUs TaskOp VisParam

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
eyeLim        = zeros(size(center,1),4);
tolWinHdl = zeros(size(center,1),1);

% generate equal sized tolerance windows for all targets in
% display
toeT = round(tolWinSize);

for i = 1:size(center,1),
    if length(toeT)==1,
        eyeLim(i,:) = [center(i,1)-toeT,...
                   center(i,1)+toeT,...
                   center(i,2)-toeT,...
                   center(1,2)+toeT];
    elseif length(toeT)==2,
        eyeLim(i,:) = [center(i,1)-toeT(i,1),...
                    center(i,1)+toeT(i,1),...
                    center(i,2)-toeT(i,2),...
                    center(i,2)+toeT(i,2)];
    end
    % no negative numbers, (problematic for evaluating behavior)
    ne = eyeLim < 0;
    eyeLim(ne) = 0; 
    
    % Correction to use with momoTbl when in "split" mode
    rectWholeWin = Screen('Rect',1);
    split = sum(VisParam.scr_rect==rectWholeWin)~=4;
    if split && ~strcmpi(TaskOp.prj,'EYECAL')&& strcmp(curMon, 'ModigMonitorTable') && strcmp(TaskOp.curSetup,'A'),
        eyeLim(i,1:2) =  round(eyeLim(i,1:2))+VisParam.scr_rect(3);
    end

    width  = eyeLim(i,2)-eyeLim(i,1);
    heigth = eyeLim(i,4)-eyeLim(i,3);
   tolWinHdl(i) = rectangle(...
          'Position', [eyeLim(i,1) eyeLim(i,3) width heigth],...
          'EdgeColor', [0 0.957 0],...
          'LineWidth', 2,...
          'Tag', 'tolWin',...
          'Visible','off',...
          'Parent', MENUs.(curMon).handles.(curActHdl));
end
