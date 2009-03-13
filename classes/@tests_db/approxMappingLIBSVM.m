function [an_approx_db, an_svm] = approxMappingLIBSVM(a_db, input_cols, output_cols, props)

% approxMappingLIBSVM - Approximates the desired input-output mapping using a support vector machine (SVM).
%
% Usage:
% [an_approx_db, an_svm] = approxMappingLIBSVM(a_db, input_cols, output_cols, props)
%
% Description:
%   Uses the LIBSVM package (http://www.csie.ntu.edu.tw/~cjlin/libsvm/). If
% 'warning on verbose' is issued prior to running, it provides additional
% debug info.
%
% Parameters:
%   a_db: A tests_db object.
%   input_cols, output_cols: Input and output columns to be mapped
% 	(see tests2cols for accept column specifications).
%   props: A structure with any optional properties.
%     classProbs: 'prob': use probabilistic sampling to normalize
%	  prior class probabilities.
%     kernel: Kernel type (default='poly').
%     crossFold: n to use in libsvm's n-fold cross-validation (default=0;
%     		disabled).
%     testControl: Ratio of dataset to train the data and rest to test for success
%		(default=0; disabled).
%     svmCost: Add the -c option to svmOpts with this value.
%     svmGamma: Add the -g option to svmOpts with this value.
%     svmOpts: Passed to LIBSVM overwriting default options (see output
%     		of svm-train for options; default='-s0 -t2 -d2').
%     (Rest passed to balanceInputProbs and tests_db)
%		
%   Returns:
%	an_approx_db: A tests_db object containing the original inputs and
%			the approximated outputs.
%	an_svm: The Matlab neural network approximator object.
%
% Example:
% >> [a_class_db, an_svm = approxMappingLIBSVM(my_db, {'NaF', 'Kv3'}, {'spike_width'});
% >> plotFigure(plot_superpose({plotScatter(my_db, 'NaF', 'spike_width'),
% 			        plotScatter(a_class_db, 'NaF', 'spike_width')}))
%
% See also: tests_db, newff
%
% $Id: approxMappingLIBSVM.m 1106 2008-10-13 23:20:59Z cengiz $
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

% read inputs and outputs from db
an_svm_inputs = ...
    get(onlyRowsTests(a_db, ':', input_cols), 'data')';
an_svm_outputs = ...
    get(onlyRowsTests(a_db, ':', output_cols), 'data')';

% create SVM object
%an_svm = feval(props.nnetFcn, an_svm_inputs, ...
%                an_svm_outputs, props.nnetParams{:});

% set display params
%if verbose
  % ?
%end

% normalize inputs
[an_svm_inputs, PSi] = mapminmax(an_svm_inputs, -1, 1);
[an_svm_outputs, PSo] = mapminmax(an_svm_outputs, -1, 1);

orig_inputs = an_svm_inputs;
orig_outputs = an_svm_outputs;

% first, divide into training and validation sets 
num_samples = size(an_svm_inputs, 2);
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
  an_svm_inputs = an_svm_inputs(:, train_logic);
  an_svm_outputs = an_svm_outputs(:, train_logic);
  % rest is for control
  orig_inputs = orig_inputs(:, ~train_logic);
  orig_outputs = orig_outputs(:, ~train_logic);
end

% balance inputs, if requested
if isfield(props, 'classProbs') && strcmp(props.classProbs, 'prob')
  [an_svm_inputs, an_svm_outputs] = ...
      balanceInputProbs(an_svm_inputs, an_svm_outputs, 1, props);
  if verbose, disp(['After balancing, got ' ...
                    num2str(size(an_svm_inputs, 2)) ' samples.']); end
end

% set options
if ~ isfield(props, 'svmOpts')
  props.svmOpts = '-s 0 -t 2 -d 2 -m 500';
end

if isfield(props, 'svmCost')
  props.svmOpts = [ props.svmOpts ' -c ' num2str(props.svmCost) ] ;
end

if isfield(props, 'svmGamma')
  props.svmOpts = [ props.svmOpts ' -g ' num2str(props.svmGamma) ] ;
end

if verbose, disp([ 'LIBSVM options: "' props.svmOpts '"']), end

% train  

% do regular training to get a sample SVM model and prediction
an_svm = struct;
an_svm.model = svmtrain(an_svm_outputs', an_svm_inputs', props.svmOpts);

% calculate predictions
[predicted_label, accuracy, prob_estimates] = ...
    svmpredict(orig_outputs', orig_inputs', an_svm.model); %, '-b 1'
% accuracy contains: accuracy, mean squared error, squared correlation coefficient.
an_svm.accuracy = accuracy(1);
an_svm.mse = accuracy(2);
an_svm.scc = accuracy(3);
an_svm.prob_estimates = prob_estimates;

% if requested, do cross validation afterwards to get accuracy
if isfield(props, 'crossFold') && props.crossFold > 0
  props.svmOpts = [ props.svmOpts ' -v ' num2str(props.crossFold) ];
  an_svm.cross_accuracy = ...
      svmtrain(an_svm_outputs', an_svm_inputs', props.svmOpts);
  
  % predictions cannot be calculated since validation mode does not
  % return the SVM model
end

% return simulated approximator output in new db

% add the predicted labels in a NaN pre-filled column
new_data = [get(onlyRowsTests(a_db, ':', input_cols), 'data'), ...
           repmat(NaN, dbsize(a_db, 1), 1)];
new_data(~train_logic, end) = predicted_label;

col_names = getColNames(a_db);
an_approx_db = ...
    tests_db(new_data, ...
             [ col_names(tests2cols(a_db, input_cols)), ...
               col_names(tests2cols(a_db, output_cols)) ], {}, ...
             [ 'SVM approximated ' get(a_db, 'id') ], ...
             struct('classifier', an_svm));
end

