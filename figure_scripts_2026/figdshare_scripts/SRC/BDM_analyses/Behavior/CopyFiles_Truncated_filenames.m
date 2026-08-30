
pd = 'C:\Users\dfhil\Dropbox\Schultz_Lab\Ulysses\BX\AllCompactBx\';
pdNew = 'C:\Users\dfhil\Dropbox\Schultz_Lab\Ulysses\BX\AllCompactBxTrunc\';


fn = ls([pd,'*COMP*']);

for i = 1:length(fn(:,1))
    finam = fn(i,:);
    
    fl = ([pd,finam]);
    flNew = [pdNew,finam(5:end)];
    copyfile(fl,flNew,'f')
end

