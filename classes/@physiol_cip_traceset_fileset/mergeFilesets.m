function [a_fileset, traceset_offset, neuron_id_offset] = mergeFilesets(a_fileset, w_fileset)

% mergeFilesets - Concatenates two physiol_cip_traceset_fileset objects.
%
% Usage:
% [a_fileset, traceset_offset, neuron_id_offset] = mergeFilesets(a_fileset, w_fileset)
%
% Description:
%   Concatenates the list contents, and combines the neuron_idx
% structures. The properties such as dt, dy and props are retained from
% first object.
%
% Parameters:
%   a_fileset, w_fileset: Two physiol_cip_traceset_fileset objects without
%		overlapping neuron_id items.
%
% Returns:
%   a_fileset: The new object with combined contents.
%
% See also: physiol_cip_traceset_fileset
%
% $Id: mergeFilesets.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/05/18

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% concat lists
list1 = get(a_fileset, 'list');
list2 = get(w_fileset, 'list');

% count tracesets
traceset_offset = length(list1);

% shift neuron ids
a_fileset_neuronids = cell2mat(struct2cell(a_fileset.neuron_idx));
w_fileset_neuronids = cell2mat(struct2cell(w_fileset.neuron_idx));
w_fileset_neuronnames = fieldnames(w_fileset.neuron_idx);

neuron_id_offset = max(a_fileset_neuronids) - min(w_fileset_neuronids) + 1;
w_fileset.neuron_idx = ...
    cell2struct(num2cell(w_fileset_neuronids + neuron_id_offset), w_fileset_neuronnames, 1);

% combine lists from two filesets
a_list = { list1{:},  list2{:} };

% find union of all treatments
[discard_neuron_idx, all_treatments] = scanNeuronsTreats(a_list);

% use the list after resetting missing treatment values to zero
a_fileset = set(a_fileset, 'list', resetDefaultTreats(a_list, all_treatments));

% merge neuron_idx
a_fileset.neuron_idx = mergeStructs(a_fileset.neuron_idx, w_fileset.neuron_idx);

    
