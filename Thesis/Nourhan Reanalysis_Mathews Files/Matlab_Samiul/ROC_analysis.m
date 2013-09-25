%% this file computes the complete ROC analysis

%% 1. Run computeTransferFunction.m 
computeTransferFunction
%% 2. Run generateParametersForROC.m 
generateParametersForROC
%% 3. ROC analysis

AUC.header.databaseName = (char(fieldnames(data)));
AUC.header.thresholdFuncName = char(fName);
AUC.header.propagation = propagationName;
AUC.header.eyeStatus = eyeStatus;
AUC.header.thresholdVector = threshold;
if freqBandType == 1
    AUC.header.frequencyBands = 'P1: 0-0.1Hz,P2: 0.1-0.2Hz, P3 :0.2-0.3Hz';
elseif freqBandType == 2
    AUC.header.frequencyBands = 'P1: 0.03-0.13Hz, P2: 0.13-0.23Hz, P3: 0.23-0.33Hz';
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%% ROC for constant threshold: P1/Ptotal, P2/Ptotal...etc %%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%% ROC in MATLAB %%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i =1
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
% P1_Ptotal_ROC=rocNew(P1_Ptotal,[],0.05,1,'b','1');
% disp('ROC result for P2_Ptotal');
% P2_Ptotal_ROC=rocNew(P2_Ptotal,[],0.05,1,'g','2');
% disp('ROC result for P3_Ptotal');
% P3_Ptotal_ROC=rocNew(P3_Ptotal,[],0.05,1,'c','3');
% disp('ROC result for P2_P3');
% P2_P3_ROC=rocNew(P2_P3,[],0.05,1,'y','6');
% 
% disp('ROC result for P1_P2');
% P1_P2_ROC=rocNew(P1_P2,[],0.05,1,'r','4');
% disp('ROC result for P1_P3');
% P1_P3_ROC=rocNew(P1_P3,[],0.05,1,'k','5');
% 
% AUC.results.P1_Ptotal = P1_Ptotal_ROC.AUC;
% AUC.results.P2_Ptotal = P2_Ptotal_ROC.AUC;
% AUC.results.P3_Ptotal = P3_Ptotal_ROC.AUC;
% AUC.results.P1_P2 = P1_P2_ROC.AUC;
% AUC.results.P1_P3 = P1_P3_ROC.AUC;
% AUC.results.P2_P3 = P2_P3_ROC.AUC;
end
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

% %%%%%%% ROC in MATLAB %%%%%%%%%%%%%%%%%%%%%%%%%%%%

parameter = P_band1_Total;
AUC.header.parameter = 'P_band1_Total';
paramIndex = 1; %%% for xls writing purpose only

% parameter = P_band2_Total;
% AUC.header.parameter = 'P_band2_Total';
% paramIndex = 2; %%% for xls writing purpose only

% parameter = P_band3_Total;
% AUC.header.parameter = 'P_band3_Total';
% paramIndex = 3; %%% for xls writing purpose only

% parameter = P_band1_band2;
% AUC.header.parameter = 'P_band1_band2';
% paramIndex = 4; %%% for xls writing purpose only

% parameter = P_band1_band3;
% AUC.header.parameter = 'P_band1_band3';
% paramIndex = 5; %%% for xls writing purpose only

% parameter = P_band2_band3;
% AUC.header.parameter = 'P_band2_band3';
% paramIndex = 6; %%% for xls writing purpose only

% parameter = entropy_band1;
% AUC.header.parameter = 'SpectralEntropy_band1';
% paramIndex = 7; %%% for xls writing purpose only

% parameter = entropy_band2;
% AUC.header.parameter = 'SpectralEntropy_band2';
% paramIndex = 8; %%% for xls writing purpose only

% parameter = entropy_band3;
% AUC.header.parameter = 'SpectralEntropy_band3';
% paramIndex = 9; %%% for xls writing purpose only


for i=1:size(parameter,2) %%% P_band1_Total = number_of_person by (length(thresholdVector) + 1) matrix
    threshVec{i}=zeros(length(field_database(2:end)),2); %%% number of ROC curves
end

for i=1:size(parameter,2) %% (length(thresholdVector) + 1)
    for j=1:length(field_database(2:end)) %% number_of_person
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
                [0.5 0.5 1],[0.5 1 0.5],[1 0.5 0.5],[0.5 1 1],...
                [0.5 0.5 1],[0.5 1 0.5],[1 0.5 0.5],[0.5 1 1],...
                [0.5 0.5 1],[0.5 1 0.5],[1 0.5 0.5],[0.5 1 1]};
               
%%% for TFwithAmplitudeThreshold and TFwithPowerThresholdDenom                     
thresholdValue = [0 threshold];

%%% for TFwithPowerThreshold
% k = 1;
% for i =1:length(threshold.thresholdValueNum)
%     for j =1:length(threshold.thresholdValueDenom)
%         thresholdVector(k,:) = [threshold.thresholdValueNum(i) threshold.thresholdValueDenom(j)];
%         k = k + 1;
%     end 
% end
% thresholdValue = [zeros(1,2); thresholdVector];
%%%%

for i=1:size(parameter,2) %%% P_band1_Total = 39 by 11 matrix
    if  size(threshVec{i},1) < floor(length(field_database(2:end)) * 0.7)
        plotRoc(i).AUC = 0;
    else
        try
            plotRoc(i) = rocNew(threshVec{i},[],0.05,1,color_vector{i},sprintf('%d',i));
        catch err
            if strcmp(err.message,'Warning: all X values must be numeric and finite') %%% catch infinite entries
                threshVec{i}(find(isinf(threshVec{i}(:,1))),:)=[];
                if size(threshVec{i},1) >= floor(length(field_database(2:end)) * 0.7)
                    try
                        plotRoc(i) = rocNew(threshVec{i},[],0.05,1,color_vector{i},sprintf('%d',i));
                    catch err1
                        if strcmp(err1.message,'Warning: there are only healthy subjects!') || strcmp(err.message,'Warning: there are only unhealthy subjects!')
                            plotRoc(i).AUC = 0;
                        elseif strcmp(err.identifier,'MATLAB:badsubscript')
                            plotRoc(i).AUC = 0;
                        end % if
                    end %try-catch
                else
                    plotRoc(i).AUC = 0;
                end %if
            elseif strcmp(err.message,'Warning: there are only healthy subjects!') || strcmp(err.message,'Warning: there are only unhealthy subjects!')
                plotRoc(i).AUC = 0;
            elseif strcmp(err.identifier,'MATLAB:badsubscript')
                plotRoc(i).AUC = 0;
            end %if
        end % try-catch
    end % if
    %%% for TFwithAmplitudeThreshold and TFwithPowerThresholdDenom  
    AUC.results.(sprintf('threshold_%d',i)) = [thresholdValue(i) plotRoc(i).AUC];
    
    %%% for TFwithPowerThreshold 
%     AUC.results.(sprintf('threshold_%d',i)) = [thresholdValue(i,:) plotRoc(i).AUC];
end %for

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% display %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
AUC.header
AUC.results
%%% for data entry purpose to the excel sheet

for i=1:size(parameter,2)
    vec(i) = plotRoc(i).AUC;
end

range = strcat('A',num2str(paramIndex));
xlswrite('dataEntry.xlsx', vec,1,range);
