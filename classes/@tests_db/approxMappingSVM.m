function [an_approx_db, an_svm] = approxMappingSVM(a_db, input_cols, output_cols, props)

% approxMappingSVM - Approximates the desired input-output mapping using a support vector machine (SVM).
%
% Usage:
% [an_approx_db, an_svm] = approxMappingSVM(a_db, input_cols, output_cols, props)
%
% Description:
%   Uses the SVM-KM package
% (http://asi.insa-rouen.fr/enseignants/~arakotom/toolbox/index.html). If
% 'warning on verbose' is issued prior to running, it provides additional
% debug info.
%
%   Parameters:
%	a_db: A tests_db object.
%	input_cols, output_cols: Input and output columns to be mapped
%		(see tests2cols for accept column specifications).
%	props: A structure with any optional properties.
%	  classProbs: 'prob': use probabilistic sampling to normalize
%	  		prior class probabilities.
%	  kernel: Kernel type (default='poly').
%	  (Rest passed to balanceInputProbs and tests_db)
%		
%   Returns:
%	an_approx_db: A tests_db object containing the original inputs and
%			the approximated outputs.
%	an_svm: The Matlab neural network approximator object.
%
% Example:
% >> [a_class_db, an_svm = approxMappingSVM(my_db, {'NaF', 'Kv3'}, {'spike_width'});
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

orig_inputs = an_svm_inputs;
% balance inputs, if requested
if isfield(props, 'classProbs') && strcmp(props.classProbs, 'prob')
  [an_svm_inputs, an_svm_outputs] = ...
      balanceInputProbs(an_svm_inputs, an_svm_outputs, 1, props);
end

% normalize inputs
[an_svm_inputs, PSi] = mapminmax(an_svm_inputs, -1, 1);
[an_svm_outputs, PSo] = mapminmax(an_svm_outputs, -1, 1);

% train it
if ~ isfield(props, 'kernel') || strcmp(props.kernel, 'poly')
  % polynomial kernel
  lambda = 1e-7;  
  C = 10;
  kernel='gauss';
  kerneloption=2;
  verbose=1;
  qpsize=100;
  span = ones(size(an_svm_outputs, 2));
  an_svm = struct;
  [xsup,w,w0,tps,alpha] = ...
      svmclassLS(an_svm_inputs', an_svm_outputs', C, lambda, kernel, ...
                 kerneloption,verbose,span,qpsize);
  an_svm.xsup = xsup;
  an_svm.w = w;
  an_svm.w0 = w0;
  an_svm.tps = tps;
  an_svm.alpha = alpha;
  an_svm.kernel = kernel;
  an_svm.kerneloption = kerneloption;
else
  % gaussian kernel
  error('not implemented');
end

% return simulated approximator output in new db
col_names = getColNames(a_db);
an_approx_db = ...
    tests_db([get(onlyRowsTests(a_db, ':', input_cols), 'data'), ...
              svmval(orig_inputs',an_svm.xsup,an_svm.w,an_svm.w0,an_svm.kernel,an_svm.kerneloption, ...
                  ones(length(orig_inputs),1))], ...
             [ col_names(tests2cols(a_db, input_cols)), ...
               col_names(tests2cols(a_db, output_cols)) ], {}, ...
             [ 'SVM approximated ' get(a_db, 'id') ]);
end

