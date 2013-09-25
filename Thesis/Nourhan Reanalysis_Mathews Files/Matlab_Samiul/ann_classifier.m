% function propObj = getPropForAnnClassifier()
function net = ann_classifier(hiddenLayerSize,propObj)
% Obtain properties for ANN_CLASSIFIER network
%   Detailed explanation goes here
% x = input features 
% t = target
% propObj = object for properties

% global propertyObj
% propObj = propertyObj;
% clear 'propertyObj';

net = patternnet(hiddenLayerSize);
%%% Customize the network

%%% Input and output Processing Functions  %%% Must set it before training
f = fieldnames(propObj.inputProcessFcn);
pFuncList = cell(0);
for i = 1:length(f)
    if propObj.inputProcessFcn.(f{i})
        switch f{i}(end)
            case '1'
                pFuncList=[pFuncList,{'fixunknowns'}];
                continue;
            case '2'
                pFuncList=[pFuncList,{'lvqoutputs'}];
                continue;
            case '3'
                pFuncList=[pFuncList,{'mapminmax'}];
                continue;
            case '4'
                pFuncList=[pFuncList,{'mapstd'}];
                continue;
            case '5'
                pFuncList=[pFuncList,{'processpca'}];
                continue;
            case '6'
                pFuncList=[pFuncList,{'removeconstantrows'}];
                continue;
            case '7'
                pFuncList=[pFuncList,{'removerows'}];
                continue;
        end
    end
end
net.inputs{1}.processFcns = pFuncList;


f = fieldnames(propObj.outputProcessFcn);
pFuncList = cell(0);
for i = 1:length(f)
    if propObj.outputProcessFcn.(f{i})
        switch f{i}(end)
            case '1'
                pFuncList=[pFuncList,{'fixunknowns'}];
                continue;
            case '2'
                pFuncList=[pFuncList,{'lvqoutputs'}];
                continue;
            case '3'
                pFuncList=[pFuncList,{'mapminmax'}];
                continue;
            case '4'
                pFuncList=[pFuncList,{'mapstd'}];
                continue;
            case '5'
                pFuncList=[pFuncList,{'processpca'}];
                continue;
            case '6'
                pFuncList=[pFuncList,{'removeconstantrows'}];
                continue;
            case '7'
                pFuncList=[pFuncList,{'removerows'}];
                continue;
        end
    end
end
net.outputs{1}.processFcns = pFuncList;

%%% Layer Properties 
tLayer = textscan(propObj.layerInitFcn,'%s');
net.layers{1}.initFcn = tLayer{1}{1}; %%% hidden layer initialization function

tLayer = textscan(propObj.layerNetInpFcn,'%s');
net.layers{1}.netInputFcn = tLayer{1}{1};

tLayer = textscan(propObj.layerTransferFcn,'%s');
net.layers{1}.transferFcn = tLayer{1}{1};

%%%% Bias properties
tBias = textscan(propObj.biasInitFcn,'%s');
tBias = tBias{1}{1};
if strcmp(tBias,'none')
    for i = 1:net.numLayers
        net.biases{i}.initFcn = '';
    end
else
    for i = 1:net.numLayers
        net.biases{i}.initFcn = tBias;
    end
end

tBias = textscan(propObj.biasLearnFcn,'%s');
for i = 1:net.numLayers
    net.biases{i}.learnFcn = tBias{1}{1};
end

%%%% Input Weight Properties
tInWeight = textscan(propObj.inpWeightInitFcn,'%s');
tInWeight = tInWeight{1}{1};
if strcmp(tInWeight,'none')
    for i = 1:net.numLayers
        for j = 1:net.numInputs
            if ~isempty(net.inputWeights{i,j})
                net.inputWeights{i,j}.initFcn = '';
            end
        end
    end
else
    for i = 1:net.numLayers
        for j = 1:net.numInputs
            if ~isempty(net.inputWeights{i,j})
                net.inputWeights{i,j}.initFcn = tInWeight;
            end
        end
    end
end

tInWeight = textscan(propObj.inpWeightLearnFcn,'%s');
for i = 1:net.numLayers
    for j = 1:net.numInputs
        if ~isempty(net.inputWeights{i,j})
            net.inputWeights{i,j}.learnFcn = tInWeight{1}{1};
        end
    end
end

tInWeight = textscan(propObj.inpWeightWeightFcn,'%s');
for i = 1:net.numLayers
    for j = 1:net.numInputs
        if ~isempty(net.inputWeights{i,j})
            net.inputWeights{i,j}.weightFcn = tInWeight{1}{1};
        end
    end
end

%%%% Layer Weight Properties
tLayerWeight = textscan(propObj.layerWeightInitFcn,'%s');
tLayerWeight = tLayerWeight{1}{1};
if strcmp(tLayerWeight,'none')
    for i = 1:net.numLayers
        for j = 1:net.numLayers
            if ~isempty(net.layerWeights{i,j})
                net.layerWeights{i,j}.initFcn = '';
            end
        end
    end
else
    for i = 1:net.numLayers
        for j = 1:net.numLayers
            if ~isempty(net.layerWeights{i,j})
                net.layerWeights{i,j}.initFcn = tLayerWeight;
            end
        end
    end
end

tLayerWeight = textscan(propObj.layerWeightLearnFcn,'%s');
for i = 1:net.numLayers
    for j = 1:net.numLayers
        if ~isempty(net.layerWeights{i,j})
            net.layerWeights{i,j}.learnFcn = tLayerWeight{1}{1};
        end
    end
end

tLayerWeight = textscan(propObj.layerWeightWeightFcn,'%s');
for i = 1:net.numLayers
    for j = 1:net.numLayers
        if ~isempty(net.layerWeights{i,j})
            net.layerWeights{i,j}.weightFcn = tLayerWeight{1}{1};
        end
    end
end

%%%% Other Properties
tTrain = textscan(propObj.netTrainFcn,'%s');
net.trainFcn = tTrain{1}{1};

tPerform = textscan(propObj.netPerformFcn,'%s');
net.performFcn = tPerform{1}{1};

tDivide = textscan(propObj.divideFcn,'%s');
net.divideFcn = tDivide{1}{1};

if strcmp(net.divideFcn,'divideind')
    net.divideParam.trainInd = propObj.divideParam.trainInd;
    net.divideParam.valInd = propObj.divideParam.valInd;
    net.divideParam.testInd = propObj.divideParam.testInd;
else
    net.divideParam.trainRatio = propObj.divideParam.trainRatio;
    net.divideParam.valRatio = propObj.divideParam.valRatio;
    net.divideParam.testRatio = propObj.divideParam.testRatio;
end
     
net.trainParam.epochs = propObj.epochs; %%% Maximum number of iteration 
net.trainParam.max_fail = propObj.max_fail;
net.trainParam.goal = propObj.goal;  


% if strcmp(propertyObj,'default')
%     %%%% Definition of default property object
%     propObj.hiddenLayerSize = 10; %%% I-H-O neural network: I = input layer; H = hidden layer; o = output layer
%     
%     propObj.inputProcessFcns = {'removeconstantrows','mapminmax'};
%     
%     propObj.hiddenInitFcn = 'initnw'; %%% hidden layer initialization function
%     propObj.hiddenNetInputFcn = 'netsum';
%     propObj.hiddenTransferFcn = 'tansig';
%     
%     propObj.outputProcessFcns = {'removeconstantrows','mapminmax'};
%     
%     propObj.biasLearningFcn = 'learngdm';
%     
%     propObj.inputWeightsInitFcn = '';
%     propObj.inputWeightsLearningFcn = 'learngdm';
%     propObj.inputWeightsWeightFcn = 'dotprod';
%     
%     propObj.layerWeightsLearningFcn = 'learngdm';
%     propObj.layerWeightsWeightFcn = 'dotprod';
%     
%     propObj.trainFcn = 'trainscg';
%     
%     propObj.divideFcn = 'dividerand';
%     propObj.divideParam.trainRatio = 70;
%     propObj.divideParam.valRatio = 30;
%     propObj.divideParam.testRatio = 0;
%     
%     propObj.epochs = 200; %%% Maximum number of iteration 
%     
%     propObj.goal = 10^(-7);  
% end
    
% [net,tr] = train_ann_classifier(x, t, propObj);
% end %  ann_classifier

% function [network, outObject] = train_ann_classifier(input, target, propObj)
%    
% hiddenLayerSize = propObj.hiddenLayerSize; %% 1, 2, 3, 4, 5, 10, 15, 20 
% %%% Define the network
% net = patternnet(hiddenLayerSize); %%% one hidden layer with hiddenLayerSize number of neurons
% % view(net);
% 
% %%% Customize the network
% %%% Input Processing Functions  %%% Must set it before training
% net.inputs{1}.processFcns = propObj.inputProcessFcns;
% %%%% Layer initialization function %%%%%
% net.layers{1}.initFcn = propObj.hiddenInitFcn; %%% hidden layer initialization function
% net.layers{1}.netInputFcn = propObj.hiddenNetInputFcn;
% net.layers{1}.transferFcn = propObj.hiddenTransferFcn;
% 
% net.outputs{1}.processFcns = propObj.outputProcessFcns;
% net.biases{1}.learnFcn = propObj.biasLearningFcn;
% net.biases{2}.learnFcn = propObj.biasLearningFcn;
% 
% net.inputWeights{1}.initFcn = propObj.inputWeightsInitFcn;
% net.inputWeights{1}.learnFcn = propObj.inputWeightsLearningFcn;
% net.inputWeights{1}.weightFcn = propObj.inputWeightsWeightFcn;
% 
% net.layerWeights{1}.learnFcn = propObj.layerWeightsLearningFcn;
% net.layerWeights{1}.weightFcn = propObj.layerWeightsWeightFcn;
% 
% net.trainFcn = propObj.trainFcn;
% 
% net.divideFcn = propObj.divideFcn;
% 
% net.divideParam.trainRatio = propObj.divideParam.trainRatio;
% net.divideParam.valRatio = propObj.divideParam.valRatio;
% net.divideParam.testRatio = propObj.divideParam.testRatio;
%      
% net.derivFcn = propObj.derivFcn;
% 
% net.trainParam.epochs = propObj.epochs; %%% Maximum number of iteration 
% net.trainParam.goal = propObj.goal;  
% 
% [network, outObject] = train(net,input,target);
% 
% end % train_ann_classifier 


% %%%% related or useful codes/ links:
% % net2 = newff(x,t,[10 5],{'tansig' 'tansig' 'tansig'}); %%% two hidden layers H1 with 10 neurons and H2 with 5 neurons
% 
% 
% %% Customize the network
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Input Processing Functions  %%% Must set it before training
% net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
% 
% % General Data Preprocessing
% %     fixunknowns        - Processes matrix rows with unknown values.
% %     mapminmax          - Map matrix row minimum and maximum values to [-1 1].
% %     mapstd             - Map matrix row means and deviations to standard values.
% %     processpca         - Processes rows of matrix with principal component analysis.
% %     removeconstantrows - Remove matrix rows with constant values.
% %     removerows         - Remove matrix rows with specified indices.
% %   Data Preprocessing for Specific Algorithms
% %     lvqoutputs         - Define settings for LVQ outputs, without changing values.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%%%%%%%%%%%% Hidden Layers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% %%%% Layer initialization function %%%%%
% net.layers{1}.initFcn = 'initnw'; %% default initnw
% % Neural Network Toolbox Layer Initialization Functions.
% %     initnw - Nguyen-Widrow layer initialization function.
% %     initwb - By-weight-and-bias layer initialization function.
% 
% %%%% Layer netInput function %%%%%%%%%
% net.layers{1}.netInputFcn = 'netsum';  %% default netsum
% % Neural Network Toolbox Net Input Functions.
% %     netprod - Product net input function.
% %     netsum  - Sum net input function
% 
% %%%% Layer transfer function %%%%%%%%%
% net.layers{1}.transferFcn = 'tansig';  %% default netsum
% % Neural Network Toolbox Transfer Functions.
% %     compet - Competitive transfer function.
% %     elliotsig - Elliot sigmoid transfer function.
% %     hardlim - Positive hard limit transfer function.
% %     hardlims - Symmetric hard limit transfer function.
% %     logsig - Logarithmic sigmoid transfer function.
% %     netinv - Inverse transfer function.
% %     poslin - Positive linear transfer function.
% %     purelin - Linear transfer function.
% %     radbas - Radial basis transfer function.
% %     radbasn - Radial basis normalized transfer function.
% %     satlin - Positive saturating linear transfer function.
% %     satlins - Symmetric saturating linear transfer function.
% %     softmax - Soft max transfer function.
% %     tansig - Symmetric sigmoid transfer function.
% %     tribas - Triangular basis transfer function.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%%%%%%% Output Layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% output processing Functions  %%% Must set it before training
% net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};
% 
% % General Data Preprocessing
% %     fixunknowns        - Processes matrix rows with unknown values.
% %     mapminmax          - Map matrix row minimum and maximum values to [-1 1].
% %     mapstd             - Map matrix row means and deviations to standard values.
% %     processpca         - Processes rows of matrix with principal component analysis.
% %     removeconstantrows - Remove matrix rows with constant values.
% %     removerows         - Remove matrix rows with specified indices.
% %   Data Preprocessing for Specific Algorithms
% %     lvqoutputs         - Define settings for LVQ outputs, without changing values.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%% Bias %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% net.biases{1}.learnFcn = 'learngdm';
% net.biases{2}.learnFcn = 'learngdm'; 
% %  Neural Network Toolbox Learning Functions.
% %     learncon  - Conscience bias learning function.
% %     learngd   - Gradient descent weight/bias learning function.
% %     learngdm  - Gradient descent w/momentum weight/bias learning function. %% default
% %     learnh    - Hebb weight learning rule.
% %     learnhd   - Hebb with decay weight learning rule.
% %     learnis   - Instar weight learning function.
% %     learnk    - Kohonen weight learning function.
% %     learnlv1  - LVQ1 weight learning function.
% %     learnlv2  - LVQ 2.1 weight learning function.
% %     learnos   - Outstar weight learning function.
% %     learnp    - Perceptron weight/bias learning function.
% %     learnpn   - Normalized perceptron weight/bias learning function.
% %     learnsom  - Self-organizing map weight learning function.
% %     learnsomb - LEARNSOM Batch self-organizing map weight learning function.
% %     learnwh   - Widrow-Hoff weight/bias learning function.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%% input weights %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%  input weight initialization function %%%%%%
% net.inputWeights{1}.initFcn = ''; %%% default: none
% % Neural Network Toolbox Weight Initialization Functions.
% %   Weight and bias initialization functions
% %     initzero  - Zero weight/bias initialization function.
% %     midpoint  - Midpoint weight initialization function.
% %     randnc    - Normalized column weight initialization function.
% %     randnr    - Normalized row weight initialization function.
% %     rands     - Symmetric random weight/bias initialization function.
% %     randsmall - Small random weight/bias initialization function.
% %   Weight only initialization functions
% %     initlvq   - LVQ weight initialization function.
% %     initsompc - Initialize SOM weights with principle components.
% %   Bias only initialization functions
% %     initcon   - Conscience bias initialization function.
% 
% %%%%% input weights learn function and weight function %%%%%%
% net.inputWeights{1}.learnFcn = 'learngdm'; %%% other options same as mentioned before
% net.inputWeights{1}.weightFcn = 'dotprod'; 
% % Neural Network Toolbox Weight Functions.
% % Weight functions
% %     convwf   - Convolution weight function.
% %     dotprod  - Dot product weight function. %%% default
% %     negdist  - Negative distance weight function.
% %     normprod - Normalized dot product weight function.
% %     scalprod - Scalar product weight function.
% %  
% % Distance functions can be used as weight functions
% % boxdist  - Box distance function.
% %     dist     - Euclidean distance weight function.
% %     linkdist - Link distance function.
% %     mandist  - Manhattan distance function.
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
% %%%%%%%%%%%%% Layer weights %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%% layer weights learn function and weight function %%%%%%
% net.layerWeights{1}.learnFcn = 'learngdm'; %%% other options same as mentioned before
% net.layerWeights{1}.weightFcn = 'dorprod'; %%% other options same as mentioned before
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%% Effect of netwrok training functions %%%%
% net.trainFcn = 'trainlm';  % Levenberg-Marquardt
% % net.trainFcn = 'trainbfg';  % BFGS quasi newton backpropagation
% % net.trainFcn = 'trainbr';  % Bayesian regulation backpropagation
% % net.trainFcn = 'traincgb';  % Conjugate gradient backpropagation with Powell-Beale restarts
% % net.trainFcn = 'traincgf';  % Conjugate gradient backpropagation with Fletcher-Reeves updates.
% % net.trainFcn = 'traincgp';  % Conjugate gradient backpropagation with Polak-Ribiere updates.
% % net.trainFcn = 'traingd';  % Gradient descent backpropagation.
% % net.trainFcn = 'traingda';  % Gradient descent with adaptive lr backpropagation.
% % net.trainFcn = 'traingdm';  % Gradient descent with momentum.
% % net.trainFcn = 'traingdx';  % Gradient descent w/momentum & adaptive lr backpropagation.
% % net.trainFcn = 'trainoss';  % One step secant backpropagation.
% % net.trainFcn = 'trainrp';  % RPROP backpropagation.
% % net.trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.
% 
% %%%% Effect of input data division functions 
% % Neural Network Toolbox Division Functions:
% net.divideFcn =  'dividerand'; % 'dividetrain';
% net.divideParam.trainRatio = 70;
% net.divideParam.valRatio = 30;
% net.divideParam.testRatio = 0;
% 
% % divideblock - Partition indices into three sets using blocks of indices. %% parameters: trainRatio, valRatio testRatio
% % divideind   - Partition indices into three sets using specified indices. %% parameters: trainInd, valInd, testInd
% % divideint   - Partition indices into three sets using interleaved indices. %% parameters: trainRatio, valRatio testRatio
% % dividerand  - Partition indices into three sets using random indices. %% parameters: trainRatio, valRatio testRatio
% % dividetrain - Partition indices into training set only. %% parameters: none
% 
% %%%% Effect of data derivative functions 
% %  Neural Network Toolbox Derivative Functions.
% net.derivFcn = 'defaultderiv';
% 
% %     bttderiv     - Backpropagation-through-time derivative function.
% %     defaultderiv - Default derivative function.
% %     fpderiv      - Forward-perturbation derivative function.
% %     num2deriv    - Numeric two-point network derivative function.
% %     num5deriv    - Numeric five-point stencil neural network derivative function.
% %     staticderiv  - Static backpropagation derivative function.
% 
% %%%% Effect of changing epochs
% net.trainParam.epochs = 200; %%% maximum 100 iterations
% 
% %%%% Effect of training goals
% net.trainParam.goal = 0;
% 
% %% Train the network
% % Now the network is ready to be trained. The samples are automatically
% % divided into training, validation and test sets. The training set is
% % used to teach the network. Training continues as long as the network
% % continues improving on the validation set. The test set provides a
% % completely independent measure of network accuracy.
% %
% % The NN Training Tool shows the network being trained and the algorithms
% % used to train it.  It also displays the training state during training
% % and the criteria which stopped training will be highlighted in green.
% %
% % The buttons at the bottom  open useful plots which can be opened during
% % and after training.  Links next to the algorithm names and plot buttons
% % open documentation on those subjects.
% 
% [net,tr] = train(net,x,t);
% 
% %%
% % To see how the network's performance improved during training, either
% % click the "Performance" button in the training tool, or call PLOTPERFORM.
% %
% % Performance is measured in terms of mean squared error, and shown in
% % log scale.  It rapidly decreased as the network was trained.
% %
% % Performance is shown for each of the training, validation and test sets.
% % The version of the network that did best on the validation set is
% % was after training.
% 
% plotperform(tr)
% 
% %%
% % The trained neural network can now be tested with the testing samples we
% % partitioned from the main dataset. The testing data was not used in
% % training in any way and hence provides an "out-of-sample" dataset to
% % test the network on. This will give us a sense of how well the network
% % will do when tested with data from the real world.
% %
% % The network outputs will be in the range 0 to 1, so we threshold them
% % to get 1's and 0's indicating cancer or normal patients respectively.
% 
% testX = x(:,tr.testInd);
% testT = t(:,tr.testInd);
% 
% % testX = x(:,tr.valInd);
% % testT = t(:,tr.valInd);
% 
% testY = net(testX);
% testClasses = testY > 0.5
% 
% %%
% % One measure of how well the neural network has fit the data is the
% % confusion plot.  Here the confusion matrix is plotted across all samples.
% %
% % The confusion matrix shows the percentages of correct and incorrect
% % classifications.  Correct classifications are the green squares on the
% % matrices diagonal.  Incorrect classifications form the red squares.
% %
% % If the network has learned to classify properly, the percentages in the
% % red squares should be very small, indicating few misclassifications.
% %
% % If this is not the case then further training, or training a network
% % with more hidden neurons, would be advisable.
% 
% plotconfusion(testT,testY)
% 
% %%
% % Here are the overall percentages of correct and incorrect classification.
% 
% [c,cm] = confusion(testT,testY)
% 
% fprintf('Percentage Correct Classification   : %f%%\n', 100*(1-c));
% fprintf('Percentage Incorrect Classification : %f%%\n', 100*c);
% 
% % Another measure of how well the neural network has fit data is the
% % receiver operating characteristic plot.  This shows how the false
% % positive and true positive rates relate as the thresholding of outputs
% % is varied from 0 to 1.
% %
% % The farther left and up the line is, the fewer false positives need to
% % be accepted in order to get a high true positive rate.  The best
% % classifiers will have a line going from the bottom left corner, to the
% % top left corner, to the top right corner, or close to that.
% 
% plotroc(testT,testY)
% rocAna=rocNew([testY' testT'],[],0.05,1,'g','6');
% 
% %%
% %%%%%%%%%%%%%%%%%% Network Testing with independent data %%%%%%%%%%%%%%%
% 
% load('ANN_testInput.mat'); %%%% load input and target for test data  (contains only patients followup data)
% 
% testX = input;
% testT = target;
% % testX = [testX x(:,randi(12,1,6))]; %%% since the test data contains only patient data, so include some data from the control subject randomly from the trainInput
% testX = [testX x(:,1:6)]; %%% since the test data contains only patient data, so include some data from the control subject randomly from the trainInput
% testT = [testT zeros(1,6)];
% 
% testY = net(testX);
% testClasses = testY > 0.5;
% 
% plotconfusion(testT,testY)
% 
% plotroc(testT,testY)
% rocAna=rocNew([testY' testT'],[],0.05,1,'g','6');
% 
% 



