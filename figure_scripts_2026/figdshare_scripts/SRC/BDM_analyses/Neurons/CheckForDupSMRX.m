db = DropboxDir;

pd = [db,'Schultz_Lab\BDM_Data\Vicer_data\'];
% pd = [db,'Schultz_Lab\BDM_Data\Uly_Data\'];

dpd = dir([pd,'*_M7*']);
pdn = {dpd.name};
%%
for iPd= 1:length(pdn)
    fn = ls([pd,pdn{iPd},'\*.smrx']);
    if length(fn(:,1))>1
        disp([pd,pdn{iPd}])
        disp(fn)
    end
end

%% remove stupid icon file from google 
% 
% for iPd= 1:length(pdn)
%     fn = ls([pd,pdn{iPd},'\*.ini']);
%     if ~isempty(fn)
%         delete([pd,pdn{iPd},'\',fn])
%     end
% end