function x = centralmovavg(tseries,n)

x = NaN.*ones(length(tseries),1);

if (rem(n,2) == 1)
    n1 = floor(n/2)+1;
    n2 = floor(n/2);
    for j = n1:length(tseries)-n2
        x(j,1) = mean(tseries(j-n2:j+n2));
    end
end

if (rem(n,2) == 0)
    n1 = n/2;
    for j = n1:length(tseries)-n1
        x(j,1) = mean(tseries(j-n1:j+n1));
    end
end