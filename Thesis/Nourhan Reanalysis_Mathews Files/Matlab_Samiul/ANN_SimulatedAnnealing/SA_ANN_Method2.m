%% Simulated Annealing approach in Neural Network Training to avoid local minimum in during training
addParentDirectory;

clear all;
clc
% rng('default');

[currentDirectory, parentDirectory] = getParentDirectory;
%%% Resources

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

train_ind_ratio = 70;
nTrainPt = ceil(sampleNum * train_ind_ratio / 100); 

trainIndex = randperm(sampleNum,nTrainPt); %% random sample 'without replacements'
testIndex = setdiff(1:sampleNum, trainIndex);

xTrain = input(:,trainIndex);
tTrain = target(:,trainIndex);

xTest = input(:,testIndex);
tTest = target(:,testIndex);

% featureNum = size(x,1); % get number of features
%%% define network 'net'
hiddenLayerSize = 3;
net = patternnet(hiddenLayerSize);
net.divideParam.trainRatio = 0.75;
net.divideParam.valRatio = 0.25;
net.divideParam.testRatio = 0;
net.trainFcn = 'trainscg'; % 'trainrp';

%%% Algorithm Parameter
Ti = 1;  % initial temp
Ts = 1e-8;         % stopping temp
cool = @(T)(0.8*T);        % annealing schedule
As = 0.98; % Stopping Value
maxConsRejections = 200; % 1000; % maximum number of consecutive rejections
maxTry = 30; % 300; % maximum number of tries within one temperature
maxSuccess = 10; % 20; % maximum number of success within one temperature
k = 1;   % boltzmann constant

%%% Initialization
itry = 0; %%% iteration counter
success = 0; %%% number of success within one temperature
finished = 0; 
consec = 0; %%% number of consecutive rejections
T = Ti;
total = 0;

%%% Train the network 'net' with the input dataset and obtain Az
[net, tr] = train(net,xTrain,tTrain);
yTest = net(xTest);

rocAna = roc_for_ANN([yTest' tTest'],0);
Az = rocAna.AUC;

iter = 1;
%%% Run the algorithm 
while ~finished;
    itry = itry+1; % just an iteration counter
%     current = parent; 
    
    %%% Stopping or temperature reduciton criteria
    if itry >= maxTry || success >= maxSuccess;
        if T < Ts || consec >= maxConsRejections;
            finished = 1;
            total = total + itry;
            break;
        else
            T = cool(T);  % decrease T according to cooling schedule
            total = total + itry;
            itry = 1;
            success = 1;
        end
    end
    
    %%% Take a bootstrap sample of input and continue training 'net' to obtain updated network net_updated and Az_updated  
    
    bootIndex = randi(sampleNum,1,sampleNum); %% draw a random sample 'with replacements'
    trainIndex = bootIndex(randperm(length(bootIndex),ceil(train_ind_ratio / 100 * length(bootIndex))));
    testIndex = setSubtract(bootIndex, trainIndex);

    xTrain = input(:,trainIndex);
    tTrain = target(:,trainIndex);

    xTest = input(:,testIndex);
    tTest = target(:,testIndex);
    %%% Train the network 'net' with the input dataset and obtain Az
    [net_updated, tr_updated] = train(net,xTrain,tTrain);
    yTest = net_updated(xTest);

    rocAna = roc_for_ANN([yTest' tTest'],0);
    Az_updated = rocAna.AUC;
    
    if Az_updated >= As 
        net = net_updated; 
        Az = Az_updated;
        break
    end % if
    
    if Az_updated < Az 
        if (rand < exp( (Az_updated - Az)/(k*T) ));
            net = net_updated;
            Az = Az_updated;
            success = success+1;
            consec = 0;
        else
            consec = consec+1;
        end % if
    else 
        net = net_updated;
        Az = Az_updated;
    end % if
    plot(iter,Az,'o'),hold on;
    iter = iter + 1;
end % while

plot(iter,Az,'o')
net_final = net;
Az_final = Az

