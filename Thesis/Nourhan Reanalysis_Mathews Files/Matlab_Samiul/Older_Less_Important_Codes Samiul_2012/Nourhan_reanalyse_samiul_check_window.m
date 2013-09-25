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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Open necessary files %%%%%%%
%%%%%% C1 == Control subject 1, P1 = Patient 1....etc
%%%%%% C = Eyes Closed, O = Eyes Open %%%%

root_dir='C:\Users\Samiul\Downloads\My Dropbox\samiul_home_lab\Calgary Matlab Folder\Thesis\Nourhan Reanalysis_Mathews Files\All Patient Data\Dataset';

check_type=input('Control Subject or patient data?(Type "c" for Control and "p" for Patient):','s');
if check_type=='c'
    check_number=input('Enter control subject number (1 to 12): ');
    check_eye=input('Eyes Closed or Open? (Type "c" for closed and "o" for open): ','s');
    if check_eye=='c'
        file_dir=strcat('\controls','\C',num2str(check_number),'\RegionsTC','\C');
    elseif check_eye=='o' 
        file_dir=strcat('\controls','\C',num2str(check_number),'\RegionsTC','\O');
    else error('myApp:eyeChk', 'Wrong Eye condition!!!')
    end 
elseif check_type=='p'
    check_number=input('Enter patient number (1 to 12): ');
    check_eye=input('Eyes Closed or Open? (Type "c" for closed and "o" for open): ','s');
    check_return_patient = input('Enter Patient Nature: "Null" for current patient, "a" for return patient\n or "b" for double retrun patient: ','s');
    if check_eye=='c'
        file_dir=strcat('\patients','\p',num2str(check_number),check_return_patient,'\RegionsTC','\C');
    elseif check_eye=='o' 
        file_dir=strcat('\patients','\p',num2str(check_number),check_return_patient,'\RegionsTC','\O');
    else error('myApp:eyeChk', 'Wrong Eye condition!!!')
    end
else error('myApp:eyeChk2', 'Wrong Command!!!')
end
root_dir=strcat(root_dir,file_dir);
w=cd;
cd(root_dir);
if check_eye=='c'
    load(strcat('C','LGN1.dat'));
    load(strcat('C','LGN2.dat'));
    load(strcat('C','LOC1.dat'));
    load(strcat('C','LOC2.dat'));
    load(strcat('C','SPA1.dat'));
    load(strcat('C','SPA2.dat'));
    load(strcat('C','V1.dat'));
else 
    load(strcat('O','LGN1.dat'));
    load(strcat('O','LGN2.dat'));
    load(strcat('O','LOC1.dat'));
    load(strcat('O','LOC2.dat'));
    load(strcat('O','SPA1.dat'));
    load(strcat('O','SPA2.dat'));
    load(strcat('O','V1.dat'));
end
cd(w);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if check_eye=='c'
    LGN = CLGN1;
    V1 = CV1;
    LOC1 = CLOC1;
    LOC2 = CLOC2;
    SPA1 = CSPA1;
    SPA2 = CSPA2;
else 
    LGN = OLGN1;
    V1 = OV1;
    LOC1 = OLOC1;
    LOC2 = OLOC2;
    SPA1 = OSPA1;
    SPA2 = OSPA2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Define time and frequency vectors and other parameters %%%%%%%%%%%

T=1.25; %%%%% Sampling Time (TR=2000ms)
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
    w_vector={'rectwin','barthannwin','blackman','blackmanharris','bohmanwin'};%,'chebwin','gausswin','hamming','hann','kaiser','nuttallwin',...
%               'parzenwin','taylo%rwin','tukeywin'};
%     w_vector={'rectwin','blackmanharris_p','blackmanharris_s'};
    for i=1:length(w_vector)
        if strcmp(w_vector{i},'blackmanharris_p')
            window_vector = window('blackmanharris',L,'periodic');
        elseif strcmp(w_vector{i},'blackmanharris_s')
            window_vector = window('blackmanharris',L,'symmetric');
        else window_vector = window(w_vector{i},L);
        end
        
        LGN_noDC_windowed = LGN_noDC.*window_vector;
%         V1_noDC_windowed = V1_noDC.*window_vector;
%         LOC1_noDC_windowed = LOC1_noDC.*window_vector;
%         LOC2_noDC_windowed = LOC2_noDC.*window_vector;
%         SPA1_noDC_windowed = SPA1_noDC.*window_vector;
%         SPA2_noDC_windowed = SPA2_noDC.*window_vector;
        
%         figure;
%         subplot 211
%         plot(window_vector), title('window')
%         subplot 212
%         plot(time_vector,[LGN_noDC_windowed,V1_noDC_windowed,LOC1_noDC_windowed,LOC2_noDC_windowed,SPA1_noDC_windowed,...
%                                     SPA2_noDC_windowed]);  %%%% Time domain plot of data with DC component removed and windowed 
%         legend('LGN','V1','LOC1','LOC2','SPA1','SPA2');
%         title('Data after windowing')
        
    %%%% Frequency response of each region 
        LGN_noDC_windowed_fft(:,i) = fft(LGN_noDC_windowed,NFFT);
%         V1_noDC_windowed_fft(:,i) = fft(V1_noDC_windowed,NFFT);
%         LOC1_noDC_windowed_fft = fft(LOC1_noDC_windowed,NFFT);
%         LOC2_noDC_windowed_fft = fft(LOC2_noDC_windowed,NFFT);
%         SPA1_noDC_windowed_fft = fft(SPA1_noDC_windowed,NFFT);
%         SPA2_noDC_windowed_fft = fft(SPA2_noDC_windowed,NFFT);
%         
    end
    
        figure;
%         subplot 311
        plot(frequency_vector_NFFT,abs(LGN_noDC_windowed_fft(1:length(frequency_vector_NFFT),1:5)));
        title('Frequency Response for LGN region: Patient Eyes Opened')
        legend('rectwin','barthannwin','blackman','blackmanharris','bohmanwin');
        subplot 312
        plot(frequency_vector_NFFT,abs(LGN_noDC_windowed_fft(1:length(frequency_vector_NFFT),6:10)));
        title('Frequency Response for LGN region: Patient Eyes Opened')
        legend('chebwin','gausswin','hamming','hann','kaiser');
        subplot 313
        plot(frequency_vector_NFFT,abs(LGN_noDC_windowed_fft(1:length(frequency_vector_NFFT),11:14)));
        title('Frequency Response for LGN region: Patient Eyes Opened')
        legend('nuttallwin','parzenwin','taylorwin','tukeywin');
            

%         plot(frequency_vector_NFFT,abs([LGN_noDC_windowed_fft(1:length(frequency_vector_NFFT)),V1_noDC_windowed_fft(1:length(frequency_vector_NFFT)),...
%                                 LOC1_noDC_windowed_fft(1:length(frequency_vector_NFFT)),LOC2_noDC_windowed_fft(1:length(frequency_vector_NFFT))...
%                                 SPA1_noDC_windowed_fft(1:length(frequency_vector_NFFT)),SPA2_noDC_windowed_fft(1:length(frequency_vector_NFFT))]));
%         legend('LGN','V1','LOC1','LOC2','SPA1','SPA2');
%         title('Frequency Response')
    
%     %%% Correlation Transfer Function %%%
%     %%% LGN--->V1
%     tf_LGN_V1 = V1_noDC_windowed_fft./LGN_noDC_windowed_fft;
%     power_tf_LGN_V1 = tf_LGN_V1.*conj(tf_LGN_V1);
%     
%     %%% V1--->LOC1
%     tf_V1_LOC1 = LOC1_noDC_windowed_fft./V1_noDC_windowed_fft;
%     power_tf_V1_LOC1 = tf_V1_LOC1.*conj(tf_V1_LOC1);
%     
%     %%% V1--->LOC2
%     tf_V1_LOC2 = LOC2_noDC_windowed_fft./V1_noDC_windowed_fft;
%     power_tf_V1_LOC2 = tf_V1_LOC2.*conj(tf_V1_LOC2);
%     
%     %%% V1--->SPA1
%     tf_V1_SPA1 = SPA1_noDC_windowed_fft./V1_noDC_windowed_fft;
%     power_tf_V1_SPA1 = tf_V1_SPA1.*conj(tf_V1_SPA1);
%     
%     %%% V1--->SPA2
%     tf_V1_SPA2 = SPA2_noDC_windowed_fft./V1_noDC_windowed_fft;
%     power_tf_V1_SPA2 = tf_V1_SPA2.*conj(tf_V1_SPA2);
%     end

%     figure;
%     plot(frequency_vector_NFFT,)
% Pxx = abs(fft(C1_LGN_Closed_DC_removed,NFFT)).^2/L*T;
% Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',1/T); 
% % h=spectrum.welch;
% % Hpsd=psd(h,C1_LGN_Closed_DC_removed);
% plot(Hpsd)


