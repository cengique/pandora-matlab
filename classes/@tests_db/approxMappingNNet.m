function [an_approx_db, a_nnet] = approxMappingNNet(a_db, input_cols, output_cols, props)

% approxMappingNNet - Approximates the desired input-output mapping using a Matlab neural network.
%
% Usage:
% [an_approx_db, a_nnet] = approxMappingNNet(a_db, input_cols, output_cols, props)
%
% Description:
%   Approximates the mapping between the given inputs to outputs
% using the Matlab Neural Network Toolbox. By default it creates a
% feedf-forward network to be trained with a Levenberg-Marquardt training
% algorithm (see newff). Returns and the trained network object and a
% database with output columns obtained from the approximator. The outputs
% can then be compared to the original database to test the success of the
% approximation.
%
%   Parameters:
%	a_db: A tests_db object.
%	input_cols, output_cols: Input and output columns to be mapped
%		(see tests2cols for accept column specifications).
%	props: A structure with any optional properties.
%	  nnetFcn: Neural network classifier function (default='newff')
%	  nnetParams: Cell array of parameters passed to nnetFcn after
%	  	      inputs and outputs.
%	  plotIt: If 1, plot training and classification results.
%	  (Rest passed to tests_db)
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
a_nnet_ouputs = ...
    get(onlyRowsTests(a_db, ':', output_cols), 'data')';

% create NNet object
a_nnet = feval(props.nnetFcn, a_nnet_inputs, ...
                a_nnet_ouputs, props.nnetParams{:});

% set display params
if ~ isfield(props, 'plotIt') || props.plotIt == 0
  a_nnet.trainParam.show = NaN;
end

% train it
a_nnet = train(a_nnet, a_nnet_inputs, a_nnet_ouputs);

% return simulated approximator output in new db
col_names = getColNames(a_db);
an_approx_db = ...
    tests_db([get(onlyRowsTests(a_db, ':', input_cols), 'data'), ...
              sim(a_nnet, a_nnet_inputs)'], ...
             [ col_names(tests2cols(a_db, input_cols)), ...
               col_names(tests2cols(a_db, output_cols)) ], {}, ...
             [ 'NNet approximated ' get(a_db, 'id') ]);
