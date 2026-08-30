function PlotTracesStacked(trace_matrix,yzero_index)

% if yzero_index is called, the x value at yzero_index is subtracted from each trace

mxtr = max(max(trace_matrix));
mntr = min(min(trace_matrix));

if nargin <2
    yz = zeros(length(trace_matrix(:,1)),1);
else
    yz = trace_matrix(:,yzero_index);
    while any(isnan(yz))
        yzero_index = yzero_index+1;
        if yzero_index>length(trace_matrix(1,:))
            yz = trace_matrix(:,1);
            break
        else
            yz = trace_matrix(:,yzero_index);
        end
    end
end
trace_matrix = trace_matrix-yz;


r = range([mxtr,mntr]);
inc = r/20;

for i = 1:length(trace_matrix(:,1))
    plot(trace_matrix(i,:)+(i*inc))
    hold on
end


