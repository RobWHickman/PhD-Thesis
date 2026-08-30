function [triStr triHdl]  = drawTriangle(clr,pos,parentAxisHdl, axisKids, varargin)
% [triStr triHdl]  = drawTriangle(clr,pos,parentAxisHdl, axisKids, varargin)
%
% drawTriangle is used to create the strings for drawing tris in the
% experimenter's screen and in the subject's. note that triangle drawing in
% experimenter monitor's is very inaccurate!
%
% inputs:
%   clr
%   pos 
%   parentAxisHdl
%   axisKids
%   varargin; setting the first element to 1 generates drawing strings with
%       fillpoly -not implemented so far.
%
% outputs:
%   [triStr triHdl]
%
%
% See Also DRAWRECTANGLE_RBM, DRAWCIRCLES, DRAWRINGS 
%
% rbm 07.08
%     10.08 fillpoly implementation 
%

% TODO: accurate triangles in momo
global VisParam

if ~isempty(varargin) && varargin{1}==1,
    goPoly = 1;
else
    goPoly = 0;
end

% amount of tris to be created... 
tris = size(pos,1);

% more size and position variables
triSz = pos(:,3:4)-pos(:,1:2);
triCtr = pos(:,1:2) + (triSz/2);

% intialize outputs
triStr = [];
triHdl = zeros(size(triCtr,1),axisKids);

% 
for i = 1:tris,
    if sum(pos(i,:))>0
        c = ['[',num2str(clr),']'];
        
        if goPoly,
            one = num2str([pos(i,1) pos(i,2) + diff(pos(i,[2 4]))/2]);
            two = num2str(pos(i,[3 2]));
            tri = num2str(pos(i,3:4)); 
            p = ['[',one,';',two,';',tri,']'];        
            preStr = 'Screen(''FillPoly'', VisParam.scr_handle,';
            triStr = [triStr, preStr, c,',', p, ');'];            
        else
            p = ['[',num2str(pos(i,:)),']'];            
            preStr = 'Screen(''FillOval'', VisParam.scr_handle,';
            triStr = [triStr, preStr,c,',',p,',1);'];
        end
    end
end

for k = 1:size(triCtr,1),
    if triSz(k,:)>0
        X = round([pos(k,[1 3]) pos(k,3)+((pos(k,3)-pos(k,1))/2)]);
        Y = VisParam.scr_rect(4)-round([pos(k,[4 2]) pos(k,4)+((pos(k,4)-pos(k,2))/2)]);
        for j = 1:axisKids
            triHdl(k,j) = fill(X,Y,...
               clr./256,...
               'Parent',parentAxisHdl,...
               'lineWidth',3,...
               'Visible', 'off');
        end
    end
end

% clean figure handles...
triHdl(triHdl(:,1)==0,:) = [];

