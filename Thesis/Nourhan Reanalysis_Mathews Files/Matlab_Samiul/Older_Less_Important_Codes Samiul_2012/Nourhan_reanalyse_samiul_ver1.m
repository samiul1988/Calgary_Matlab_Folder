%%%%%%%% Reanalysis of Nourhan's Data using all patients and control %%%%%%%%
%%%%%%%% subjects' data 
%%%%%% generates time domain figures, frequency features and transfer
%%%%%% functions 

clear all;
clc;
close all;

% w=cd;
% [filename, pathname, fileindex]=uigetfile('*.dat','Select the desired file');  %%% open control or patients' data
% cd(pathname);
% load(filename);
% cd(w);
C1EC=get_input; %%%% Get the input data
LGN=C1EC.LGN;
V1=C1EC.V1;
LOC1=C1EC.LOC1;
LOC2=C1EC.LOC2;
SPA1=C1EC.SPA1;
SPA2=C1EC.SPA2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Define time and frequency vectors and other parameters %%%%%%%%%%%

T=1.5; %%%%% Sampling Time
L= length(LGN); %%%% Signal Length
NFFT = 512; %%%%%% Number of FFT point 
time_vector = (0:L-1)*T;
frequency_vector = 0:1/(L*T):1/(2*T); %%% for normal FFT
frequency_vector_NFFT = 0:1/(NFFT*T):1/(2*T); %%% for NFFT-point FFT
% frequency_vector = 0:1/(L*T):(160 - 1) / (2* 160 * 1.25);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    figure;
    plot(time_vector,[LGN,V1,LOC1,LOC2,SPA1,SPA2]);  %%%% Time domain plot of raw data
    legend('LGN','V1','LOC1','LOC2','SPA1','SPA2');
    title('Raw Data')
    
    %%%  DC removal %%%
    LGN_noDC = LGN-mean(LGN);
    V1_noDC = V1-mean(V1);
    LOC1_noDC = LOC1-mean(LOC1);
    LOC2_noDC = LOC2-mean(LOC2);
    SPA1_noDC = SPA1-mean(SPA1);
    SPA2_noDC= SPA2-mean(SPA2);
                
    figure;
    plot(time_vector,[LGN_noDC,V1_noDC,LOC1_noDC,LOC2_noDC,SPA1_noDC,SPA2_noDC]);  %%%% Time domain plot of data with DC component removed
    legend('LGN','V1','LOC1','LOC2','SPA1','SPA2');
    title('Data with DC component removed')
    
    %%% Windowing %%%%
%     w_vector={'rectwin','barthannwin','blackman','blackmanharris','bohmanwin','chebwin','gausswin','hamming','hann','kaiser','nuttallwin',...
%               'parzenwin','taylorwin','tukeywin'};
    w_vector={'tukeywin'};
    for i=1:length(w_vector)
        if strcmp(w_vector{i},'blackmanharris')
            window_vector = window(w_vector{i},L,'periodic');
        elseif strcmp(w_vector{i},'tukeywin')
            window_vector = window(w_vector{i},L,0.5);
        else
            window_vector = window(w_vector{i},L);
        end
        
%       w=1; %%%% for no window
        LGN_noDC_windowed = LGN_noDC.*window_vector;
        V1_noDC_windowed = V1_noDC.*window_vector;
        LOC1_noDC_windowed = LOC1_noDC.*window_vector;
        LOC2_noDC_windowed = LOC2_noDC.*window_vector;
        SPA1_noDC_windowed = SPA1_noDC.*window_vector;
        SPA2_noDC_windowed = SPA2_noDC.*window_vector;
        
        figure;
       
%         subplot 211
%         plot(window_vector), title('window')
%         subplot 212
%         plot(time_vector,[LGN_noDC_windowed,V1_noDC_windowed,LOC1_noDC_windowed,LOC2_noDC_windowed,SPA1_noDC_windowed,...
%                                     SPA2_noDC_windowed]);  %%%% Time domain plot of data with DC component removed and windowed 
%         legend('LGN','V1','LOC1','LOC2','SPA1','SPA2');
%         title('Data after windowing')
        
    %%%% Frequency response of each region 
        LGN_noDC_windowed_fft = fft(LGN_noDC_windowed,NFFT);
        V1_noDC_windowed_fft = fft(V1_noDC_windowed,NFFT);
        LOC1_noDC_windowed_fft = fft(LOC1_noDC_windowed,NFFT);
        LOC2_noDC_windowed_fft = fft(LOC2_noDC_windowed,NFFT);
        SPA1_noDC_windowed_fft = fft(SPA1_noDC_windowed,NFFT);
        SPA2_noDC_windowed_fft = fft(SPA2_noDC_windowed,NFFT);
        
        p_LGN = LGN_noDC_windowed_fft.*conj(LGN_noDC_windowed_fft);
        p_V1 = V1_noDC_windowed_fft.*conj(V1_noDC_windowed_fft);
%         figure;
%         plot(frequency_vector_NFFT,[p_LGN(1:length(frequency_vector_NFFT)) p_V1(1:length(frequency_vector_NFFT))]);
%         legend('LGN','V1');
%         xlabel('Frequency (Hz)'), ylabel('Power Spectrum');
%         title('Frequency Response')
        figure;
        plot(frequency_vector_NFFT,abs([LGN_noDC_windowed_fft(1:length(frequency_vector_NFFT)) V1_noDC_windowed_fft(1:length(frequency_vector_NFFT))]));
        legend('LGN','V1');
        xlabel('Frequency (Hz)'), ylabel('Amplitude Spectrum');
        title('Frequency Response')
%         figure;
%         plot(frequency_vector_NFFT,abs([LGN_noDC_windowed_fft(1:length(frequency_vector_NFFT)),V1_noDC_windowed_fft(1:length(frequency_vector_NFFT)),...
%                                 LOC1_noDC_windowed_fft(1:length(frequency_vector_NFFT)),LOC2_noDC_windowed_fft(1:length(frequency_vector_NFFT))...
%                                 SPA1_noDC_windowed_fft(1:length(frequency_vector_NFFT)),SPA2_noDC_windowed_fft(1:length(frequency_vector_NFFT))]));
%         legend('LGN','V1','LOC1','LOC2','SPA1','SPA2');
%         title('Frequency Response')
    
    %%% Correlation Transfer Function %%%
    %%% LGN--->V1
    tf_LGN_V1 = V1_noDC_windowed_fft./LGN_noDC_windowed_fft;
    atf=abs(tf_LGN_V1);
    power_tf_LGN_V1 = tf_LGN_V1.*conj(tf_LGN_V1);
%   power_tf_LGN_V1= p_V1./ p_LGN;
% power_tf_LGN_V1= abs(tf_LGN_V1);
  
    figure;
    plot(frequency_vector_NFFT,atf(1:length(frequency_vector_NFFT)));
    legend('V1/LGN');
    xlabel('Frequency (Hz)'), ylabel('Spectral Power');
    title('Frequency Response of the Transfer Function, LGN-->V1');
    %%% V1--->LOC1
    tf_V1_LOC1 = LOC1_noDC_windowed_fft./V1_noDC_windowed_fft;
    power_tf_V1_LOC1 = tf_V1_LOC1.*conj(tf_V1_LOC1);
    
    %%% V1--->LOC2
    tf_V1_LOC2 = LOC2_noDC_windowed_fft./V1_noDC_windowed_fft;
    power_tf_V1_LOC2 = tf_V1_LOC2.*conj(tf_V1_LOC2);
    
    %%% V1--->SPA1
    tf_V1_SPA1 = SPA1_noDC_windowed_fft./V1_noDC_windowed_fft;
    power_tf_V1_SPA1 = tf_V1_SPA1.*conj(tf_V1_SPA1);
    
    %%% V1--->SPA2
    tf_V1_SPA2 = SPA2_noDC_windowed_fft./V1_noDC_windowed_fft;
    power_tf_V1_SPA2 = tf_V1_SPA2.*conj(tf_V1_SPA2);
    end
    
%     figure;
%     plot(frequency_vector_NFFT,)
% Pxx = abs(fft(C1_LGN_Closed_DC_removed,NFFT)).^2/L*T;
% Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',1/T); 
% % h=spectrum.welch;
% % Hpsd=psd(h,C1_LGN_Closed_DC_removed);
% plot(Hpsd)


