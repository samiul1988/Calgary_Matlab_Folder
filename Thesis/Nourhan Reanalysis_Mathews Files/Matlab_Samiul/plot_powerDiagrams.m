%%% This flie generates power spectrum of different patients and controls
%%% for  LGN to V1 propagation for eyesclosed condition

%%%%% Power Diagrams %%%%%%
clear all;
clc;
close all;
%%% Load database %%%
load('TF_database.mat');
power=struct;

field=fieldnames(database);
frequency_vector_NFFT=database.header.frequency_vector_NFFT;
L_NFFT=database.header.L_NFFT;
% band1=find(frequency_vector_NFFT<=0.1);
% band2=find(frequency_vector_NFFT>0.1 & frequency_vector_NFFT<=0.2);
% band3=find(frequency_vector_NFFT>0.2);

for i=2:length(field)
    pSpectrum(i,:)=database.(field{i}).eyesClosed.TF.ptf_LGN1_V1;
end
    
figure; 
plot(frequency_vector_NFFT,pSpectrum(13:16,1:L_NFFT));

