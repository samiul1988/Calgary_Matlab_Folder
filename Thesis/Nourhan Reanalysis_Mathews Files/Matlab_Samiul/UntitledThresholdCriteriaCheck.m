 %% Threshold Condition check 
%%%% 
load('TF_Database.mat');
f = database.header.frequency_vector_NFFT;
xLGN = database.control1.eyesClosed.FFT.LGN1;
xV1 = database.control1.eyesClosed.FFT.V1;
% xLGN = abs(RxLGN);
% xV1 = abs(xV1);
figure(1); plot(f,abs([xLGN(1:length(f))'; xV1(1:length(f))']))
%%
th = 0.1;
tf = xV1./xLGN;
tf = tf((1:length(f)));
tf_th = tf;
tf_th_power = tf;
ptf = tf.*conj(tf);

%%% Threshold based on Amplitude 

xLGN_norm = abs(xLGN/max(xLGN));

for i = 1:length(tf)
    if xLGN_norm(i) < th 
        tf_th(i) = NaN;
    end
end

figure(2); subplot 211, plot(f,abs(tf));
subplot 212, plot(f,abs(tf_th))

%%% Threshold based on Average Power
%%% Two threshold approach

pxLGN = (xLGN .* conj(xLGN)) / length(xLGN);
pxLGN(2:end) = 2 * pxLGN(2:end);
pAvg_LGN = sum(pxLGN) / 1000;
th_LGN = sqrt(1* pAvg_LGN);

pxV1 = (xV1 .* conj(xV1)) / length(xV1);
pxV1(2:end) = 2 * pxV1(2:end);
pAvg_V1 = sum(pxV1) / 1000;
th_V1 = sqrt(1* pAvg_V1);

for i = 1 : length(tf)
    if abs(xLGN(i)) < th_LGN 
        tf_th_power(i) = NaN;
    else
        if abs(xV1(i)) < th_V1
            tf(i) = 0;
        end
    end
end

figure(3); subplot 211, plot(f,abs(tf));
subplot 212, plot(f,abs(tf_th_power))
%%
threshold = 0.1;
numSignal = xV1;
denomSignal = xLGN;
tf = numSignal./denomSignal;
tf = tf((1:length(f)));

tf_th_power = tf;
ptf = tf.*conj(tf);

%%% Threshold based on Average Power
%%% Two threshold approach

pNumSignal = (numSignal .* conj(numSignal)) / length(numSignal);
pDenomSignal = (denomSignal .* conj(denomSignal)) / length(denomSignal);

pNumSignal(2:end) = 2 * pNumSignal(2:end);
pDenomSignal(2:end) = 2 * pDenomSignal(2:end);

pAvgNumSignal = sum(pNumSignal) / 1000;
pAvgDenomSignal = sum(pDenomSignal) / 1000;

thNumSignal = sqrt(1* pAvgNumSignal);
thDenomSignal = sqrt(1* pAvgDenomSignal);

for i = 1 : length(tf)
    if abs(denomSignal(i)) < thDenomSignal 
        tf_th_power(i) = NaN;
    else
        if abs(numSignal(i)) < thNumSignal
            tf(i) = 0;
        end
    end
end

figure(3); subplot 211, plot(f,abs(tf));
subplot 212, plot(f,abs(tf_th_power))






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% A Matlab program to calculate average power, PSD, etc. of a discretized
% signal. It also demonstrates Parseval's relation.
% The example signal is a periodic rectangular pulse
%
clear
close all
Fs=10000;
% Fs=sample rate
T=1;
% T=time duration of the waveform, in secs.
n=T*Fs;
% n=number of samples
time=(1:n)/Fs;
% time is the vector of the sample times
f=1000/(2*pi);
x=cos(2*pi*f*time);
%t=find(x<0);
%x(t)=zeros(size(t)); % x is a half-wave rectified cosine waveform
x=sign(x);
t=find(x<0);
x(t)=zeros(size(t));
% x is a half-wave rectified cosine waveform
%sound(x/max(abs(x)),Fs) % plays the waveform as an audio file
figure(1)
plot(time,x)
axis([0 10/f -1.2 1.2])
% Displaying just 10 cycles of x(t)
title('First few cycles of the waveform, x(t)');
grid
%
% Calculating power from the time signal
% This is a Riemann sum approximation of Average Power
% Note: Duration, T=n*Ts, where Ts=1/Fs
%
Power_of_x=sum(x.^2)/n
% Riemann approximation of the integral
%
% Looking at frequency domain
% fft evaluates the discrete Fourier transform (DFT)
% at a set of equally spaced points on [0,1]
%
XFs=fft(x)/Fs;
% scale fft(x) to get spectrum of x(t)
%
% fftshift moves this to [-0.5, 0.5] for better visualization
%
Xf=fftshift(XFs);
%
% Computing energy spectrum
%
Exf=abs(Xf).^2;
% Note: Exf can also be computed as abs(Xf).^2
%
% Pxf is an approximation to the continuous time PSD
%
Pxf=Exf/T;
%
% Assigning frequencies to the samples of the PSD
%
figure(2)
df=Fs/n;
% Df=freq separation between two consecutive fft points
freq=[-(n/2)+1:1:n/2]*df;
maxPxf=max(Pxf);
subplot(211)
plot(freq,Pxf)
axis([-5000 5000 0 maxPxf])
title('Power Spectral Density of x(t) ');
subplot(212)
plot(freq,10*log10(Pxf/maxPxf))
axis([-5000 5000 -100 0])
grid
title('Power Spectral Density of x(t) in dB ');
%
% Calculating power from the PSD using Parseval's relation:
% i.e., power = integral of (Pxf) over all frequencies.
% This is a Riemann sum approximation to the actual power
%
Power_from_PSD=sum(Pxf)*df
%Now use Matlab's PSD function to plot the PSD
 
