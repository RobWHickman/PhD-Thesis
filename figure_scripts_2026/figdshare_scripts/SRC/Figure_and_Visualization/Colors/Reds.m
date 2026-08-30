function color_matrix = Reds(number_of_colors)

%number of colors limited to 6

d = 1/number_of_colors;
for i = 1:number_of_colors
    cols(i,:)=[d*i 0 0];
end



color_matrix = cols;

