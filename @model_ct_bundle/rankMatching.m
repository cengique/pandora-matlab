function a_ranked_bundle = rankMatching(a_mbundle, a_crit_bundle, props)

% rankMatching - Create a model_ranked_to_physiol_bundle from given criterion db.
%
% Usage:
% a_cip_trace = rankMatching(a_mbundle, a_crit_bundle, props)
%
% Description:
%
%   Parameters:
%	a_mbundle: A physiol_cip_traceset_fileset object.
%	a_db: A DB created by this fileset to read the trial numbers from.
%	trials: A column vector with trial numbers.
%	cip_levels: A column vector of CIP-levels to be loaded.
%	props: A structure with any optional properties.
%	  (passed to tests_db/rankMatching)
%		
%   Returns:
%	a_cip_trace: One or more cip_trace objects that hold the raw data.
%
% See also: loadItemProfile, physiol_cip_traceset/cip_trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/18

if ~exist('props')
  props = struct;
end

a_ranked_bundle = ...
    model_ranked_to_physiol_bundle(get(a_mbundle, 'dataset'), get(a_mbundle, 'db'), ...
				   rankMatching(get(a_mbundle, 'joined_db'), ...
						get(a_crit_bundle, 'joined_db'), props), ...
				   a_crit_bundle);
