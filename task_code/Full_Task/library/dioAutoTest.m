function result = dioAutoTest(dio)
% result = dioAutoTest(dio)
%
% test that the connection between the DAQ card and the screw terminal is
% operational
% Returns 1 if the connection is fully operational, otherwise issues an
% error and returns 0
%
% so far I haven't figures out how to avoid the warning message-->
% Port is not line configurable. All line directions on the port have been
% set

% rbm 01.08
dirChange = 0;

allOnes = ones(1,length(dio.Line));

% if the ports are for input change them to output
if sum(allOnes) == sum(strcmp(dio.Line.direction,'In'))
    dio.line.direction = 'out';
    dirChange = 1; 
end

% test what we are sending
putvalue(dio.Line, allOnes)
realOut = getvalue(dio);
putvalue(dio.Line, allOnes-1)

% revert DIO direction changes if any
if dirChange,
    dio.line.direction = 'in';
end
    
% report any no connections
noConnection = realOut ~= allOnes;
if sum(noConnection)>0
    [x idx] = find(noConnection==1); % bit cumbersome 
    ncLines = dio.line(idx).HwLine;
    ncPort  = dio.Line(idx).Port;
    result = 0;
    error('No DAQ--screw Terminal connection in Line %d @ port %d', ...
        ncLines, ncPort)
else
    result = 1;
end