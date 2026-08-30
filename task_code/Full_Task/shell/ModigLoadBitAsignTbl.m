function BitAsign = ModigLoadBitAsignTbl(prj,animal_ID)
% BitAsign = ModigLoadBitAsignTbl(prj,animal_ID)
%   
% Read bit asignment table specific to each prj and each monkey ID.
% Each project needs to have a bit asignment file in 'definition' directory
% The filename is 'BitTbl_XXXX_YYY.mat, where XXXX is subject ID in 
%   4 digits and YYY is a project name, e.g. BitTbl_0053_CAL.mat 
%   
%   In: prj, project name. e.g. CAL /string
%       animal_ID, unique subject identifier /double
%   Out: BitAsign, structure with the following fields: BitAsign = 
%           BitTbl: 
%           BitTblColumn: {'bit_event_name'  'bit_asignment'
%           'initial_value'  'comment'}
%           BitTblColumnID: 
%           prj: 
%           animal_ID: 
%           filename:
%           loaded:
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   RBM 3.04.07 + comments, debugging, error dialog added

global ModigDir
BitTbl_name = strcat(ModigDir.Projects,'\',prj,'\definition\BitTbl_00',...
    num2str(animal_ID),'_',prj,'.mat');
if exist(BitTbl_name,'file')
    load(BitTbl_name);
    BitAsign.BitTbl = BitTbl;
    BitAsign.BitTblColumn = BitTbl(1,:);
    BitAsign.BitTbl(1,:) = [];
    % make a table of title name and column number
    [NumRowTbl NumBitTbl] = feval('size',BitTbl);
    for t_id = 1:NumBitTbl
        str1 = cell2mat(BitAsign.BitTblColumn(t_id));
        blanks = findstr(str1,' ');
        % if space in column name, replace it with underbar
        str1(blanks) = '_'; 
        str = strcat('BitAsign.BitTblColumnID.',str1,'=',num2str(t_id),';');
        eval(str);
    end
    BitAsign.prj        = prj;
    BitAsign.animal_ID  = animal_ID;
    BitAsign.filename   = BitTbl_name;
    BitAsign.loaded     = 1;
else
    BitAsign.loaded = 0;
    warning('%s doesn''t exists. No bits loaded!',BitTbl_name)
end
