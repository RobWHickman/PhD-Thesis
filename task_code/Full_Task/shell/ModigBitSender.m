function  ModigBitSender(lines, values)
% ModigBitSender(lines, values)
%
%   changes the state of the 'lines' to that of the 'value' in the
%   ExtDevice.outputDio
%

% rbm 01.08
global ExtDevice

if length(lines) ~= length(values)
    error('inputs: lines and values need to be the same length')
end

% read port values
bitVec = getvalue(ExtDevice.outputDio);

% generate new vector replacing the values in the lines
bitVec(lines) = values;

% issue the new value
putvalue(ExtDevice.outputDio, bitVec)
