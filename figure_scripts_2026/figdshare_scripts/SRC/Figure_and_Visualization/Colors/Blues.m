function color_matrix = Blues(number_of_colors)

%number of colors limited to 6

d = 1/number_of_colors;
for i = 1:number_of_colors
    cols(i,:)=[0 0 d*i];
end



color_matrix = cols;
