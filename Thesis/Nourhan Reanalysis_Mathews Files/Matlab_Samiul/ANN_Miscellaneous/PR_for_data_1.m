% %%%%%
% % This script assumes these variables are defined:
% %
% %   simpleclassInputs - input data.
% %   simpleclassTargets - target data.
% 
% % addpath(genpath('C:\Users\Samiul\Dropbox\samiul_home_lab\Calgary Matlab Folder\Thesis\Nourhan Reanalysis_Mathews Files\Matlab_Samiul'));
% 
% %%% load input matrix for ANN PR
% load('ON_input.mat'); %%%%% will load 'input' which is a 6 by 39 matrix containing patient and control subject data and target is a 2 by 39 data matrix
% 
% inputs = input;
% targets = target;
% epochs = 3000;
% 
% % inputs = simpleclassInputs;  %%% input to the network
% % targets = simpleclassTargets; %%% target matrix
% 
% % Create a Pattern Recognition Network
% hiddenLayerSize = 10; 
% net = patternnet(hiddenLayerSize); %%% feedforward pattern recognition network
% 
% % Choose Input and Output Pre/Post-Processing Functions
% % For a list of all processing functions type: help nnprocess
% net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
% net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};
% 
% % Setup Division of Data for Training, Validation, Testing
% % For a list of all data division functions type: help nndivision
% % net.divideFcn = 'dividerand';  % Divide data randomly
% net.divideFcn = 'dividerand';  % Divide data randomly
% net.divideMode = 'sample';  % Divide up every sample
% net.divideParam.trainRatio = 70/100;
% net.divideParam.valRatio = 15/100;
% net.divideParam.testRatio = 15/100;
% 
% % For help on training function 'trainlm' type: help trainlm
% % For a list of all training functions type: help nntrain
% % net.trainFcn = 'trainlm';  % Levenberg-Marquardt
% net.trainFcn = 'trainbfg';  % BFGS quasi newton backpropagation
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
% 
% % Choose a Performance Function
% % For a list of all performance functions type: help nnperformance
% net.performFcn = 'mse';  % Mean squared error
% 
% % Choose Plot Functions
% % For a list of all plot functions type: help nnplot
% net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
%   'plotregression', 'plotfit'};
% 
% 
% % Train the Network
% [net,tr] = train(net,inputs,targets);
% 
% % Test the Network
% outputs = net(inputs);
% errors = gsubtract(targets,outputs);
% performance = perform(net,targets,outputs)
% 
% % Recalculate Training, Validation and Test Performance
% trainTargets = targets .* tr.trainMask{1};
% valTargets = targets  .* tr.valMask{1};
% testTargets = targets  .* tr.testMask{1};
% trainPerformance = perform(net,trainTargets,outputs)
% valPerformance = perform(net,valTargets,outputs)
% testPerformance = perform(net,testTargets,outputs)
% 
% % View the Network
% view(net)
% 
% % Plots
% % Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% %figure, plottrainstate(tr)
% %figure, plotconfusion(targets,outputs)
% %figure, ploterrhist(errors)
% 
% 
% %%
% 
% nump=3;  % number of classes
%  
% n=3;     % number of images per class
% 
% % training images reshaped into columns in P 
% % image size (3x3) reshaped to (1x9)
% 
% 
% % training images 
% P=[196    35   234   232    59   244   243    57   226; ...
%    188    15   236   244    44   228   251    48   230; ...    % class 1
%    246    48   222   225    40   226   208    35   234; ...
%    
%    255   223   224   255     0   255   249   255   235; ...
%    234   255   205   251     0   251   238   253   240; ...    % class 2
%    232   255   231   247    38   246   190   236   250; ...
%    
%    25     53   224   255    15    25   249    55   235; ...
%    24     25   205   251    10    25   238    53   240; ...    % class 3
%    22     35   231   247    38    24   190    36   250]';
% 
% % testing images 
% N=[208    16   235   255    44   229   236    34   247; ...
%    245    21   213   254    55   252   215    51   249; ...    % class 1
%    248    22   225   252    30   240   242    27   244; ...
%    
%    255   241   208   255    28   255   194   234   188; ...
%    237   243   237   237    19   251   227   225   237; ...    % class 2
%    224   251   215   245    31   222   233   255   254; ...
%    
%     25    21   208   255    28    25   194    34   188; ...
%     27    23   237   237    19    21   227    25   237; ...    % class 3
%     24    49   215   245    31    22   233    55   254]';
% 
% % Normalization
% P=P/256;
% N=N/256;
% 
% 
% % display the training images 
% figure(1),
% for i=1:n*nump
%     im=reshape(P(:,i), [3 3]);
%     im=imresize(im,20);        % resize the image to make it clear
%     subplot(nump,n,i),imshow(im);title(strcat('Train image/Class #', int2str(ceil(i/n))))
% end
% % display the testing images 
% figure,
% for i=1:n*nump
%     im=reshape(N(:,i), [3 3]);
%     im=imresize(im,20);        % resize the image to make it clear 
%     subplot(nump,n,i),imshow(im);title(strcat('test image #', int2str(i)))
% end
% 
% 
% % targets
% T=[  1  1   1   0   0   0   0   0   0
%      0  0   0   1   1   1   0   0   0
%      0  0   0   0   0   0   1   1   1 ];

 %%
load('ON_input.mat'); %%%%% will load 'input' which is a 6 by 39 matrix containing patient and control subject data and target is a 2 by 39 data matrix

P = input; 
T = target; 

%%% neural network  
S1=5;   % number of hidden layers
S2=2;   % number of output layers (= number of classes)

[R,Q]=size(P); 
epochs = 10000;      % number of iterations
goal_err = 10e-5;    % goal error
a=0.3;                        % define the range of random variables
b=-0.3;
W1=a + (b-a) *rand(S1,R);     % Weights between Input and Hidden Neurons
W2=a + (b-a) *rand(S2,S1);    % Weights between Hidden and Output Neurons
b1=a + (b-a) *rand(S1,1);     % Weights between Input and Hidden Neurons
b2=a + (b-a) *rand(S2,1);     % Weights between Hidden and Output Neurons
n1=W1*P;
A1=logsig(n1);
n2=W2*A1;
A2=logsig(n2);
e=A2-T;
error =0.5* mean(mean(e.*e));    
nntwarn off
for  itr =1:epochs
    if error <= goal_err 
        break
    else
         for i=1:Q
            df1=dlogsig(n1,A1(:,i));
            df2=dlogsig(n2,A2(:,i));
            s2 = -2*diag(df2) * e(:,i);			       
            s1 = diag(df1)* W2'* s2;
            W2 = W2-0.1*s2*A1(:,i)';
            b2 = b2-0.1*s2;
            W1 = W1-0.1*s1*P(:,i)';
            b1 = b1-0.1*s1;

            A1(:,i)=logsig(W1*P(:,i),b1);
            A2(:,i)=logsig(W2*A1(:,i),b2);
         end
            e = T - A2;
            error =0.5*mean(mean(e.*e));
            disp(sprintf('Iteration :%5d        mse :%12.6f%',itr,error));
            mse(itr)=error;
    end
end

threshold=0.9;   % threshold of the system (higher threshold = more accuracy)

% training images result

%TrnOutput=real(A2)
TrnOutput=real(A2>threshold)    

% applying test images to NN
n1=W1*N;
A1=logsig(n1);
n2=W2*A1;
A2test=logsig(n2);

% testing images result

%TstOutput=real(A2test)
TstOutput=real(A2test>threshold)


% recognition rate
wrong=size(find(TstOutput-T),1);
recognition_rate=100*(size(N,2)-wrong)/size(N,2)

