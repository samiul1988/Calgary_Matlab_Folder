%%% Feature selection for the neural network with  small sample size
%%% "Exhaustive searching with bootstrap": will search each possible combinations of
%%% the feature set and find out the best feature set 

%%%% Run the "addParentDirectory.m" file first if this is the first time you are running this program in this session

%%% Initialization
clear all;
clc;

rng('default');
[currentDirectory, parentDirectory] = getParentDirectory;

%%% 1. load and shuffle (if necessary) input dataset with all available features
data = load(strcat(parentDirectory,'/ANNDatabaseForThesis/dbBaselineRawLGN1ToV1ECTFAmp.mat'));

input = data.input;
target = data.target;

% load('cancer_dataset.mat');
% input = cancerInputs(:,1:50);
% target = cancerTargets(1,1:50);

[nFeature, nSample] = size(input); % number of features and number of samples

%%% shuffle data
shuffledIndex = randperm(nSample,nSample);
input = input(:,shuffledIndex);
target = target(1,shuffledIndex);

%%% 2. Break data into 'nPartition' number of bootstrap partitions
nPartition = 2; % number of partitions
% divide the data like this: 80% data will be drawn (with replacement, meaning, bootstrap sample) for outer training, and the remaining 20% will be used for testing 
bootPercent = 0.80;
nOuterTrainIndex = ceil(nSample * bootPercent); 
inputIndex = 1: nSample;

%%% Neural network declaration and initial setting
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);
net.divideFcn = 'dividetrain'; %%% set the network for training only (no validation or testing in the training phase)
% net.divideFcn = 'dividerand';
% net.divideParam.trainRatio = 0.75;
% net.divideParam.valRatio = 0.25;
% net.divideParam.testRatio = 0;

net.trainParam.epochs = 300; %%% maximum number of iterations
net.trainParam.max_fail = 300; %%% maximum number of iterations

divideInnerTrain = 0.7; %%% inner input train data is 70% of the outer input train data
divideInnerTest = 0.3;

bestInnerSetScore = 100* ones(1, nPartition); % 0; % random high value: to store the best innerSetScore
% bestInnerFeatureSet = 1; % random feature set

%%%% 3. For each partition run the algorithm
for i = 1:nPartition    
    outerTrainSetIndex = randi(nSample, 1, nOuterTrainIndex); 
    outerTestSetIndex = setdiff(inputIndex, outerTrainSetIndex);
    
    outerTrainSetInput = input(:,outerTrainSetIndex);
    outerTestSetInput = input(:,outerTestSetIndex);
    
    outerTrainSetTarget = target(:,outerTrainSetIndex);
    outerTestSetTarget = target(:,outerTestSetIndex);
    
    %%% inner train and test set: randomly selected 70% data from the
    %%% outerTrainSetInput as innerTrainSet and rest 30% as innerTestSet
    
    innerTrainSetIndex = outerTrainSetIndex(randperm(length(outerTrainSetIndex),floor(divideInnerTrain * length(outerTrainSetIndex))));
    innerTestSetIndex = setSubtract(outerTrainSetIndex, innerTrainSetIndex);
    
    innerTrainSetInput = input(:,innerTrainSetIndex);
    innerTestSetInput = input(:,innerTestSetIndex);
    
    innerTrainSetTarget = target(:,innerTrainSetIndex);
    innerTestSetTarget = target(:,innerTestSetIndex);
    
    for j = 1: nFeature
        featureIndex = combntns(1:nFeature,j);
        
        for k = 1: size(featureIndex,1)
            netTemp = net;
            trainInput = innerTrainSetInput(featureIndex(k,:),:);
            trainTarget = innerTrainSetTarget(:,:);
            netTemp = train(netTemp,trainInput, trainTarget);
            innerY = netTemp(innerTestSetInput(featureIndex(k,:),:));
            % rocInner = roc_for_ANN([innerY' innerTestSetTarget'],0);
            % rocInnerScore = rocInner.AUC;
            
            innerTestScore{j}(k) = sqrt(sum((innerY - innerTestSetTarget).^2) / length(innerY)); % rocInnerScore;
            innerFeatureSet{j}{k} = featureIndex(k,:);
            if bestInnerSetScore(i) > innerTestScore{j}(k) % bestInnerSetScore < innerTestScore{j}(k)
                bestNet = netTemp;
                bestInnerSetScore(i) = innerTestScore{j}(k);
                bestInnerFeatureSet{i} = innerFeatureSet{j}{k};
            end
        end
    end

outerY = bestNet(outerTestSetInput(bestInnerFeatureSet{i},:));
% rocOuter = roc_for_ANN([outerY' outerTestSetTarget'],0);
% rocOuterScore = rocOuter.AUC;

outerTestScore(i) = sqrt(sum((outerY - outerTestSetTarget).^2) / length(outerY)); %  rocOuterScore;
outerFeatureSet{i} = bestInnerFeatureSet{i};
end
