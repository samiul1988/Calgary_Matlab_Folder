%% This file generates transfer function with 'threshold' feature and generates metrics for ROC analysis

%% initialization
clear all;
clc;
close all;

%%% Load database %%%
data = load('TF_database.mat');

%%% general name for the input: database
database = data.database;
field_database = fieldnames(database);
% field_database={'control1','control2','control3','control4','control5','control6','control7','control8','control9','control10','control11','control12',...
%     'patient1','patient2','patient3','patient8','patient10','patient12','patient13','patient14','patient15','patient16','patient17'...
%     ,'patient19','patient20','patient21','patient22','patient23','patient24','patient25','patient26','patient27','patient28'};

% %%%%%%%%%%%%%%% Parameter Info %%%%%%%%%%%%%%%%%%%%%%%
%  T: Sampling Time: default = 1.5000
%  L: Signal Length: default = 160
%  NFFT: Number of FFT point = 2^(nextpow2(L)) or L 
%  time_vector: [1x160 double]
%  frequency_vector: [1x81 double]
%  frequency_vector_NFFT: [1x129 double] or [1x81 double]
%  L_NFFT: NFFT / 2

freq = database.header.frequency_vector_NFFT;
NFFT = database.header.NFFT;
L_NFFT = database.header.L_NFFT;
% oneSidedIndex = ceil((NFFT+1)/2); %%% Exclude half of the fft part

eyeStatus ='eyesClosed';
% eyeStatus ='eyesOpened';

%%%% Normalize data
for i=2:length(field_database)
    LGN1(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.LGN1(1:L_NFFT);
    LGN2(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.LGN2(1:L_NFFT);
    V1(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.V1(1:L_NFFT);
    LOC1(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.LOC1(1:L_NFFT);
    LOC2(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.LOC2(1:L_NFFT);
    SPA1(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.SPA1(1:L_NFFT);
    SPA2(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.SPA2(1:L_NFFT);
end

% LGN1 = normalizeMatrix(LGN1);
% LGN2 = normalizeMatrix(LGN2);
% V1 = normalizeMatrix(V1);
% LOC1 = normalizeMatrix(LOC1);
% LOC2 = normalizeMatrix(LOC2);
% SPA1 = normalizeMatrix(SPA1);
% SPA2 = normalizeMatrix(SPA2);

% figure(2)
% plot(freq,abs(LGN2(1:10,:)));
% plot(freq,abs(V1(13,:)./LGN1(13,:)))

%% Transfer Function with threshold

threshold = 0.01:.01:0.1;
%%%% function [tf,ptf,ftf] = TFwithThreshold(numeratorMatrix, denominatorMatrix,thresholdVector,freqVector,spectrumType,NFFT)
[tfMatrix,ptfMatrix,freqMatrix] = TFwithAmplitudeThreshold(SPA1,V1,threshold,freq,'power',NFFT);
% figure(2)
% plot(freq,abs(tfMatrix{}(1:10,:)));
% % plot(freq,abs(V1(13,:)./LGN1(13,:)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters for ROC analysis
%%%% ptfMatrix: numberOFperson by numberOFthreshold by FFTpoint matrix with some NaN 
%%%% freqMatrix: numberOFperson by numberOFthreshold by FFTpoint matrix with some NaN 

for i=1:length(ptfMatrix) %%% numberOfPerson
    for j=1:size(ptfMatrix{1},1) %%% numberOfThreshold
        band1{i,j}= find(freqMatrix{i}(j,:)<=0.1);
        band2{i,j}= find(freqMatrix{i}(j,:)>0.1 & freqMatrix{i}(j,:)<=0.2);
        band3{i,j}= find(freqMatrix{i}(j,:)>0.2 & freqMatrix{i}(j,:)<=0.3);
        
        P_band1(i,j) = sum(ptfMatrix{i}(j,band1{i,j}));
        P_band2(i,j) = sum(ptfMatrix{i}(j,band2{i,j}));
        P_band3(i,j) = sum(ptfMatrix{i}(j,band3{i,j}));
        P_total(i,j) = P_band1(i,j)+P_band2(i,j)+P_band3(i,j);
        
        P_band1_Total(i,j) = P_band1(i,j)/P_total(i,j);
        P_band2_Total(i,j) = P_band2(i,j)/P_total(i,j);
        P_band3_Total(i,j) = P_band3(i,j)/P_total(i,j);
        P_band1_band2(i,j) = P_band1(i,j)/P_band2(i,j);
        P_band1_band3(i,j) = P_band1(i,j)/P_band3(i,j);
        P_band2_band3(i,j) = P_band2(i,j)/P_band3(i,j);
    end
end

%% ROC analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% ROC for constant threshold: P1/Ptotal, P2/Ptotal...etc %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%% ROC in MATLAB %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P1_Ptotal=zeros(length(field_database(2:end)),2);
% P2_Ptotal=zeros(length(field_database(2:end)),2);
% P3_Ptotal=zeros(length(field_database(2:end)),2);
% P1_P2=zeros(length(field_database(2:end)),2);
% P1_P3=zeros(length(field_database(2:end)),2);
% P2_P3=zeros(length(field_database(2:end)),2);
% 
% for i=1:length(field_database(2:end))
%     P1_Ptotal(i,1)= P_band1_Total(i,1);
%     P2_Ptotal(i,1)= P_band2_Total(i,1);
%     P3_Ptotal(i,1)= P_band3_Total(i,1);
%     P1_P2(i,1)= P_band1_band2(i,1);
%     P1_P3(i,1)= P_band1_band3(i,1);
%     P2_P3(i,1)= P_band2_band3(i,1);
%     
% %     if strcmp(field_database{i+1}(1:7),'control')
%     if strcmp(field_database{i+1}(1),'C')
%         P1_Ptotal(i,2)= 0;
%         P2_Ptotal(i,2)= 0;
%         P3_Ptotal(i,2)= 0;
%         P1_P2(i,2)= 0;
%         P1_P3(i,2)= 0;
%         P2_P3(i,2)= 0;
% %     elseif strcmp(field_database{i+1}(1:7),'patient')
%     elseif strcmp(field_database{i+1}(1),'p')
%         P1_Ptotal(i,2)= 1;
%         P2_Ptotal(i,2)= 1;
%         P3_Ptotal(i,2)= 1;
%         P1_P2(i,2)= 1;
%         P1_P3(i,2)= 1;
%         P2_P3(i,2)= 1;
%     end
% end
% 
% disp('ROC result for P1_Ptotal');
% P1_Ptotal_ROC=roc(P1_Ptotal,[],0.05,1,'b','1');
% disp('ROC result for P2_Ptotal');
% P2_Ptotal_ROC=roc(P2_Ptotal,[],0.05,1,'g','2');
% disp('ROC result for P3_Ptotal');
% P3_Ptotal_ROC=roc(P3_Ptotal,[],0.05,1,'c','3');
% disp('ROC result for P2_P3');
% P2_P3_ROC=roc(P2_P3,[],0.05,1,'y','6');
% 
% disp('ROC result for P1_P2');
% P1_P2_ROC=roc(P1_P2,[],0.05,1,'r','4');
% disp('ROC result for P1_P3');
% P1_P3_ROC=roc(P1_P3,[],0.05,1,'k','5');
% AUC(1)=P1_Ptotal_ROC.AUC;
% AUC(2)=P2_Ptotal_ROC.AUC;
% AUC(3)=P3_Ptotal_ROC.AUC;
% AUC(4)=P1_P2_ROC.AUC;
% AUC(5)=P1_P3_ROC.AUC;
% AUC(6)=P2_P3_ROC.AUC;

%%%%%%%%%%%%% ROC in ROCKIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1
% fid = fopen('ROC_result.txt','w');
% fprintf(fid,'%s\n','ROC results without thresholding');
% fprintf(fid,'%s\n','"P1/Ptotal"  "P2/Ptotal"  "P3/Ptotal"  "P1/P2"  "P1/P3"  "P2/P3"');
% fprintf(fid,'%s\n','S S S S S S');
% numOfControl = 0;
% numOfPatient = 0;
% 
% for i=1:length(field_database(2:end))
%     if strcmp(field_database{i+1}(1:7),'control')
%         numOfControl = numOfControl + 1;
%     else
%         numOfPatient = numOfPatient +1;
%     end
% end
% for i=1:numOfControl
%     fprintf(fid,'%f  %f  %f  %f  %f  %f\n',P_band1_Total(i,1),P_band2_Total(i,1),P_band3_Total(i,1),P_band1_band2(i,1),P_band1_band3(i,1),P_band2_band3(i,1));
% end
% fprintf(fid,'%s\n','*******');
% for i=numOfControl+1:numOfControl+numOfPatient
%     fprintf(fid,'%f  %f  %f  %f  %f  %f\n',P_band1_Total(i,1),P_band2_Total(i,1),P_band3_Total(i,1),P_band1_band2(i,1),P_band1_band3(i,1),P_band2_band3(i,1));
% end
% fprintf(fid,'%s\n','*******');
% fclose(fid);

% save('LGNtoV1_without_threshold.mat','P1_Ptotal_ROC','P2_Ptotal_ROC','P3_Ptotal_ROC','P1_P2_ROC','P1_P3_ROC','P2_P3_ROC');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% ROC for changing threshold: P1/Ptotal %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% ROC in MATLAB %%%%%%%%%%%%%%%%%%%%%%%%%%%%

parameter = P_band1_Total;
% parameter = P_band2_Total;
% parameter = P_band3_Total;
% parameter = P_band1_band2;
% parameter = P_band1_band3;
% parameter = P_band2_band3;

for i=1:size(parameter,2) %%% P_band1_Total = 39 by 11 matrix
    threshVec{i}=zeros(length(field_database(2:end)),2); %%% number of ROC curves
end

for i=1:size(parameter,2) %% 11
    for j=1:length(field_database(2:end)) %% 39
        threshVec{i}(j,1) = parameter(j,i);
%         if strcmp(field_database{j+1}(1:7),'control')
        if strcmp(field_database{j+1}(1),'C') 
            threshVec{i}(j,2) = 0;
%         elseif strcmp(field_database{j+1}(1:7),'patient')
        elseif strcmp(field_database{j+1}(1),'p')
            threshVec{i}(j,2) = 1;
        end
    end
end

%%%%% check for NaN entries %%%
for i=1:length(threshVec)
    threshVec{i}(find(isnan(threshVec{i}(:,1))),:)=[];
end


%%% Plot ROC 
color_vector = {[0 0 1],[0 0 0.5],[0 0.5 0],[0.5 0 0],...
                [0 0.5 1],[0 1 0.5],[1 0.5 0],[0.5 0 1],...
                [0.5 0.5 1],[0.5 1 0.5],[1 0.5 0.5],[0.5 1 1]};
            
for i=1:size(parameter,2) %%% P_band1_Total = 39 by 11 matrix
    plotRoc(i) = roc(threshVec{i},[],0.05,1,color_vector{i},sprintf('%d',i));
    AUC(i)=plotRoc(i).AUC;
end


%%%%%%%%%%%%% ROC in ROCKIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1
% fid = fopen('ROC_result_with_Threshold.txt','w');
% fprintf(fid,'%s\n','ROC results with changing threshold values');
% 
% for i=1:length(threshVec) %%% 1:11
%     fprintf(fid,'"TH_%d" ',i-1);
% end
% 
% fprintf(fid,'%s\n','');
% fprintf(fid,'%s\n','S S S S S S S L L L L S S L');
% numOfControl = 0;
% numOfPatient = 0;
% 
% for i=1:length(field_database(2:end))
%     if strcmp(field_database{i+1}(1:7),'control')
%         numOfControl = numOfControl + 1;
%     else
%         numOfPatient = numOfPatient +1;
%     end
% end
% for i=1:numOfControl
%     for j=1:length(threshVec) %%% 1:11
%         if ~isnan(threshVec{j}(i,1))
%             fprintf(fid,'%f  ',threshVec{j}(i,1));
%         else
%             fprintf(fid,'%s  ','#');
%         end
%     end
%     fprintf(fid,'%s\n','');
% end
% fprintf(fid,'%s\n','*********');
% 
% for i=numOfControl+1:numOfControl+numOfPatient
%     for j=1:length(threshVec) %%% 1:11
%         if ~isnan(threshVec{j}(i,1))
%             fprintf(fid,'%f  ',threshVec{j}(i,1));
%         else
%             fprintf(fid,'%s  ','#');
%         end
%     end
%     fprintf(fid,'%s\n','');
% end
% 
% fprintf(fid,'%s\n','*********');
% fclose(fid);
end
