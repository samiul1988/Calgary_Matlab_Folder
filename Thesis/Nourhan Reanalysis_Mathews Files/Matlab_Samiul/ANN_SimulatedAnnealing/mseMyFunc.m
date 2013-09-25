function perf = mseMyFunc(net,varargin)
%MSE Mean squared error performance function.
%
% <a href="matlab:doc mse">mse</a>(net,targets,outputs,errorWeights,...parameters...) calculates a
% network performance given targets, outputs, error weights and parameters
% as the mean of squared errors.
%
% Only the first three arguments are required.  The default error weight
% is {1}, which weights the importance of all targets equally.
%
% Parameters are supplied as parameter name and value pairs:
%
% 'regularization' - a fraction between 0 (the default) and 1 indicating
%    the proportion of performance attributed to weight/bias values. The
%    larger this value the network will be penalized for large weights,
%    and the more likely the network function will avoid overfitting.
%
% 'normalization' - this can be 'none' (the default), or 'standard', which
%   results in outputs and targets being normalized to [-1, +1], and
%   therefore errors in the range [-2, +2), or 'percent' which normalizes
%   outputs and targets to [-0.5, 0.5] and errors to [-1, 1].
%
% Here a network's performance with 0.1 regularization is calculated.
%
%   perf = <a href="matlab:doc mse">mse</a>(net,targets,outputs,{1},'regularization',0.1)
%
% To setup a network to us the same performance measure during training:
%
%   net.<a href="matlab:doc nnproperty.net_performFcn">performFcn</a> = '<a href="matlab:doc mse">mse</a>';
%   net.<a href="matlab:doc nnproperty.net_performParam">performParam</a>.<a href="matlab:doc nnparam.regularization">regularization</a> = 0.1;
%   net.<a href="matlab:doc nnproperty.net_performParam">performParam</a>.<a href="matlab:doc nnparam.normalization">normalization</a> = 'none';
%
% See also MAE, SSE, SAE.

% Copyright 1992-2012 The MathWorks, Inc.
% $Revision: 1.1.6.14.2.1 $

% Function Info
persistent INFO;
if isempty(INFO), INFO = nnModuleInfo(mfilename); end
if nargin == 0, perf = INFO; return; end

% NNET Backward Compatibility
% WARNING - This functionality may be removed in future versions
if ischar(net) || ~(isa(net,'network') || isstruct(net))
  perf = nnet7.performance_fcn(mfilename,net,varargin{:}); return
end

% Arguments
param = nn_modular_fcn.parameter_defaults(mfilename);
[args,param,nargs] = nnparam.extract_param(varargin,param);
if (nargs < 2), error(message('nnet:Args:NotEnough')); end
t = args{1};
y = args{2};
if nargs < 3, ew = {1}; else ew = varargin{3}; end
net.performParam = param;
net.performFcn = mfilename;

% Apply
perf = nncalc.perform(net,t,y,ew,param);
% perf = modified_perform(net,t,y,ew,param); %%% modified from nncalc.perform

% function perf = modified_perform(net,t,y,ew,param)
% % function perf = perform(net,t,y,ew,param)
% 
% if ~iscell(t), t={t}; end
% if ~iscell(y), y={y}; end
% if ~iscell(ew), ew={ew}; end
% 
% % Performance Function
% info = feval(net.performFcn,'info');
% if nargin < 5
%   param = net.performParam;
% end
% 
% % Error
% e = gsubtract(t,y);
% 
% % Normalized Error
% switch param.normalization
%   case 'none', % no change required
%   case 'standard', e = nnperf.norm_err(net,e);
%   case 'percent', e = nnperf.perc_err(net,e);
% end
% 
% % Standard Performance:  mean(e.^2) + 
% perfs = cell(size(e));
% for i=1:numel(perfs)
%   perfs{i} = info.apply(t{i},y{i},e{i},param);
% end
% perfs = gmultiply(perfs,ew);
% perf = 0;
% perfN = 0;
% for i=1:numel(perfs)
%   perfi = perfs{i};
%   nanInd = find(isnan(perfi));
%   perfi(nanInd) = 0;
%   perf = perf + sum(perfi(:));
%   perfN = perfN + numel(perfi) - numel(nanInd);
% end
% if info.normalize
%   perf = perf / perfN;
% end
% 
% % Penalty Term
% % input_weight = net.IW{2,1};
% % input_weight = reshape(input_weight,1,numel(input_weight));
% % 
% % perf_penalty = info.apply(zeros(size(input_weight)),input_weight,-input_weight,param);
% % perf_penalty = ((param.eta1 * param.beta * perf_penalty)./ (1 + param.beta * perf_penalty)) + param.eta2 * perf_penalty; 
% % 
% % perf = perf + perf_penalty;
% % perf = perf * param.ratio + perf_penalty * (1-param.ratio);
% % Regularization
% reg = param.regularization;
% if (reg ~= 0)
%   wb = getwb(net);
%   perfwb = info.apply(zeros(size(wb)),wb,-wb,param);
%   if info.normalize, perfwb = perfwb / numel(wb); end
%   perf = perf * (reg-1) + perfwb * reg;
% end
