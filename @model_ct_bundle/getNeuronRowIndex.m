function a_row_index = getNeuronRowIndex(a_bundle, trial_num, props)

% getNeuronRowIndex - Returns the neuron index from bundle.
%
% Usage:
% a_row_index = getNeuronRowIndex(a_bundle, trial_num, props)
%
% Description:
%
%   Parameters:
%	a_bundle: A physiol_cip_traceset_fileset object.
%	trial_num: The trial number of model neuron.
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_row_index: A row index of neuron in a_bundle.joined_db.
%
% See also: dataset_db_bundle
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/09

if ~exist('props')
  props = struct;
end

if isa(trial_num, 'tests_db')
  trial_num = get(onlyRowsTests(trial_num, 1, 'trial'), 'data');
end

joined_db = get(a_bundle, 'joined_db');

a_row_index = find(joined_db(:, 'trial') == trial_num);
