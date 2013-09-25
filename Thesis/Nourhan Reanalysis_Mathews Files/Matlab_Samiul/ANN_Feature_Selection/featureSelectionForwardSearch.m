%%% Feature selection for the neural network with  small sample size
%%% "Forward searching": this is the simplest greedy searching approach of 
%%% feature selection: see "http://www.cs.cmu.edu/~kdeng/thesis/feature.pdf" for details

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

%%% 2. Break data into 'nPartition' number of partitions
nPartition = 2; % number of partitions
sBlock = ceil(nSample / nPartition); % size of each partition
inputIndex = 1: nSample;
k=1;
for i =1:nPartition
    if k+sBlock-1 <= nSample
        pIndex{i} = inputIndex(k:k+sBlock-1);
        k = k+sBlock;
    else 
        pIndex{i} = inputIndex(k:end);
    end
end

%%% Neural network declaration and initial setting
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);
% net.divideFcn = 'dividetrain'; %%% set the network for training only (no validation or testing in the training phase)
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.75;
net.divideParam.valRatio = 0.25;
net.divideParam.testRatio = 0;

net.trainParam.epochs = 300; %%% maximum number of iterations
net.trainParam.max_fail = 300; %%% maximum number of iterations

divideInnerTrain = 0.7; %%% inner input train data is 70% of the outer input train data
divideInnerTest = 0.3;

% bestInnerSetScore = 100; % random high value: to store the best innerSetScore
% bestInnerFeatureSet = 1; % random feature set

%%%% 3. For each partition run the algorithm
for i = 1:nPartition
    outerTrainSetIndex = setdiff(inputIndex, pIndex{i});
    outerTestSetIndex = pIndex{i};
    
    outerTrainSetInput = input(:,outerTrainSetIndex);
    outerTestSetInput = input(:,outerTestSetIndex);
    
    outerTrainSetTarget = target(:,outerTrainSetIndex);
    outerTestSetTarget = target(:,outerTestSetIndex);
    
    %%% inner train and test set: randomly selected 70% data from the
    %%% outerTrainSetInput as innerTrainSet and rest 30% as innerTestSet
    
    innerTrainSetIndex = outerTrainSetIndex(randperm(length(outerTrainSetIndex),floor(divideInnerTrain * length(outerTrainSetIndex))));
    innerTestSetIndex = setdiff(outerTrainSetIndex, innerTrainSetIndex);
    
    innerTrainSetInput = input(:,innerTrainSetIndex);
    innerTestSetInput = input(:,innerTestSetIndex);
    
    innerTrainSetTarget = target(:,innerTrainSetIndex);
    innerTestSetTarget = target(:,innerTestSetIndex);
    
    for j = 1: nFeature
        featureIndex = combntns(1:nFeature,j);
        if j ~= 1    
            k = 1;
            for l= 1:size(featureIndex,1)
                array = ismember(featureIndex(l,:),bestInnerFeatureSet{j-1});
                if any(array)
                    if sum(array == 1) == (j-1) 
                        temp(k,:) = featureIndex(l,:);
                        k = k + 1;
                    end
                end
            end
            featureIndex = temp;
            clear temp;
        end
        
        bestFeatureIndex{j} = featureIndex;
        
        for k = 1: size(featureIndex,1)
            trainInput = innerTrainSetInput(featureIndex(k,:),:);
            trainTarget = innerTrainSetTarget(:,:);
            netTemp(k).net = train(net,trainInput, trainTarget);
            innerY = netTemp(k).net((innerTestSetInput(featureIndex(k,:),:)));
            innerTestScore{j}(k) = sqrt(sum((innerY - innerTestSetTarget).^2) / length(innerY));
            innerFeatureSet{j}{k} = featureIndex(k,:);
        end
        bestk = find(innerTestScore{j} == min(innerTestScore{j}));
        bestInnerNet(j).net = netTemp(bestk).net;
        bestInnerSetScore(j) = innerTestScore{j}(bestk);
        bestInnerFeatureSet{j} = innerFeatureSet{j}{bestk};
    end
    
    bestInnerSetIndex = find(bestInnerSetScore == min(bestInnerSetScore));
    bestInnerSet = bestInnerFeatureSet{bestInnerSetIndex};
    bestNet = bestInnerNet(bestInnerSetIndex).net;
%     bestNet = bestInnerNet(find(bestInnerSetScore == min(bestInnerSetScore)));
    outerY = bestNet(outerTestSetInput(bestInnerSet,:));

    outerTestScore(i) = sqrt(sum((outerY - outerTestSetTarget).^2) / length(outerY));
    outerFeatureSet{i} = bestInnerSet;
end


