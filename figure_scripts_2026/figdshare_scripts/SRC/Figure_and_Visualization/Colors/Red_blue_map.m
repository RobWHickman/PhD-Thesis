

%  intt = 0:.01:1;
 
 r = [171,5,32]/255;
 b = [12,35,75]/255;
 
 
 %%
 % rr = 0:.008:.8;
% gg = 0:.002:.2;
% b = 0.2:.002:.4;
% bb = flip(b);
 r = .0471:.006235:.6706;
 rr = flip(r);
 gg = .0196:.001177:.1373;
 bb = 0.1255:.001686:.2941;
 
map = [rr; gg; bb];

 
 %%
% rr = intt;
% g = zeros(1,length(intt));
% bb = flip(intt);

map = [rr, gg, bb];
map=map';

