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

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('props', 'var')
  props = struct;
end

trial_num = getTrialNum(a_bundle, trial_num, props);

a_label = properTeXLabel([ get(get(a_bundle, 'db'), 'id') '(t' num2str(trial_num) ')' ]);
