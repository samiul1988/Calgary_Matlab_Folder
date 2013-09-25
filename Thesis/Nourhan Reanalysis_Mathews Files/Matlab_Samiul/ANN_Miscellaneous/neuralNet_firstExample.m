%% initilization
clear all
clc
close all

%%% inputs and target 
% [x,t] = ovarian_dataset;

load('ANN_input_24-Jan-2013.mat'); %% load 'input' (6 by 33) and target (1 by 33) matrix : 33 = number of samples, 6 = number of features, 1 = 1 or 0 vector
x = input;
t = target;

% Each column in |x| represents one of 216 different patients.
%
% Each row in |x| represents the ion intensity level at one of the 100
% specific mass-charge values for each patient.
%
% The variable |t| is a row of 216 values each of which are either 1,
% indicating a cancer patient, or 0 for a normal patient.

% Since the neural network is initialized with random initial weights, the
% results after training the network vary slightly every time the example is
% run. To avoid this randomness, the random seed is set to reproduce the
% same results every time. However this is not necessary for your own
% applications.

setdemorandstream(672880951)

%% Classification Using a Feed Forward Neural Network
% Now that you have identified some significant features, you can use this
% information to classify the cancer and normal samples. 
%%%
% A 1-hidden layer feed forward neural network with 5 hidden layer neurons is created and trained. The training set is used to teach the network. 
% Training continues as long as the network continues improving on the validation set. The test set provides a completely independent measure of 
% network accuracy. 

%%% customize the network with one hidden layer
hiddenLayerSize = 10; %% 1, 2, 3, 4, 5, 10, 15, 20
% net2 = newff(x,t,[10 5],{'tansig' 'tansig' 'tansig'}); %%% two hidden layers H1 with 10 neurons and H2 with 5 neurons

net = patternnet(hiddenLayerSize); %%% one hidden layer with hiddenLayerSize number of neurons
view(net);

%%% Customize the network

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Input Processing Functions  %%% Must set it before training
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};

% General Data Preprocessing
%     fixunknowns        - Processes matrix rows with unknown values.
%     mapminmax          - Map matrix row minimum and maximum values to [-1 1].
%     mapstd             - Map matrix row means and deviations to standard values.
%     processpca         - Processes rows of matrix with principal component analysis.
%     removeconstantrows - Remove matrix rows with constant values.
%     removerows         - Remove matrix rows with specified indices.
%   Data Preprocessing for Specific Algorithms
%     lvqoutputs         - Define settings for LVQ outputs, without changing values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% Hidden Layers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%% Layer initialization function %%%%%
net.layers{1}.initFcn = 'initnw'; %% default initnw
% Neural Network Toolbox Layer Initialization Functions.
%     initnw - Nguyen-Widrow layer initialization function.
%     initwb - By-weight-and-bias layer initialization function.

%%%% Layer netInput function %%%%%%%%%
net.layers{1}.netInputFcn = 'netsum';  %% default netsum
% Neural Network Toolbox Net Input Functions.
%     netprod - Product net input function.
%     netsum  - Sum net input function

%%%% Layer transfer function %%%%%%%%%
net.layers{1}.transferFcn = 'tansig';  %% default netsum
% Neural Network Toolbox Transfer Functions.
%     compet - Competitive transfer function.
%     elliotsig - Elliot sigmoid transfer function.
%     hardlim - Positive hard limit transfer function.
%     hardlims - Symmetric hard limit transfer function.
%     logsig - Logarithmic sigmoid transfer function.
%     netinv - Inverse transfer function.
%     poslin - Positive linear transfer function.
%     purelin - Linear transfer function.
%     radbas - Radial basis transfer function.
%     radbasn - Radial basis normalized transfer function.
%     satlin - Positive saturating linear transfer function.
%     satlins - Symmetric saturating linear transfer function.
%     softmax - Soft max transfer function.
%     tansig - Symmetric sigmoid transfer function.
%     tribas - Triangular basis transfer function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Output Layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% output processing Functions  %%% Must set it before training
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};

% General Data Preprocessing
%     fixunknowns        - Processes matrix rows with unknown values.
%     mapminmax          - Map matrix row minimum and maximum values to [-1 1].
%     mapstd             - Map matrix row means and deviations to standard values.
%     processpca         - Processes rows of matrix with principal component analysis.
%     removeconstantrows - Remove matrix rows with constant values.
%     removerows         - Remove matrix rows with specified indices.
%   Data Preprocessing for Specific Algorithms
%     lvqoutputs         - Define settings for LVQ outputs, without changing values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%% Bias %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
net.biases{1}.learnFcn = 'learngdm';
net.biases{2}.learnFcn = 'learngdm'; 
%  Neural Network Toolbox Learning Functions.
%     learncon  - Conscience bias learning function.
%     learngd   - Gradient descent weight/bias learning function.
%     learngdm  - Gradient descent w/momentum weight/bias learning function. %% default
%     learnh    - Hebb weight learning rule.
%     learnhd   - Hebb with decay weight learning rule.
%     learnis   - Instar weight learning function.
%     learnk    - Kohonen weight learning function.
%     learnlv1  - LVQ1 weight learning function.
%     learnlv2  - LVQ 2.1 weight learning function.
%     learnos   - Outstar weight learning function.
%     learnp    - Perceptron weight/bias learning function.
%     learnpn   - Normalized perceptron weight/bias learning function.
%     learnsom  - Self-organizing map weight learning function.
%     learnsomb - LEARNSOM Batch self-organizing map weight learning function.
%     learnwh   - Widrow-Hoff weight/bias learning function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% input weights %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  input weight initialization function %%%%%%
net.inputWeights{1}.initFcn = ''; %%% default: none
% Neural Network Toolbox Weight Initialization Functions.
%   Weight and bias initialization functions
%     initzero  - Zero weight/bias initialization function.
%     midpoint  - Midpoint weight initialization function.
%     randnc    - Normalized column weight initialization function.
%     randnr    - Normalized row weight initialization function.
%     rands     - Symmetric random weight/bias initialization function.
%     randsmall - Small random weight/bias initialization function.
%   Weight only initialization functions
%     initlvq   - LVQ weight initialization function.
%     initsompc - Initialize SOM weights with principle components.
%   Bias only initialization functions
%     initcon   - Conscience bias initialization function.

%%%%% input weights learn function and weight function %%%%%%
net.inputWeights{1}.learnFcn = 'learngdm'; %%% other options same as mentioned before
net.inputWeights{1}.weightFcn = 'dotprod'; 
% Neural Network Toolbox Weight Functions.
% Weight functions
%     convwf   - Convolution weight function.
%     dotprod  - Dot product weight function. %%% default
%     negdist  - Negative distance weight function.
%     normprod - Normalized dot product weight function.
%     scalprod - Scalar product weight function.
%  
% Distance functions can be used as weight functions
% boxdist  - Box distance function.
%     dist     - Euclidean distance weight function.
%     linkdist - Link distance function.
%     mandist  - Manhattan distance function.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%% Layer weights %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% layer weights learn function and weight function %%%%%%
net.layerWeights{1}.learnFcn = 'learngdm'; %%% other options same as mentioned before
net.layerWeights{1}.weightFcn = 'dorprod'; %%% other options same as mentioned before
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Effect of netwrok training functions %%%%
net.trainFcn = 'trainlm';  % Levenberg-Marquardt
% net.trainFcn = 'trainbfg';  % BFGS quasi newton backpropagation
% net.trainFcn = 'trainbr';  % Bayesian regulation backpropagation
% net.trainFcn = 'traincgb';  % Conjugate gradient backpropagation with Powell-Beale restarts
% net.trainFcn = 'traincgf';  % Conjugate gradient backpropagation with Fletcher-Reeves updates.
% net.trainFcn = 'traincgp';  % Conjugate gradient backpropagation with Polak-Ribiere updates.
% net.trainFcn = 'traingd';  % Gradient descent backpropagation.
% net.trainFcn = 'traingda';  % Gradient descent with adaptive lr backpropagation.
% net.trainFcn = 'traingdm';  % Gradient descent with momentum.
% net.trainFcn = 'traingdx';  % Gradient descent w/momentum & adaptive lr backpropagation.
% net.trainFcn = 'trainoss';  % One step secant backpropagation.
% net.trainFcn = 'trainrp';  % RPROP backpropagation.
% net.trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

%%%% Effect of input data division functions 
% Neural Network Toolbox Division Functions:
net.divideFcn =  'dividerand'; % 'dividetrain';
net.divideParam.trainRatio = 70;
net.divideParam.valRatio = 30;
net.divideParam.testRatio = 0;

% divideblock - Partition indices into three sets using blocks of indices. %% parameters: trainRatio, valRatio testRatio
% divideind   - Partition indices into three sets using specified indices. %% parameters: trainInd, valInd, testInd
% divideint   - Partition indices into three sets using interleaved indices. %% parameters: trainRatio, valRatio testRatio
% dividerand  - Partition indices into three sets using random indices. %% parameters: trainRatio, valRatio testRatio
% dividetrain - Partition indices into training set only. %% parameters: none

%%%% Effect of data derivative functions 
%  Neural Network Toolbox Derivative Functions.
net.derivFcn = 'defaultderiv';

%     bttderiv     - Backpropagation-through-time derivative function.
%     defaultderiv - Default derivative function.
%     fpderiv      - Forward-perturbation derivative function.
%     num2deriv    - Numeric two-point network derivative function.
%     num5deriv    - Numeric five-point stencil neural network derivative function.
%     staticderiv  - Static backpropagation derivative function.

%%%% Effect of changing epochs
net.trainParam.epochs = 200; %%% maximum 100 iterations

%%%% Effect of training goals
net.trainParam.goal = 0;

%% Train the network
% Now the network is ready to be trained. The samples are automatically
% divided into training, validation and test sets. The training set is
% used to teach the network. Training continues as long as the network
% continues improving on the validation set. The test set provides a
% completely independent measure of network accuracy.
%
% The NN Training Tool shows the network being trained and the algorithms
% used to train it.  It also displays the training state during training
% and the criteria which stopped training will be highlighted in green.
%
% The buttons at the bottom  open useful plots which can be opened during
% and after training.  Links next to the algorithm names and plot buttons
% open documentation on those subjects.

[net,tr] = train(net,x,t);

%%
% To see how the network's performance improved during training, either
% click the "Performance" button in the training tool, or call PLOTPERFORM.
%
% Performance is measured in terms of mean squared error, and shown in
% log scale.  It rapidly decreased as the network was trained.
%
% Performance is shown for each of the training, validation and test sets.
% The version of the network that did best on the validation set is
% was after training.

plotperform(tr)

%%
% The trained neural network can now be tested with the testing samples we
% partitioned from the main dataset. The testing data was not used in
% training in any way and hence provides an "out-of-sample" dataset to
% test the network on. This will give us a sense of how well the network
% will do when tested with data from the real world.
%
% The network outputs will be in the range 0 to 1, so we threshold them
% to get 1's and 0's indicating cancer or normal patients respectively.

testX = x(:,tr.testInd);
testT = t(:,tr.testInd);

% testX = x(:,tr.valInd);
% testT = t(:,tr.valInd);

testY = net(testX);
testClasses = testY > 0.5

%%
% One measure of how well the neural network has fit the data is the
% confusion plot.  Here the confusion matrix is plotted across all samples.
%
% The confusion matrix shows the percentages of correct and incorrect
% classifications.  Correct classifications are the green squares on the
% matrices diagonal.  Incorrect classifications form the red squares.
%
% If the network has learned to classify properly, the percentages in the
% red squares should be very small, indicating few misclassifications.
%
% If this is not the case then further training, or training a network
% with more hidden neurons, would be advisable.

plotconfusion(testT,testY)

%%
% Here are the overall percentages of correct and incorrect classification.

[c,cm] = confusion(testT,testY)

fprintf('Percentage Correct Classification   : %f%%\n', 100*(1-c));
fprintf('Percentage Incorrect Classification : %f%%\n', 100*c);

% Another measure of how well the neural network has fit data is the
% receiver operating characteristic plot.  This shows how the false
% positive and true positive rates relate as the thresholding of outputs
% is varied from 0 to 1.
%
% The farther left and up the line is, the fewer false positives need to
% be accepted in order to get a high true positive rate.  The best
% classifiers will have a line going from the bottom left corner, to the
% top left corner, to the top right corner, or close to that.

plotroc(testT,testY)
rocAna=rocNew([testY' testT'],[],0.05,1,'g','6');

%%
%%%%%%%%%%%%%%%%%% Network Testing with independent data %%%%%%%%%%%%%%%

load('ANN_testInput.mat'); %%%% load input and target for test data  (contains only patients followup data)

testX = input;
testT = target;
% testX = [testX x(:,randi(12,1,6))]; %%% since the test data contains only patient data, so include some data from the control subject randomly from the trainInput
testX = [testX x(:,1:6)]; %%% since the test data contains only patient data, so include some data from the control subject randomly from the trainInput
testT = [testT zeros(1,6)];

testY = net(testX);
testClasses = testY > 0.5;

plotconfusion(testT,testY)

plotroc(testT,testY)
rocAna=rocNew([testY' testT'],[],0.05,1,'g','6');



%%
% This example illustrated how neural networks can be used as classifiers
% for cancer detection. One can also experiment using techniques like
% principal component analysis to reduce the dimensionality of the data
% to be used for building neural networks to improve classifier
% performance. 
%

%% References
% [1] T.P. Conrads, et al., "High-resolution serum proteomic features for
%     ovarian detection", Endocrine-Related Cancer, 11, 2004, pp. 163-178.
%%
% [2] E.F. Petricoin, et al., "Use of proteomic patterns in serum to
%     identify ovarian cancer", Lancet, 359(9306), 2002, pp. 572-577.

% %%
% % *<mailto:nnet-feedback@mathworks.com?subject=Feedback%20for%20CANCERDETECTDEMO%20in%20Bioinformatics%20Toolbox%202.1.1 Provide feedback for this example.>*
% 
% displayEndOfDemoMessage(mfilename)
