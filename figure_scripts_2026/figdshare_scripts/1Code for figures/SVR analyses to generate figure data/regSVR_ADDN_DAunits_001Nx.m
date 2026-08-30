clear all hidden,  close all hidden,  clc

disc = 'c';

% load the data
load('Ulysses_SVM_data_FiringRates_FxdWind_180-340ms.mat')
DAunits     = [ 5     9    15    16    20    23    24    25    32    33    34    35    36    37    44    45    46    47    50    56    57    58    59    60    64    65    66    67    68    72    73    74    75    76    77    83    87    88    89    90    91    99   100   101   106   107   108   109   110   111   112   113   114   115   116   117   118   119   120   124   125   126   127   130   137   138   139   140   141   142   143   144   145   146   147   148   149   152   153   154   155   156   157   158   159   160   161   162   163   164   165   166   167   168   169   170   171   172   173   174   175   176   177   178   179   181   182   183   184   185   186   187   191   192   193   194   195   196   197   198   203   211   212];

TRIAL_NUMBER  = 10  % number of trials within the same bid range used for regression
ADD_N         = 1
ADD_repeat    = 100
RANDOM_repeat = 3

WW = {};

for ADDN=1:ADD_repeat
disp(['---------------------------------------------------------------------------------------   ADDN = ', num2str(ADDN) ' # ' num2str(ADD_repeat)]);

% run to the number of time windows, this data has 1 window
for win=1:size(data2{1},2)

for repeats=1:RANDOM_repeat %:100

groups = data1(DAunits);
rates = data2(DAunits);

% create ten cell matrices with size [nr_of_neurons x 1] each
% each cell matrix G01 G02 ... contains at each cell indices to bid ranges  0.0-0.1  0.1-0.2  0.2-0.3  0.3-0.4  ...  0.9-1.0
% each cell in cell matrix G01 G02 ... corresponds to single neuron
clear  S  G01  G02  G03  G04  G05  G06  G07  G08  G09  G10
for S=1:size(rates,1) % run up to the number of neurons
    G01{S,1} = find( groups{S,1} > 0.0  &  groups{S,1} <= 0.1 );
    G02{S,1} = find( groups{S,1} > 0.1  &  groups{S,1} <= 0.2 );
    G03{S,1} = find( groups{S,1} > 0.2  &  groups{S,1} <= 0.3 );
    G04{S,1} = find( groups{S,1} > 0.3  &  groups{S,1} <= 0.4 );
    G05{S,1} = find( groups{S,1} > 0.4  &  groups{S,1} <= 0.5 );
    G06{S,1} = find( groups{S,1} > 0.5  &  groups{S,1} <= 0.6 );
    G07{S,1} = find( groups{S,1} > 0.6  &  groups{S,1} <= 0.7 );
    G08{S,1} = find( groups{S,1} > 0.7  &  groups{S,1} <= 0.8 );
    G09{S,1} = find( groups{S,1} > 0.8  &  groups{S,1} <= 0.9 );
    G10{S,1} = find( groups{S,1} > 0.9  &  groups{S,1} <= 10.0 );
end

% find neurons with missing categories
n01=[]; n02=[]; n03=[]; n04=[]; n05=[]; n06=[]; n07=[]; n08=[]; n09=[]; n10=[];
for S=1:size(rates,1) % run up to the number of neurons
if( isempty(G01{S,1} )),  n01 = [n01  S];  end
if( isempty(G02{S,1} )),  n02 = [n02  S];  end
if( isempty(G03{S,1} )),  n03 = [n03  S];  end
if( isempty(G04{S,1} )),  n04 = [n04  S];  end
if( isempty(G05{S,1} )),  n05 = [n05  S];  end
if( isempty(G06{S,1} )),  n06 = [n06  S];  end
if( isempty(G07{S,1} )),  n07 = [n07  S];  end
if( isempty(G08{S,1} )),  n08 = [n08  S];  end
if( isempty(G09{S,1} )),  n09 = [n09  S];  end
if( isempty(G10{S,1} )),  n10 = [n10  S];  end
end
U = unique([n01 n02 n03 n04 n05 n06 n07 n08 n09 n10])
W = setdiff(1:size(rates,1),U)

% take the number of neurons we use for ADD Neuron analysis
W = W( randperm(size(W,2), ADD_N) )
WW{repeats,win,ADDN} = W;

groups = groups(W);
rates = rates(W);

% AGAIN the same
clear  S  G01  G02  G03  G04  G05  G06  G07  G08  G09  G10
for S=1:size(rates,1) % run up to the number of neurons
    G01{S,1} = find( groups{S,1} > 0.0  &  groups{S,1} <= 0.1 );
    G02{S,1} = find( groups{S,1} > 0.1  &  groups{S,1} <= 0.2 );
    G03{S,1} = find( groups{S,1} > 0.2  &  groups{S,1} <= 0.3 );
    G04{S,1} = find( groups{S,1} > 0.3  &  groups{S,1} <= 0.4 );
    G05{S,1} = find( groups{S,1} > 0.4  &  groups{S,1} <= 0.5 );
    G06{S,1} = find( groups{S,1} > 0.5  &  groups{S,1} <= 0.6 );
    G07{S,1} = find( groups{S,1} > 0.6  &  groups{S,1} <= 0.7 );
    G08{S,1} = find( groups{S,1} > 0.7  &  groups{S,1} <= 0.8 );
    G09{S,1} = find( groups{S,1} > 0.8  &  groups{S,1} <= 0.9 );
    G10{S,1} = find( groups{S,1} > 0.9  &  groups{S,1} <= 10.0 );
end


% fill the missing elements with repeated values
for S=1:size(rates,1) % run up to the number of neurons

    for P=1:TRIAL_NUMBER
        if( P > size(G01{S,1},1) )
            %G01{S,1}(P,1) = NaN;  G01{S,1}(:,1)
            missing = TRIAL_NUMBER - size(G01{S,1},1)
            % generates values in range '1:size(G01{S,1},1)' and pickups randomly 'missing' numbers from that range '1:size(G01{S,1},1)'
            % 'missing' may be higher than '1:size(G01{S,1},1)'
            new_vals = G01{S,1}(  randi(size(G01{S,1},1), 1, missing)  )
            %new_vals = G01{S,1}(  randi([min(G01{S,1}) max(G01{S,1})], 1, missing) ) 
            G01{S,1}(size(G01{S,1}+1,1)+1:TRIAL_NUMBER, 1) = new_vals
        end
        
        if( P > size(G02{S,1},1) )
            %G01{S,1}(P,1) = NaN;  G01{S,1}(:,1)
            missing = TRIAL_NUMBER - size(G02{S,1},1)
            % generates values in range '1:size(G01{S,1},1)' and pickups randomly 'missing' numbers from that range '1:size(G01{S,1},1)'
            % 'missing' may be higher than '1:size(G01{S,1},1)'
            new_vals = G02{S,1}(  randi(size(G02{S,1},1), 1, missing)  )
            %new_vals = G02{S,1}(  randi([min(G02{S,1}) max(G02{S,1})], 1, missing) ) 
            G02{S,1}(size(G02{S,1}+1,1)+1:TRIAL_NUMBER, 1) = new_vals
        end
        
        if( P > size(G03{S,1},1) )
            %G01{S,1}(P,1) = NaN;  G01{S,1}(:,1)
            missing = TRIAL_NUMBER - size(G03{S,1},1)
            % generates values in range '1:size(G01{S,1},1)' and pickups randomly 'missing' numbers from that range '1:size(G01{S,1},1)'
            % 'missing' may be higher than '1:size(G01{S,1},1)'
            new_vals = G03{S,1}(  randi(size(G03{S,1},1), 1, missing)  )
            %new_vals = G03{S,1}(  randi([min(G03{S,1}) max(G03{S,1})], 1, missing) ) 
            G03{S,1}(size(G03{S,1}+1,1)+1:TRIAL_NUMBER, 1) = new_vals
        end

        if( P > size(G04{S,1},1) )
            %G01{S,1}(P,1) = NaN;  G01{S,1}(:,1)
            missing = TRIAL_NUMBER - size(G04{S,1},1)
            % generates values in range '1:size(G01{S,1},1)' and pickups randomly 'missing' numbers from that range '1:size(G01{S,1},1)'
            % 'missing' may be higher than '1:size(G01{S,1},1)'
            new_vals = G04{S,1}(  randi(size(G04{S,1},1), 1, missing)  )
            %new_vals = G04{S,1}(  randi([min(G04{S,1}) max(G04{S,1})], 1, missing) ) 
            G04{S,1}(size(G04{S,1}+1,1)+1:TRIAL_NUMBER, 1) = new_vals
        end
        
        if( P > size(G05{S,1},1) )
            %G01{S,1}(P,1) = NaN;  G01{S,1}(:,1)
            missing = TRIAL_NUMBER - size(G05{S,1},1)
            % generates values in range '1:size(G01{S,1},1)' and pickups randomly 'missing' numbers from that range '1:size(G01{S,1},1)'
            % 'missing' may be higher than '1:size(G01{S,1},1)'
            new_vals = G05{S,1}(  randi(size(G05{S,1},1), 1, missing)  )
            %new_vals = G04{S,1}(  randi([min(G04{S,1}) max(G04{S,1})], 1, missing) ) 
            G05{S,1}(size(G05{S,1}+1,1)+1:TRIAL_NUMBER, 1) = new_vals
        end
        
        if( P > size(G06{S,1},1) )
            %G01{S,1}(P,1) = NaN;  G01{S,1}(:,1)
            missing = TRIAL_NUMBER - size(G06{S,1},1)
            % generates values in range '1:size(G01{S,1},1)' and pickups randomly 'missing' numbers from that range '1:size(G01{S,1},1)'
            % 'missing' may be higher than '1:size(G01{S,1},1)'
            new_vals = G06{S,1}(  randi(size(G06{S,1},1), 1, missing)  )
            %new_vals = G04{S,1}(  randi([min(G04{S,1}) max(G04{S,1})], 1, missing) ) 
            G06{S,1}(size(G06{S,1}+1,1)+1:TRIAL_NUMBER, 1) = new_vals
        end
        
        if( P > size(G07{S,1},1) )
            %G01{S,1}(P,1) = NaN;  G01{S,1}(:,1)
            missing = TRIAL_NUMBER - size(G07{S,1},1)
            % generates values in range '1:size(G01{S,1},1)' and pickups randomly 'missing' numbers from that range '1:size(G01{S,1},1)'
            % 'missing' may be higher than '1:size(G01{S,1},1)'
            new_vals = G07{S,1}(  randi(size(G07{S,1},1), 1, missing)  )
            %new_vals = G04{S,1}(  randi([min(G04{S,1}) max(G04{S,1})], 1, missing) ) 
            G07{S,1}(size(G07{S,1}+1,1)+1:TRIAL_NUMBER, 1) = new_vals
        end

        if( P > size(G08{S,1},1) )
            %G01{S,1}(P,1) = NaN;  G01{S,1}(:,1)
            missing = TRIAL_NUMBER - size(G08{S,1},1)
            % generates values in range '1:size(G01{S,1},1)' and pickups randomly 'missing' numbers from that range '1:size(G01{S,1},1)'
            % 'missing' may be higher than '1:size(G01{S,1},1)'
            new_vals = G08{S,1}(  randi(size(G08{S,1},1), 1, missing)  )
            %new_vals = G04{S,1}(  randi([min(G04{S,1}) max(G04{S,1})], 1, missing) ) 
            G08{S,1}(size(G08{S,1}+1,1)+1:TRIAL_NUMBER, 1) = new_vals
        end

        if( P > size(G09{S,1},1) )
            %G01{S,1}(P,1) = NaN;  G01{S,1}(:,1)
            missing = TRIAL_NUMBER - size(G09{S,1},1)
            % generates values in range '1:size(G01{S,1},1)' and pickups randomly 'missing' numbers from that range '1:size(G01{S,1},1)'
            % 'missing' may be higher than '1:size(G01{S,1},1)'
            new_vals = G09{S,1}(  randi(size(G09{S,1},1), 1, missing)  )
            %new_vals = G04{S,1}(  randi([min(G04{S,1}) max(G04{S,1})], 1, missing) ) 
            G09{S,1}(size(G09{S,1}+1,1)+1:TRIAL_NUMBER, 1) = new_vals
        end

        if( P > size(G10{S,1},1) )
            %G01{S,1}(P,1) = NaN;  G01{S,1}(:,1)
            missing = TRIAL_NUMBER - size(G10{S,1},1)
            % generates values in range '1:size(G01{S,1},1)' and pickups randomly 'missing' numbers from that range '1:size(G01{S,1},1)'
            % 'missing' may be higher than '1:size(G01{S,1},1)'
            new_vals = G10{S,1}(  randi(size(G10{S,1},1), 1, missing)  )
            %new_vals = G04{S,1}(  randi([min(G04{S,1}) max(G04{S,1})], 1, missing) ) 
            G10{S,1}(size(G10{S,1}+1,1)+1:TRIAL_NUMBER, 1) = new_vals
        end
    end
end


% create ten cell matrices G01_permutation G02_permutation ... G03_permutation with size [nr_of_neurons x 1], 
% each of ten cell matrices G01_permutation G02_permutation ... G03_permutation contains 'TRIAL_NUMBER' randpermutted  indices to groups 1 2 3 4 ... 10
%
clear  S  G01_permutation  G02_permutation  G03_permutation  G04_permutation  G05_permutation  G06_permutation  G07_permutation  G08_permutation  G09_permutation  G10_permutation
for S=1:size(rates,1) % run up to the number of neurons
rng('default');rng('shuffle');   G01_permutation{S,1} = G01{S,1}( randperm(size(G01{S,1},1), TRIAL_NUMBER) );
rng('default');rng('shuffle');   G02_permutation{S,1} = G02{S,1}( randperm(size(G02{S,1},1), TRIAL_NUMBER) );
rng('default');rng('shuffle');   G03_permutation{S,1} = G03{S,1}( randperm(size(G03{S,1},1), TRIAL_NUMBER) );
rng('default');rng('shuffle');   G04_permutation{S,1} = G04{S,1}( randperm(size(G04{S,1},1), TRIAL_NUMBER) );
rng('default');rng('shuffle');   G05_permutation{S,1} = G05{S,1}( randperm(size(G05{S,1},1), TRIAL_NUMBER) );
rng('default');rng('shuffle');   G06_permutation{S,1} = G06{S,1}( randperm(size(G06{S,1},1), TRIAL_NUMBER) );
rng('default');rng('shuffle');   G07_permutation{S,1} = G07{S,1}( randperm(size(G07{S,1},1), TRIAL_NUMBER) );
rng('default');rng('shuffle');   G08_permutation{S,1} = G08{S,1}( randperm(size(G08{S,1},1), TRIAL_NUMBER) );
rng('default');rng('shuffle');   G09_permutation{S,1} = G09{S,1}( randperm(size(G09{S,1},1), TRIAL_NUMBER) );
rng('default');rng('shuffle');   G10_permutation{S,1} = G10{S,1}( randperm(size(G10{S,1},1), TRIAL_NUMBER) );
end


% create matrix for training 10x'[TRIAL_NUMBER x nr_of_neurons]', i.e. WINDOW_DATA[10*TRIAL_NUMBER x nr_of_neurons]
% creat matrix for training  10x'[TRIAL_NUMBER x nr_of_neurons]', i.e. GROUP_DATA [10*TRIAL_NUMBER x nr_of_neurons]
% at every run of the 'repeats=100' iteration and next 'win' iteration we create two matrices as below
% A=(A(~isnan(A)));
clear  WINDOW_DATA  GROUP_DATA  S
for S=1:size(rates,1) % run up to the number of neurons
    WINDOW_DATA(:,S) = [rates{S,1}(G01_permutation{S,1},win);  rates{S,1}(G02_permutation{S,1},win);  rates{S,1}(G03_permutation{S,1},win);  rates{S,1}(G04_permutation{S,1},win);  rates{S,1}(G05_permutation{S,1},win);  rates{S,1}(G06_permutation{S,1},win);  rates{S,1}(G07_permutation{S,1},win);  rates{S,1}(G08_permutation{S,1},win);  rates{S,1}(G09_permutation{S,1},win);  rates{S,1}(G10_permutation{S,1},win) ];
    GROUP_DATA(:,S)  = [groups{S,1}(G01_permutation{S,1},1);   groups{S,1}(G02_permutation{S,1},1);   groups{S,1}(G03_permutation{S,1},1);   groups{S,1}(G04_permutation{S,1},1);   groups{S,1}(G05_permutation{S,1},1);   groups{S,1}(G06_permutation{S,1},1);   groups{S,1}(G07_permutation{S,1},1);   groups{S,1}(G08_permutation{S,1},1);   groups{S,1}(G09_permutation{S,1},1);   groups{S,1}(G10_permutation{S,1},1) ];
end


clear GROUP_DATA
bid = 0;
for d=1:10
    GROUP_DATA( (d-1)*TRIAL_NUMBER+1:d*TRIAL_NUMBER, 1) = 0.05 + bid
    bid = bid + 0.1;
end


% WINDOW_DATA = WINDOW_DATA(:,1:100);
% GROUP_DATA = mean(GROUP_DATA(1:10,1),2); % take the first column only
clear  Mdl  Mdl_shuf  thisPoint  thisGroup  allOtherPoints  allOtherGroups  p  SVR  SVR_shuff  YFit
rng('default'); rng('shuffle');   GROUP_DATA_SHUFF = GROUP_DATA( randperm(size(GROUP_DATA,1)) , 1);
nPoints = size(WINDOW_DATA,1) / 10; % because we use 90% training vs 10% testing of the data
pointMatrix = WINDOW_DATA;  trueGroups = GROUP_DATA_SHUFF;
for p = 1:2:nPoints % iterate over points
% p, 
    % matrix 'thisPoint' contains 1, 11, 21, ... 91 row from training matrix at the first 'p' iteration and so on 
    thisPoint = [pointMatrix(p:p+1, :);                                pointMatrix(1*TRIAL_NUMBER+p:1*TRIAL_NUMBER+p+1, :);  pointMatrix(2*TRIAL_NUMBER+p:2*TRIAL_NUMBER+p+1, :);  pointMatrix(3*TRIAL_NUMBER+p:3*TRIAL_NUMBER+p+1, :); ...
                 pointMatrix(4*TRIAL_NUMBER+p:4*TRIAL_NUMBER+p+1, :);  pointMatrix(5*TRIAL_NUMBER+p:5*TRIAL_NUMBER+p+1, :);  pointMatrix(6*TRIAL_NUMBER+p:6*TRIAL_NUMBER+p+1, :);  pointMatrix(7*TRIAL_NUMBER+p:7*TRIAL_NUMBER+p+1, :); ...
                 pointMatrix(8*TRIAL_NUMBER+p:8*TRIAL_NUMBER+p+1, :);  pointMatrix(9*TRIAL_NUMBER+p:9*TRIAL_NUMBER+p+1, :)  ]
    % column 'thisGroup' contains 1, 11, 21, ... 91 row(single element) from training output column at the first 'p' iteration and so on 
    thisGroup = [trueGroups(p:p+1);                                    trueGroups(1*TRIAL_NUMBER+p:1*TRIAL_NUMBER+p+1);      trueGroups(2*TRIAL_NUMBER+p:2*TRIAL_NUMBER+p+1);      trueGroups(3*TRIAL_NUMBER+p:3*TRIAL_NUMBER+p+1);  ...
                 trueGroups(4*TRIAL_NUMBER+p:4*TRIAL_NUMBER+p+1);      trueGroups(5*TRIAL_NUMBER+p:5*TRIAL_NUMBER+p+1);      trueGroups(6*TRIAL_NUMBER+p:6*TRIAL_NUMBER+p+1);      trueGroups(7*TRIAL_NUMBER+p:7*TRIAL_NUMBER+p+1);  ...
                 trueGroups(8*TRIAL_NUMBER+p:8*TRIAL_NUMBER+p+1);      trueGroups(9*TRIAL_NUMBER+p:9*TRIAL_NUMBER+p+1) ]

    [ p:p+1;                                1*TRIAL_NUMBER+p:1*TRIAL_NUMBER+p+1;   2*TRIAL_NUMBER+p:2*TRIAL_NUMBER+p+1;  3*TRIAL_NUMBER+p:3*TRIAL_NUMBER+p+1;  4*TRIAL_NUMBER+p:4*TRIAL_NUMBER+p+1;  5*TRIAL_NUMBER+p:5*TRIAL_NUMBER+p+1;  ...
      6*TRIAL_NUMBER+p:6*TRIAL_NUMBER+p+1;  7*TRIAL_NUMBER+p:7*TRIAL_NUMBER+p+1;   8*TRIAL_NUMBER+p:8*TRIAL_NUMBER+p+1;  9*TRIAL_NUMBER+p:9*TRIAL_NUMBER+p+1 ]

    % matrix 'allOtherPoints' contains 2:10 , 12:20 ... 92:100 rows from training matrix at the first 'p' iteration and so on 
    allOtherPoints = [ pointMatrix(0*TRIAL_NUMBER+1:0*TRIAL_NUMBER+p-1, :);   pointMatrix(0*TRIAL_NUMBER+p+2:1*TRIAL_NUMBER, :); ...
                       pointMatrix(1*TRIAL_NUMBER+1:1*TRIAL_NUMBER+p-1, :);   pointMatrix(1*TRIAL_NUMBER+p+2:2*TRIAL_NUMBER, :); ...
                       pointMatrix(2*TRIAL_NUMBER+1:2*TRIAL_NUMBER+p-1, :);   pointMatrix(2*TRIAL_NUMBER+p+2:3*TRIAL_NUMBER, :); ...
                       pointMatrix(3*TRIAL_NUMBER+1:3*TRIAL_NUMBER+p-1, :);   pointMatrix(3*TRIAL_NUMBER+p+2:4*TRIAL_NUMBER, :); ...
                       pointMatrix(4*TRIAL_NUMBER+1:4*TRIAL_NUMBER+p-1, :);   pointMatrix(4*TRIAL_NUMBER+p+2:5*TRIAL_NUMBER, :); ...
                       pointMatrix(5*TRIAL_NUMBER+1:5*TRIAL_NUMBER+p-1, :);   pointMatrix(5*TRIAL_NUMBER+p+2:6*TRIAL_NUMBER, :); ...
                       pointMatrix(6*TRIAL_NUMBER+1:6*TRIAL_NUMBER+p-1, :);   pointMatrix(6*TRIAL_NUMBER+p+2:7*TRIAL_NUMBER, :); ...
                       pointMatrix(7*TRIAL_NUMBER+1:7*TRIAL_NUMBER+p-1, :);   pointMatrix(7*TRIAL_NUMBER+p+2:8*TRIAL_NUMBER, :); ...
                       pointMatrix(8*TRIAL_NUMBER+1:8*TRIAL_NUMBER+p-1, :);   pointMatrix(8*TRIAL_NUMBER+p+2:9*TRIAL_NUMBER, :); ...
                       pointMatrix(9*TRIAL_NUMBER+1:9*TRIAL_NUMBER+p-1, :);   pointMatrix(9*TRIAL_NUMBER+p+2:10*TRIAL_NUMBER, :) ];

    % column 'allOtherGroups' contains 2:10 , 12:20 ... 92:100 rows(single elements) from training output column at the first 'p' iteration and so on 
    allOtherGroups = [ trueGroups(0*TRIAL_NUMBER+1:0*TRIAL_NUMBER+p-1);   trueGroups(0*TRIAL_NUMBER+p+2:1*TRIAL_NUMBER); ...
                       trueGroups(1*TRIAL_NUMBER+1:1*TRIAL_NUMBER+p-1);   trueGroups(1*TRIAL_NUMBER+p+2:2*TRIAL_NUMBER); ...
                       trueGroups(2*TRIAL_NUMBER+1:2*TRIAL_NUMBER+p-1);   trueGroups(2*TRIAL_NUMBER+p+2:3*TRIAL_NUMBER); ...
                       trueGroups(3*TRIAL_NUMBER+1:3*TRIAL_NUMBER+p-1);   trueGroups(3*TRIAL_NUMBER+p+2:4*TRIAL_NUMBER); ...
                       trueGroups(4*TRIAL_NUMBER+1:4*TRIAL_NUMBER+p-1);   trueGroups(4*TRIAL_NUMBER+p+2:5*TRIAL_NUMBER); ...
                       trueGroups(5*TRIAL_NUMBER+1:5*TRIAL_NUMBER+p-1);   trueGroups(5*TRIAL_NUMBER+p+2:6*TRIAL_NUMBER); ...
                       trueGroups(6*TRIAL_NUMBER+1:6*TRIAL_NUMBER+p-1);   trueGroups(6*TRIAL_NUMBER+p+2:7*TRIAL_NUMBER); ...
                       trueGroups(7*TRIAL_NUMBER+1:7*TRIAL_NUMBER+p-1);   trueGroups(7*TRIAL_NUMBER+p+2:8*TRIAL_NUMBER); ...
                       trueGroups(8*TRIAL_NUMBER+1:8*TRIAL_NUMBER+p-1);   trueGroups(8*TRIAL_NUMBER+p+2:9*TRIAL_NUMBER); ...
                       trueGroups(9*TRIAL_NUMBER+1:9*TRIAL_NUMBER+p-1);   trueGroups(9*TRIAL_NUMBER+p+2:10*TRIAL_NUMBER) ];

    Mdl = fitrsvm(allOtherPoints, allOtherGroups, 'Standardize', true, 'KernelFunction', 'linear', 'OptimizeHyperparameters', 'all' );  % gives better results than 'auto' option, but takes longer time
    
    % use the training data for prediction and plot results
    YFit = predict(Mdl, thisPoint);
    SVR_shuf(1:size(YFit,1),p) = thisGroup;  SVR_shuf(1:size(YFit,1),p+1) = YFit;
    
    close all hidden
end % for p = 1:nPoints

% create cell matrix where in columns we have results for time windows
Z_shuf{repeats,win,ADDN} = SVR_shuf;

close all hidden

end % for repeats=1:100
end % for win=1:size(rates{1},2)

end  % for ADDN=1:50


Z = [];
% save interediate data
filename = [ mfilename  '_TN#' sprintf('%03.0f', TRIAL_NUMBER)  '_ADDN#' sprintf('%03.0f', ADD_N) '_ADDR#' sprintf('%03.0f', ADD_repeat) '_RR#' sprintf('%03.0f', RANDOM_repeat) '.mat' ];
save(filename, 'Z', 'Z_shuf', 'TRIAL_NUMBER', 'ADD_N', 'ADD_repeat', 'RANDOM_repeat', 'win', 'WW');







