% main
%% initilization
clear all
clc
close all

rng('default');
[currentDirectory, parentDirectory] = getParentDirectory;

%%% load and shuffle (if necessary) input dataset with all available features
%%% input and target 
%%% input format: numFeature by numSample Matrix
%%% target format: 1 by numSample Matrix: sorted as control-patient sequence 

data = load(strcat(parentDirectory,'/ANNDatabaseForThesis/dbBaselineRawLGN1ToV1ECTFAmp.mat'));
% load('ANN_input_24-Jan-2013.mat'); %%% load 'input' (6 by 33) and target (1 by 33) matrix : 33 = number of samples, 6 = number of features, 1 = 1 or 0 vector
bestFeatureSet = [1 2 3 4 5 7 8 9];
input = data.input(bestFeatureSet,:);
target = data.target;

[featureNum, sampleNum] = size(input); % number of features and number of samples
inputIndex = 1: sampleNum;

%%% shuffle data
shuffledIndex = randperm(sampleNum,sampleNum);
x = input(:,shuffledIndex); %%% randomized dataset
t = target(1,shuffledIndex); %%% corresponding target

%%% creat a pattern recognition neural network ....get property object for neural network
global propertyObj

hiddenLayerSize = 1;
ann_GUI;

while ~propertyObj.flag
    pause(3);
end
propObj = propertyObj;

%%%% Other parameters
numBoot_out = 100; % bootstrap sample number for outer loop
    
h = waitbar(0,'Process running...','Name',strcat(mfilename,' Hidden layer size: ',num2str(hiddenLayerSize)),'Resize','on');
tic;

for boot = 1:numBoot_out
    for i = 1:sampleNum
        trainX = x(:,(1:sampleNum)~=i);
        trainT = t(:,(1:sampleNum)~=i);
        
        testX = x(:,i);
        testT(i) = t(:,i);
                
        net = ann_classifier(hiddenLayerSize,propObj);  %%% Create a single neural network 
        [net, tr] = train(net,trainX,trainT);
        
        % testing 
        testY(i) = net(testX);
        testClasses(i) = testY(i) > 0.5;
    end
    
    rocAna = roc_for_ANN([testY' testT'],0); 
    rocAUC(boot) = rocAna.AUC;
    waitbar(boot/numBoot_out,h,strcat(num2str(boot/numBoot_out*100),'% in progress'))
end
 
waitbar(1,h,'Finalizing results...')

rng('default');
nBootAz = 2000;
alpha = 0.05;
[ci,rAUCboot] = bootci(nBootAz,{@(x)mean(x),rocAUC},'alpha',alpha);
waitbar(1,h,'Finished')
delete(h);

runTime = toc;
hours = floor(runTime / 3600);
minutes = floor( (runTime - hours * 3600) / 60 );
seconds = rem(runTime,60);  
runTime = strcat(num2str(hours),' Hour(s)',' ',num2str(minutes),' minute(s)',' ',num2str(seconds),' second(s)');

%%% save data
%%% ask for saving data

fileName = strcat('ANN_LOO_',num2str(featureNum),'11_HLS',num2str(hiddenLayerSize),generateFileNameForANN(data.header));
dialog = questdlg('Do you want to save the variables in a .mat file?', 'Save Option', 'yes','no','yes');

switch dialog
    case 'yes'
        saveName = questdlg('Do you want to use default naming option?', 'Save Option', 'yes','no','yes');
        if strcmp(saveName,'yes')
            save(strcat(fileName,'.mat'), 'ci','rAUCboot','rocAUC','net','numBoot_in','numBoot_out','runTime');
        else
            customName = inputdlg('Enter .mat file name:','Save Option',1,{fileName},'on');
            if  ~isempty(customName)
                save(strcat(customName{1},'.mat'), 'ci','rAUCboot','rocAUC','net','numBoot_in','numBoot_out','runTime');           
            end
        end
        break;
    case 'no'
end


%
% % plotroc(testT,testY)
% %     rocAna = rocNew([testY' testT'],[],0.01,0,'g','6');
%     rocAna = roc_for_ANN([testY{i}' testT'],0);
%     rocAUC(i) = rocAna.AUC;
% end
% 
% hist(rocAUC)