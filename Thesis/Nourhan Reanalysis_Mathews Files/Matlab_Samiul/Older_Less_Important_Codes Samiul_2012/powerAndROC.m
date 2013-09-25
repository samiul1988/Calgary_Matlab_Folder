%%% ROC analysis %%%%
%%%% between control and patients in eyes closed condition %%%
%%% for LGN1 to V1 %%%

clear all;
clc;
close all;
%%% Load database %%%
% load('TF_database.mat');
load('TF_databseNFFT256.mat');
power = struct;

field = fieldnames(database);
frequency_vector_NFFT = database.header.frequency_vector_NFFT;
band1 = find(frequency_vector_NFFT<=0.1);
band2 = find(frequency_vector_NFFT>0.1 & frequency_vector_NFFT<=0.2);
band3 = find(frequency_vector_NFFT>0.2);

for i = 2:length(field)
    pSpectrum = database.(field{i}).eyesClosed.TF.ptf_V1_LOC1;
    
    P_band1 = sum(pSpectrum(band1));
    P_band2 = sum(pSpectrum(band2));
    P_band3 = sum(pSpectrum(band3));
    P_total = P_band1+P_band2+P_band3;

    power.(field{i}).P_band1_Total = P_band1/P_total;
    power.(field{i}).P_band2_Total = P_band2/P_total;
    power.(field{i}).P_band3_Total = P_band3/P_total;
    power.(field{i}).P_band1_band2 = P_band1/P_band2;
    power.(field{i}).P_band1_band3 = P_band1/P_band3;
    power.(field{i}).P_band2_band3 = P_band2/P_band3;
    clear pSpectrum P_band1 P_band2 P_band3 P_total;
end

%%%%%%%%%% ROC analysis %%%%%%%%%%%%%%%%
field_power=fieldnames(power);
P1_Ptotal=zeros(length(field_power),2);
P2_Ptotal=zeros(length(field_power),2);
P3_Ptotal=zeros(length(field_power),2);
P1_P2=zeros(length(field_power),2);
P1_P3=zeros(length(field_power),2);
P2_P3=zeros(length(field_power),2);

for i=1:length(field_power)
    P1_Ptotal(i,1)=power.(field_power{i}).P_band1_Total;
    P2_Ptotal(i,1)=power.(field_power{i}).P_band2_Total;
    P3_Ptotal(i,1)=power.(field_power{i}).P_band3_Total;
    P1_P2(i,1)=power.(field_power{i}).P_band1_band2;
    P1_P3(i,1)=power.(field_power{i}).P_band1_band3;
    P2_P3(i,1)=power.(field_power{i}).P_band2_band3;
    
    if strcmp(field_power{i}(1:7),'control')
        P1_Ptotal(i,2)= 0;
        P2_Ptotal(i,2)= 0;
        P3_Ptotal(i,2)= 0;
        P1_P2(i,2)= 0;
        P1_P3(i,2)= 0;
        P2_P3(i,2)= 0;
    elseif strcmp(field_power{i}(1:7),'patient')
        P1_Ptotal(i,2)= 1;
        P2_Ptotal(i,2)= 1;
        P3_Ptotal(i,2)= 1;
        P1_P2(i,2)= 1;
        P1_P3(i,2)= 1;
        P2_P3(i,2)= 1;
    end
end

P2_Ptotal_ROC=roc(P2_Ptotal,[],0.05,1,'g','2');
% P3_Ptotal_ROC=roc(P3_Ptotal,[],0.05,1,'c','3');
% 
% P2_P3_ROC=roc(P2_P3,[],0.05,1,'y','6');
% 
% 
% P1_P2_ROC=roc(P1_P2,[],0.05,1,'r','4');
% P1_P3_ROC=roc(P1_P3,[],0.05,1,'k','5');
% P1_Ptotal_ROC=roc(P1_Ptotal,[],0.05,1,'b','1');


        
        
    



