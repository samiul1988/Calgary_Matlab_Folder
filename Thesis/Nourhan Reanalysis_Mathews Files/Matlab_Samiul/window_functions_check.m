clear all
clc
close all

Fs = 100;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 150;                     % Length of signal
t = (0:L-1)*T;                % Time vector
NFFT = 2^(nextpow2(L));
f= 0:Fs/NFFT:Fs/2;

%%% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x = sin(2*pi*1*t) + sin(2*pi*6*t)+1*randn(size(t)); 
% beta=0:0.1:1;
% for i=1:length(beta)
%     w=window('kaiser',L,beta(i));
%     xw=x'.*w;
%     X=abs(fft(xw,NFFT));
%     plot(f,X(1:length(f)),'Color',[1 0.5 beta(i)]);
%     hold on
% end
% legend('1','2','3','4','5','6','7','8','9','10');
% 
% hold off
% beta=0:0.1:1;
% for i=1:length(beta)
% w=window('kaiser',L,0.8);
% plot(w)
% hold on
% end


% y = x + 2*randn(size(t));     % Sinusoids plus noise
% y=[1 zeros(1,L-1)];
 w_vector={'rectwin','barthannwin','blackman','blackmanharris','bohmanwin','chebwin','flattopwin','gausswin','hamming','hann','kaiser','nuttallwin',...
              'parzenwin','taylorwin','tukeywin'};

    for i=1:length(w_vector)
        w=window(w_vector{1},L);
        xr=x'.*w;
        XR=abs(fft(xr,NFFT));
        window_vector = window(w_vector{i},L);
        xw=x'.*window_vector;
        
        X=abs(fft(xw,NFFT));
        figure
%         subplot 211
%         plot(t(1:100),xw(1:100),'r'),title('Actual Signal, x'), xlabel('time (milliseconds)')
%         subplot 212
        plot(f,[X(1:length(f)),XR(1:length(f))])
        legend(sprintf('Frequency Response with %s window',w_vector{i}),sprintf('Frequency Response with %s window',w_vector{1}));
    end