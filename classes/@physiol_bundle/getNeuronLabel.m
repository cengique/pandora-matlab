function a_label = getNeuronLabel(a_bundle, traceset_index, props)

% getNeuronLabel - Constructs the neuron label from dataset.
%
% Usage:
% a_label = getNeuronLabel(a_bundle, traceset_index, props)
%
% Description:
%
%   Parameters:
%	a_bundle: A physiol_cip_traceset_fileset object.
%	traceset_index: The traceset index of neuron.
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_label: A string label identifying selected neuron in bundle.
%
% See also: dataset_db_bundle
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/05

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('props', 'var')
  props = struct;
end

traceset_index = item2TracesetIndex( a_bundle, traceset_index );
traceset_index = traceset_index(1);     % take only one

a_label = properTeXLabel([ get(getItem(get(a_bundle, 'dataset'), traceset_index), 'id') ...
			  '(s' num2str(traceset_index) ')']);
