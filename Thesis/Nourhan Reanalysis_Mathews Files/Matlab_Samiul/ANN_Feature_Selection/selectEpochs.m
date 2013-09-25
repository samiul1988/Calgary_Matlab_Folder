%%% Selection of the number of epochs for the artificial neural network
%%% Will vary the number of iterations (epcohs) in the neural network training and find out the optimum one

%%%% Run the "addParentDirectory.m" file first if this is the first time you are running this program in this session
addParentDirectory;

%%% Initialization
clear all;
clc;

rng('default');
[currentDirectory, parentDirectory] = getParentDirectory;

%%% 1. load and shuffle (if necessary) input dataset with all available features
data = load(strcat(parentDirectory,'/ANNDatabaseForThesis/dbBaselineRawLGN1ToV1ECTFAmp.mat'));
% data = load('ANN_input_24-Jan-2013.mat');
input = data.input;
target = data.target;

% load('cancer_dataset.mat');
% input = cancerInputs(:,1:50);
% target = cancerTargets(1,1:50);

divideTrain = 0.75; %%% input train data is (divideTrain * 100)% of the data
[nFeature, nSample] = size(input); % number of features and number of samples

inputIndex = 1: nSample;
trainSetIndex = inputIndex(randperm(length(inputIndex),floor(divideTrain * length(inputIndex))));
testSetIndex = setdiff(inputIndex, trainSetIndex);
trainInput = input(:,trainSetIndex);
trainTarget = target(:,trainSetIndex);
testInput = input(:,testSetIndex);
testTarget = target(:,testSetIndex);
hiddenLayerSize = 1:10;% [1 3 9 13 16 18 24]; %%% best HLS values 

%%% Vary the number of epochs and train and test the network
epochVector = 50:50:500;


for i = 1:length(epochVector)
    for j = 1:length(hiddenLayerSize)
        for k = 1:10
            %%% Neural network declaration and initial setting
            net = patternnet(hiddenLayerSize(j));
            % net.divideFcn = 'dividetrain'; %%% set the network for training only (no validation or testing in the training phase)
            net.divideFcn = 'dividerand';
            net.divideParam.trainRatio = 0.70;
            net.divideParam.valRatio = 0.30;
            net.divideParam.testRatio = 0;
            
            net.trainParam.epochs = epochVector(i); %%% maximum number of iterations
            net.trainParam.max_fail = epochVector(i);
            
            net = train(net,trainInput, trainTarget);
            testOutput = net(testInput);
            roc = roc_for_ANN([testOutput' testTarget'],0);
            Az(i,j,k) = roc.AUC;
            clear net;
        end
    end
end

meanAz = mean(Az,3);