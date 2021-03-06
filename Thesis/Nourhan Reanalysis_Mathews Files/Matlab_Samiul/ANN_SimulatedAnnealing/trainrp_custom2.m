function [out1,out2] = trainrp_custom2(varargin)
%TRAINRP RPROP backpropagation.
%
%  <a href="matlab:doc trainrp">trainrp</a> is a network training function that updates weight and bias
%  values according to the resilient backpropagation algorithm (RPROP).
%
%  [NET,TR] = <a href="matlab:doc trainrp">trainrp</a>(NET,X,T) takes a network NET, input data X
%  and target data T and returns the network after training it, and a
%  a training record TR.
%  
%  [NET,TR] = <a href="matlab:doc trainrp">trainrp</a>(NET,X,T,Xi,Ai,EW) takes additional optional
%  arguments suitable for training dynamic networks and training with
%  error weights.  Xi and Ai are the initial input and layer delays states
%  respectively and EW defines error weights used to indicate
%  the relative importance of each target value.
%
%  Training occurs according to training parameters, with default values.
%  Any or all of these can be overridden with parameter name/value argument
%  pairs appended to the input argument list, or by appending a structure
%  argument with fields having one or more of these names.
%    show        25  Epochs between displays
%    showCommandLine 0 generate command line output
%    showWindow   1 show training GUI
%    epochs     100  Maximum number of epochs to train
%    goal         0  Performance goal
%    time       inf  Maximum time to train in seconds
%    min_grad  1e-6  Minimum performance gradient
%    max_fail     5  Maximum validation failures
%    lr        0.01  Learning rate
%    delt_inc   1.2  Increment to weight change
%    delt_dec   0.5  Decrement to weight change
%    delta0    0.07  Initial weight change
%    deltamax  50.0  Maximum weight change
%
%  To make this the default training function for a network, and view
%  and/or change parameter settings, use these two properties:
%
%    net.<a href="matlab:doc nnproperty.net_trainFcn">trainFcn</a> = 'trainrp';
%    net.<a href="matlab:doc nnproperty.net_trainParam">trainParam</a>
%
%  See also NEWFF, NEWCF, TRAINGDM, TRAINGDA, TRAINGDX, TRAINLM,
%           TRAINCGP, TRAINCGF, TRAINCGB, TRAINSCG, TRAINOSS,
%           TRAINBFG.

% Updated by Orlando De Jes�s, Martin Hagan, Dynamic Training 7-20-05
% Copyright 1992-2012 The MathWorks, Inc.
% $Revision: 1.1.6.16 $ $Date: 2012/04/20 19:14:19 $

%% =======================================================
%  BOILERPLATE_START
%  This code is the same for all Training Functions.

  persistent INFO;
  if isempty(INFO), INFO = get_info; end
  nnassert.minargs(nargin,1);
  in1 = varargin{1};
  if ischar(in1)
    switch (in1)
      case 'info'
        out1 = INFO;
      case 'apply'
        [out1,out2] = train_network(varargin{2:end});
      case 'formatNet'
        out1 = formatNet(varargin{2});
      case 'check_param'
        param = varargin{2};
        err = nntest.param(INFO.parameters,param);
        if isempty(err)
          err = check_param(param);
        end
        if nargout > 0
          out1 = err;
        elseif ~isempty(err)
          nnerr.throw('Type',err);
        end
      otherwise,
        try
          out1 = eval(['INFO.' in1]);
        catch me, nnerr.throw(['Unrecognized first argument: ''' in1 ''''])
        end
    end
  else
    net = varargin{1};
    oldTrainFcn = net.trainFcn;
    oldTrainParam = net.trainParam;
    if ~strcmp(net.trainFcn,mfilename)
      net.trainFcn = mfilename;
      net.trainParam = INFO.defaultParam;
    end
    [out1,out2] = train(net,varargin{2:end});
    net.trainFcn = oldTrainFcn;
    net.trainParam = oldTrainParam;
  end
end

%  BOILERPLATE_END
%% =======================================================

function info = get_info()
  isSupervised = true;
  usesGradient = true;
  usesJacobian = false;
  usesValidation = true;
  supportsCalcModes = true;
  info = nnfcnTraining(mfilename,'RProp',8.0,...
    isSupervised,usesGradient,usesJacobian,usesValidation,supportsCalcModes,...
    [ ...
    nnetParamInfo('showWindow','Show Training Window Feedback','nntype.bool_scalar',true,...
    'Display training window during training.'), ...
    nnetParamInfo('showCommandLine','Show Command Line Feedback','nntype.bool_scalar',false,...
    'Generate command line output during training.') ...
    nnetParamInfo('show','Command Line Frequency','nntype.strict_pos_int_inf_scalar',25,...
    'Frequency to update command line.'), ...
    ...
    nnetParamInfo('epochs','Maximum Epochs','nntype.pos_int_scalar',1000,...
    'Maximum number of training iterations before training is stopped.') ...
    nnetParamInfo('time','Maximum Training Time','nntype.pos_inf_scalar',inf,...
    'Maximum time in seconds before training is stopped.') ...
    ...
    nnetParamInfo('goal','Performance Goal','nntype.pos_scalar',0,...
    'Performance goal.') ...
    nnetParamInfo('min_grad','Minimum Gradient','nntype.pos_scalar',1e-5,...
    'Minimum performance gradient before training is stopped.') ...
    nnetParamInfo('max_fail','Maximum Validation Checks','nntype.strict_pos_int_scalar',6,...
    'Maximum number of validation checks before training is stopped.') ...
    ...
    nnetParamInfo('delta0','Initial Delta','nntype.pos_scalar',0.07,...
    'Initial delta value.') ...
    nnetParamInfo('delt_inc','Delta Increase','nntype.over1',1.2,...
    'Multiplier to increase delta.') ...
    nnetParamInfo('delt_dec','Delta Decrease','nntype.real_0_to_1',0.5,...
    'Multiple to decrease delta.') ...
    nnetParamInfo('deltamax','Maximum Delta','nntype.pos_scalar',50.0,...
    'Maximum delta value.') ...
    nnetParamInfo('deltamin','Minimum Delta','nntype.num_scalar',0.0,...
    'Minimum delta value.') ...
    nnetParamInfo('tempInit','T_init','nntype.pos_scalar',1,...
    'Temperature parameter for Simulated Annealing.') ...
    nnetParamInfo('tempFinal','T_final','nntype.pos_scalar',1e-8,...
    'Temperature parameter for Simulated Annealing.') ...
    ], ...
    [ ...
    nntraining.state_info('gradient','Gradient','continuous','log') ...
    nntraining.state_info('val_fail','Validation Checks','discrete','linear') ...
    ]);
end

function err = check_param(param)
  err = '';
end

function net = formatNet(net)
  if isempty(net.performFcn)
    warning('nnet:trainrp:Performance',nnwarn_empty_performfcn_corrected);
    net.performFcn = 'mse';
  end
end

function [calcNet,tr] = train_network(archNet,rawData,calcLib,calcNet,tr)
  
  % Parallel Workers
  isParallel = calcLib.isParallel;
  isMainWorker = calcLib.isMainWorker;
  mainWorkerInd = calcLib.mainWorkerInd;

  % Create broadcast variables
  stop = []; 
  WB = [];
  
  % Initialize
  param = archNet.trainParam;
  if isMainWorker
      startTime = clock;
      original_net = calcNet;
  end
  
  [perf,vperf,tperf,gWB,gradient] = calcLib.perfsGrad(calcNet);
  
  if isMainWorker
      [best,val_fail] = nntraining.validation_start(calcNet,perf,vperf);
      WB = calcLib.getwb(calcNet);
      dWB = zeros(size(WB));  %%% added
      deltaWB = param.delta0*ones(size(WB));
      deltaMAX = param.deltamax*ones(size(WB));
      deltaMIN = param.deltamin*ones(size(WB));  %%% added
%       gWB = gWB - 0.01.*WB./(1+WB.^2) * SA;  %%% added 
%       gWB_old = gWB;
% gWB_old = zeros(size(gWB)); %%% added
       T = param.tempInit;
       minT = param.tempFinal;
%       
      
      % Training Record
      tr.best_epoch = 0;
      tr.goal = param.goal;
      tr.states = {'epoch','time','perf','vperf','tperf','gradient','val_fail'};

      % Status
      status = ...
        [ ...
        nntraining.status('Epoch','iterations','linear','discrete',0,param.epochs,0), ...
        nntraining.status('Time','seconds','linear','discrete',0,param.time,0), ...
        nntraining.status('Performance','','log','continuous',perf,param.goal,perf) ...
        nntraining.status('Gradient','','log','continuous',gradient,param.min_grad,gradient) ...
        nntraining.status('Validation Checks','','linear','discrete',0,param.max_fail,0) ...
        ];
      nn_train_feedback('start',archNet,status);
  end
  
  
  
  % counters etc
itry = 0;
success = 0;
finished = 0;
consec = 0;
epoch = 0;
initenergy = loss(parent);
oldenergy = initenergy;
total = 0;

%% Train
while ~finished;
    itry = itry+1; % just an iteration counter
    WB = WB; % current = parent; 
    
    % Stopping Criteria
    if isMainWorker
        current_time = etime(clock,startTime);
        [userStop,userCancel] = nntraintool('check');
        if userStop, tr.stop = 'User stop.'; calcNet = best.net;
        elseif userCancel, tr.stop = 'User cancel.'; calcNet = original_net;
        elseif (perf <= param.goal), tr.stop = 'Performance goal met.'; calcNet = best.net;
        elseif (epoch == param.epochs), tr.stop = 'Maximum epoch reached.'; calcNet = best.net;
        elseif (current_time >= param.time), tr.stop = 'Maximum time elapsed.'; calcNet = best.net;
        elseif (gradient <= param.min_grad), tr.stop = 'Minimum gradient reached.'; calcNet = best.net;
        elseif (val_fail >= param.max_fail), tr.stop = 'Validation stop.'; calcNet = best.net;
        end

        % Training record * feedback
        tr = nntraining.tr_update(tr,[epoch current_time perf vperf tperf gradient val_fail]);
        statusValues = [epoch,current_time,best.perf,gradient,val_fail];
        nn_train_feedback('update',archNet,rawData,calcLib,calcNet,tr,status,statusValues);
        stop = ~isempty(tr.stop);
    end
    
    % Stop
    if isParallel, stop = labBroadcast(mainWorkerInd,stop); end
    if stop, return, end
    
    % % Stop / decrement T criteria
    if itry >= max_try || success >= max_success;
        if T < minT || consec >= max_consec_rejections;
            finished = 1;
            total = total + itry;
            return;
        else
            T = 0.8 * (T);  % decrease T according to cooling schedule
            total = total + itry;
            itry = 1;
            success = 1;
        end
    end
    
    if isMainWorker
%         ggWB = gWB.*gWB_old;
%         deltaWB = ((ggWB>0)*param.delt_inc + (ggWB<0)*param.delt_dec + (ggWB==0)).*deltaWB;
%         deltaWB = min(deltaWB,deltaMAX);
%         dWB = deltaWB.*sign(gWB);
%         WB = WB + dWB;
%         gWB_old = gWB;
        
        % APPLY RPROP UPDATE
%         SA = 2^-(T * epoch);
%         gWB = gWB; %- 0.01.*WB./(1+WB.^2) * SA;  %%% added 
        gWB_old = gWB;
        ggWB = gWB.*gWB_old;
        for i = 1:length(ggWB)
            if ggWB(i) > 0
                deltaWB(i) = param.delt_inc * deltaWB(i);
                deltaWB(i) = min(deltaWB(i),deltaMAX(i));
                dWB(i) = deltaWB(i) * sign(gWB(i));
                WB(i) = WB(i) + dWB(i);
                gWB_old(i) = gWB(i);
            elseif ggWB(i) < 0
                if deltaWB(i) < (0.4 * SA^2)
%                 if rand < exp( ggWB(i)/T)
                    deltaWB(i) = param.delt_dec * deltaWB(i) + 0.8 * rand *SA^2;
                else 
                    deltaWB(i) = param.delt_dec * deltaWB(i);
                end
                deltaWB(i) = max(deltaWB(i),deltaMIN(i));
%             deltaWB(i) = min(deltaWB(i),deltaMAX(i));
                dWB(i) = deltaWB(i) * sign(gWB(i));
                WB(i) = WB(i) + dWB(i);
                gWB_old(i) = 0;
            elseif ggWB(i) == 0
%                deltaWB(i) = deltaWB(i);
%                deltaWB(i) = min(deltaWB(i),deltaMAX(i));
                dWB(i) = deltaWB(i) * sign(gWB(i));
                WB(i) = WB(i) + dWB(i);
                gWB_old(i) = gWB(i);
            end
        end
    
%     newparam = newsol(current); % WB 
%     newenergy = loss(newparam); % gWB
    
    if (newenergy < minF),
        parent = newparam; 
        oldenergy = newenergy;
        break
    end
    
    if (oldenergy-newenergy > 1e-6)
        parent = newparam;
        oldenergy = newenergy;
        success = success+1;
        consec = 0;
    else
        if (rand < exp( (oldenergy-newenergy)/(k*T) ));
            parent = newparam;
            oldenergy = newenergy;
            success = success+1;
        else
            consec = consec+1;
        end
    end
end

minimum = parent;
fval = oldenergy;



%   %% Train
%   for epoch=0:param.epochs

%     % Stopping Criteria
%     if isMainWorker
%         current_time = etime(clock,startTime);
%         [userStop,userCancel] = nntraintool('check');
%         if userStop, tr.stop = 'User stop.'; calcNet = best.net;
%         elseif userCancel, tr.stop = 'User cancel.'; calcNet = original_net;
%         elseif (perf <= param.goal), tr.stop = 'Performance goal met.'; calcNet = best.net;
%         elseif (epoch == param.epochs), tr.stop = 'Maximum epoch reached.'; calcNet = best.net;
%         elseif (current_time >= param.time), tr.stop = 'Maximum time elapsed.'; calcNet = best.net;
%         elseif (gradient <= param.min_grad), tr.stop = 'Minimum gradient reached.'; calcNet = best.net;
%         elseif (val_fail >= param.max_fail), tr.stop = 'Validation stop.'; calcNet = best.net;
%         end
% 
%         % Training record * feedback
%         tr = nntraining.tr_update(tr,[epoch current_time perf vperf tperf gradient val_fail]);
%         statusValues = [epoch,current_time,best.perf,gradient,val_fail];
%         nn_train_feedback('update',archNet,rawData,calcLib,calcNet,tr,status,statusValues);
%         stop = ~isempty(tr.stop);
%     end
%     
%     % Stop
%     if isParallel, stop = labBroadcast(mainWorkerInd,stop); end
%     if stop, return, end

    % APPLY RPROP UPDATE
%     if isMainWorker
% %         ggWB = gWB.*gWB_old;
% %         deltaWB = ((ggWB>0)*param.delt_inc + (ggWB<0)*param.delt_dec + (ggWB==0)).*deltaWB;
% %         deltaWB = min(deltaWB,deltaMAX);
% %         dWB = deltaWB.*sign(gWB);
% %         WB = WB + dWB;
% %         gWB_old = gWB;
%         
%         % APPLY RPROP UPDATE
%         SA = 2^-(T * epoch);
%         gWB = gWB; %- 0.01.*WB./(1+WB.^2) * SA;  %%% added 
%         gWB_old = gWB;
%         ggWB = gWB.*gWB_old;
%         for i = 1:length(ggWB)
%             if ggWB(i) > 0
%                 deltaWB(i) = param.delt_inc * deltaWB(i);
%                 deltaWB(i) = min(deltaWB(i),deltaMAX(i));
%                 dWB(i) = deltaWB(i) * sign(gWB(i));
%                 WB(i) = WB(i) + dWB(i);
%                 gWB_old(i) = gWB(i);
%             elseif ggWB(i) < 0
%                 if deltaWB(i) < (0.4 * SA^2)
% %                 if rand < exp( ggWB(i)/T)
%                     deltaWB(i) = param.delt_dec * deltaWB(i) + 0.8 * rand *SA^2;
%                 else 
%                     deltaWB(i) = param.delt_dec * deltaWB(i);
%                 end
%                 deltaWB(i) = max(deltaWB(i),deltaMIN(i));
% %             deltaWB(i) = min(deltaWB(i),deltaMAX(i));
%                 dWB(i) = deltaWB(i) * sign(gWB(i));
%                 WB(i) = WB(i) + dWB(i);
%                 gWB_old(i) = 0;
%             elseif ggWB(i) == 0
% %                deltaWB(i) = deltaWB(i);
% %                deltaWB(i) = min(deltaWB(i),deltaMAX(i));
%                 dWB(i) = deltaWB(i) * sign(gWB(i));
%                 WB(i) = WB(i) + dWB(i);
%                 gWB_old(i) = gWB(i);
%             end
%         end
        
%         %% Stop / decrement T criteria
%         if T > minT
% %            T = cool(T);  % decrease T according to cooling schedule
%             T = 0.8 * T;  % decrease T according to cooling schedule
%         end
    end

     
    calcNet = calcLib.setwb(calcNet,WB);
    [perf,vperf,tperf,gWB,gradient] = calcLib.perfsGrad(calcNet);
    
    % Validation
    if isMainWorker
        [best,tr,val_fail] = nntraining.validation(best,tr,val_fail,calcNet,perf,vperf,epoch);
    end
  end
end










% 
% function [out1,out2] = trainrp_custom(varargin)
% %TRAINRP RPROP backpropagation.
% %
% %  <a href="matlab:doc trainrp">trainrp</a> is a network training function that updates weight and bias
% %  values according to the resilient backpropagation algorithm (RPROP).
% %
% %  [NET,TR] = <a href="matlab:doc trainrp">trainrp</a>(NET,X,T) takes a network NET, input data X
% %  and target data T and returns the network after training it, and a
% %  a training record TR.
% %  
% %  [NET,TR] = <a href="matlab:doc trainrp">trainrp</a>(NET,X,T,Xi,Ai,EW) takes additional optional
% %  arguments suitable for training dynamic networks and training with
% %  error weights.  Xi and Ai are the initial input and layer delays states
% %  respectively and EW defines error weights used to indicate
% %  the relative importance of each target value.
% %
% %  Training occurs according to training parameters, with default values.
% %  Any or all of these can be overridden with parameter name/value argument
% %  pairs appended to the input argument list, or by appending a structure
% %  argument with fields having one or more of these names.
% %    show        25  Epochs between displays
% %    showCommandLine 0 generate command line output
% %    showWindow   1 show training GUI
% %    epochs     100  Maximum number of epochs to train
% %    goal         0  Performance goal
% %    time       inf  Maximum time to train in seconds
% %    min_grad  1e-6  Minimum performance gradient
% %    max_fail     5  Maximum validation failures
% %    lr        0.01  Learning rate
% %    delt_inc   1.2  Increment to weight change
% %    delt_dec   0.5  Decrement to weight change
% %    delta0    0.07  Initial weight change
% %    deltamax  50.0  Maximum weight change
% %
% %  To make this the default training function for a network, and view
% %  and/or change parameter settings, use these two properties:
% %
% %    net.<a href="matlab:doc nnproperty.net_trainFcn">trainFcn</a> = 'trainrp';
% %    net.<a href="matlab:doc nnproperty.net_trainParam">trainParam</a>
% %
% %  See also NEWFF, NEWCF, TRAINGDM, TRAINGDA, TRAINGDX, TRAINLM,
% %           TRAINCGP, TRAINCGF, TRAINCGB, TRAINSCG, TRAINOSS,
% %           TRAINBFG.
% 
% % Updated by Orlando De Jes�s, Martin Hagan, Dynamic Training 7-20-05
% % Copyright 1992-2012 The MathWorks, Inc.
% % $Revision: 1.1.6.16 $ $Date: 2012/04/20 19:14:19 $
% 
% %% =======================================================
% %  BOILERPLATE_START
% %  This code is the same for all Training Functions.
% 
%   persistent INFO;
%   if isempty(INFO), INFO = get_info; end
%   nnassert.minargs(nargin,1);
%   in1 = varargin{1};
%   if ischar(in1)
%     switch (in1)
%       case 'info'
%         out1 = INFO;
%       case 'apply'
%         [out1,out2] = train_network(varargin{2:end});
%       case 'formatNet'
%         out1 = formatNet(varargin{2});
%       case 'check_param'
%         param = varargin{2};
%         err = nntest.param(INFO.parameters,param);
%         if isempty(err)
%           err = check_param(param);
%         end
%         if nargout > 0
%           out1 = err;
%         elseif ~isempty(err)
%           nnerr.throw('Type',err);
%         end
%       otherwise,
%         try
%           out1 = eval(['INFO.' in1]);
%         catch me, nnerr.throw(['Unrecognized first argument: ''' in1 ''''])
%         end
%     end
%   else
%     net = varargin{1};
%     oldTrainFcn = net.trainFcn;
%     oldTrainParam = net.trainParam;
%     if ~strcmp(net.trainFcn,mfilename)
%       net.trainFcn = mfilename;
%       net.trainParam = INFO.defaultParam;
%     end
%     [out1,out2] = train(net,varargin{2:end});
%     net.trainFcn = oldTrainFcn;
%     net.trainParam = oldTrainParam;
%   end
% end
% 
% %  BOILERPLATE_END
% %% =======================================================
% 
% function info = get_info()
%   isSupervised = true;
%   usesGradient = true;
%   usesJacobian = false;
%   usesValidation = true;
%   supportsCalcModes = true;
%   info = nnfcnTraining(mfilename,'RProp',8.0,...
%     isSupervised,usesGradient,usesJacobian,usesValidation,supportsCalcModes,...
%     [ ...
%     nnetParamInfo('showWindow','Show Training Window Feedback','nntype.bool_scalar',true,...
%     'Display training window during training.'), ...
%     nnetParamInfo('showCommandLine','Show Command Line Feedback','nntype.bool_scalar',false,...
%     'Generate command line output during training.') ...
%     nnetParamInfo('show','Command Line Frequency','nntype.strict_pos_int_inf_scalar',25,...
%     'Frequency to update command line.'), ...
%     ...
%     nnetParamInfo('epochs','Maximum Epochs','nntype.pos_int_scalar',1000,...
%     'Maximum number of training iterations before training is stopped.') ...
%     nnetParamInfo('time','Maximum Training Time','nntype.pos_inf_scalar',inf,...
%     'Maximum time in seconds before training is stopped.') ...
%     ...
%     nnetParamInfo('goal','Performance Goal','nntype.pos_scalar',0,...
%     'Performance goal.') ...
%     nnetParamInfo('min_grad','Minimum Gradient','nntype.pos_scalar',1e-5,...
%     'Minimum performance gradient before training is stopped.') ...
%     nnetParamInfo('max_fail','Maximum Validation Checks','nntype.strict_pos_int_scalar',6,...
%     'Maximum number of validation checks before training is stopped.') ...
%     ...
%     nnetParamInfo('delta0','Initial Delta','nntype.pos_scalar',0.07,...
%     'Initial delta value.') ...
%     nnetParamInfo('delt_inc','Delta Increase','nntype.over1',1.2,...
%     'Multiplier to increase delta.') ...
%     nnetParamInfo('delt_dec','Delta Decrease','nntype.real_0_to_1',0.5,...
%     'Multiple to decrease delta.') ...
%     nnetParamInfo('deltamax','Maximum Delta','nntype.pos_scalar',50.0,...
%     'Maximum delta value.') ...
%     nnetParamInfo('deltamin','Minimum Delta','nntype.num_scalar',0.0,...
%     'Minimum delta value.') ...
%     nnetParamInfo('tempInit','T_init','nntype.pos_scalar',1,...
%     'Temperature parameter for Simulated Annealing.') ...
%     nnetParamInfo('tempFinal','T_final','nntype.pos_scalar',1e-8,...
%     'Temperature parameter for Simulated Annealing.') ...
%     ], ...
%     [ ...
%     nntraining.state_info('gradient','Gradient','continuous','log') ...
%     nntraining.state_info('val_fail','Validation Checks','discrete','linear') ...
%     ]);
% end
% 
% function err = check_param(param)
%   err = '';
% end
% 
% function net = formatNet(net)
%   if isempty(net.performFcn)
%     warning('nnet:trainrp:Performance',nnwarn_empty_performfcn_corrected);
%     net.performFcn = 'mse';
%   end
% end
% 
% function [calcNet,tr] = train_network(archNet,rawData,calcLib,calcNet,tr)
%   
%   % Parallel Workers
%   isParallel = calcLib.isParallel;
%   isMainWorker = calcLib.isMainWorker;
%   mainWorkerInd = calcLib.mainWorkerInd;
% 
%   % Create broadcast variables
%   stop = []; 
%   WB = [];
%   
%   % Initialize
%   param = archNet.trainParam;
%   if isMainWorker
%       startTime = clock;
%       original_net = calcNet;
%   end
%   
%   [perf,vperf,tperf,gWB,gradient] = calcLib.perfsGrad(calcNet);
%   
%   if isMainWorker
%       [best,val_fail] = nntraining.validation_start(calcNet,perf,vperf);
%       WB = calcLib.getwb(calcNet);
%       dWB = zeros(size(WB));  %%% added
%       deltaWB = param.delta0*ones(size(WB));
%       deltaMAX = param.deltamax*ones(size(WB));
%       deltaMIN = param.deltamin*ones(size(WB));  %%% added
% %       gWB = gWB - 0.01.*WB./(1+WB.^2) * SA;  %%% added 
% %       gWB_old = gWB;
% % gWB_old = zeros(size(gWB)); %%% added
%        T = param.tempInit;
%        minT = param.tempFinal;
% %       
%       
%       % Training Record
%       tr.best_epoch = 0;
%       tr.goal = param.goal;
%       tr.states = {'epoch','time','perf','vperf','tperf','gradient','val_fail'};
% 
%       % Status
%       status = ...
%         [ ...
%         nntraining.status('Epoch','iterations','linear','discrete',0,param.epochs,0), ...
%         nntraining.status('Time','seconds','linear','discrete',0,param.time,0), ...
%         nntraining.status('Performance','','log','continuous',perf,param.goal,perf) ...
%         nntraining.status('Gradient','','log','continuous',gradient,param.min_grad,gradient) ...
%         nntraining.status('Validation Checks','','linear','discrete',0,param.max_fail,0) ...
%         ];
%       nn_train_feedback('start',archNet,status);
%   end
%   
%   %% Train
%   for epoch=0:param.epochs
% 
%     % Stopping Criteria
%     if isMainWorker
%         current_time = etime(clock,startTime);
%         [userStop,userCancel] = nntraintool('check');
%         if userStop, tr.stop = 'User stop.'; calcNet = best.net;
%         elseif userCancel, tr.stop = 'User cancel.'; calcNet = original_net;
%         elseif (perf <= param.goal), tr.stop = 'Performance goal met.'; calcNet = best.net;
%         elseif (epoch == param.epochs), tr.stop = 'Maximum epoch reached.'; calcNet = best.net;
%         elseif (current_time >= param.time), tr.stop = 'Maximum time elapsed.'; calcNet = best.net;
%         elseif (gradient <= param.min_grad), tr.stop = 'Minimum gradient reached.'; calcNet = best.net;
%         elseif (val_fail >= param.max_fail), tr.stop = 'Validation stop.'; calcNet = best.net;
%         end
% 
%         % Training record * feedback
%         tr = nntraining.tr_update(tr,[epoch current_time perf vperf tperf gradient val_fail]);
%         statusValues = [epoch,current_time,best.perf,gradient,val_fail];
%         nn_train_feedback('update',archNet,rawData,calcLib,calcNet,tr,status,statusValues);
%         stop = ~isempty(tr.stop);
%     end
%     
%     % Stop
%     if isParallel, stop = labBroadcast(mainWorkerInd,stop); end
%     if stop, return, end
% 
%     % APPLY RPROP UPDATE
%     if isMainWorker
% %         ggWB = gWB.*gWB_old;
% %         deltaWB = ((ggWB>0)*param.delt_inc + (ggWB<0)*param.delt_dec + (ggWB==0)).*deltaWB;
% %         deltaWB = min(deltaWB,deltaMAX);
% %         dWB = deltaWB.*sign(gWB);
% %         WB = WB + dWB;
% %         gWB_old = gWB;
% %         'CoolSched',@(T) (.8*T),...
% %         'Generator',@(x) (x+(randperm(length(x))==length(x))*randn/100),...
% %         'InitTemp',5,...
% %         'MaxConsRej',1000,...
% %         'MaxSuccess',20,...
% %         'MaxTries',300,...
% %         'StopTemp',1e-8,...
% %         'StopVal',-Inf,...
%         
%         % APPLY RPROP UPDATE
%         SA = 2^-(T * epoch);
%         gWB = gWB - 0.01.*WB./(1+WB.^2) * SA;  %%% added 
%         gWB_old = gWB;
%         ggWB = gWB.*gWB_old;
%         for i = 1:length(ggWB)
%             if ggWB(i) > 0
%                 deltaWB(i) = param.delt_inc * deltaWB(i);
%                 deltaWB(i) = min(deltaWB(i),deltaMAX(i));
%                 dWB(i) = deltaWB(i) * sign(gWB(i));
%                 WB(i) = WB(i) + dWB(i);
%                 gWB_old(i) = gWB(i);
%             elseif ggWB(i) < 0
% %                 if deltaWB(i) < (0.4 * SA^2)
%                 if rand < exp( ggWB(i)/T)
%                     deltaWB(i) = param.delt_dec * deltaWB(i) + rand / 10;
%                 else 
%                     deltaWB(i) = param.delt_dec * deltaWB(i);
%                 end
%                 deltaWB(i) = max(deltaWB(i),deltaMIN(i));
% %             deltaWB(i) = min(deltaWB(i),deltaMAX(i));
%                 dWB(i) = deltaWB(i) * sign(gWB(i));
%                 WB(i) = WB(i) + dWB(i);
%                 gWB_old(i) = 0;
%             elseif ggWB(i) == 0
% %                deltaWB(i) = deltaWB(i);
% %                deltaWB(i) = min(deltaWB(i),deltaMAX(i));
%                 dWB(i) = deltaWB(i) * sign(gWB(i));
%                 WB(i) = WB(i) + dWB(i);
%                 gWB_old(i) = gWB(i);
%             end
%         end
%         
%         %% Stop / decrement T criteria
%         if T > minT
% %            T = cool(T);  % decrease T according to cooling schedule
%             T = 0.8 * T;  % decrease T according to cooling schedule
%         end
%     end
% 
%      
%     calcNet = calcLib.setwb(calcNet,WB);
%     [perf,vperf,tperf,gWB,gradient] = calcLib.perfsGrad(calcNet);
%     
%     % Validation
%     if isMainWorker
%         [best,tr,val_fail] = nntraining.validation(best,tr,val_fail,calcNet,perf,vperf,epoch);
%     end
%   end
% end












% 
% function [out1,out2] = trainrp_custom(varargin)
% %TRAINRP RPROP backpropagation.
% %
% %  <a href="matlab:doc trainrp">trainrp</a> is a network training function that updates weight and bias
% %  values according to the resilient backpropagation algorithm (RPROP).
% %
% %  [NET,TR] = <a href="matlab:doc trainrp">trainrp</a>(NET,X,T) takes a network NET, input data X
% %  and target data T and returns the network after training it, and a
% %  a training record TR.
% %  
% %  [NET,TR] = <a href="matlab:doc trainrp">trainrp</a>(NET,X,T,Xi,Ai,EW) takes additional optional
% %  arguments suitable for training dynamic networks and training with
% %  error weights.  Xi and Ai are the initial input and layer delays states
% %  respectively and EW defines error weights used to indicate
% %  the relative importance of each target value.
% %
% %  Training occurs according to training parameters, with default values.
% %  Any or all of these can be overridden with parameter name/value argument
% %  pairs appended to the input argument list, or by appending a structure
% %  argument with fields having one or more of these names.
% %    show        25  Epochs between displays
% %    showCommandLine 0 generate command line output
% %    showWindow   1 show training GUI
% %    epochs     100  Maximum number of epochs to train
% %    goal         0  Performance goal
% %    time       inf  Maximum time to train in seconds
% %    min_grad  1e-6  Minimum performance gradient
% %    max_fail     5  Maximum validation failures
% %    lr        0.01  Learning rate
% %    delt_inc   1.2  Increment to weight change
% %    delt_dec   0.5  Decrement to weight change
% %    delta0    0.07  Initial weight change
% %    deltamax  50.0  Maximum weight change
% %
% %  To make this the default training function for a network, and view
% %  and/or change parameter settings, use these two properties:
% %
% %    net.<a href="matlab:doc nnproperty.net_trainFcn">trainFcn</a> = 'trainrp';
% %    net.<a href="matlab:doc nnproperty.net_trainParam">trainParam</a>
% %
% %  See also NEWFF, NEWCF, TRAINGDM, TRAINGDA, TRAINGDX, TRAINLM,
% %           TRAINCGP, TRAINCGF, TRAINCGB, TRAINSCG, TRAINOSS,
% %           TRAINBFG.
% 
% % Updated by Orlando De Jes�s, Martin Hagan, Dynamic Training 7-20-05
% % Copyright 1992-2012 The MathWorks, Inc.
% % $Revision: 1.1.6.16 $ $Date: 2012/04/20 19:14:19 $
% 
% %% =======================================================
% %  BOILERPLATE_START
% %  This code is the same for all Training Functions.
% 
%   persistent INFO;
%   if isempty(INFO), INFO = get_info; end
%   nnassert.minargs(nargin,1);
%   in1 = varargin{1};
%   if ischar(in1)
%     switch (in1)
%       case 'info'
%         out1 = INFO;
%       case 'apply'
%         [out1,out2] = train_network(varargin{2:end});
%       case 'formatNet'
%         out1 = formatNet(varargin{2});
%       case 'check_param'
%         param = varargin{2};
%         err = nntest.param(INFO.parameters,param);
%         if isempty(err)
%           err = check_param(param);
%         end
%         if nargout > 0
%           out1 = err;
%         elseif ~isempty(err)
%           nnerr.throw('Type',err);
%         end
%       otherwise,
%         try
%           out1 = eval(['INFO.' in1]);
%         catch me, nnerr.throw(['Unrecognized first argument: ''' in1 ''''])
%         end
%     end
%   else
%     net = varargin{1};
%     oldTrainFcn = net.trainFcn;
%     oldTrainParam = net.trainParam;
%     if ~strcmp(net.trainFcn,mfilename)
%       net.trainFcn = mfilename;
%       net.trainParam = INFO.defaultParam;
%     end
%     [out1,out2] = train(net,varargin{2:end});
%     net.trainFcn = oldTrainFcn;
%     net.trainParam = oldTrainParam;
%   end
% end
% 
% %  BOILERPLATE_END
% %% =======================================================
% 
% function info = get_info()
%   isSupervised = true;
%   usesGradient = true;
%   usesJacobian = false;
%   usesValidation = true;
%   supportsCalcModes = true;
%   info = nnfcnTraining(mfilename,'RProp',8.0,...
%     isSupervised,usesGradient,usesJacobian,usesValidation,supportsCalcModes,...
%     [ ...
%     nnetParamInfo('showWindow','Show Training Window Feedback','nntype.bool_scalar',true,...
%     'Display training window during training.'), ...
%     nnetParamInfo('showCommandLine','Show Command Line Feedback','nntype.bool_scalar',false,...
%     'Generate command line output during training.') ...
%     nnetParamInfo('show','Command Line Frequency','nntype.strict_pos_int_inf_scalar',25,...
%     'Frequency to update command line.'), ...
%     ...
%     nnetParamInfo('epochs','Maximum Epochs','nntype.pos_int_scalar',1000,...
%     'Maximum number of training iterations before training is stopped.') ...
%     nnetParamInfo('time','Maximum Training Time','nntype.pos_inf_scalar',inf,...
%     'Maximum time in seconds before training is stopped.') ...
%     ...
%     nnetParamInfo('goal','Performance Goal','nntype.pos_scalar',0,...
%     'Performance goal.') ...
%     nnetParamInfo('min_grad','Minimum Gradient','nntype.pos_scalar',1e-5,...
%     'Minimum performance gradient before training is stopped.') ...
%     nnetParamInfo('max_fail','Maximum Validation Checks','nntype.strict_pos_int_scalar',6,...
%     'Maximum number of validation checks before training is stopped.') ...
%     ...
%     nnetParamInfo('delta0','Initial Delta','nntype.pos_scalar',0.07,...
%     'Initial delta value.') ...
%     nnetParamInfo('delt_inc','Delta Increase','nntype.over1',1.2,...
%     'Multiplier to increase delta.') ...
%     nnetParamInfo('delt_dec','Delta Decrease','nntype.real_0_to_1',0.5,...
%     'Multiple to decrease delta.') ...
%     nnetParamInfo('deltamax','Maximum Delta','nntype.pos_scalar',50.0,...
%     'Maximum delta value.') ...
%     nnetParamInfo('deltamin','Minimum Delta','nntype.num_scalar',0.0,...
%     'Minimum delta value.') ...
%     nnetParamInfo('temperature','T','nntype.pos_scalar',0.05,...
%     'Temperature parameter for Simulated Annealing.') ...   
%     ], ...
%     [ ...
%     nntraining.state_info('gradient','Gradient','continuous','log') ...
%     nntraining.state_info('val_fail','Validation Checks','discrete','linear') ...
%     ]);
% end
% 
% function err = check_param(param)
%   err = '';
% end
% 
% function net = formatNet(net)
%   if isempty(net.performFcn)
%     warning('nnet:trainrp:Performance',nnwarn_empty_performfcn_corrected);
%     net.performFcn = 'mse';
%   end
% end
% 
% function [calcNet,tr] = train_network(archNet,rawData,calcLib,calcNet,tr)
%   
%   % Parallel Workers
%   isParallel = calcLib.isParallel;
%   isMainWorker = calcLib.isMainWorker;
%   mainWorkerInd = calcLib.mainWorkerInd;
% 
%   % Create broadcast variables
%   stop = []; 
%   WB = [];
%   
%   % Initialize
%   param = archNet.trainParam;
%   if isMainWorker
%       startTime = clock;
%       original_net = calcNet;
%   end
%   
%   [perf,vperf,tperf,gWB,gradient] = calcLib.perfsGrad(calcNet);
%   
%   if isMainWorker
%       [best,val_fail] = nntraining.validation_start(calcNet,perf,vperf);
%       WB = calcLib.getwb(calcNet);
%       dWB = zeros(size(WB));  %%% added
%       deltaWB = param.delta0*ones(size(WB));
%       deltaMAX = param.deltamax*ones(size(WB));
%       deltaMIN = param.deltamin*ones(size(WB));  %%% added
%       gWB_old = gWB;
% % gWB_old = zeros(size(gWB)); %%% added
% %       gWB_old = gWB - 0.01.*WB./(1+WB.^2) * SA;  %%% added 
%       
%       % Training Record
%       tr.best_epoch = 0;
%       tr.goal = param.goal;
%       tr.states = {'epoch','time','perf','vperf','tperf','gradient','val_fail'};
% 
%       % Status
%       status = ...
%         [ ...
%         nntraining.status('Epoch','iterations','linear','discrete',0,param.epochs,0), ...
%         nntraining.status('Time','seconds','linear','discrete',0,param.time,0), ...
%         nntraining.status('Performance','','log','continuous',perf,param.goal,perf) ...
%         nntraining.status('Gradient','','log','continuous',gradient,param.min_grad,gradient) ...
%         nntraining.status('Validation Checks','','linear','discrete',0,param.max_fail,0) ...
%         ];
%       nn_train_feedback('start',archNet,status);
%   end
%   
%   %% Train
%   for epoch=0:param.epochs
% 
%     % Stopping Criteria
%     if isMainWorker
%         current_time = etime(clock,startTime);
%         [userStop,userCancel] = nntraintool('check');
%         if userStop, tr.stop = 'User stop.'; calcNet = best.net;
%         elseif userCancel, tr.stop = 'User cancel.'; calcNet = original_net;
%         elseif (perf <= param.goal), tr.stop = 'Performance goal met.'; calcNet = best.net;
%         elseif (epoch == param.epochs), tr.stop = 'Maximum epoch reached.'; calcNet = best.net;
%         elseif (current_time >= param.time), tr.stop = 'Maximum time elapsed.'; calcNet = best.net;
%         elseif (gradient <= param.min_grad), tr.stop = 'Minimum gradient reached.'; calcNet = best.net;
%         elseif (val_fail >= param.max_fail), tr.stop = 'Validation stop.'; calcNet = best.net;
%         end
% 
%         % Training record * feedback
%         tr = nntraining.tr_update(tr,[epoch current_time perf vperf tperf gradient val_fail]);
%         statusValues = [epoch,current_time,best.perf,gradient,val_fail];
%         nn_train_feedback('update',archNet,rawData,calcLib,calcNet,tr,status,statusValues);
%         stop = ~isempty(tr.stop);
%     end
%     
%     % Stop
%     if isParallel, stop = labBroadcast(mainWorkerInd,stop); end
%     if stop, return, end
% 
%     % APPLY RPROP UPDATE
%     if isMainWorker
% %         ggWB = gWB.*gWB_old;
% %         deltaWB = ((ggWB>0)*param.delt_inc + (ggWB<0)*param.delt_dec + (ggWB==0)).*deltaWB;
% %         deltaWB = min(deltaWB,deltaMAX);
% %         dWB = deltaWB.*sign(gWB);
% %         WB = WB + dWB;
% %         gWB_old = gWB;
% %         SA = 2^-(param.temperature*epoch);
%         
%         ggWB = gWB.*gWB_old;
%         for i = 1:length(ggWB)
%             if ggWB(i) > 0
%                 deltaWB(i) = param.delt_inc * deltaWB(i);
%                 deltaWB(i) = min(deltaWB(i),deltaMAX(i));
%                 dWB(i) = deltaWB(i) * sign(gWB(i));
%                 WB(i) = WB(i) + dWB(i);
%                 gWB_old(i) = gWB(i);
%             elseif ggWB(i) < 0
%                 deltaWB(i) = param.delt_dec * deltaWB(i);
%                 deltaWB(i) = max(deltaWB(i),deltaMIN(i));
% %             deltaWB(i) = min(deltaWB(i),deltaMAX(i));
%                 dWB(i) = deltaWB(i) * sign(gWB(i));
%                 WB(i) = WB(i) + dWB(i);
%                 gWB_old(i) = 0;
%             elseif ggWB(i) == 0
% %                deltaWB(i) = deltaWB(i);
% %                deltaWB(i) = min(deltaWB(i),deltaMAX(i));
%                 dWB(i) = deltaWB(i) * sign(gWB(i));
%                 WB(i) = WB(i) + dWB(i);
%                 gWB_old(i) = gWB(i);
%             end
%         end
% 
%     end
%     
%     calcNet = calcLib.setwb(calcNet,WB);
%     [perf,vperf,tperf,gWB,gradient] = calcLib.perfsGrad(calcNet);
%     
%     % Validation
%     if isMainWorker
%         [best,tr,val_fail] = nntraining.validation(best,tr,val_fail,calcNet,perf,vperf,epoch);
%     end
%   end
% end
% 
% 
% 

