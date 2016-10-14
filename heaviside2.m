function y = heaviside2(x,h)

y = zeros(length(x),1);
for i = 1:length(x)
    if x(i) < h
        y(i) = 0;
    else
        y(i)=1;
        
    end
    
end
