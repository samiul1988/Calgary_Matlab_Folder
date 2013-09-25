%%%%%%%%%%%%%%%%%% Matlab program for generating databse for optic neuritis
%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
clc

database=struct;
%%%%%%% Define time and frequency vectors and other parameters %%%%%%%%%%%
sampleNumber = 1; %%% 1: consider all samples, 2: downsample by 2
T=1.5*sampleNumber; %%%%% Sampling Time
L= 160/sampleNumber; %%%% Signal Length
NFFT = 2^(nextpow2(L)); %%%%%% Number of FFT point 
time_vector = (0:L-1)*T;
frequency_vector = 0:1/(L*T):1/(2*T); %%% for normal FFT
frequency_vector_NFFT = 0:1/(NFFT*T):1/(2*T); %%% for NFFT-point FFT
L_NFFT=length(frequency_vector_NFFT);

database.header.T=T; %%%%% Sampling Time
database.header.L= L; %%%% Signal Length
database.header.NFFT = NFFT; %%%%%% Number of FFT point 
database.header.time_vector = time_vector;
database.header.frequency_vector = frequency_vector; %%% for normal FFT
database.header.frequency_vector_NFFT = frequency_vector_NFFT; %%% for NFFT-point FFT
database.header.L_NFFT=L_NFFT;
% frequency_vector = 0:1/(L*T):(160 - 1) / (2* 160 * 1.25);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%% for home laptop %%%
rootDir_controls='C:\Users\Samiul\Dropbox\samiul_home_lab\Calgary Matlab Folder\Thesis\Nourhan Reanalysis_Mathews Files\All Patient Data\Dataset\before_windowing\controls';
rootDir_patients='C:\Users\Samiul\Dropbox\samiul_home_lab\Calgary Matlab Folder\Thesis\Nourhan Reanalysis_Mathews Files\All Patient Data\Dataset\before_windowing\patients';

%%% for LAB PC %%%
% rootDir_controls='C:\Users\shchoudh\Dropbox\samiul_home_lab\Calgary Matlab Folder\Thesis\Nourhan Reanalysis_Mathews Files\All Patient Data\Dataset\before_windowing\controls';
% rootDir_patients='C:\Users\shchoudh\Dropbox\samiul_home_lab\Calgary Matlab Folder\Thesis\Nourhan Reanalysis_Mathews Files\All Patient Data\Dataset\before_windowing\patients';


num_controls=12;
num_patients=28;

window_type='tukeywin';
powerOrAmplitude='power';


%%%%%%%% for control subjects %%%%%%
for i=1:num_controls
    %%% data for eyes closed condition
    rootAddClosed=strcat(rootDir_controls,'\C',num2str(i),'\RegionsTC\C');
    w=cd;
    cd(rootAddClosed);
    
    if ~isempty(dir(strcat(rootAddClosed,'/*.dat')))
        load('CLGN1.dat');
        load('CLGN2.dat');
        load('CLOC1.dat');
        load('CLOC2.dat');
        load('CSPA1.dat');
        load('CSPA2.dat');
        load('CV1.dat');
        cd(w);
        database.(sprintf('control%d',i)).eyesClosed.Original.LGN1=downsample(CLGN1,sampleNumber);
        database.(sprintf('control%d',i)).eyesClosed.Original.LGN2=downsample(CLGN2,sampleNumber);
        database.(sprintf('control%d',i)).eyesClosed.Original.LOC1=downsample(CLOC1,sampleNumber);
        database.(sprintf('control%d',i)).eyesClosed.Original.LOC2=downsample(CLOC2,sampleNumber);
        database.(sprintf('control%d',i)).eyesClosed.Original.SPA1=downsample(CSPA1,sampleNumber);
        database.(sprintf('control%d',i)).eyesClosed.Original.SPA2=downsample(CSPA2,sampleNumber);
        database.(sprintf('control%d',i)).eyesClosed.Original.V1=downsample(CV1,sampleNumber);
        
        ECnoDC=remove_DC(database.(sprintf('control%d',i)).eyesClosed.Original);
        ECnoDCwin=do_window(ECnoDC,window_type);
        %%%% fft calculation 
        database.(sprintf('control%d',i)).eyesClosed.FFT=do_fft(ECnoDCwin,NFFT);
    
        %%%%%  calculate transfer function %%%%%
        database.(sprintf('control%d',i)).eyesClosed.TF=do_TransferFunction(database.(sprintf('control%d',i)).eyesClosed.FFT,'all',powerOrAmplitude,NFFT);
       
        clear('CLGN1','CLGN2','CLOC1','CLOC2','CSPA1','CSPA2','CV1','ECnoDC','ECnoDCwin');
    else 
        cd(w);
    end %% if 
    
         %%% data for eyes opened condition
        rootAddOpened=strcat(rootDir_controls,'\C',num2str(i),'\RegionsTC\O');
        w=cd;
        cd(rootAddOpened);
    if ~isempty(dir(strcat(rootAddOpened,'/*.dat')))
        load('OLGN1.dat');
        load('OLGN2.dat');
        load('OLOC1.dat');
        load('OLOC2.dat');
        load('OSPA1.dat');
        load('OSPA2.dat');
        load('OV1.dat');
        cd(w)
        database.(sprintf('control%d',i)).eyesOpened.Original.LGN1=downsample(OLGN1,sampleNumber);
        database.(sprintf('control%d',i)).eyesOpened.Original.LGN2=downsample(OLGN2,sampleNumber);
        database.(sprintf('control%d',i)).eyesOpened.Original.LOC1=downsample(OLOC1,sampleNumber);
        database.(sprintf('control%d',i)).eyesOpened.Original.LOC2=downsample(OLOC2,sampleNumber);
        database.(sprintf('control%d',i)).eyesOpened.Original.SPA1=downsample(OSPA1,sampleNumber);
        database.(sprintf('control%d',i)).eyesOpened.Original.SPA2=downsample(OSPA2,sampleNumber);
        database.(sprintf('control%d',i)).eyesOpened.Original.V1=downsample(OV1,sampleNumber);
        
        EOnoDC=remove_DC(database.(sprintf('control%d',i)).eyesOpened.Original);
        EOnoDCwin=do_window(EOnoDC,window_type);
        %%%% fft calculation 
        database.(sprintf('control%d',i)).eyesOpened.FFT=do_fft(EOnoDCwin,NFFT);
        %%%%%  calculate transfer function %%%%%
        database.(sprintf('control%d',i)).eyesOpened.TF=do_TransferFunction(database.(sprintf('control%d',i)).eyesOpened.FFT,'all',powerOrAmplitude,NFFT);  
        clear('OLGN1','OLGN2','OLOC1','OLOC2','OSPA1','OSPA2','OV1','EOnoDC','EOnoDCwin');
    else 
        cd(w);
    end %% if   
end %% for

%%%%%%%% for patients %%%%%%
for i=1:num_patients
    %%% data for eyes closed condition
    rootAddClosed=strcat(rootDir_patients,'\p',num2str(i),'\RegionsTC\C');
    w=cd;
    cd(rootAddClosed);
    
    if ~isempty(dir(strcat(rootAddClosed,'/*.dat')))
        load('CLGN1.dat');
        load('CLGN2.dat');
        load('CLOC1.dat');
        load('CLOC2.dat');
        load('CSPA1.dat');
        load('CSPA2.dat');
        load('CV1.dat');
        cd(w)
        database.(sprintf('patient%d',i)).eyesClosed.Original.LGN1=downsample(CLGN1,sampleNumber);
        database.(sprintf('patient%d',i)).eyesClosed.Original.LGN2=downsample(CLGN1,sampleNumber);
        database.(sprintf('patient%d',i)).eyesClosed.Original.LOC1=downsample(CLGN1,sampleNumber);
        database.(sprintf('patient%d',i)).eyesClosed.Original.LOC2=downsample(CLGN1,sampleNumber);
        database.(sprintf('patient%d',i)).eyesClosed.Original.SPA1=downsample(CLGN1,sampleNumber);
        database.(sprintf('patient%d',i)).eyesClosed.Original.SPA2=downsample(CLGN1,sampleNumber);
        database.(sprintf('patient%d',i)).eyesClosed.Original.V1=downsample(CLGN1,sampleNumber);
        
        ECnoDC=remove_DC(database.(sprintf('patient%d',i)).eyesClosed.Original);
        ECnoDCwin=do_window(ECnoDC,window_type);
        %%%% fft calculation 
        database.(sprintf('patient%d',i)).eyesClosed.FFT=do_fft(ECnoDCwin,NFFT);
        %%%%%  calculate transfer function %%%%%
        database.(sprintf('patient%d',i)).eyesClosed.TF=do_TransferFunction(database.(sprintf('patient%d',i)).eyesClosed.FFT,'all',powerOrAmplitude,NFFT);
        
        clear('CLGN1','CLGN2','CLOC1','CLOC2','CSPA1','CSPA2','CV1','ECnoDC','ECnoDCwin');
    else 
        cd(w);
    end %%if
    
    %%% data for eyes opened condition
    rootAddOpened=strcat(rootDir_patients,'\p',num2str(i),'\RegionsTC\O');
    w=cd;
    cd(rootAddOpened);
    
    if ~isempty(dir(strcat(rootAddOpened,'/*.dat')))
        load('OLGN1.dat');
        load('OLGN2.dat');
        load('OLOC1.dat');
        load('OLOC2.dat');
        load('OSPA1.dat');
        load('OSPA2.dat');
        load('OV1.dat');
        cd(w)
        database.(sprintf('patient%d',i)).eyesOpened.Original.LGN1=downsample(OLGN1,sampleNumber);
        database.(sprintf('patient%d',i)).eyesOpened.Original.LGN2=downsample(OLGN2,sampleNumber);
        database.(sprintf('patient%d',i)).eyesOpened.Original.LOC1=downsample(OLOC1,sampleNumber);
        database.(sprintf('patient%d',i)).eyesOpened.Original.LOC2=downsample(OLOC2,sampleNumber);
        database.(sprintf('patient%d',i)).eyesOpened.Original.SPA1=downsample(OSPA1,sampleNumber);
        database.(sprintf('patient%d',i)).eyesOpened.Original.SPA2=downsample(OSPA2,sampleNumber);
        database.(sprintf('patient%d',i)).eyesOpened.Original.V1=downsample(OV1,sampleNumber);
        
        EOnoDC=remove_DC(database.(sprintf('patient%d',i)).eyesOpened.Original);
        EOnoDCwin=do_window(EOnoDC,window_type);
        %%%% fft calculation 
        database.(sprintf('patient%d',i)).eyesOpened.FFT=do_fft(EOnoDCwin,NFFT);
        %%%%%  calculate transfer function %%%%%
        database.(sprintf('patient%d',i)).eyesOpened.TF=do_TransferFunction(database.(sprintf('patient%d',i)).eyesOpened.FFT,'all',powerOrAmplitude,NFFT);  
        clear('OLGN1','OLGN2','OLOC1','OLOC2','OSPA1','OSPA2','OV1','EOnoDC','EOnoDCwin');
    else
        cd(w);
    end %%%% if
end %%% for
  
% save('TF_databseNFFT256.mat','database');