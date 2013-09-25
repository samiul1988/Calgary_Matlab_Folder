function E = EntropyEstimationHist(input)   
[h x] = hist(input,min([max([0.1*length(input),10]),50]));

zero = find(h == 0);
for k = 1:length(zero)
%     h(zero(k)) = 1;
h(zero(k)) = [];
end

h = h/sum(h);
step = x(2)-x(1);
E = log(step)-sum(h.*log(h));