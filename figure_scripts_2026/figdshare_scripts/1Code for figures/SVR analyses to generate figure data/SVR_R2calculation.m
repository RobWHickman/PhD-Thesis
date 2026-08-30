clear all hidden, close all hidden, clc

% read output file from regSVR_ADDN_DAunits_001N.m
N001 = load('regSVR_ADDN_DAunits_001N_TN#010_ADDN#001_ADDR#100_RR#003.mat')

% read output file from regSVR_ADDN_DAunits_001Nx.m
N001x = load('regSVR_ADDN_DAunits_001Nx_TN#010_ADDN#001_ADDR#100_RR#003.mat')



% --- normal data calculations below ----------------------------------------------------------------------------------------
R2min = -1; R2max = 1;
STD = 0.5;

A1 = N001;  yCalc1N001 = [];  yN001 = [];
for S=1:size(A1.Z,3)
Z = A1.Z(:,:,S);   Z_shuf = A1.Z_shuf;

clear  ZZ  
for a=1:size(Z,1)
x = 0;
    for b=1:10:size(Z{1},1) * size(Z{1},2)/2
    y = 1;  
        for c=1:2:size(Z{1},2)
            ZZ{a,1}(b-1+ y+1-1:b-1+ y+2-1,:) = Z{a,1}(x+1:x+2, c+1-1:c+2-1);
            y = y + 2;
        end  % c
    x = x + 2;
    end  % b

end
Z = ZZ; 

C = [];  D = [];
for a=1:size(Z,1)
    for b=1:size(Z,2)
        C = [C;  Z{a,b}];
        D = [D,  Z{a,b}];
    end
end
clear  yCalc1  y
yCalc1 = C(:,2);    yCalc1N001 = [yCalc1N001; yCalc1];
y = C(:,1);         yN001      = [yN001;      y];

x=y; y=yCalc1;
x2 = x.^2;
y2 = y.^2;
xy = x.*y;
n = size(x,1);
R2 = [  (n*sum(xy) - sum(x)*sum(y) )  /  ( sqrt( n*sum(x2) - (sum(x))^2 ) * sqrt( n*sum(y2) - (sum(y))^2 ) )  ]^2
Rsq1(S,1) = R2;

A1.WW{S};       aaaaaa=1;
end
yCalc1N001(yCalc1N001<-1) = 0;  min(yCalc1N001);
yCalc1N001(yCalc1N001> 1) = 0;  max(yCalc1N001);
RsqN001 = nanmedian(Rsq1);


R2N     = [RsqN001];
yCalc1N = [yCalc1N001];
yN      = [yN001];
yN_diff = yCalc1N - yN;
SVMstructC1vsC2_SD = std(yN_diff);    SVMstructC1vsC2_SEM = std(yN_diff)/sqrt(number_of_neurons);







% --- shuffled data calculations below ----------------------------------------------------------------------------------------
A1 = N001x;  yCalc1N001_shuf = [];  yN001_shuf = [];
for S=1:size(A1.Z_shuf,3)
Z = A1.Z_shuf(:,:,S);

clear  ZZ  
for a=1:size(Z,1)
x = 0;
    for b=1:10:size(Z{1},1) * size(Z{1},2)/2
    y = 1;  
        for c=1:2:size(Z{1},2)
            ZZ{a,1}(b-1+ y+1-1:b-1+ y+2-1,:) = Z{a,1}(x+1:x+2, c+1-1:c+2-1);
            y = y + 2;
        end  % c
    x = x + 2;
    end  % b

end
Z = ZZ;

C = [];  D = [];
for a=1:size(Z,1)
    for b=1:size(Z,2)
        C = [C;  Z{a,b}];
        D = [D,  Z{a,b}];
    end
end
clear  yCalc1  y
yCalc1 = C(:,2);    yCalc1N001_shuf = [yCalc1N001_shuf; yCalc1];
y = C(:,1);         yN001_shuf      = [yN001_shuf;      y];

x=y; y=yCalc1;
x2 = x.^2;
y2 = y.^2;
xy = x.*y;
n = size(x,1);
R2 = [  (n*sum(xy) - sum(x)*sum(y) )  /  ( sqrt( n*sum(x2) - (sum(x))^2 ) * sqrt( n*sum(y2) - (sum(y))^2 ) )  ]^2
Rsq1_shuf(S,1) = R2;

A1.WW{S};       aaaaaa=1;
end
yCalc1N001_shuf(yCalc1N001_shuf<-1) = 0;  min(yCalc1N001_shuf);
yCalc1N001_shuf(yCalc1N001_shuf> 1) = 0;  max(yCalc1N001_shuf);
RsqN001_shuf = nanmedian(Rsq1_shuf);


R2N_shuf     = [RsqN001_shuf];
yCalc1N_shuf = [yCalc1N001_shuf];
yN_shuf      = [yN001_shuf];
yN_diff_shuf = yCalc1N_shuf - yN_shuf;
SVMstructC1vsC2_SD_shuf = std(yN_diff_shuf);    SVMstructC1vsC2_SEM_shuf = std(yN_diff_shuf)/sqrt(number_of_neurons);





