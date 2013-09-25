%% 
clc;
clear all;
clear net tr 
load('cancer_dataset.mat');
% load('thyroid_dataset.mat');
% clear net
X = cancerInputs;
T = cancerTargets(1,:);


X_train = X(:,200:end);
T_train = T(:,200:end);

X_test = X(:,1:199);
T_test = T(:,1:199);

net = patternnet(10);
% net.trainFcn = 'trainscg';
% net.trainFcn = 'trainrp';
% net.trainFcn = 'trainrp_custom';
net.trainFcn = 'trainrp_custom3';

net.performFcn = 'mse';
% net.performFcn = 'mseMyFunc2';

net.trainParam.epochs = 1000;
net.trainParam.max_fail = 500; 
net.trainParam.min_grad = 1e-15;

% net.performFcn = 'sse';

[net,tr] = train(net, X_train, T_train);
% [net,tr] = train(net, thyroidInputs, thyroidTargets);

testY = net(X_test);
testT = T_test;
rocAna = roc_for_ANN([testY' testT'],0);
AUC = rocAna.AUC
% 

%%
tt = tr.vperf;
tt= 10*log10(tt);
%%
xx= 1:length(tt);
loss= fittedmodel3;
%%
options = struct('CoolSched',@(T) (.8*T),...
                 'Generator',@(x) (x+(randperm(length(x))==length(x))*3*randn),...
                 'InitTemp',50,...
                 'MaxConsRej',1000,...
                 'MaxSuccess',200,...
                 'MaxTries',1000,...
                 'StopTemp',1e-8,...
                 'StopVal',-Inf,...
                 'Verbosity',2);
[x f] = anneal_test(loss,0,options)

% [x1 fval] = simulannealbnd(@objecfun,0)
%% 
fs= 1000;
f= 10;
T = 1/f;
x = 0:1/fs:3*T;
func =  sin(2*pi*f*x).*exp(-6*x);
plot(x,func)

% func =  @(x)sin(x)*exp(-3);
func = @(x)sin(2*pi*f*x).*exp(-.2*x);
options = struct('CoolSched',@(T) (.8*T),...
                 'Generator',@(x) (x+randn/100),...
                 'InitTemp',10,...
                 'MaxConsRej',100,...
                 'MaxSuccess',200,...
                 'MaxTries',1000,...
                 'StopTemp',1e-8,...
                 'StopVal',-Inf,...
                 'Verbosity',2);
[x_min f_min] = anneal_test(func,0,options)


x0 = [0 0];
      fun = @dejong5fcn;
      lb = [-64 -64];
      ub = [64 64];
      [x,fval] = simulannealbnd(fun,x0,lb,ub)


%% 
clc;
clear all;
% load('cancer_dataset.mat');
% load('thyroid_dataset.mat');
load('ANN_input_24-Jan-2013.mat');

% X = cancerInputs;
% T = cancerTargets(1,:);

% X_train = X(:,200:end);
% T_train = T(:,200:end);
% 
% X_test = X(:,1:199);
% T_test = T(:,1:199);

X = input;
T = target;

train_ind = [23 21 24 4    27    30    12    10    17    29    14    20    11    32    25 ...
              6     3    19     8     9     1    16    31    15];
          
test_ind = [2     5     7    13    18    22    26    28    33];

X_train = X;%(:,train_ind);
T_train = T;%(:,train_ind);

X_test = X(:,test_ind);
T_test = T(:,test_ind);


testT = T_test;

net1 = patternnet(10);
% net.trainFcn = 'trainscg';
% net.trainFcn = 'trainrp';
% net.trainFcn = 'trainrp_custom';
net1.trainFcn = 'trainrp_custom3';

net1.performFcn = 'mse';
% net.performFcn = 'mseMyFunc2';

net1.trainParam.epochs = 1000;
net1.trainParam.max_fail = 500; 
net1.trainParam.min_grad = 1e-15;

% net.performFcn = 'sse';
for i = 1:500
[net1,tr1] = train(net1, X_train, T_train);
% [net,tr] = train(net, thyroidInputs, thyroidTargets);

testY1 = net1(X_test);
rocAna = roc_for_ANN([testY1' testT'],0);
AUC1(i) = rocAna.AUC;
epoch1(i) = tr1.best_epoch;
time1(i) = mean(tr1.time);
end


net2 = patternnet(10);
% net.trainFcn = 'trainscg';
net2.trainFcn = 'trainrp';
% net.trainFcn = 'trainrp_custom';
% net.trainFcn = 'trainrp_custom3';
% 
net2.performFcn = 'mse';
% net.performFcn = 'mseMyFunc2';

net2.trainParam.epochs = 1000;
net2.trainParam.max_fail = 500; 
net2.trainParam.min_grad = 1e-15;

% net.performFcn = 'sse';
for i = 1:500
[net2,tr2] = train(net2, X_train, T_train);
% [net,tr] = train(net, thyroidInputs, thyroidTargets);

testY2 = net2(X_test);
% testT = T_test;
rocAna = roc_for_ANN([testY2' testT'],0);
AUC2(i) = rocAna.AUC;
epoch2(i) = tr2.best_epoch;
time2(i) = mean(tr2.time);
end
nBootAz = 500;
alpha = 0.05;
[ci1,rAUCboot1] = bootci(nBootAz,{@(x)mean(x),AUC1},'alpha',alpha);
[ci2,rAUCboot2] = bootci(nBootAz,{@(x)mean(x),AUC2},'alpha',alpha);

ci1
ci2
mean(rAUCboot1)
mean(rAUCboot2)

