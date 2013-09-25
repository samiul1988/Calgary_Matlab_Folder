%%
clear all
clc
close all
%%
%%%%%% Generate a simple single frequency sine wave %%%%%
Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
%%% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x = sin(2*pi*50*t) + (1i)* sin(2*pi*120*t); 
xx = xcorr(x);
% plot(abs(x)
% % NFFT = 2^(nextpow2(L)); 
% % X=fft(x,NFFT);
% % f= 0:Fs/NFFT:Fs/2;
% % Px = X.*conj(X);
% % length(X)
% % length(Px)

%%

y = x + 2*randn(size(t));     % Sinusoids plus noise
% y=[1 zeros(1,L-1)];
subplot(3,2,[1 2])
plot(t(1:100),x(1:100),'r'),title('Actual Signal, x'), xlabel('time (milliseconds)'), hold on
plot(t(1:100),y(1:100),'b'),title('Noisy Signal, y'), xlabel('time (milliseconds)')
%%
%%%%%%%% Fourier Transform %%%%%%%%%%%

NFFT = 2^(nextpow2(L)); % Number of FFT points: Next power of 2 from length of y
% f = Fs/2*linspace(0,1,NFFT/2+1);
f= 0:Fs/NFFT:Fs/2;

% X = fft(x,NFFT);
Y = fft(y,NFFT)/L;
Py=10*log10(Y.*conj(Y));
% Plot single-sided amplitude spectrum.
subplot(3,2,[3 4])
plot(f,Py(1:length(f))), xlabel('Frequency (Hz)'), ylabel('|X(f)|')
% plot(f,abs(X(1:NFFT/2+1))), xlabel('Frequency (Hz)'), ylabel('|X(f)|')
h = spectrum.welch;
subplot(3,2,[5 6])
msspectrum(h,y,'Fs',Fs,'NFFT',NFFT);
subplot(3,2,4)
plot(f,abs(Y(1:NFFT/2+1))), xlabel('Frequency (Hz)'), ylabel('|Y(f)|')


% %%%%% another example %%%
% % Sampling frequency 
% Fs = 1024; 
% 
% % Time vector of 1 second 
% t = 0:1/Fs:1; 
% 
% % Create a sine wave of 200 Hz.
% x = sin(2*pi*t*200); 
% 
% % Use next highest power of 2 greater than or equal to length(x) to calculate FFT.
% nfft= 2^(nextpow2(length(x))); 
% 
% % Take fft, padding with zeros so that length(fftx) is equal to nfft 
% fftx = fft(x,nfft); 
% 
% % Calculate the numberof unique points
% NumUniquePts = ceil((nfft+1)/2); 
% 
% % FFT is symmetric, throw away second half 
% fftx = fftx(1:NumUniquePts); 
% 
% % Take the magnitude of fft of x and scale the fft so that it is not a function of the length of x
% mx = abs(fftx)/length(x); 
% 
% % Take the square of the magnitude of fft of x. 
% mx = mx.^2; 
% 
% % Since we dropped half the FFT, we multiply mx by 2 to keep the same energy.
% % The DC component and Nyquist component, if it exists, are unique and should not be multiplied by 2.
% 
% if rem(nfft, 2) % odd nfft excludes Nyquist point
%   mx(2:end) = mx(2:end)*2;
% else
%   mx(2:end -1) = mx(2:end -1)*2;
% end
% 
% 
% % This is an evenly spaced frequency vector with NumUniquePts points. 
% f = (0:NumUniquePts-1)*Fs/nfft; 
% 
% % Generate the plot, title and labels. 
% plot(f,mx); 
% title('Power Spectrum of a 200Hz Sine Wave'); 
% xlabel('Frequency (Hz)'); 
% ylabel('Power'); 
