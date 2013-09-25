MyData = [1 3 2 1 2 1 1 3 1 1 2]';
MyData = [1 0 2 9]';
UniqueMyData = unique(MyData)
nUniqueMyData = length(UniqueMyData)
FreqMyData = zeros(nUniqueMyData,1);
for i = 1:nUniqueMyData
    FreqMyData(i) = sum(double(MyData == UniqueMyData(i)));
end

%%

% X = [1 0 2 9]';
X = [4 4 4 4]';
% Establish size of data
[n m] = size(X);

% Housekeeping
H = zeros(1,m);

for Column = 1:m,
    % Assemble observed alphabet
    Alphabet = unique(X(:,Column));
	
    % Housekeeping
    Frequency = zeros(size(Alphabet));
	
    % Calculate sample frequencies
    for symbol = 1:length(Alphabet)
        Frequency(symbol) = sum(X(:,Column) == Alphabet(symbol));
    end
	
    % Calculate sample class probabilities
    P = Frequency / sum(Frequency);
	
    % Calculate entropy in bits
    % Note: floating point underflow is never an issue since we are
    %   dealing only with the observed alphabet
    H(Column) = -sum(P .* log(P))/length(Frequency)
end
%%
clc
% d1 = [1 0 2 9]
% d2 = [4 4 4 4]
% p1 = d1/sum(d1);
% p2 = d2/sum(d2);
% p1(p1==0) = [];
% p2(p2==0) = [];
% h1 = -sum(p1 .* log(p1)/log(length(p1))) 
% h2 = -sum(p2 .* log(p2)/log(length(p1))) 
%  d=[1 2 9 0];
%     d=d/sum(d+ 1e-12);
%     logd = log(d + 1e-12);
%     Entropy = -sum(d.*logd)/log(length(d))

lgn_c1 = abs(database.C1.eyesClosed.FFT.LGN1(1:129));
lgn_p2 = abs(database.p2.eyesClosed.FFT.LGN1(1:129));

lgn_c1 = lgn_c1(40:80);
lgn_p2 = lgn_p2(40:80);

p_c1 = lgn_c1 / sum(lgn_c1);
p_p2 = lgn_p2 / sum(lgn_p2);

h_c1 = -sum(p_c1 .* log(p_c1 + eps)) / log(length(p_c1))
h_p2 = -sum(p_p2 .* log(p_p2 + eps)) / log(length(p_p2))

%%
close all
for i = 1: length(field_database)-24
denomSignal= database.(field_database{i+1}).eyesClosed.FFT.LGN1(1:129);
numSignal = database.(field_database{i+1}).eyesClosed.FFT.V1(1:129); 

thresholdValueNum = 0.00002:0.00003:0.00008;
thresholdValueDenum = 0.0001:0.0001:0.0005;

tf = numSignal ./ denomSignal;
tff = tf;
ptf = tf .* conj(tf);
ptf(2 : end -1) = ptf(2:end -1)*2;

pNumSignal = (numSignal .* conj(numSignal));
pDenomSignal = (denomSignal .* conj(denomSignal));

pNumSignal(2:end-1 ) = 2 * pNumSignal(2:end-1);
pDenomSignal(2:end-1) = 2 * pDenomSignal(2:end-1);

pAvgNumSignal = sum(pNumSignal);
pAvgDenomSignal = sum(pDenomSignal);

thNumSignal = sqrt(thresholdValueNum * pAvgNumSignal);
thDenomSignal = sqrt(thresholdValueDenum * pAvgDenomSignal);
 
% for k = 1:length(denomSignal)
%     if abs(denomSignal(k)) <= thDenomSignal
%         tff(k) = NaN;
% %         ptf(k) = NaN;
%     else 
%         if abs(numSignal(k)) <= thNumSignal
%                     tff(k) = 0;
% %                     ptf(k) = 0;
%         end % if
%     end % if
% end % for k

% figure; plot(abs(tf));

figure; plot(abs(denomSignal)), hold on; 
for i = 1:length(thresholdValueDenum) 
    line([0 129],[thDenomSignal(i) thDenomSignal(i)]);
    hold on;
end
figure; plot(abs(numSignal)), hold on; 
for i = 1:length(thresholdValueNum) 
    line([0 129],[thNumSignal(i) thNumSignal(i)]);
    hold on;
end
% figure; plot(abs(tff));
end