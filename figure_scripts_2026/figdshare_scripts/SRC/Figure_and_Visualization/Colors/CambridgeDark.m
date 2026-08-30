function color_matrix = ColorBlind_Tol(number_of_colors)

%number of colors limited to 6

cols = [232 156 18
    138 21 56
    17 94 103
    0 60 113
    78 91 49
    71 41 92
    190,77,0
    133,176,154
    232,156,174
    175,149,166
    183,191,16];
    
col = cols./255;

color_matrix = col(1:number_of_colors,:);

