function [an_approx_db, a_nnet] = approxMappingNNet(a_db, input_cols, output_cols, props)

% approxMappingNNet - Approximates the desired input-output mapping using a Matlab neural network.
%
% Usage:
% [an_approx_db, a_nnet] = approxMappingNNet(a_db, input_cols, output_cols, props)
%
% Description:
%   Approximates the mapping between the given inputs to outputs
% using the Matlab Neural Network Toolbox. By default it creates a
% feed-forward network to be trained with a Levenberg-Marquardt training
% algorithm (see newff). Returns and the trained network object and a
% database with output columns obtained from the approximator. The outputs
% can then be compared to the original database to test the success of the
% approximation. If 'warning on verbose' is issued prior to running, it
% provides additional debug info.
%
% Parameters:
%   a_db: A tests_db object.
%   input_cols, output_cols: Input and output columns to be mapped
%		(see tests2cols for accept column specifications).
%   props: A structure with any optional properties.
%     nnetFcn: Neural network classifier function (default='newff')
%     nnetParams: Cell array of parameters passed to nnetFcn after
%	  	      inputs and outputs.
%     trainMode: 'batch' or 'incr'.
%     testControl: Ratio of dataset to train the data and rest to test for success
%		(default=0; disabled).
%     classProbs: 'prob': use probabilistic sampling to normalize
%	  		prior class probabilities.
%     maxEpochs: maximum number of epochs to train for.
%     (Rest passed to balanceInputProbs and tests_db)
%		
%   Returns:
%	an_approx_db: A tests_db object containing the original inputs and
%			the approximated outputs.
%	a_nnet: The Matlab neural network approximator object.
%
% Example:
% >> [a_class_db, a_nnet = approxMappingNNet(my_db, {'NaF', 'Kv3'}, {'spike_width'});
% >> plotFigure(plot_superpose({plotScatter(my_db, 'NaF', 'spike_width'),
% 			        plotScatter(a_class_db, 'NaF', 'spike_width')}))
%
% See also: tests_db, newff
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/12/12

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if ~exist('props', 'var')
  props = struct;
end

if ~ isfield(props, 'nnetFcn')
  props.nnetFcn = 'newff';
end

if ~ isfield(props, 'nnetParams')
  props.nnetParams = {};
end

% read inputs and outputs from db
a_nnet_inputs = ...
    get(onlyRowsTests(a_db, ':', input_cols), 'data')';
a_nnet_outputs = ...
    get(onlyRowsTests(a_db, ':', output_cols), 'data')';

% create NNet object
a_nnet = feval(props.nnetFcn, a_nnet_inputs, ...
                a_nnet_outputs, props.nnetParams{:});

% set display params
if ~ verbose
  a_nnet.trainParam.show = NaN;
end

orig_inputs = a_nnet_inputs;
orig_outputs = a_nnet_outputs;

% first, divide into training and validation sets 
num_samples = size(a_nnet_inputs, 2);
train_logic = false(num_samples, 1);
if isfield(props, 'testControl') && props.testControl ~= 0
  num_train = floor(props.testControl * num_samples);
  num_test = num_samples - num_train;
  if verbose
    disp(['Train/test with ' num2str(num_train) '/' num2str(num_test) ...
          ' samples.']);
  end
  % choose training samples randomly
  a_perm = randperm(num_samples)';
  train_logic(a_perm(1:num_train), :) = true;
  a_nnet_inputs = a_nnet_inputs(:, train_logic);
  a_nnet_outputs = a_nnet_outputs(:, train_logic);
  % rest is for control
  orig_inputs = orig_inputs(:, ~train_logic);
  orig_outputs = orig_outputs(:, ~train_logic);
end

% balance inputs, if requested
if isfield(props, 'classProbs') && strcmp(props.classProbs, 'prob')
  [a_nnet_inputs, a_nnet_outputs] = ...
      balanceInputProbs(a_nnet_inputs, a_nnet_outputs, 1, props);
end

% train it
if ~ isfield(props, 'trainMode') || strcmp(props.trainMode, 'batch')
  % batch training
  a_nnet = train(a_nnet, a_nnet_inputs, a_nnet_outputs);
else
  % incremental training
  if isfield(props, 'maxEpochs')
    num_passes = props.maxEpochs;
  else
    num_passes = 10;
  end
  goal_mse = 1e-3;
  cell_ins = num2cell(a_nnet_inputs, 1);
  cell_outs = num2cell(a_nnet_outputs); 
  last_conditions = [];
  for pass_num = 1:num_passes
    [a_nnet, nn_outs, nn_errs, last_conditions] = ...
        adapt(a_nnet, cell_ins, cell_outs, last_conditions);
    nn_mse = mse(nn_errs);
    if verbose, nn_mse, end
    if nn_mse < goal_mse
      if verbose, disp([ 'mse goal ' num2str(goal_mse) ' met.']); end
      break;
    end
  end
end

% add the predicted labels in a NaN pre-filled column
new_data = [get(onlyRowsTests(a_db, ':', input_cols), 'data'), ...
           repmat(NaN, dbsize(a_db, 1), 1)];
new_data(~train_logic, end) = sim(a_nnet, orig_inputs)';

% return simulated approximator output in new db
col_names = getColNames(a_db);
an_approx_db = ...
    tests_db(new_data, ...
             [ col_names(tests2cols(a_db, input_cols)), ...
               col_names(tests2cols(a_db, output_cols)) ], {}, ...
             [ 'NNet approximated ' get(a_db, 'id') ]);
end

