function fileName = generateFileNameForANN(header)
%%%% This function generates meaningful filename for the ANN input
%%%% It includes the information about the database, propagation region, threshold function
%%%% and eye status

%%% fields of header: databaseName, thresholdFuncName, propagation, eyeStatus, thresholdVector, freqBandType

switch header.databaseName 
    case 'database_baseline_raw'
        dbName = 'dbBaselineRaw';
    case 'database_after6Months'
        dbName = 'dbFollowUp6M';
    case 'database_after1Year'
        dbName = 'dbFollowUp1Y';
    case 'database'
        dbName = 'dbBaselineRawOld';
    case 'database_baseline_filtered'
        dbName = 'dbBaselineFiltered'
end

switch header.thresholdFuncName
    case 'TFwithAmplitudeThreshold'
        fName = 'TFAmp';
    case 'TFwithPowerThresholdDenom'
        fName = 'TFPowerDenom';
    case 'TFwithPowerThreshold'
        fName = 'TFPower';
end

switch header.propagation
    case 'LGN1->V1'
        propName = 'LGN1ToV1';
    case 'V1->SPA1'
        propName = 'V1ToSPA1';
    case 'V1->SPA2'
        propName = 'V1ToSPA2';    
    case 'V1->LOC1'
        propName = 'V1ToLOC1';
    case 'V1->LOC2'
        propName = 'V1ToLOC2';    
end

switch header.eyeStatus
    case 'eyesClosed'
        eS = 'EC';
    case 'eyesOpened'
        eS = 'EO';
end

fileName = strcat(dbName,propName,eS,fName);