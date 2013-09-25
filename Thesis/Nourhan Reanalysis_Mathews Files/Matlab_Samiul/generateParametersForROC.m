%% This file generates parameters for ROC analysis
%%%% ptfMatrix: numberOFperson by numberOFthreshold by FFTpoint matrix with some NaN 
%%%% freqMatrix: numberOFperson by numberOFthreshold by FFTpoint matrix with some NaN 

%%%% RUN THIS FILE AFTER RUNNING computeTransferFunction.m

freqBandType = 1; % if 1: 0-0.1,0.1-0.2,0.2-0.3Hz bands;
                  % if 2: 0.03-0.13,0.13-0.23,0.23-0.33Hz bands;
                  
for i=1:length(ptfMatrix) %%% numberOfPerson
    for j=1:size(ptfMatrix{1},1) %%% numberOfThreshold
        switch freqBandType
            case 1
                band1{i,j}= find(freqMatrix{i}(j,:)<=0.1); %%% this ignores the nan entries
                band2{i,j}= find(freqMatrix{i}(j,:)>0.1 & freqMatrix{i}(j,:)<=0.2);
                band3{i,j}= find(freqMatrix{i}(j,:)>0.2 & freqMatrix{i}(j,:)<=0.3);
            case 2
                band1{i,j}= find(freqMatrix{i}(j,:) >= 0.03 & freqMatrix{i}(j,:) <= 0.13);
                band2{i,j}= find(freqMatrix{i}(j,:) > 0.13 & freqMatrix{i}(j,:) <= 0.23);
                band3{i,j}= find(freqMatrix{i}(j,:) > 0.23 & freqMatrix{i}(j,:) <= 0.33);
        end
        %%% parameter: ratio of power in different bands to total power and ratio of power between different bands  
        P_band1(i,j) = nansum(ptfMatrix{i}(j,band1{i,j})); %%% total power in bands ignoring nan values (if any)
        P_band2(i,j) = nansum(ptfMatrix{i}(j,band2{i,j}));
        P_band3(i,j) = nansum(ptfMatrix{i}(j,band3{i,j}));
        P_total(i,j) = P_band1(i,j)+P_band2(i,j)+P_band3(i,j);
        
        P_band1_Total(i,j) = P_band1(i,j)/P_total(i,j);
        P_band2_Total(i,j) = P_band2(i,j)/P_total(i,j);
        P_band3_Total(i,j) = P_band3(i,j)/P_total(i,j);
        P_band1_band2(i,j) = P_band1(i,j)/P_band2(i,j);
        P_band1_band3(i,j) = P_band1(i,j)/P_band3(i,j);
        P_band2_band3(i,j) = P_band2(i,j)/P_band3(i,j);
        
        %%% parameter: Spectral Entropy of different bands
        P_temp_band1_normalized = ptfMatrix{i}(j,band1{i,j}) / nansum(ptfMatrix{i}(j,band1{i,j}));
        P_temp_band2_normalized = ptfMatrix{i}(j,band2{i,j}) / nansum(ptfMatrix{i}(j,band2{i,j}));
        P_temp_band3_normalized = ptfMatrix{i}(j,band3{i,j}) / nansum(ptfMatrix{i}(j,band3{i,j}));
        
        if length(P_temp_band1_normalized) <= 1 %%% dealing with single element vector and null vector
            entropy_band1(i,j) = Inf;
        else
            entropy_band1(i,j) = -sum(P_temp_band1_normalized .* log(P_temp_band1_normalized + eps)) / log(length(P_temp_band1_normalized));
        end
        if length(P_temp_band2_normalized) <= 1 %%% dealing with single element vector and null vector
            entropy_band2(i,j) = Inf;
        else
            entropy_band2(i,j) = -sum(P_temp_band2_normalized .* log(P_temp_band2_normalized + eps)) / log(length(P_temp_band2_normalized));
        end
        if length(P_temp_band3_normalized) <= 1 %%% dealing with single element vector and null vector
            entropy_band3(i,j) = Inf;
        else
            entropy_band3(i,j) = -sum(P_temp_band3_normalized .* log(P_temp_band3_normalized + eps)) / log(length(P_temp_band3_normalized));
        end
        
    end
end