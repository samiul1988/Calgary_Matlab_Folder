%% WVD of signals
%% Add Time/Frequency Toolbox to search path
%%%%% For Home Laptop
% addpath(genpath('C:\Users\Samiul\Dropbox\samiul_home_lab\Calgary_study_documents\Thesis\Time Frequency Toolbox\tftb-0.2'));
%%%%% For Lab PC
% addpath(genpath('C:\Users\shchoudh\Dropbox\samiul_home_lab\Calgary_study_documents\Thesis\Time Frequency Toolbox\tftb-0.2'));

%% Clear Data and screen
% clear all;
% clc;
% close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Practice with simple example  
Fs=10000;
Ts=1/Fs;
L=1000;
NFFT=1024;
t=(0:L-1)*Ts;
fNfft=0:1/(NFFT*Ts):1/(2*Ts);
fN=fNfft/Fs;
x=sin(2*pi*100*t);
X=fft(x,NFFT);
xx=ifft(X,NFFT);


% figure;
% subplot 211; plot(t,x);
% subplot 212; plot(t,xx(1:length(t)));

figure;
plot_hht(x,Ts)
%%% Linear Time-Frequency Processing
% tfrgabor(x'); %%%%% Gabor representation
% tfrstft(x');   %%%%% Short time Fourier transform (***)

%%%  Bilinear Time-Frequency Processing in the Cohen's Class
% tfrbj(x');  %%%    - Born-Jordan distribution.                     
% tfrbud(x');  %%%   - Butterworth distribution.                   
% tfrcw(x');  %%%    - Choi-Williams distribution.                   
% tfrgrd(x');  %%%    - Generalized rectangular distribution.        
% tfrmh(x');  %%%     - Margenau-Hill distribution.                    
% tfrmhs(x');  %%%   - Margenau-Hill-Spectrogram distribution.  (*)
% tfrmmce(x');  %%%   - MMCE combination of spectrograms. 
% tfrpage(x');  %%%   - Page distribution.                          
% tfrpmh(x');  %%%    - Pseudo Margenau-Hill distribution.          
% tfrppage(x');  %%%  - Pseudo Page distribution.                 
% tfrpwv(x');  %%%    - Pseudo Wigner-Ville distribution.  (*)          
% tfrri(x');  %%%     - Rihaczek distribution.                       
% tfrridb(x');  %%%   - Reduced interference distribution (Bessel window).
% tfrridh(x');  %%%   - Reduced interference distribution (Hanning window).
% % tfrridn(x');  %%%   - Reduced interference distribution (binomial window).
% tfrridt(x');  %%%   - Reduced interference distribution (triangular window).
% tfrsp(x');  %%%     - Spectrogram.       (**)              
% tfrspwv(x');  %%%   - Smoothed Pseudo Wigner-Ville distribution.   (*)
% tfrwv(x');  %%%     - Wigner-Ville distribution.
% tfrzam(x');  %%%    - Zhao-Atlas-Marks distribution.    (*)        
% 
% %%%% Bilinear Time-Frequency Processing in the Affine Class
% tfrbert(x');  %%%   - Unitary Bertrand distribution.  (*)
% tfrdfla(x');  %%%   - D-Flandrin distribution.
% tfrscalo(x');  %%%  - Scalogram, for Morlet or Mexican hat wavelet.
% tfrspaw(x');  %%%   - Smoothed Pseudo Affine Wigner distributions.
% tfrunter(x');  %%%  - Unterberger distribution, active or passive form.
%     
% %%%%% Reassigned Time-Frequency Processing
% tfrrgab(x');  %%%   - Reassigned Gabor spectrogram.       (**)
% tfrrmsc(x');  %%%   - Reassigned Morlet Scalogram time-frequency distribution.
% tfrrpmh(x');  %%%   - Reassigned Pseudo Margenau-Hill distribution.
% tfrrppag(x');  %%%  - Reassigned Pseudo Page distribution.
% tfrrpwv(x');  %%%   - Reassigned Pseudo Wigner-Ville distribution.    (**)
% tfrrsp(x');  %%%    - Reassigned Spectrogram. 
% tfrrspwv(x');  %%%  - Reassigned Smoothed Pseudo WV distribution.
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sample brain signal from the transfer function  
 
load('TF_database.mat'); %%% load 'database'
SIG = database.patient11.eyesClosed.TF.tf_V1_SPA1;
sig = abs(ifft(SIG));
plot_hht(sig, 1.25)
% tfrstft(sig); 
% tfrgabor(sig)
% tfrpwv(sig);
% tfrsp(sig);
% tfrzam(sig);  %%%    - Zhao-Atlas-Marks distribution
% tfrrgab(sig);  %%%   - Reassigned Gabor spectrogram
% tfrrpwv(sig);  %%%   - Reassigned Pseudo Wigner-Ville distribution
% figure; plot(abs(database.control1.eyesClosed.TF.tf_LGN1_V1(1:128)));


%%
% tfrwv(database.control2.eyesOpened.Original.LOC1);

u=abs(ifft(database.control2.eyesOpened.TF.tf_LGN1_V1));    
tfrwv(u);


T=1.5; %%%%% Sampling Time
L= 160; %%%% Signal Length
NFFT = 256; %%%%%% Number of FFT point 
time_vector = (0:L-1)*T;
frequency_vector = 0:1/(L*T):1/(2*T); %%% for normal FFT
frequency_vector_NFFT = 0:1/(NFFT*T):1/(2*T); %%% for NFFT-point FFT
L_NFFT=length(frequency_vector_NFFT);
% frequency_vector = 0:1/(L*T):(160 - 1) / (2* 160 * 1.25);


% 
% t=0:0.0001:0.2;
% y=sin(2*pi*10*t);
% tfrwv(y');


