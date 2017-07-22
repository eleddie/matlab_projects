function [p] = lagrange(xVals, yVals)
syms x p(x);
p = x-x;
for i = 1 : length(xVals)
    num = 1; den = 1;
    for j = 1 : length(xVals)
        if i ~= j
            num = num * (x - xVals(j));
            den = den * (xVals(i) - xVals(j));
        end
    end
    p = p + yVals(i) * num / den;
end
end