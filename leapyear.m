function [f] = leapyear(year)

f = 0;

if (mod(year,4) == 0 && mod(year,100) ~= 0)
    f = 1;
end

if (mod(year,400) == 0)
    f = 1;
end
