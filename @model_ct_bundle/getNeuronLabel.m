function a_label = getNeuronLabel(a_bundle, trial_num, props)

% getNeuronLabel - Constructs the neuron label from bundle.
%
% Usage:
% a_label = getNeuronLabel(a_bundle, trial_num, props)
%
% Description:
%
%   Parameters:
%	a_bundle: A physiol_cip_traceset_fileset object.
%	trial_num: The trial number of model neuron.
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_label: A string label identifying selected neuron in bundle.
%
% See also: dataset_db_bundle
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/26

if ~exist('props')
  props = struct;
end

trial_num = getTrialNum(a_bundle, trial_num, props);

a_label = properTeXLabel([ get(get(a_bundle, 'db'), 'id') '(t' num2str(trial_num) ')' ]);
