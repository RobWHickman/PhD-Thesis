function color_matrix = CB_reds(number_of_colors)

%number of colors limited to 6

cols = [
    253 141 60
    252 78 42
    177 0 38
    ];
    
col = cols./255;

color_matrix = col(1:number_of_colors,:);

