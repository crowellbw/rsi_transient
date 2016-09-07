function [probc1] = kurtsolver(tseries)

a1 = find(tseries >= 50);
a2 = find(tseries <= 50);

[sortpos,indpos] = sort(abs(tseries(a1)-50));
[sortneg,indneg] = sort(abs(tseries(a2)-50));

kurtpos = zeros(length(sortpos),1);
kurtneg = zeros(length(sortneg),1);

if (length(sortpos) > 200)
    for i = 200:length(sortpos)
        kurtpos(i,1) = kurtosis(sortpos(1:i));
    end
end
if (length(sortneg) >200)
    for i = 200:length(sortneg)
        kurtneg(i,1) = kurtosis(sortneg(1:i));
    end
end


cdfnegc1 = 0.5.*(1+erf((kurtneg-4.694643)./0.31845./sqrt(2)));
cdfposc1 = 0.5.*(1+erf((kurtpos-4.694643)./0.31845./sqrt(2)));
%cdfnegc2 = 0.5.*(1+erf((kurtneg-3.219936)./0.119518./sqrt(2)));
%cdfposc2 = 0.5.*(1+erf((kurtpos-3.219936)./0.119518./sqrt(2)));

probc1 = zeros(length(tseries),1);
%probc2 = zeros(length(tseries),1);

for i = 1:length(a1)
    aa = indpos(i);
    probc1(a1(aa),1) = cdfposc1(i);
    %probc2(a1(aa),1) = cdfposc2(i);
end

for i = 1:length(a2)
    aa = indneg(i);
    probc1(a2(aa),1) = -cdfnegc1(i);
    %probc2(a2(aa),1) = -cdfnegc2(i);
end
