function col_vals = Reds_and_Blacks(num_col)


for iCol = 1:num_col
    if num_col<10
        if iCol == 1
            cl(1,:) = [1 0 0];
        elseif iCol == 2
            cl(2,:) = [0 0 0];
        elseif iCol == 3
            cl(3,:) = [.5 .5 .5];
        elseif iCol == 4
            cl(4,:) = [.5 0 0];
        elseif iCol == 5
            cl(5,:) = [.2 .2 .2];
        elseif iCol == 6
            cl(6,:) = [.8 .8 .8];
        elseif iCol == 7
            cl(7,:) = [1 .2 .2];
        elseif iCol == 8
            cl(8,:) = [.35 .35 .35];
        elseif iCol == 9
            cl(9,:) = [.65 .65 .65];
        end
        col_vals=cl;
    else
        
        if mod(iCol,2)~=0
            col_vals(iCol,:) = [255 255 255]-[255/(iCol+.2) 255/(iCol+.2) 255/(iCol+.2)];
        else
            if mod(iCol,4)~=0
                col_vals(iCol,:) = [255 0 0]-[255/(255*iCol/10) 0 0];
            else
                col_vals(iCol,:) = [255 0 0]+[0 255/(iCol+.2) 255/(iCol+.2)];
            end
        end
        col_vals = flipud(col_vals./255);
        
    end
end


% col_vals = col_vals./255;

%
%
% col_vals = [1	0	0
% 0.5	0.5	0.5
% 1	0.8	0.8
% 0.7	0.7	0.7
% 0.6	0.3	0.3
% 0.3	0.3	0.3
% 1	0.4	0.4
% 0.5	0.4	0.4];