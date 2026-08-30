function GUI_Logit(Currency,Rewards,Choices,ID,Mode,handles)

global TP TG

WaterMax = TP.BCb.WaterMax;

IX = Rewards == ID;

Currency = Currency(IX);
Choices  = Choices(IX);

CurrencyVals = unique(Currency);

if strcmp(Mode,'NoDom')
    CurrencyVals = CurrencyVals(CurrencyVals < WaterMax - 0.01);
end

RS      = zeros(length(CurrencyVals),4);

for k = 1:length(CurrencyVals)

    CurrVal     = CurrencyVals(k);                      % Select a single water volume to parse the data by.
    W_Index     = 0.01 > abs(Currency - CurrVal);       % Index for a given water volume.
    W_Choice    = Choices(W_Index);                     % Choices at a given water volume.
    n_Offers    = length(W_Choice);
    n_ChoseB    = sum(W_Choice == 1);                   % The number of times that a bundle was chosen.
    n_ChoseW    = sum(W_Choice == 2);                   % The number of times that only water was chosen.

    RS(k,1)     = CurrVal;
    RS(k,2)     = n_Offers;
    RS(k,3)     = n_ChoseW;
    RS(k,4)     = n_ChoseB;

end

% Get relevant data:
WaterVols   = RS(:,1)';
ChoseBundle = RS(:,4);
nOffers     = RS(:,2);
Proportion  = ChoseBundle./nOffers;
WaterVol    = linspace(WaterVols(1),WaterVols(end),1000); % Renders fits as smooth lines.

% Generate Logistic GLM:
[LogitCoef, LogitDev, LogitStat]   = glmfit(WaterVols,[ChoseBundle nOffers], 'binomial', 'link', 'logit');
[LogitFit, CFLo, CFHi]             = glmval(LogitCoef, WaterVol, 'logit', LogitStat);

CFHi            = LogitFit + CFHi;
CFLo            = LogitFit - CFLo;
ValueEstimate   = -LogitCoef(1)/LogitCoef(2);

StandardDev     = (1/LogitCoef(2))*1.6; % Standard deviation by approximating a normal distribution?

% Get CFLo/Hi for indifference point:
[~, CFHiIX]     = min(abs(CFHi - 0.5));
[~, CFLoIX] 	= min(abs(CFLo - 0.5));

CFHiEstimate    = WaterVol(CFHiIX);
CFLoEstimate    = WaterVol(CFLoIX);

Range           = abs(CFLoEstimate - CFHiEstimate);

InferredBid     = WaterMax - ValueEstimate;

if isfield(TG.BDM_BC_GUI.Handles,'BCb_LogAn')
    delete(TG.BDM_BC_GUI.Handles.BCb_LogAn)
end

TG.BDM_BC_GUI.Handles.BCb_LogAn = plot(handles.BCb_Logit, WaterVols, Proportion, 'bs', WaterVol, LogitFit, 'b-', WaterVol, CFHi, 'r-', WaterVol, CFLo, 'r-');
xlabel('Water offered in bundle'); ylabel('Proportion of bundle choice');
legend('Data','Logit model', 'Confidence Intervals', 'Location', 'northwest');

handles.BCb_Logit_Value.String = num2str(ValueEstimate, '%.3g');
handles.BCb_Logit_Range.String = num2str(Range, '%.3g');
handles.BCb_Logit_Std.String   = num2str(StandardDev, '%.3g');
handles.BCb_Logit_CIH.String   = num2str(CFHiEstimate, '%.3g');
handles.BCb_Logit_CIL.String   = num2str(CFLoEstimate, '%.3g');
handles.BCb_Logit_InferredBid.String   = num2str(InferredBid, '%.3g');