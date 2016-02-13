function name_strs = neuronNameFromId(fileset, neuron_ids)

% neuronNameFromId - Returns string neuron names from a list of neuron ids.
%
% Usage:
% name_strs = neuronNameFromId(fileset, neuron_ids)
%
% Description:
%
%   Parameters:
%	fileset: A physiol_cip_traceset_fileset object.
%	neuron_ids: One or more neuron ids in a vector.
%		
%   Returns:
%	name_strs: Cell array of neuron names corresponding to the ids given.
%
% See also: physiol_cip_traceset_fileset
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/11/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

neuron_ids_all = cell2mat(struct2cell(fileset.neuron_idx));
neuron_names = fieldnames(fileset.neuron_idx);

% sort the ids
[sorted_ids, sort_indices] = sortrows(neuron_ids_all);

% assertion
diffed_ids = diff(sorted_ids);
if sum(diffed_ids) ~= (size(sorted_ids) - 1)
  disp('offending neuron_ids:')
  sorted_ids(diffed_ids ~= 1)
  error('Neuron ids contain gaps or duplicates!');
end

% return names (assuming neuron_ids_all are strictly icnreasing)
name_strs = neuron_names(sort_indices(neuron_ids));
