%% This file generates transfer function metrics 
%%% initialization
clear all;
clc;
close all;

%%% INPUT: (1) data 
%          (2)eyeStatus 
%          (3)Threshold Function
%          (4) propagationName (e.g. LGN2V1 etc)
%          (5) threshold vector  

%%%%%%%%%%%%%%% (1) Load database %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% and make the general name for the database as: 'database'

data = load('OpticNeuritisDatabaseForThesis/database_baseline_raw_15-Jul-2013.mat');  %%% this will load 'database_baseline_raw'
% data = load('OpticNeuritisDatabaseForThesis/TF_database_raw_old.mat');
% data = load('OpticNeuritisDatabaseForThesis/database_after6Months_15-Jul-2013.mat');  %%% this will load 'database_after6Months'
% data = load('OpticNeuritisDatabaseForThesis/database_after1Year_15-Jul-2013.mat');  %%% this will load 'database_after1Year'

%%%%%%%%%%%%%% (2) eyesClosed or eyesOpened %%%%%%%%%%%%%%%%%%%%%%%%
eyeStatus ='eyesClosed';
% eyeStatus ='eyesOpened';

%%%%%%%%%%%%%% (3) Threshold Function %%%%%%%%%%%%%%%%%%%%%%%%%%%%
fName = @TFwithAmplitudeThreshold;
% fName = @TFwithPowerThresholdDenom;
% fName = @TFwithPowerThreshold;

%%%%%%%%%%%% (4) propagation name %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
propagationName = 'LGN1->V1';
% propagationName = 'V1->SPA1';
% propagationName = 'V1->SPA2';
% propagationName = 'V1->LOC1';
% propagationName = 'V1->LOC2';

%%%%%%%%%%%% (5) Threshold Vector %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold = 0.01:.01:0.1; %%% threshold vector for TFwithAmplitudeThreshold algorithm

% threshold = 0.0001:0.0001:0.0005;  %%% threshold vector for TFwithPowerThresholdDenom 
 
% threshold.thresholdValueNum = 0.00002:0.00003:0.00008; %%% threshold vector for the numerator for TFwithPowerThreshold
% threshold.thresholdValueDenom = 0.0001:0.0001:0.0005; %%% threshold vector for the denominator for for TFwithPowerThreshold

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
database = data.(char(fieldnames(data)));
%%% corrupted data %%%
%%% database_baseline_raw: 2 and 13
%%% database_after6Months: 2 and 13
%%% database_after1Year: 6
% 
%%% remove corrupted data (applicable for "database_baseline_raw", "database_after6Months" and "database_after1Year")
if strcmp(char(fieldnames(data)),'database_baseline_raw') || strcmp(char(fieldnames(data)),'database_after6Months')
    database = rmfield(database,{'C2','p1'}); %%% remove entry 2 and 13
elseif strcmp(char(fieldnames(data)),'database_after1Year')
    database = rmfield(database,'p1'); %%% remove entry 6
end 
field_database = fieldnames(database); %%% get the fieldnames of the database

% field_database={'control1','control2','control3','control4','control5','control6','control7','control8','control9','control10','control11','control12',...
%     'patient1','patient2','patient3','patient8','patient10','patient12','patient13','patient14','patient15','patient16','patient17'...
%     ,'patient19','patient20','patient21','patient22','patient23','patient24','patient25','patient26','patient27','patient28'};

% %%%%%%%%%%%%%%% Parameter Info (can be found at database header) %%%%%%%%%%%%%%%%%%%%%%%
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

%%% obtain signals from controls and patients
for i=2:length(field_database)
    LGN1(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.LGN1(1:L_NFFT);
    LGN2(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.LGN2(1:L_NFFT);
    V1(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.V1(1:L_NFFT);
    LOC1(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.LOC1(1:L_NFFT);
    LOC2(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.LOC2(1:L_NFFT);
    SPA1(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.SPA1(1:L_NFFT);
    SPA2(i-1,:) = database.(field_database{i}).(sprintf('%s',eyeStatus)).FFT.SPA2(1:L_NFFT);
end
%%% corrupted data %%%
%%% database_baseline_raw: 2 and 13
%%% database_after6Months: 2 and 13
%%% database_after1Year: 6
% 
%%% remove corrupted data (applicable for "database_baseline_raw", "database_after6Months" and "database_after1Year")
% if strcmp(char(fieldnames(data)),'database_baseline_raw') || strcmp(char(fieldnames(data)),'database_after6Months') 
%      LGN1(13,:) = []; LGN1(2,:) = [];
%      LGN2(13,:) = []; LGN2(2,:) = [];
%      V1(13,:) = []; V1(2,:) = [];
%      LOC1(13,:) = []; LOC1(2,:) = [];
%      LOC2(13,:) = []; LOC2(2,:) = [];
%      SPA1(13,:) = []; SPA1(2,:) = [];
%      SPA2(13,:) = []; SPA2(2,:) = [];
% elseif strcmp(char(fieldnames(data)),'database_after1Year')
%      LGN1(6,:) = [];
%      LGN2(6,:) = [];
%      V1(6,:) = [];
%      SPA1(6,:) = [];
%      SPA2(6,:) = [];
%      LOC1(6,:) = [];
%      LOC2(6,:) = [];
% end

%%%% PLOT AND CHECK DATA
for i=1
% figure(1)
% plot(freq,abs(LGN1([1:end],:)));
% figure(2)
% plot(freq,abs(LGN2([1:end],:)));
% figure(3)
% plot(freq,abs(V1([1:end],:)));
% figure(4)
% plot(freq,abs(LOC1([1:end],:)));
% figure(5)
% plot(freq,abs(LOC2([1:end],:)));
% figure(6)
% plot(freq,abs(SPA1([1:end],:)));
% figure(7)
% plot(freq,abs(SPA2([1:end],:)));

% figure(1)
% plot(freq,abs(LGN1(1:5,:)));  legend('1','2','3','4','5');
% figure(2)
% plot(freq,abs(LGN1(6:11,:))); legend('6','7','8','9','10','11');
% figure(3)
% plot(freq,abs(LGN1(12:17,:))); legend('12','13','14','15','16','17')
% figure(4)
% plot(freq,abs(LGN1(18:24,:)));  legend('18','19','20','21','22','23')
% figure(5)
% plot(freq,abs(LGN1(25:33,:)));  legend('25','26','27','28','29','30','31','32','33')


% legend('1','2','3','4','5','6','7','8','9','10')
% plot(freq,abs(V1(13,:)./LGN1(13,:)))
end  

%%% Transfer Function with threshold using 'TFwithAmplitudeThreshold' or 'TFwithPowerThreshold' or 'TFwithPowerThresholdDenom'

%%%% function [tf,ptf,ftf] = TFwithThreshold(numeratorMatrix, denominatorMatrix,thresholdVector,freqVector,spectrumType,NFFT)
% size of numeratorMatrix and denominatorMatrix: 'number of persons' by 'one sided spectrum length'
% size of tf, ptf and, ftf: 'number of persons' by (length(thresholdVector) + 1) by 'one sided spectrum length'

switch propagationName
    case 'LGN1->V1'
        [tfMatrix,ptfMatrix,freqMatrix] = fName(V1,LGN1,threshold,freq,'power',NFFT);
    case 'V1->SPA1'
        [tfMatrix,ptfMatrix,freqMatrix] = fName(SPA1,V1,threshold,freq,'power',NFFT);
    case 'V1->SPA2'
        [tfMatrix,ptfMatrix,freqMatrix] = fName(SPA2,V1,threshold,freq,'power',NFFT);    
    case 'V1->LOC1'
        [tfMatrix,ptfMatrix,freqMatrix] = fName(LOC1,V1,threshold,freq,'power',NFFT);
    case 'V1->LOC2'
        [tfMatrix,ptfMatrix,freqMatrix] = fName(LOC2,V1,threshold,freq,'power',NFFT);    
end
