function color_matrix = CB_blues(number_of_colors)

%number of colors limited to 6

cols = [
    127 205 187
    65 182 196
    29 145 192
    34 94 168
    12 44 132
    ];
    
col = cols./255;

color_matrix = col(1:number_of_colors,:);

