function obj = vertcat(obj, obj2)
% vertcat - Concatenates multiple physiol_cip_traceset_fileset objects.
%
% Usage:
% obj = vertcat(obj, obj2)
%
% Description:
%   Concatenates the list contents, and combines the neuron_idx
% structures. The properties such as dt, dy and props are retained from
% first object.
%
% Parameters:
%   obj, obj2: Two physiol_cip_traceset_fileset objects without
%		overlapping neuron_id items.
%
% Returns:
%   obj: The new object with combined contents.
%
% See also: physiol_cip_traceset_fileset
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/01/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% concat lists
list1 = get(obj, 'list');
list2 = get(obj2, 'list');
obj = set(obj, 'list', { list1{:},  list2{:} });

% merge neuron_idx
obj.neuron_idx = mergeStructs(obj.neuron_idx, obj2.neuron_idx);
