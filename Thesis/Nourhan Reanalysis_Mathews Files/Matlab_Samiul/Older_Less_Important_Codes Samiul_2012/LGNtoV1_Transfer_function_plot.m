%%%% Loading the fft data %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C1EC=load('C1EC.mat');
C1EO=load('C1EO.mat');
P1EC=load('P1EC.mat');
P1EO=load('P1EO.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Define time and frequency vectors and other parameters %%%%%%%%%%%
T=1.5; %%%%% Sampling Time (TR=2000ms)
L= 160; %%%% Signal Length
NFFT = 512; %%%%%% Number of FFT point 
time_vector = (0:L-1)*T;
frequency_vector = 0:1/(L*T):1/(2*T); %%% for normal FFT
frequency_vector_NFFT = 0:1/(NFFT*T):1/(2*T); %%% for NFFT-point FFT
% frequency_vector = 0:1/(L*T):(160 - 1) / (2* 160 * 1.25);

%%%%%%%%%%% Amplitude Spectrum of signal %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C1EC_LGN=abs(C1EC.LGN_noDC_windowed_fft);
C1EC_V1=abs(C1EC.V1_noDC_windowed_fft);
C1EO_LGN=abs(C1EO.LGN_noDC_windowed_fft);
C1EO_V1=abs(C1EO.V1_noDC_windowed_fft);
P1EC_LGN=abs(P1EC.LGN_noDC_windowed_fft);
P1EC_V1=abs(P1EC.V1_noDC_windowed_fft);
P1EO_LGN=abs(P1EO.LGN_noDC_windowed_fft);
P1EO_V1=abs(P1EO.V1_noDC_windowed_fft);

% C1EC_LGN_phase=angle(C1EC.LGN_noDC_windowed_fft);
% C1EC_V1_phase=angle(C1EC.V1_noDC_windowed_fft);
% figure
% plot(frequency_vector_NFFT,[C1EC_LGN_phase(1:length(frequency_vector_NFFT)) C1EC_V1_phase(1:length(frequency_vector_NFFT))])
% legend('LGN','V1')

figure
plot(frequency_vector_NFFT,[C1EC_LGN(1:length(frequency_vector_NFFT)) C1EC_V1(1:length(frequency_vector_NFFT))])
legend('LGN','V1')

figure
plot(frequency_vector_NFFT,[P1EC_LGN(1:length(frequency_vector_NFFT)) P1EC_V1(1:length(frequency_vector_NFFT))])
legend('LGN','V1')

%%%% Normalization (not necessary)%%%%%
% clear C1EC_LGN C1EC_V1
% C1EC_LGN=C1EC.LGN_noDC_windowed_fft/max(C1EC.LGN_noDC_windowed_fft);
% C1EC_V1=C1EC.V1_noDC_windowed_fft/max(C1EC.V1_noDC_windowed_fft);
% % C1EC_LGN=C1EC_LGN/max(C1EC_LGN);
% % C1EC_V1=C1EC_V1/max(C1EC_V1);
% C1EC_LGN=abs(C1EC_LGN);
% C1EC_V1=abs(C1EC_V1);

%%%%%%%%%%% Power Spectrum of signal %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% C1EC_LGN=C1EC.LGN_noDC_windowed_fft.*conj(C1EC.LGN_noDC_windowed_fft);
% C1EC_V1=C1EC.V1_noDC_windowed_fft.*conj(C1EC.V1_noDC_windowed_fft);
% C1EO_LGN=C1EO.LGN_noDC_windowed_fft.*conj(C1EO.LGN_noDC_windowed_fft);
% C1EO_V1=C1EO.V1_noDC_windowed_fft.*conj(C1EO.V1_noDC_windowed_fft);
% P1EC_LGN=P1EC.LGN_noDC_windowed_fft.*conj(P1EC.LGN_noDC_windowed_fft);
% P1EC_V1=P1EC.V1_noDC_windowed_fft.*conj(P1EC.V1_noDC_windowed_fft);
% P1EO_LGN=P1EO.LGN_noDC_windowed_fft.*conj(P1EO.LGN_noDC_windowed_fft);
% P1EO_V1=P1EO.V1_noDC_windowed_fft.*conj(P1EO.V1_noDC_windowed_fft);

%%%%%%%%%%%%%% Display %%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% plot(frequency_vector_NFFT,[C1EC_LGN(1:length(frequency_vector_NFFT)) C1EC_V1(1:length(frequency_vector_NFFT)) C1EO_LGN(1:length(frequency_vector_NFFT))...
%                             C1EO_V1(1:length(frequency_vector_NFFT)) P1EC_LGN(1:length(frequency_vector_NFFT)) P1EC_V1(1:length(frequency_vector_NFFT))...
%                             P1EO_LGN(1:length(frequency_vector_NFFT)) P1EO_V1(1:length(frequency_vector_NFFT))]);
%                         
% legend('LGN C1EC','V1 C1EC','LGN C1EO','V1 C1EO','LGN P1EC','V1 P1EC','LGN P1EO','V1 P1EO');
% xlabel('Frequency (Hz)'), ylabel('Amplitude Spectrum');
% title('Frequency Response')

% %%%%%%%%% Transfer function calculation normal %%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% C1EC.LGN_noDC_windowed_fft=C1EC.LGN_noDC_windowed_fft/max(C1EC.LGN_noDC_windowed_fft);
% C1EC.V1_noDC_windowed_fft=C1EC.V1_noDC_windowed_fft/max(C1EC.V1_noDC_windowed_fft);
tf_C1EC_LGN_V1= C1EC.V1_noDC_windowed_fft./ C1EC.LGN_noDC_windowed_fft;
P_tf_C1EC_LGN_V1= tf_C1EC_LGN_V1.*conj(tf_C1EC_LGN_V1);
A_tf_C1EC_LGN_V1 = abs(tf_C1EC_LGN_V1);

tf_C1EO_LGN_V1= C1EO.V1_noDC_windowed_fft./ C1EO.LGN_noDC_windowed_fft;
P_tf_C1EO_LGN_V1= tf_C1EO_LGN_V1.*conj(tf_C1EO_LGN_V1);
A_tf_C1EO_LGN_V1 = abs(tf_C1EO_LGN_V1);

tf_P1EC_LGN_V1= P1EC.V1_noDC_windowed_fft./ P1EC.LGN_noDC_windowed_fft;
P_tf_P1EC_LGN_V1= tf_P1EC_LGN_V1.*conj(tf_P1EC_LGN_V1);
A_tf_P1EC_LGN_V1=abs(tf_P1EC_LGN_V1);

tf_P1EO_LGN_V1= P1EO.V1_noDC_windowed_fft./ P1EO.LGN_noDC_windowed_fft;
P_tf_P1EO_LGN_V1= tf_P1EO_LGN_V1.*conj(tf_P1EO_LGN_V1);
A_tf_P1EO_LGN_V1=abs(tf_P1EO_LGN_V1);

figure
plot(frequency_vector_NFFT,A_tf_C1EC_LGN_V1(1:length(frequency_vector_NFFT)))

% figure;
% plot(frequency_vector_NFFT,[A_tf_C1EC_LGN_V1(1:length(frequency_vector_NFFT)) A_tf_C1EO_LGN_V1(1:length(frequency_vector_NFFT))...
%                             A_tf_P1EC_LGN_V1(1:length(frequency_vector_NFFT)) A_tf_P1EO_LGN_V1(1:length(frequency_vector_NFFT))])
% legend('C1EC','C1EO','P1EC','P1EO')

%%%%%%% Transfer function using Moving average smoothing %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ma_point=3;
tf_C1EC_LGN_V1_smooth= smooth(abs(C1EC.V1_noDC_windowed_fft),ma_point)./ smooth(abs(C1EC.LGN_noDC_windowed_fft),ma_point);
P_tf_C1EC_LGN_V1_smooth= tf_C1EC_LGN_V1_smooth.*conj(tf_C1EC_LGN_V1_smooth);
A_tf_C1EC_LGN_V1_smooth = abs(tf_C1EC_LGN_V1_smooth);

tf_C1EO_LGN_V1_smooth= smooth(abs(C1EO.V1_noDC_windowed_fft),ma_point)./ smooth(abs(C1EO.LGN_noDC_windowed_fft),ma_point);
P_tf_C1EO_LGN_V1_smooth= tf_C1EC_LGN_V1_smooth.*conj(tf_C1EC_LGN_V1_smooth);
A_tf_C1EO_LGN_V1_smooth = abs(tf_C1EC_LGN_V1_smooth);

tf_P1EC_LGN_V1_smooth= smooth(abs(P1EC.V1_noDC_windowed_fft),ma_point)./ smooth(abs(P1EC.LGN_noDC_windowed_fft),ma_point);
P_tf_P1EC_LGN_V1_smooth= tf_C1EC_LGN_V1_smooth.*conj(tf_C1EC_LGN_V1_smooth);
A_tf_P1EC_LGN_V1_smooth=abs(tf_C1EC_LGN_V1_smooth);

tf_P1EO_LGN_V1_smooth= smooth(abs(P1EO.V1_noDC_windowed_fft),ma_point)./ smooth(abs(P1EO.LGN_noDC_windowed_fft),ma_point);
P_tf_P1EO_LGN_V1_smooth= tf_C1EC_LGN_V1_smooth.*conj(tf_C1EC_LGN_V1_smooth);
A_tf_P1EO_LGN_V1_smooth=abs(tf_C1EC_LGN_V1_smooth);

figure;
plot(frequency_vector_NFFT,A_tf_C1EC_LGN_V1_smooth(1:length(frequency_vector_NFFT)))
figure;
plot(frequency_vector_NFFT,[A_tf_C1EC_LGN_V1_smooth(1:length(frequency_vector_NFFT)) A_tf_C1EO_LGN_V1_smooth(1:length(frequency_vector_NFFT))...
                            A_tf_P1EC_LGN_V1_smooth(1:length(frequency_vector_NFFT)) A_tf_P1EO_LGN_V1_smooth(1:length(frequency_vector_NFFT))])
legend('C1EC','C1EO','P1EC','P1EO')

%%%%%%%%%%%% Transfer function using frequency bands (manual smoothing) %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear tf_C1EC_LGN_V1 A_tf_C1EC_LGN_V1
smoothing_length=4;

c=length(frequency_vector_NFFT)-mod(length(frequency_vector_NFFT),smoothing_length);
for i=1:c
    numerator_C1EC=mean(C1EC.V1_noDC_windowed_fft(i:i+smoothing_length-1));
    denom_C1EC=mean(C1EC.LGN_noDC_windowed_fft(i:i+smoothing_length-1));
    tf_C1EC_LGN_V1(i)=numerator_C1EC/denom_C1EC;
    
    numerator_C1EO=mean(C1EO.V1_noDC_windowed_fft(i:i+smoothing_length-1));
    denom_C1EO=mean(C1EO.LGN_noDC_windowed_fft(i:i+smoothing_length-1));
    tf_C1EO_LGN_V1(i)=numerator_C1EO/denom_C1EO;
    
    numerator_P1EC=mean(P1EC.V1_noDC_windowed_fft(i:i+smoothing_length-1));
    denom_P1EC=mean(P1EC.LGN_noDC_windowed_fft(i:i+smoothing_length-1));
    tf_P1EC_LGN_V1(i)=numerator_P1EC/denom_P1EC;
    
    numerator_P1EO=mean(P1EO.V1_noDC_windowed_fft(i:i+smoothing_length-1));
    denom_P1EO=mean(P1EO.LGN_noDC_windowed_fft(i:i+smoothing_length-1));
    tf_P1EO_LGN_V1(i)=numerator_P1EO/denom_P1EO;
end
tf_C1EC_LGN_V1(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length))=C1EC.V1_noDC_windowed_fft(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length))...
                                                                      ./C1EC.LGN_noDC_windowed_fft(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length));
tf_C1EO_LGN_V1(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length))=C1EO.V1_noDC_windowed_fft(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length))...
                                                                      ./C1EO.LGN_noDC_windowed_fft(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length));
tf_P1EC_LGN_V1(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length))=P1EC.V1_noDC_windowed_fft(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length))...
                                                                      ./P1EC.LGN_noDC_windowed_fft(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length));
tf_P1EO_LGN_V1(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length))=P1EO.V1_noDC_windowed_fft(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length))...
                                                                      ./P1EO.LGN_noDC_windowed_fft(c+1:c+rem(length(frequency_vector_NFFT),smoothing_length));

% tf_C1EC_LGN_V1= abs(C1EC.V1_noDC_windowed_fft)./ abs(C1EC.LGN_noDC_windowed_fft);
P_tf_C1EC_LGN_V1= tf_C1EC_LGN_V1.*conj(tf_C1EC_LGN_V1);
A_tf_C1EC_LGN_V1 = abs(tf_C1EC_LGN_V1);

% tf_C1EO_LGN_V1= abs(C1EO.V1_noDC_windowed_fft)./ abs(C1EO.LGN_noDC_windowed_fft);
P_tf_C1EO_LGN_V1= tf_C1EO_LGN_V1.*conj(tf_C1EO_LGN_V1);
A_tf_C1EO_LGN_V1 = abs(tf_C1EO_LGN_V1);

% tf_P1EC_LGN_V1= abs(P1EC.V1_noDC_windowed_fft)./ abs(P1EC.LGN_noDC_windowed_fft);
P_tf_P1EC_LGN_V1= tf_P1EC_LGN_V1.*conj(tf_P1EC_LGN_V1);
A_tf_P1EC_LGN_V1=abs(tf_P1EC_LGN_V1);

% tf_P1EO_LGN_V1= abs(P1EO.V1_noDC_windowed_fft)./ abs(P1EO.LGN_noDC_windowed_fft);
P_tf_P1EO_LGN_V1= tf_P1EO_LGN_V1.*conj(tf_P1EO_LGN_V1);
A_tf_P1EO_LGN_V1=abs(tf_P1EO_LGN_V1);
figure;
plot(frequency_vector_NFFT,A_tf_C1EC_LGN_V1(1:length(frequency_vector_NFFT)))

plot(frequency_vector_NFFT,[A_tf_C1EC_LGN_V1(1:length(frequency_vector_NFFT)) A_tf_C1EO_LGN_V1(1:length(frequency_vector_NFFT))...
                            A_tf_P1EC_LGN_V1(1:length(frequency_vector_NFFT)) A_tf_P1EO_LGN_V1(1:length(frequency_vector_NFFT))])
legend('C1EC','C1EO','P1EC','P1EO')




%%%%%% Transfer funcion using frequency bands (by thresholding) %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear tf_C1EC_LGN_V1 A_tf_C1EC_LGN_V1
threshold_level=10;

tf_C1EC_LGN_V1=threshold_tf(C1EC.V1_noDC_windowed_fft,C1EC.LGN_noDC_windowed_fft,4);
tf_C1EO_LGN_V1=threshold_tf(C1EO.V1_noDC_windowed_fft,C1EO.LGN_noDC_windowed_fft,5);
tf_P1EC_LGN_V1=threshold_tf(P1EC.V1_noDC_windowed_fft,P1EC.LGN_noDC_windowed_fft,2);
tf_P1EO_LGN_V1=threshold_tf(P1EO.V1_noDC_windowed_fft,P1EO.LGN_noDC_windowed_fft,7);

A_tf_C1EC_LGN_V1=abs(tf_C1EC_LGN_V1);
A_tf_C1EO_LGN_V1=abs(tf_C1EO_LGN_V1);
A_tf_P1EC_LGN_V1=abs(tf_P1EC_LGN_V1);
A_tf_P1EO_LGN_V1=abs(tf_P1EO_LGN_V1);

figure;
plot(frequency_vector_NFFT',[A_tf_C1EC_LGN_V1(1:length(frequency_vector_NFFT));A_tf_C1EO_LGN_V1(1:length(frequency_vector_NFFT))
                             A_tf_P1EC_LGN_V1(1:length(frequency_vector_NFFT));  A_tf_P1EO_LGN_V1(1:length(frequency_vector_NFFT))]);
legend('C1EC','C1EO','P1EC','P1EO')                         
% A_tf_C1EO_LGN_V1(1:length(frequency_vector_NFFT))...
%                             A_tf_P1EC_LGN_V1(1:length(frequency_vector_NFFT)) A_tf_P1EO_LGN_V1(1:length(frequency_vector_NFFT))]);
% legend('C1EC','C1EO','P1EC','P1EO')
% figure;
% A_tf_C1EC_LGN_V1=abs(tf_C1EC_LGN_V1);
% plot(frequency_vector_NFFT,A_tf_C1EC_LGN_V1(1:length(frequency_vector_NFFT)))
% 
% figure;
% A_tf_P1EC_LGN_V1=abs(tf_P1EC_LGN_V1);
% plot(frequency_vector_NFFT,A_tf_P1EC_LGN_V1(1:length(frequency_vector_NFFT)))




        
        



plot(frequency_vector_NFFT,[A_tf_C1EC_LGN_V1(1:length(frequency_vector_NFFT)) A_tf_C1EO_LGN_V1(1:length(frequency_vector_NFFT))...
                            A_tf_P1EC_LGN_V1(1:length(frequency_vector_NFFT)) A_tf_P1EO_LGN_V1(1:length(frequency_vector_NFFT))])
legend('C1EC','C1EO','P1EC','P1EO')














%%% Amplitude spectrum of LGN and V1 signal 
figure;
subplot 221
plot(frequency_vector_NFFT,[C1EC_LGN(1:length(frequency_vector_NFFT)) C1EC_V1(1:length(frequency_vector_NFFT))]);
legend('LGN C1EC','V1 C1EC');
xlabel('Frequency (Hz)'), ylabel('Amplitude Spectrum');

subplot 222
plot(frequency_vector_NFFT,[C1EO_LGN(1:length(frequency_vector_NFFT)) C1EO_V1(1:length(frequency_vector_NFFT))]);
legend('LGN C1EO','V1 C1EO');
xlabel('Frequency (Hz)'), ylabel('Amplitude Spectrum');

subplot 223
plot(frequency_vector_NFFT,[P1EC_LGN(1:length(frequency_vector_NFFT)) P1EC_V1(1:length(frequency_vector_NFFT))]);
legend('LGN P1EC','V1 P1EC');
xlabel('Frequency (Hz)'), ylabel('Amplitude Spectrum');

subplot 224
plot(frequency_vector_NFFT,[P1EO_LGN(1:length(frequency_vector_NFFT)) P1EO_V1(1:length(frequency_vector_NFFT))]);
legend('LGN P1EO','V1 P1EO');
xlabel('Frequency (Hz)'), ylabel('Amplitude Spectrum');
                        



figure;
plot(frequency_vector_NFFT,[A_tf_C1EC_LGN_V1(1:length(frequency_vector_NFFT)) A_tf_C1EO_LGN_V1(1:length(frequency_vector_NFFT))...
                            A_tf_P1EC_LGN_V1(1:length(frequency_vector_NFFT)) A_tf_P1EO_LGN_V1(1:length(frequency_vector_NFFT))]);
legend('C1EC','C1EO','P1EC','P1EO');
xlabel('Frequency (Hz)'), ylabel('Amplitude Spectrum');
title('Frequency Response of transfer function LGN--->V1')

figure;
plot(frequency_vector_NFFT,[P_tf_C1EC_LGN_V1(1:length(frequency_vector_NFFT)) P_tf_C1EO_LGN_V1(1:length(frequency_vector_NFFT))...
                            P_tf_P1EC_LGN_V1(1:length(frequency_vector_NFFT)) P_tf_P1EO_LGN_V1(1:length(frequency_vector_NFFT))]);
legend('C1EC','C1EO','P1EC','P1EO');
xlabel('Frequency (Hz)'), ylabel('Power Spectrum');
title('Frequency Response of transfer function LGN--->V1')

%%%%%%%%% Transfer function calculation with bands %%%%%%%%%%%
a=C1EC.V1_noDC_windowed_fft;
b=smooth(C1EC.V1_noDC_windowed_fft,3);
% subplot 211
plot(frequency_vector_NFFT,abs([a(1:length(frequency_vector_NFFT)) b(1:length(frequency_vector_NFFT))]))
legend('a','b')
