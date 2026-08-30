function color_matrix = ColorBlind_Tol(number_of_colors)

%number of colors limited to 6

cols = [51 34 136
    17 119 51
    68 170 153
    136 204 238
    221 204 119
    204 102 119
    170 68 153
    136 34 85
    213 137 115
    141 71 200
    213 92 39
    174 4 66 
    245 89 146
    216 122 226
    ];
    
col = cols./255;

color_matrix = col(1:number_of_colors,:);

