%%% Feature selection for the neural network with  small sample size
%%% "Exhaustive searching": will search each possible combinations of
%%% the feature set and find out the best feature set

clear all;
clc;

rng('default');

%%% load input dataset with all available features

load('cancer_dataset.mat');
tTrain = cancerTargets(1,:);

nFeature = size(cancerInputs,1); % number of features
[pSet, nCom] = powerSet(1:nFeature); % obtain all possible combinations of feature set

%%% ANN parameter and definition
hiddenLayerSize = 5;

nIteration = 10;
tic
for i =1:nIteration
    net = patternnet(hiddenLayerSize);
    for j = 1: nCom
        xTrain = cancerInputs(pSet{j},:);
        netTemp = net;
        [netTemp, tr] = train(netTemp, xTrain, tTrain);
        saliency(i,j) = tr.perf(find(tr.epoch == tr.best_epoch));
    end % for j
end % for i
toc


%%
clear all;
clc;

rng('default');

%%% load input dataset with all available features

load('cancer_dataset.mat');
tTrain = cancerTargets(1,:);

hiddenLayerSize = 5;

net = patternnet(hiddenLayerSize);
xTrain = cancerInputs(1:2,:);
[net, tr] = train(net, xTrain, tTrain);
saliency = tr.perf(find(tr.epoch == tr.best_epoch))

