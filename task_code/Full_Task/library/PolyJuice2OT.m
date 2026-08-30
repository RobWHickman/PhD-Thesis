function [y] = PolyJuice2OT(x)
% x is the desired target quantity in grams.
% y is the corresponding opening time in ms.

p(1) = 1.543419176677325e+02;
p(2) = -2.880800469288017e+02;
p(3) = 3.420665948129260e+02;
p(4) = 15.438403082413881;

y = polyval(p,x);

Reward = x

end

% p(1) = 1.265921466641136e+03;
% p(2) = -2.643969021898722e+03;
% p(3) = 1.886728671723963e+03;
% p(4) = -2.852217178699831e+02;
% p(5) = 18.772504221278457;