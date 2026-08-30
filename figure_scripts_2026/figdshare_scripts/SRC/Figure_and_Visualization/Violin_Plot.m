function Violin_Plot(M,dist,group_ix)
%%
[r,c] = size(M);

if nargin<2
    dist = 'Kernel';
end
if nargin<3
    group_ix = ones(c,1);
end 
   
num_groups = max(group_ix);

for iV = 1:num_groups
    for i = 1:(c/num_groups)
        
    
    
    pd = fitdist(d,dist);

x = 0:.001:1;
y = pdf(pd,x);
plot(x,y)
hold on
ejs =[0:.1:1];
histogram(d,ejs,'Normalization','pdf','FaceAlpha',.2)

end
end
