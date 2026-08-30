function [imgStr] = drawImagesTK(fname, pos, texturenum)
% [imgStr] = drawImagesTK(fname, pos)
%
% Modified version of Ray's drawImages. Ignores Modig Monitor Table.

global VisParam 

% load data from the image, create a texture and a string to draw it.
image_data = imread(fname);

VisParam.texture(texturenum).tex = Screen('MakeTexture',VisParam.scr_handle,image_data);
imgStr = sprintf('Screen(''DrawTexture'',VisParam.scr_handle,VisParam.texture(%d).tex,[],%s);',texturenum,mat2str(pos));
end
