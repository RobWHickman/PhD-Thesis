% CleanVisParamTextures

global VisParam

if isfield(VisParam,'texture') && ~isempty(VisParam.texture)
    Screen('close',VisParam.texture(1).tex)
    VisParam.texture    = [];
end