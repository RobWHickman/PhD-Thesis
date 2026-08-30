function runED(a,monitors)
% runED(a,monitors)
%
%  a, if 'e', ON, else 'OFF'
%  monitors, elo ts
%

    if a=='e'
        onoff=1;
    else
        onoff=0;
    end
    
    ED(onoff,monitors);
end