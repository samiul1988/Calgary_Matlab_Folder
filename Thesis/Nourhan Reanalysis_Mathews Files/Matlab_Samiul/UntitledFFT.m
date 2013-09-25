%%
N = 160; %% number of points
T = 1.5; %% sampling period = 1.5 s
Fs = 1 /T; %% sampling frequency = 0.6667 Hz 
t = [0:N-1]*T; %% define time vector
x = sin(2*pi*0.1*t); %%define function, 0.1 Hz sine wave
figure(1), plot(t,x)
%%
p = abs(fft(x))/160; %%% has 160 frequency bins: bin 80 corresponds to 0.3333 Hz ( = Fs/2) 
p1 = abs(fft(x,256))/256; %%% has 256 frequency bins: bin 128 corresponds to 0.3333 Hz ( = Fs/2) 
p2 = abs(fft(x,512))/512; %%% has 512 frequency bins: bin 256 corresponds to 0.3333 Hz ( = Fs/2) 
p3 = abs(fft(x,1024))/1024; %%% has 1024 frequency bins: bin 512 corresponds to 0.3333 Hz ( = Fs/2) 

%%% frequency vector
f = [0:N/2-1]/(N/2)*(Fs/2); %% find the corresponding frequency in Hz
f1 = [0:256/2-1]/(256/2)*(Fs/2); %% find the corresponding frequency in Hz
f2 = [0:512/2-1]/(512/2)*(Fs/2); %% find the corresponding frequency in Hz
f3 = [0:1024/2-1]/(1024/2)*(Fs/2); %% find the corresponding frequency in Hz

figure(2), plot(f,p(1:N/2))
figure(3), plot(f1,p1(1:256/2))
figure(4), plot(f2,p2(1:512/2))
figure(5), plot(f3,p3(1:1024/2))
%%


% length_f = length(f)

freq = [0:N/2-1]; %% find the corresponding frequency in Hz
freq1 = [0:1024/2-1]/T; %% find the corresponding frequency in Hz
freq2 = [0:2048/2-1]/T; %% find the corresponding frequency in Hz
freq3 = [0:4096/2-1]/T; %% find the corresponding frequency in Hz

p = abs(fft(f));
p1 = abs(fft(f,1024));
p2 = abs(fft(f,2048));
p3 = abs(fft(f,4096));

figure(2), plot(freq,p(1:N/2))

p = abs(fft(f))/(N/2); %% absolute value of the fft


p = p(1:N/2).^2 %% take the power of positve freq. half
freq = [0:N/2-1]/T; %% find the corresponding frequency in Hz
plot(freq,p); %% plot on semilog scale
axis([0 20 0 1]); %% zoom in
%%
clc
N = 160; %% number of points
T = 1.5; %% sampling period = 1.5 s
Fs = 1 /T; %% sampling frequency = 0.6667 Hz 
t = [0:N-1]*T; %% define time vector
x = sin(2*pi*0.1*t); %%define function, 0.1 Hz sine wave
% figure(1), plot(t,x)
NFFT = length(x);
X = fft(x)/ NFFT;
Px = (X .* conj(X));
Pavg = sum(Px)

XX = X(1:N/2); 
Pxx = (XX .* conj(XX));
Pxx(2:end -1) = 2 * Pxx(2:end -1);
Pavg2 = sum(Pxx)
figure(1), plot(abs(Px))
%%% comparison with PSD
Hpsd = dspdata.psd(Px(1:length(Px)/2),'Fs',Fs);  
figure(2), plot(Hpsd); 
