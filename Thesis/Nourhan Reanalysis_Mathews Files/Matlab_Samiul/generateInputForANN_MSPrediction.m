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
% target = ones(1, length(field_database(2:end))); % numGroups by numberOFperson matrix (for only two options for group (patient(1) and control(0)), numGroups =1)
target = zeros(3, length(field_database(2:end))); % numGroups by numberOFperson matrix (for three options for group (patient with MS(2), patient without MS(1), and control(0)), numGroups = 3)
thresholdIndex = 1; % index for parameters with particular threshold value, thresholdIndex = 1 indicates parameters without threshold

control_data_after6Months  = {'AG', 'AR', 'C12', 'CF', 'CP', 'CS', 'GH', 'JF', 'JT', 'NA', 'NZ', 'TZ'}; %%% 6 month followup data corresponds to control_data sequence (c1 - c12)
control_dataBaseline  =      {'C1', 'C2', 'C3',  'C4', 'C5', 'C6', 'C7', 'C8', 'C9', 'C10','C11','C12'};
patient_data_after6Months  = {'SBi','ZW','SJBU','LS','CDD','JV', 'JJS','RS', 'JB', 'LH', 'AJ', 'MID','EC', 'NW', 'NR', 'MC', 'RF', 'HB', 'WW', 'SA', 'CP'}; %%% 6 month followup data corresponds to patient_data sequence, eg. SJBU ==> p3, LS ==> p8 etc
patient_dataBaseline   =     {'p1', 'p2', 'p3', 'p8', 'p10','p12','p13','p14','p15','p16','p17','p19','p20','p21','p22','p23','p24','p25','p26','p27','p28'};
patient_status             = {'MS', 'MS', 'CIS','CIS','CIS','MS', 'CIS','CIS','MS', 'CIS','MS', 'CIS','MS', 'MS', 'MS', 'CIS','MS', 'CIS','CIS','CIS','MS'};
%%%% 'MS' = RRMS (has multiple sclerosis, CIS = clinically isolated syndrome, don't advance to MS)

for i=1:length(paramList)
    for j=1:length(field_database(2:end))
        input(i,j) = paramList{i}(j,thresholdIndex);
    end
end
for j = 1:length(field_database(2:end))
        switch field_database{j+1}
            case {'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9', 'C10','C11','C12'}
                target(1,j) = 1;
                target(2,j) = 0;
                target(3,j) = 0;
            case {'p3', 'p8', 'p10','p13','p14','p16','p19','p23','p25','p26','p27'}
                target(1,j) = 0;
                target(2,j) = 1;
                target(3,j) = 0;
            case {'p1', 'p2','p12','p15','p17','p20','p21','p22','p24','p28'}
                target(1,j) = 0;
                target(2,j) = 0;
                target(3,j) = 1;
        end
end

filename = generateFileNameForANN(header); %%% generates useful filename for the database
% save(strcat(filename,'.mat'),'header','input','target');
