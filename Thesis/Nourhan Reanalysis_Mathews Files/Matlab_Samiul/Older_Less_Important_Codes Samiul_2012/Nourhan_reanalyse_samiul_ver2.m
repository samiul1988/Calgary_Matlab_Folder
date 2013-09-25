%%%%%%%% Reanalysis of Nourhan's Data using two patients and two control %%%%%%%%
%%%%%%%% subjects' data 
%%%%%% generates time domain figures, frequency features and transfer
%%%%%% functions 

clear all;
clc;
close all;
% LOC /V1 and then V1 / LGN
%First can we open a file
% C1/RegionsTC/C/LGN.dat
%Compare original data

%%%%% Open necessary files %%%%%%%
%%%%%% C1 == Control subject 1, P1 = Patient 1....etc
%%%%%% C = Eyes Closed, O = Eyes Open %%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Eyes Closed Condition %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C1_LGN_Closed = load('C1\RegionsTC\C\LGN.dat');
C1_V1_Closed = load('C1\RegionsTC\C\V1.dat');
C1_LOC_Closed = load('C1\RegionsTC\C\LOC.dat');

C2_LGN_Closed = load('C2\RegionsTC\C\LGN.dat');
C2_V1_Closed = load('C2\RegionsTC\C\V1.dat');
C2_LOC_Closed = load('C2\RegionsTC\C\LOC.dat');

P1_LGN_Closed = load('P1\RegionsTC\C\LGN.dat');
P1_V1_Closed = load('P1\RegionsTC\C\V1.dat');
P1_LOC_Closed = load('P1\RegionsTC\C\LOC.dat');

P2_LGN_Closed = load('P2\RegionsTC\C\LGN.dat');
P2_V1_Closed = load('P2\RegionsTC\C\V1.dat');
P2_LOC_Closed = load('P2\RegionsTC\C\LOC.dat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Define time and frequency vectors and other parameters %%%%%%%%%%%

T=1.25; %%%%% Sampling Time
L= 160; %%%% Signal Length
NFFT = 256; %%%%%% Number of FFT point 
time_vector = (0:L-1)*T;
frequency_vector = 0:1/(L*T):1/(2*T); %%% for normal FFT
frequency_vector_NFFT = 0:1/(NFFT*T):1/(2*T); %%% for NFFT-point FFT
% frequency_vector = 0:1/(L*T):(160 - 1) / (2* 160 * 1.25);

%%%%% Remove DC Components for comparison %%%%%%%%

C1_LGN_Closed_DC_removed = C1_LGN_Closed - mean(C1_LGN_Closed);
C1_V1_Closed_DC_removed = C1_V1_Closed - mean(C1_V1_Closed);
C1_LOC_Closed_DC_removed = C1_LOC_Closed - mean(C1_LOC_Closed);

C2_LGN_Closed_DC_removed = C2_LGN_Closed - mean(C2_LGN_Closed);
C2_V1_Closed_DC_removed = C2_V1_Closed - mean(C2_V1_Closed);
C2_LOC_Closed_DC_removed = C2_LOC_Closed - mean(C2_LOC_Closed);

P1_LGN_Closed_DC_removed = P1_LGN_Closed - mean(P1_LGN_Closed);
P1_V1_Closed_DC_removed = P1_V1_Closed - mean(P1_V1_Closed);
P1_LOC_Closed_DC_removed = P1_LOC_Closed - mean(P1_LOC_Closed);

P2_LGN_Closed_DC_removed = P2_LGN_Closed - mean(P2_LGN_Closed);
P2_V1_Closed_DC_removed = P2_V1_Closed - mean(P2_V1_Closed);
P2_LOC_Closed_DC_removed = P2_LOC_Closed - mean(P2_LOC_Closed);

% Pxx = abs(fft(C1_LGN_Closed_DC_removed,NFFT)).^2/L*T;
% Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',1/T); 
% % h=spectrum.welch;
% % Hpsd=psd(h,C1_LGN_Closed_DC_removed);
% plot(Hpsd)

%%%%%%% Plot time domain graphs %%%%%%%%%%

figure(1)
plot(time_vector,C1_LGN_Closed_DC_removed,'b'); hold on;
plot(time_vector,C2_LGN_Closed_DC_removed,'r'); hold on;
plot(time_vector,P1_LGN_Closed_DC_removed,'g'); hold on;
plot(time_vector,P2_LGN_Closed_DC_removed,'k'); 
legend('LGN-Control 1','LGN-Control 2','LGN-Patient 1','LGN-Patient 2')

figure(2)
plot(time_vector,C1_V1_Closed_DC_removed,'b'); hold on;
plot(time_vector,C2_V1_Closed_DC_removed,'r'); hold on;
plot(time_vector,P1_V1_Closed_DC_removed,'g'); hold on;
plot(time_vector,P2_V1_Closed_DC_removed,'k'); 
legend('V1-Control 1','V1-Control 2','V1-Patient 1','V1 Patient 2')

figure(3)
plot(time_vector,C1_LOC_Closed_DC_removed,'b'); hold on;
plot(time_vector,C2_LOC_Closed_DC_removed,'r'); hold on;
plot(time_vector,P1_LOC_Closed_DC_removed,'g'); hold on;
plot(time_vector,P2_LOC_Closed_DC_removed,'k'); 
legend('LOC Control 1','LOC Control 2','LOC Patient 1','LOC Patient 2')

% h = spectrum.periodogram;
% figure;
% msspectrum(h,C1_LGN_Closed_DC_removed,'Fs',1/T,'NFFT',NFFT);

C1_LGN_Closed_DC_removed_FFT = fft(C1_LGN_Closed_DC_removed,NFFT)/NFFT;
C1=(C1_LGN_Closed_DC_removed_FFT.*conj(C1_LGN_Closed_DC_removed_FFT));
figure
plot(frequency_vector_NFFT,C1(1:length(frequency_vector_NFFT)))


%%%%%%%% Plot the frequenct domain graphs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C1_LGN_Closed_DC_removed_FFT = abs(fft(C1_LGN_Closed_DC_removed,NFFT));
C1_V1_Closed_DC_removed_FFT = abs(fft(C1_V1_Closed_DC_removed,NFFT));
C1_LOC_Closed_DC_removed_FFT = abs(fft(C1_LOC_Closed_DC_removed,NFFT));

C2_LGN_Closed_DC_removed_FFT = abs(fft(C2_LGN_Closed_DC_removed,NFFT));
C2_V1_Closed_DC_removed_FFT = abs(fft(C2_V1_Closed_DC_removed,NFFT));
C2_LOC_Closed_DC_removed_FFT = abs(fft(C2_LOC_Closed_DC_removed,NFFT));

P1_LGN_Closed_DC_removed_FFT = abs(fft(P1_LGN_Closed_DC_removed,NFFT));
P1_V1_Closed_DC_removed_FFT = abs(fft(P1_V1_Closed_DC_removed,NFFT));
P1_LOC_Closed_DC_removed_FFT = abs(fft(P1_LOC_Closed_DC_removed,NFFT));

P2_LGN_Closed_DC_removed_FFT = abs(fft(P2_LGN_Closed_DC_removed,NFFT));
P2_V1_Closed_DC_removed_FFT = abs(fft(P2_V1_Closed_DC_removed,NFFT));
P2_LOC_Closed_DC_removed_FFT = abs(fft(P2_LOC_Closed_DC_removed,NFFT));

figure(4)
plot(frequency_vector_NFFT,C1_LGN_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_LGN_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_LGN_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_LGN_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('LGN Control 1','LGN Control 2','LGN Patient 1','LGN Patient 2')

figure(5)
plot(frequency_vector_NFFT,C1_V1_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_V1_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_V1_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_V1_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('V1 Control 1','V1 Control 2','V1 Patient 1','V1 Patient 2')

figure(6)
plot(frequency_vector_NFFT,C1_LOC_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_LOC_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_LOC_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_LOC_Closed_DC_removed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('LOC Control 1','LOC Control 2','LOC Patient 1','LOC Patient 2')

%%%%%%%%%% Frequency response after Blackmann Harris windowing %%%%%%%%
w = window(@blackmanharris,L);
 
C1_LGN_Closed_DC_removed_windowed = C1_LGN_Closed_DC_removed.*w;
C1_V1_Closed_DC_removed_windowed = C1_V1_Closed_DC_removed.*w;
C1_LOC_Closed_DC_removed_windowed = C1_LOC_Closed_DC_removed.*w;

C2_LGN_Closed_DC_removed_windowed = C2_LGN_Closed_DC_removed.*w;
C2_V1_Closed_DC_removed_windowed = C2_V1_Closed_DC_removed.*w;
C2_LOC_Closed_DC_removed_windowed = C2_LOC_Closed_DC_removed.*w;

P1_LGN_Closed_DC_removed_windowed = P1_LGN_Closed_DC_removed.*w;
P1_V1_Closed_DC_removed_windowed = P1_V1_Closed_DC_removed.*w;
P1_LOC_Closed_DC_removed_windowed = P1_LOC_Closed_DC_removed.*w;

P2_LGN_Closed_DC_removed_windowed = P2_LGN_Closed_DC_removed.*w;
P2_V1_Closed_DC_removed_windowed = P2_V1_Closed_DC_removed.*w;
P2_LOC_Closed_DC_removed_windowed = P2_LOC_Closed_DC_removed.*w;

C1_LGN_Closed_DC_removed_windowed_FFT = abs(fft(C1_LGN_Closed_DC_removed_windowed,NFFT));
C1_V1_Closed_DC_removed_windowed_FFT = abs(fft(C1_V1_Closed_DC_removed_windowed,NFFT));
C1_LOC_Closed_DC_removed_windowed_FFT = abs(fft(C1_LOC_Closed_DC_removed_windowed,NFFT));

C2_LGN_Closed_DC_removed_windowed_FFT = abs(fft(C2_LGN_Closed_DC_removed_windowed,NFFT));
C2_V1_Closed_DC_removed_windowed_FFT = abs(fft(C2_V1_Closed_DC_removed_windowed,NFFT));
C2_LOC_Closed_DC_removed_windowed_FFT = abs(fft(C2_LOC_Closed_DC_removed_windowed,NFFT));

P1_LGN_Closed_DC_removed_windowed_FFT = abs(fft(P1_LGN_Closed_DC_removed_windowed,NFFT));
P1_V1_Closed_DC_removed_windowed_FFT = abs(fft(P1_V1_Closed_DC_removed_windowed,NFFT));
P1_LOC_Closed_DC_removed_windowed_FFT = abs(fft(P1_LOC_Closed_DC_removed_windowed,NFFT));

P2_LGN_Closed_DC_removed_windowed_FFT = abs(fft(P2_LGN_Closed_DC_removed_windowed,NFFT));
P2_V1_Closed_DC_removed_windowed_FFT = abs(fft(P2_V1_Closed_DC_removed_windowed,NFFT));
P2_LOC_Closed_DC_removed_windowed_FFT = abs(fft(P2_LOC_Closed_DC_removed_windowed,NFFT));

figure(7)
plot(frequency_vector_NFFT,C1_LGN_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_LGN_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_LGN_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_LGN_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('LGN Control 1','LGN Control 2','LGN Patient 1','LGN Patient 2')

figure(8)
plot(frequency_vector_NFFT,C1_V1_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_V1_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_V1_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_V1_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('V1 Control 1','V1 Control 2','V1 Patient 1','V1 Patient 2')

figure(9)
plot(frequency_vector_NFFT,C1_LOC_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_LOC_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_LOC_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_LOC_Closed_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('LOC Control 1','LOC Control 2','LOC Patient 1','LOC Patient 2')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Eyes Open Condition %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C1_LGN_Open = load('C1\RegionsTC\O\LGN.dat');
C1_V1_Open = load('C1\RegionsTC\O\V1.dat');
C1_LOC_Open = load('C1\RegionsTC\O\LOC.dat');

C2_LGN_Open = load('C2\RegionsTC\O\LGN.dat');
C2_V1_Open = load('C2\RegionsTC\O\V1.dat');
C2_LOC_Open = load('C2\RegionsTC\O\LOC.dat');

P1_LGN_Open = load('P1\RegionsTC\O\LGN.dat');
P1_V1_Open = load('P1\RegionsTC\O\V1.dat');
P1_LOC_Open = load('P1\RegionsTC\O\LOC.dat');

P2_LGN_Open = load('P2\RegionsTC\O\LGN.dat');
P2_V1_Open = load('P2\RegionsTC\O\V1.dat');
P2_LOC_Open = load('P2\RegionsTC\O\LOC.dat');


%%%%% Remove DC Components for comparison %%%%%%%%

C1_LGN_Open_DC_removed = C1_LGN_Open - mean(C1_LGN_Open);
C1_V1_Open_DC_removed = C1_V1_Open - mean(C1_V1_Open);
C1_LOC_Open_DC_removed = C1_LOC_Open - mean(C1_LOC_Open);

C2_LGN_Open_DC_removed = C2_LGN_Open - mean(C2_LGN_Open);
C2_V1_Open_DC_removed = C2_V1_Open - mean(C2_V1_Open);
C2_LOC_Open_DC_removed = C2_LOC_Open - mean(C2_LOC_Open);

P1_LGN_Open_DC_removed = P1_LGN_Open - mean(P1_LGN_Open);
P1_V1_Open_DC_removed = P1_V1_Open - mean(P1_V1_Open);
P1_LOC_Open_DC_removed = P1_LOC_Open - mean(P1_LOC_Open);

P2_LGN_Open_DC_removed = P2_LGN_Open - mean(P2_LGN_Open);
P2_V1_Open_DC_removed = P2_V1_Open - mean(P2_V1_Open);
P2_LOC_Open_DC_removed = P2_LOC_Open - mean(P2_LOC_Open);

%%%%%%% Plot time domain graphs %%%%%%%%%%

figure(10)
plot(time_vector,C1_LGN_Open_DC_removed,'b'); hold on;
plot(time_vector,C2_LGN_Open_DC_removed,'r'); hold on;
plot(time_vector,P1_LGN_Open_DC_removed,'g'); hold on;
plot(time_vector,P2_LGN_Open_DC_removed,'k'); 
legend('LGN-Control 1','LGN-Control 2','LGN-Patient 1','LGN-Patient 2')

figure(11)
plot(time_vector,C1_V1_Open_DC_removed,'b'); hold on;
plot(time_vector,C2_V1_Open_DC_removed,'r'); hold on;
plot(time_vector,P1_V1_Open_DC_removed,'g'); hold on;
plot(time_vector,P2_V1_Open_DC_removed,'k'); 
legend('V1-Control 1','V1-Control 2','V1-Patient 1','V1 Patient 2')

figure(12)
plot(time_vector,C1_LOC_Open_DC_removed,'b'); hold on;
plot(time_vector,C2_LOC_Open_DC_removed,'r'); hold on;
plot(time_vector,P1_LOC_Open_DC_removed,'g'); hold on;
plot(time_vector,P2_LOC_Open_DC_removed,'k'); 
legend('LOC Control 1','LOC Control 2','LOC Patient 1','LOC Patient 2')

%%%%%%%% Plot the frequenct domain graphs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C1_LGN_Open_DC_removed_FFT = abs(fft(C1_LGN_Open_DC_removed,NFFT));
C1_V1_Open_DC_removed_FFT = abs(fft(C1_V1_Open_DC_removed,NFFT));
C1_LOC_Open_DC_removed_FFT = abs(fft(C1_LOC_Open_DC_removed,NFFT));

C2_LGN_Open_DC_removed_FFT = abs(fft(C2_LGN_Open_DC_removed,NFFT));
C2_V1_Open_DC_removed_FFT = abs(fft(C2_V1_Open_DC_removed,NFFT));
C2_LOC_Open_DC_removed_FFT = abs(fft(C2_LOC_Open_DC_removed,NFFT));

P1_LGN_Open_DC_removed_FFT = abs(fft(P1_LGN_Open_DC_removed,NFFT));
P1_V1_Open_DC_removed_FFT = abs(fft(P1_V1_Open_DC_removed,NFFT));
P1_LOC_Open_DC_removed_FFT = abs(fft(P1_LOC_Open_DC_removed,NFFT));

P2_LGN_Open_DC_removed_FFT = abs(fft(P2_LGN_Open_DC_removed,NFFT));
P2_V1_Open_DC_removed_FFT = abs(fft(P2_V1_Open_DC_removed,NFFT));
P2_LOC_Open_DC_removed_FFT = abs(fft(P2_LOC_Open_DC_removed,NFFT));

figure(13)
plot(frequency_vector_NFFT,C1_LGN_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_LGN_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_LGN_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_LGN_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('LGN Control 1','LGN Control 2','LGN Patient 1','LGN Patient 2')

figure(14)
plot(frequency_vector_NFFT,C1_V1_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_V1_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_V1_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_V1_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('V1 Control 1','V1 Control 2','V1 Patient 1','V1 Patient 2')

figure(15)
plot(frequency_vector_NFFT,C1_LOC_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_LOC_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_LOC_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_LOC_Open_DC_removed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('LOC Control 1','LOC Control 2','LOC Patient 1','LOC Patient 2')

%%%%%%%%%% Frequency response after Blackmann Harris windowing %%%%%%%%
w = window(@blackmanharris,L);
 
C1_LGN_Open_DC_removed_windowed = C1_LGN_Open_DC_removed.*w;
C1_V1_Open_DC_removed_windowed = C1_V1_Open_DC_removed.*w;
C1_LOC_Open_DC_removed_windowed = C1_LOC_Open_DC_removed.*w;

C2_LGN_Open_DC_removed_windowed = C2_LGN_Open_DC_removed.*w;
C2_V1_Open_DC_removed_windowed = C2_V1_Open_DC_removed.*w;
C2_LOC_Open_DC_removed_windowed = C2_LOC_Open_DC_removed.*w;

P1_LGN_Open_DC_removed_windowed = P1_LGN_Open_DC_removed.*w;
P1_V1_Open_DC_removed_windowed = P1_V1_Open_DC_removed.*w;
P1_LOC_Open_DC_removed_windowed = P1_LOC_Open_DC_removed.*w;

P2_LGN_Open_DC_removed_windowed = P2_LGN_Open_DC_removed.*w;
P2_V1_Open_DC_removed_windowed = P2_V1_Open_DC_removed.*w;
P2_LOC_Open_DC_removed_windowed = P2_LOC_Open_DC_removed.*w;

C1_LGN_Open_DC_removed_windowed_FFT = abs(fft(C1_LGN_Open_DC_removed_windowed,NFFT));
C1_V1_Open_DC_removed_windowed_FFT = abs(fft(C1_V1_Open_DC_removed_windowed,NFFT));
C1_LOC_Open_DC_removed_windowed_FFT = abs(fft(C1_LOC_Open_DC_removed_windowed,NFFT));

C2_LGN_Open_DC_removed_windowed_FFT = abs(fft(C2_LGN_Open_DC_removed_windowed,NFFT));
C2_V1_Open_DC_removed_windowed_FFT = abs(fft(C2_V1_Open_DC_removed_windowed,NFFT));
C2_LOC_Open_DC_removed_windowed_FFT = abs(fft(C2_LOC_Open_DC_removed_windowed,NFFT));

P1_LGN_Open_DC_removed_windowed_FFT = abs(fft(P1_LGN_Open_DC_removed_windowed,NFFT));
P1_V1_Open_DC_removed_windowed_FFT = abs(fft(P1_V1_Open_DC_removed_windowed,NFFT));
P1_LOC_Open_DC_removed_windowed_FFT = abs(fft(P1_LOC_Open_DC_removed_windowed,NFFT));

P2_LGN_Open_DC_removed_windowed_FFT = abs(fft(P2_LGN_Open_DC_removed_windowed,NFFT));
P2_V1_Open_DC_removed_windowed_FFT = abs(fft(P2_V1_Open_DC_removed_windowed,NFFT));
P2_LOC_Open_DC_removed_windowed_FFT = abs(fft(P2_LOC_Open_DC_removed_windowed,NFFT));

figure(16)
plot(frequency_vector_NFFT,C1_LGN_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_LGN_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_LGN_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_LGN_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('LGN Control 1','LGN Control 2','LGN Patient 1','LGN Patient 2')

figure(17)
plot(frequency_vector_NFFT,C1_V1_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_V1_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_V1_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_V1_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('V1 Control 1','V1 Control 2','V1 Patient 1','V1 Patient 2')

figure(18)
plot(frequency_vector_NFFT,C1_LOC_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'b'); hold on;
plot(frequency_vector_NFFT,C2_LOC_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'r'); hold on;
plot(frequency_vector_NFFT,P1_LOC_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'g'); hold on;
plot(frequency_vector_NFFT,P2_LOC_Open_DC_removed_windowed_FFT(1:length(frequency_vector_NFFT)),'k'); 
legend('LOC Control 1','LOC Control 2','LOC Patient 1','LOC Patient 2')






% % clc
% % clear all
% % close all
% % 
% % % Fs = 1000;                    % Sampling frequency
% % % T = 1/Fs;                     % Sample time
% % 
% % T=1;
% % L = 160;                     % Length of signal
% % t = (0:L-1)*T;            % Time vector
% % % f = 0:(1/(L*T)):(L-1)/(L*T);
% % % f = 0:(1/(L*T)):1/(2*T);
% % 
% % %%% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
% % x = sin(2*pi*.08*t); 
% % subplot 211
% % plot(t,x)
% % X = fft(x,1024);
% % f = 0:(1/(1024*T)):1/(2*T);
% % subplot 212
% % plot(f, abs(X(1:length(f))))






% 
% figure;
% 
% load('C1\RegionsTC\C\LGN.dat');
% newC1_LGNclosed = RemoveDC(LGN);
% plot(time, newC1_LGNclosed, '-k'); hold on;
% 
% load -ASCII 'C1\RegionsTC\C\V1.dat'
% newC1_V1closed = RemoveDC(V1);
% plot(time, newC1_V1closed, '-b'); hold on;
% 
% load -ASCII 'C1\RegionsTC\C\LOC.dat'
% newC1_LOCclosed = RemoveDC(LOC);
% plot(time, newC1_LOCclosed, '-r'); 
% 
% xlabel('TIME s');
% ylabel('AMPLITUDE (AU)');
% title('Original Data -- C1 / Closed');
% legend('LGN', 'V1', 'LOC');
% 
%  % Display spectrum
%  figure;
%  plot(Hz, abs(fft(newC1_LGNclosed)), '-k'); hold on;
%  plot(Hz, abs(fft(newC1_V1closed)), '-b'); hold on;
%  plot(Hz, abs(fft(newC1_LOCclosed)), '-r'); hold on;
%  title('Frequency response -- C1 / Closed');
%  legend('LGN', 'V1', 'LOC');
%  xlabel('FREQUENCY Hz');
%  ylabel('AMPLITUDE (AU)');
%  xlim([0, 0.4]);
%  
%  %Display Transfer Function
%  figure;
%  Hz = 0:1 / (160 * 1.25):160 / (160 * 1.25) - 1 / (160 * 1.25);
%  plot(Hz, abs(fft(newC1_V1closed) ./ fft(newC1_LGNclosed)), '-k'); hold on;
%  plot(Hz, abs(fft(newC1_LOCclosed) ./fft(newC1_V1closed)), '-r'); hold on;
%  title('Transfer function  -- C1 / Closed');
%  legend('V1 / LGN', 'LOC / V1');
%  xlabel('FREQUENCY Hz');
%  ylabel('GAIN ');
%  title('Frequency -- C1 / Closed');
%  xlim([0, 0.4]);
%  
%  %Display Inverse Transfer Function
%  figure;
%  Hz = 0:1 / (160 * 1.25):160 / (160 * 1.25) - 1 / (160 * 1.25);
%  plot(Hz, abs(1 ./ (fft(newC1_V1closed) ./ fft(newC1_LGNclosed))), '-k'); hold on;
%  plot(Hz, abs(1 ./ (fft(newC1_LOCclosed) ./fft(newC1_V1closed))), '-r'); hold on;
%  title('Inverse Transfer function  -- C1 / Closed');
%  legend('LGN / V1', 'V1 / LOC');
%  xlabel('FREQUENCY Hz');
%  ylabel('GAIN ');
%  title('Frequency -- C1 / Closed');
%  xlim([0, 0.4]);
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figure;
% load -ASCII 'C2\RegionsTC\C\LGN.dat'
% newC2_LGNclosed = RemoveDC(LGN);
% plot(time, newC2_LGNclosed, '-k'); hold on;
% 
% load -ASCII 'C2\RegionsTC\C\V1.dat'
% newC2_V1closed = RemoveDC(V1);
% plot(time, newC2_V1closed, '-b'); hold on;
% 
% load -ASCII 'C2\RegionsTC\C\LOC.dat'
% newC2_LOCclosed = RemoveDC(LOC);
% plot(time, newC2_LOCclosed, '-r'); 
% 
% xlabel('TIME s');
% ylabel('AMPLITUDE (AU)');
% title('Original Data -- C2 / Closed');
% legend('LGN', 'V1', 'LOC');
% 
%  % Display spectrum
%  figure;
%  plot(Hz, abs(fft(newC2_LGNclosed)), '-k'); hold on;
%  plot(Hz, abs(fft(newC2_V1closed)), '-b'); hold on;
%  plot(Hz, abs(fft(newC2_LOCclosed)), '-r'); hold on;
%  title('Frequency response -- C2 / Closed');
%  legend('LGN', 'V1', 'LOC');
%  xlabel('FREQUENCY Hz');
%  ylabel('AMPLITUDE (AU)');
%  xlim([0, 0.4]);
%  
%  %Display Transfer Function
%  figure;
%  Hz = 0:1 / (160 * 1.25):160 / (160 * 1.25) - 1 / (160 * 1.25);
%  plot(Hz, abs(fft(newC2_V1closed) ./ fft(newC2_LGNclosed)), '-k'); hold on;
%  plot(Hz, abs(fft(newC2_LOCclosed) ./fft(newC2_V1closed)), '-r'); hold on;
%  title('Transfer function  -- C2 / Closed');
%  legend('V1 / LGN', 'LOC / V1');
%  xlabel('FREQUENCY Hz');
%  ylabel('GAIN ');
%  title('Frequency -- C2 / Closed');
%  xlim([0, 0.4]);
%  
%  %Display Inverse Transfer Function
%  figure;
%  Hz = 0:1 / (160 * 1.25):160 / (160 * 1.25) - 1 / (160 * 1.25);
%  plot(Hz, abs(1 ./ (fft(newC2_V1closed) ./ fft(newC2_LGNclosed))), '-k'); hold on;
%  plot(Hz, abs(1 ./ (fft(newC2_LOCclosed) ./fft(newC2_V1closed))), '-r'); hold on;
%  title('Inverse Transfer function  -- C2 / Closed');
%  legend('LGN / V1', 'V1 / LOC');
%  xlabel('FREQUENCY Hz');
%  ylabel('GAIN ');
%  title('Frequency -- C2 / Closed');
%  xlim([0, 0.4]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figure;
% load -ASCII 'P1\RegionsTC\C\LGN.dat'
% newP1_LGNclosed = RemoveDC(LGN);
% plot(time, newP1_LGNclosed, '-k'); hold on;
% 
% load -ASCII 'P1\RegionsTC\C\V1.dat'
% newP1_V1closed = RemoveDC(V1);
% plot(time, newP1_V1closed, '-b'); hold on;
% 
% load -ASCII 'P1\RegionsTC\C\LOC.dat'
% newP1_LOCclosed = RemoveDC(LOC);
% plot(time, newP1_LOCclosed, '-r'); 
% 
% xlabel('TIME s');
% ylabel('AMPLITUDE (AU)');
% title('Original Data -- P1 / Closed');
% legend('LGN', 'V1', 'LOC');
% 
%  % Display spectrum
%  figure;
%  plot(Hz, abs(fft(newP1_LGNclosed)), '-k'); hold on;
%  plot(Hz, abs(fft(newP1_V1closed)), '-b'); hold on;
%  plot(Hz, abs(fft(newP1_LOCclosed)), '-r'); hold on;
%  title('Frequency response -- P1 / Closed');
%  legend('LGN', 'V1', 'LOC');
%  xlabel('FREQUENCY Hz');
%  ylabel('AMPLITUDE (AU)');
%  xlim([0, 0.4]);
%  
%  %Display Transfer Function
%  figure;
%  Hz = 0:1 / (160 * 1.25):160 / (160 * 1.25) - 1 / (160 * 1.25);
%  plot(Hz, abs(fft(newP1_V1closed) ./ fft(newP1_LGNclosed)), '-k'); hold on;
%  plot(Hz, abs(fft(newP1_LOCclosed) ./fft(newP1_V1closed)), '-r'); hold on;
%  title('Transfer function  -- P1 / Closed');
%  legend('V1 / LGN', 'LOC / V1');
%  xlabel('FREQUENCY Hz');
%  ylabel('GAIN ');
%  title('Frequency -- P1 / Closed');
%  xlim([0, 0.4]);
%  
%  %Display Inverse Transfer Function
%  figure;
%  Hz = 0:1 / (160 * 1.25):160 / (160 * 1.25) - 1 / (160 * 1.25);
%  plot(Hz, abs(1 ./ (fft(newP1_V1closed) ./ fft(newP1_LGNclosed))), '-k'); hold on;
%  plot(Hz, abs(1 ./ (fft(newP1_LOCclosed) ./fft(newP1_V1closed))), '-r'); hold on;
%  title('Inverse Transfer function  -- P1 / Closed');
%  legend('LGN / V1', 'V1 / LOC');
%  xlabel('FREQUENCY Hz');
%  ylabel('GAIN ');
%  title('Frequency -- P1 / Closed');
%  xlim([0, 0.4]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figure;
% load -ASCII 'P2\RegionsTC\C\LGN.dat'
% newP2_LGNclosed = RemoveDC(LGN);
% plot(time, newP2_LGNclosed, '-k'); hold on;
% 
% load -ASCII 'P2\RegionsTC\C\V1.dat'
% newP2_V1closed = RemoveDC(V1);
% plot(time, newP2_V1closed, '-b'); hold on;
% 
% load -ASCII 'P2\RegionsTC\C\LOC.dat'
% newP2_LOCclosed = RemoveDC(LOC);
% plot(time, newP2_LOCclosed, '-r'); 
% 
% xlabel('TIME s');
% ylabel('AMPLITUDE (AU)');
% title('Original Data -- P2 / Closed');
% legend('LGN', 'V1', 'LOC');
% 
% % % Display spectrum
%  figure;
%  plot(Hz, abs(fft(newP2_LGNclosed)), '-k'); hold on;
%  plot(Hz, abs(fft(newP2_V1closed)), '-b'); hold on;
%  plot(Hz, abs(fft(newP2_LOCclosed)), '-r'); hold on;
%  title('Frequency response -- P2 / Closed');
%  legend('LGN', 'V1', 'LOC');
%  xlabel('FREQUENCY Hz');
%  ylabel('AMPLITUDE (AU)');
%  xlim([0, 0.4]);
%  
%  %Display Transfer Function
%  figure;
%  Hz = 0:1 / (160 * 1.25):160 / (160 * 1.25) - 1 / (160 * 1.25);
%  plot(Hz, abs(fft(newP2_V1closed) ./ fft(newP2_LGNclosed)), '-k'); hold on;
%  plot(Hz, abs(fft(newP2_LOCclosed) ./fft(newP2_V1closed)), '-r'); hold on;
%  title('Transfer function  -- P2 / Closed');
%  legend('V1 / LGN', 'LOC / V1');
%  xlabel('FREQUENCY Hz');
%  ylabel('GAIN ');
%  title('Frequency -- P2 / Closed');
%  xlim([0, 0.4]);
% % 
%  %Display Inverse Transfer Function
%  figure;
%  Hz = 0:1 / (160 * 1.25):160 / (160 * 1.25) - 1 / (160 * 1.25);
%  plot(Hz, abs(1 ./ (fft(newP2_V1closed) ./ fft(newP2_LGNclosed))), '-k'); hold on;
%  plot(Hz, abs(1 ./ (fft(newP2_LOCclosed) ./fft(newP2_V1closed))), '-r'); hold on;
%  title('Inverse Transfer function  -- P2 / Closed');
%  legend('LGN / V1', 'V1 / LOC');
%  xlabel('FREQUENCY Hz');
%  ylabel('GAIN ');
%  title('Frequency -- P2 / Closed');
%  xlim([0, 0.4]);