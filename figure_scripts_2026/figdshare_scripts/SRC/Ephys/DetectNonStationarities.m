function [pvalue,NS]=DetectNonStationarities(tn,T)
% Test for nonstationarity detection in a spike train.
%
% Code taken from SI of:
% Gourévitch & Eggermont 2007. 
% A simple indicator of nonstationarity of firing rate in spike trains.
% J. Neuro. Volume 163, Issue 1, 15 June 2007, Pages 181-187
% https://doi.org/10.1016/j.jneumeth.2007.02.021
%  
%
%USE : [pvalue,test_times]=ns_detect(tn,T)
%
%INPUT :  tn - spike times
%         T - length of recording
%
%OUTPUT : pvalue - pvalue of the test
%         NS - surprise statistic
 
%% Checking input
if nargin<2
    error('Second argument missing. Please, specify T');
end
 
%% Statistics and outputs
Zn=tn(:)/T;
 
if Zn(end)>=1
    error('T must be strictly greater than the time arrival of the last spike');
end
 
N=length(Zn);
 
AN=-N-1/N*(2*(1:N)-1)*log(Zn.*(1-Zn(end:-1:1)));
pvalue=1-ADinf(AN);
if pvalue<10^-5
    warning('pvalue<10^-5,limit of accuracy exceeded, pvalue and NS values may not be precise');
end
NS=-log(pvalue);
 
% %% Utility - AN Cumulative distribution function computation
% function [val]=ADinf(AN)
% %Cumulative distribution function computation for the Anderson Darling statistics
% %Values from Marsaglia G, Marsaglia J. Evaluating the Anderson-Darling Distribution.
% %J. of Stat. Soft., 2004; 9(2):1-5.
% if AN<2
%     val=1/sqrt(AN)*exp(-1.2337141/AN)*(2.00012+(0.247105-(0.0649821-(0.0347962-...
% 	(0.0116720-0.00168691*AN)*AN)*AN)*AN)*AN);
% else
%     val=exp(-exp(1.0776-(2.30695-(0.43424-(0.082433-(0.008056-...
% 	0.0003146*AN)*AN)*AN)*AN)*AN));
% end
% 
% 
% 
% 
