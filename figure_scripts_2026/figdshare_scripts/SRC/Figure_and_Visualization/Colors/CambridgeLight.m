function color_matrix = CambridgeLight(number_of_colors)

%number of colors limited to 6

cols = [
232 156 18	
0 114 206	
168 180 0	
163 193 164
235 153 169
181 147 155	

];
    
col = cols./255;

color_matrix = col(1:number_of_colors,:);