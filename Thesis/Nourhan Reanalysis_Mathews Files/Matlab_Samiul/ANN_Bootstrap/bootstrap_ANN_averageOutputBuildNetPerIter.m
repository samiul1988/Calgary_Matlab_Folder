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

hiddenLayerSize = 3;
ann_GUI;

while ~propertyObj.flag
    pause(3);
end
propObj = propertyObj;

%%%% Other parameters
sampleNum = size(input,2);  % get number of samples 
numBoot_in = 50; % bootstrap sample number for inner loop
numBoot_out = 10; % bootstrap sample number for outer loop
train_ind_ratio = 80; % percentage of data that will be used in training
test_ind_raito = 100 - train_ind_ratio; % percentage of data that will be used in testing

nTrainPt = ceil(sampleNum * train_ind_ratio / 100); 
nTestPt = sampleNum - nTrainPt;
    
h = waitbar(0,'Process running...','Name',strcat(mfilename,' Hidden layer size: ',num2str(hiddenLayerSize)),'Resize','on');
tic;

for boot = 1:numBoot_out
    
    for i = 1: numBoot_in
        train_ind = randi(sampleNum,1,nTrainPt); % randomly select nTrainPt samples 'with replacement' from the dataset as training set
        % in_b = bootstrp(numBoot, @(f)f, 1:size(x,1)); % numBoot by sampleNum matrix
    
        test_ind{i} = setdiff(1:sampleNum, train_ind); % find out the remaining samples and set them as testing set
    
        trainX = x(:,train_ind); % input to the ANN classifier
        trainT = t(:,train_ind); % target to the ANN classifier
    
    %   setdemorandstream(672880951);
        
        net = ann_classifier(hiddenLayerSize,propObj);  %%% Create a single neural network 
        [net, tr] = train(net,trainX,trainT);
        % plotperform(tr)

        % testing 
        testX = x(:,test_ind{i});
        testT = t(:,test_ind{i});
        testY{i} = net(testX);
        testClasses{i} = testY{i} > 0.5;
    end

    index_vec = [];
    test_vec = []; 
    for i = 1:length(test_ind)
        index_vec = [index_vec test_ind{i}];  %%% store the indices of samples from all iterations
        test_vec = [test_vec testY{i}]; %%% store the test outcomes of samples from all iterations
    end
    output_vec = [index_vec' test_vec']; %%% make the test output vector left col: index right col: corresponding test outcome
    o = unique(output_vec(:,1));  %%% o = 1: numSample
    for j= 1:length(o)
        t_ind = find(output_vec(:,1) == o(j)); %%% obtain the values against each index 
        testMean(j) = mean(output_vec(t_ind,2)); %%% take mean value 
    end
    rocAna = roc_for_ANN([testMean' t'],0); 
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

fileName = strcat('ANN_bootInpBuildNetPerIter_',num2str(featureNum),'11_HLS',num2str(hiddenLayerSize),generateFileNameForANN(data.header));
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

%%
% % % % %%%% Test Code for Confidence interval calculation %%%%%
% % clear all
% % clc
% % x=randi(20,1,10);
% % a=x;
% % f1 = @(x)mean(x);
% % % f2 = @(x)(x);
% % % [ci,r] = bootci(1,{f1,a},'alpha',0.05,'type','per');
% % [ci,r] = bootci(2000,{f1,a},'alpha',0.05,'type','bca');
% % alpha=0.05;
% % 
% % mr = mean(r);
% % sr = std(r);
% 
% 
% % cl = mr - norminv(.95/2)*sr  %%% right approach
% 
% cl = mr - 1.645 * sr %/sqrt(length(r))
% 
% % % 
% % % 
% % % [a,pcov] = normlike([mr,sr], r);
% % % [y,yl,yu] = normcdf(r,mr,sr,pcov,alpha);
% % % yl 
% 
