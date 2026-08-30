function y = ModigVisDistConvert(pos, unit1,unit2)
% convert between mm, pixel, and viusal angle (degree, not radian)

% coded by skoba (skoba-tky@umin.ac.jp) 8 June 2005
% last modified by skoba 8 June 2005
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% convert visual distance in unit 1 into unit 2.
% pixel -> degree
% pixel -> mm
% mm -> degree
% mm -> pixel
% degree -> mm
% degree -> pixel

global VisParam
% convert into mm first
if length(pos)==1
    switch unit1
        case 'pixel'
            buf_mm = pos * VisParam.scr_width_mm / VisParam.scr_width_pix;
        case 'mm'
            buf_mm = pos;
        case 'degree'
            buf_mm = tan(pos *pi/180)*VisParam.view_dist;
        otherwise
            errordlg('second argument has to be either pixel,mm, or degree');return
    end
elseif length(pos)==2
    switch unit1
        case 'pixel'
            buf_mm = sqrt((pos(1) * VisParam.scr_width_mm / VisParam.scr_width_pix)^2 + (pos(2) * VisParam.scr_width_mm / VisParam.scr_width_pix)^2);
        case 'mm'
            buf_mm = sqrt(pos(1)^2 + pos(2)^2);
        case 'degree'
            buf_mm = sqrt((tan(pos(1) * pi/180) * VisParam.view_dist)^2 + (tan(pos(2) * pi/180) * VisParam.view_dist)^2);
        otherwise
            errordlg('second argument has to be either pixel,mm, or degree');return
    end
end
% convert mm into degree
buf_deg=atan(buf_mm/VisParam.view_dist) *180/pi; 
switch unit2
    case 'pixel'
        y = buf_mm * VisParam.scr_width_pix / VisParam.scr_width_mm;
    case 'mm'
        y = buf_mm;
    case 'degree'
        y = buf_deg;
    otherwise
        errordlg('third argument has to be either pixel,mm, or degree');
        return
end