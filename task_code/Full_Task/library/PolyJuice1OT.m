function [y] = PolyJuice1OT(x)
% x is the desired target quantity in grams.
% y is the corresponding opening time in ms.


p(1) = 9.187189254318715;
p(2) = -46.073194765154796;
p(3) = 2.246122245065808e+02;
p(4) = 4.923511279381649;

y = polyval(p,x);
    
RiskyWater = x

end