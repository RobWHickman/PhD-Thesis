function [dbDir] = DropboxDir

if exist('D:\Dropbox\')==7
    dbDir = 'D:\Dropbox\';
elseif exist('C:\Users\dfhil\Dropbox\')
    dbDir = 'C:\Users\dfhil\Dropbox\';
elseif exist('C:\Users\hilld\Dropbox\')
    dbDir = 'C:\Users\hilld\Dropbox\';
end