function color_matrix = SingleColorMap(color,number_of_colors)

cl = {'k',1:3;
    'r',1;
    'g',2;
    'b',3;
    'y',[1:2];
    'm',[1,3];
    'c',[2:3]};

cix = ismember(cl(:,1),color);
    
    

%number of colors limited to 6
cols = zeros(number_of_colors,3);
d = (.8/number_of_colors);
for i = 1:number_of_colors
    cols(i,cl{cix,2})= .2+(d*i);
end

% cols=flipud(cols);

color_matrix = cols;
