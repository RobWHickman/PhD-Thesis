function [MMStr] = GenMMarker(YPos)
% VECTORISE THIS
global TO TP VisParam

s_WindowNumber = num2str(VisParam.scr_handle);

Range   = TO.Params.BDM.BarRange;
MinPoint= TO.Params.BDM.BarMin; % Smallest value;
MMPos   = TO.Rewards.Water.BDM.MMDefPos;

YMod    = YPos - MinPoint;
YRel    = 1- (YMod/Range);

if YRel >= 0 && YRel < 0.125
    MMPos([2 4]) = MMPos([2 4]) - (0.125*Range);
    TP.BDM.MBID = 0.125;
elseif YRel >= 0.125 && YRel < 0.25;
    MMPos([2 4]) = MMPos([2 4]) - (0.25*Range);
    TP.BDM.MBID = 0.25;
elseif YRel >= 0.25 && YRel < 0.375;
    MMPos([2 4]) = MMPos([2 4]) - (0.375*Range);
    TP.BDM.MBID = 0.375;
elseif YRel >= 0.375 && YRel < 0.5;
    MMPos([2 4]) = MMPos([2 4]) - (0.5*Range);
    TP.BDM.MBID = 0.5;
elseif YRel >= 0.5 && YRel < 0.625;
    MMPos([2 4]) = MMPos([2 4]) - (0.625*Range);
    TP.BDM.MBID = 0.625;
elseif YRel >= 0.625 && YRel < 0.75;
    MMPos([2 4]) = MMPos([2 4]) - (0.75*Range);
    TP.BDM.MBID = 0.75;
elseif YRel >= 0.75 && YRel < 0.875;
    MMPos([2 4]) = MMPos([2 4]) - (0.875*Range);
    TP.BDM.MBID = 0.875;
elseif YRel >= 0.875 && YRel <= 1;
    MMPos([2 4]) = MMPos([2 4]) - Range;
    TP.BDM.MBID = 1;
end

MMCol = num2str(TO.Rewards.Water.BDM.MMOnColor);
MMPos = num2str(MMPos);

MMStr = strcat('Screen(''FillRect'',[',s_WindowNumber,'], [',MMCol,'], [',MMPos,']);');