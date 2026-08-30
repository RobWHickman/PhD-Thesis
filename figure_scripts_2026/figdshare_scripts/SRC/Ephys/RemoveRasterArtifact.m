function [new_raster,artifact_removed] = RemoveRasterArtifact(raster_matrix,artifact_row_ix,optional_offset)

if nargin<3
    optional_offset = 0;
end
artifact_removed = 0;
new_raster = raster_matrix;
art_ctr = 0;
for iA= 1:length(artifact_row_ix)
    art_ctr = art_ctr+raster_matrix(iA,artifact_row_ix(iA)+optional_offset);
end
if art_ctr>=3
    for iA= 1:length(artifact_row_ix)
        if artifact_row_ix(iA)>0           
            inc=optional_offset;arti=0;reentry=1;
            while arti==0
                if new_raster(iA,artifact_row_ix(iA)+inc)
                    new_raster(iA,artifact_row_ix(iA)+inc)=0;
                    arti=1;
                end
                if inc<=optional_offset+2 && reentry==1 && arti==0
                    inc = inc+1;
                elseif inc>=optional_offset-2 && arti==0
                    reentry=0;
                    inc=inc-1;
                elseif inc<0
                    arti=1;
                end
            end
        end
    end
    artifact_removed = 1;
end