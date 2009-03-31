function a_row_index = getNeuronRowIndex(a_bundle, trial_num, props)

% getNeuronRowIndex - Returns the neuron index from bundle.
%
% Usage:
% a_row_index = getNeuronRowIndex(a_bundle, trial_num, props)
%
% Description:
%
%   Parameters:
%	a_bundle: A model_ct_bundle object.
%	trial_num: The trial number of model neuron, or a DB row containing this.
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_row_index: A row index of neuron in a_bundle.joined_db.
%
% See also: dataset_db_bundle
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/09

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('props', 'var')
  props = struct;
end

if isa(trial_num, 'tests_db')
  trial_num = getTrialNum(a_bundle, trial_num, props);
end

joined_db = get(a_bundle, 'joined_db');

dataset_props = get(get(a_bundle, 'dataset'), 'props');
if isfield(dataset_props, 'param_trial_name')
  trial_name = dataset_props.param_trial_name;
else 
  trial_name = 'trial';
end
if ~isempty(trial_name)
  a_row_index = find(joined_db(:, trial_name) == trial_num);
else
  a_row_index = trial_num;
end
