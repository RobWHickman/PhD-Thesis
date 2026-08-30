function xticklabels_from_array(array)
% makes array into string and labels ticks

xtl = num2cell(array);
xtl_cell= cellfun(@num2str,xtl,'UniformOutput',false);
xticklabels(xtl_cell);
