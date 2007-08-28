function [a_pbundle test_names] = constrainedMeasuresPreset(a_pbundle, preset, props)

% constrainedMeasuresPreset - Returns a physiol_bundle with constrained measures according to chosen preset.
%
% Usage:
% [a_pbundle test_names] = constrainedMeasuresPreset(a_pbundle, preset, props)
%
% Description:
%
%   Parameters:
%	a_pbundle: A physiol_cip_traceset_fileset object.
%	preset: Choose preset measure list (default=1).
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_pbundle: One or more cip_trace object that holds the raw data.
%
% See also: loadItemProfile, physiol_cip_traceset/cip_trace
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/19

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('props')
  props = struct;
end

if ~exist('preset')
  preset = 1;
end

[a_pbundle.dataset_db_bundle, test_names] = ...
    constrainedMeasuresPreset(a_pbundle.dataset_db_bundle, preset, props);

%# Fix the control DB, too
jc_db = get(a_pbundle, 'joined_control_db');
jc_db = set(jc_db, 'id', [ get(jc_db, 'id') '; preset' num2str(preset) ]);

j_props = get(get(a_pbundle, 'joined_db'), 'props');
if ~ isfield(j_props, 'testWeights')
  jc_db = setProp(jc_db, 'testWeights', j_props.testWeights);
end

a_pbundle = set(a_pbundle, 'joined_control_db', jc_db(:, test_names));

