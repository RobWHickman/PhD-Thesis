function Pest = PESTgui(Pest)
% Pest = PESTgui(Pest)
% 
% script-like fx to run a GUI to modify parameters in structure GUI without
% modifying its "History" fields
%
% See also ModigPESTroutine 
% 
% rbm 8.11

if nargin==0,
    global Pest
end
% Read current values in global/structure Pest, and prepare as input for
% the GUI. 
allF = fields(Pest);          
for i = 1:size(allF,1),
    histFld = strfind(allF{i},'History'); 
    if strcmp(allF{i},'doPest'),
        PestInput.doPest = {{'0','{1}'}};
    elseif strcmp(allF{i},'instances')
        PestInput.instances = {Pest.(allF{i}),'',[0 inf],1};
    elseif strcmp(allF{i},'range')
        PestInput.range = {Pest.range,'* [juice ml]',[0 10],1};
    elseif isempty(histFld)
        PestInput.(allF{i}) = Pest.(allF{i});
    end
end
% run GUI
PestOut = StructDlg(PestInput, 'PEST parameters');
% if it wasn't cancelled assign values back to Pest
if ~isempty(PestOut),
    outFld = fields(PestOut);          
    for i = 1:size(outFld,1),
        Pest.(outFld{i}) = PestOut.(outFld{i});
    end
    % acknowledge succesful parameter change
    fprintf('\n\tChanged PEST parameteres!\n')
end

