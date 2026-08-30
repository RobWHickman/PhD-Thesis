function dioObject = ModigCreateDio(type)
% dioObject = ModigCreateDio(type)
% 
% in: type, has to be a char either 'in' or 'out'
% out: dio object with lines
%

% RBM 05.07
%     09.07 double setup arrangement 
%     01.08 set for handshake wiring

if nargin == 0,
     warning('MODIG:MoCrDio','No dio created-->lack of input')
     return
end

% Create DIO object
dio = digitalio('nidaq','Dev1');

switch type
    case 'in'
        behavIn1 = addline(dio, 0:7, 1, 'In');
        behavIn2 = addline(dio, 0:7, 2, 'In');
        
        set(behavIn1(2),'LineName','KT1')
        set(behavIn1(4),'LineName','KT2')
        
        set(behavIn1(8),'LineName','HandShakeIn')
        set(behavIn2, 'LineName', 'dirConnIn')
        
        dio.Tag = 'ModigInputDio';
    case 'out'
        behavOut = addline(dio, 0:31, 0,'Out');
        
        set(behavOut(5),'LineName', 'Juice1')
        set(behavOut(6),'LineName', 'Juice2')
        set(behavOut(25:32), 'LineName', 'dirConnOut');
        set(behavOut(23),'LineName', 'HardTriggerOut')
        set(behavOut(24),'LineName', 'HandShakeOut')

        dio.Tag = 'ModigOutputDio';     
    otherwise
        warning('MODIG:MoCrDio','No lines added, input not recognized')
end
dioObject = dio;