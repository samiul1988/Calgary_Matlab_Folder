%% This file generates transfer function with 'threshold' feature and produces input 
%%% and target vectors for the ANN 

%% 1. Run computeTransferFunction.m 
computeTransferFunction;
%% 2. Run generateParametersForROC.m 
generateParametersForROC;
%% 3. Generate 'input' and 'target' for ANN analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% ANN Data collection %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input: M by N matrix where M = number of parameters (features), N = Number of samples (persons)
% target: 1 by N matrix where N = Number of samples (persons)

header.databaseName = (char(fieldnames(data)));
header.thresholdFuncName = char(fName);
header.propagation = propagationName;
header.eyeStatus = eyeStatus;
header.thresholdVector = threshold;
if freqBandType == 1
    header.frequencyBands = 'P1: 0-0.1Hz,P2: 0.1-0.2Hz, P3 :0.2-0.3Hz';
elseif freqBandType == 2
    header.frequencyBands = 'P1: 0.03-0.13Hz, P2: 0.13-0.23Hz, P3: 0.23-0.33Hz';
end

paramList = {P_band1_Total,P_band2_Total,P_band3_Total,P_band1_band2,P_band1_band3,P_band2_band3,entropy_band1,entropy_band2,entropy_band3};
header.paramList = ['P_band1_Total'; 'P_band2_Total'; 'P_band3_Total'; 'P_band1_band2'; 'P_band1_band3'; ...
                    'P_band2_band3'; 'entropy_band1'; 'entropy_band2'; 'entropy_band3'];

input = zeros(length(paramList), length(field_database(2:end))); % numberParameter by numberOFperson matrix 
target = ones(1, length(field_database(2:end))); % numGroups by numberOFperson matrix (for only two options for group (patient(1) and control(0)), numGroups =1)

thresholdIndex = 1; % index for parameters with particular threshold value, thresholdIndex = 1 indicates parameters without threshold
for i=1:length(paramList)
    for j=1:length(field_database(2:end))
        input(i,j) = paramList{i}(j,thresholdIndex);
        if strcmp(field_database{j+1}(1),'C')
            target(1,j) = 0;
        elseif strcmp(field_database{j+1}(1),'p')
            target(1,j) = 1;
        end
    end
end
filename = generateFileNameForANN(header); %%% generates useful filename for the database
save(strcat(filename,'.mat'),'header','input','target');
