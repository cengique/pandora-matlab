function a_ranked_bundle = rankMatching(a_mbundle, a_crit_bundle, props)

% rankMatching - Create a model_ranked_to_physiol_bundle from given criterion db.
%
% Usage:
% a_ranked_bundle = rankMatching(a_mbundle, a_crit_bundle, props)
%
% Description:
%
% Parameters:
%	a_mbundle: A model_ct_bundle object.
%	a_crit_bundle: A physiol_bundle having a crit_db as its joined_db.
%	props: A structure with any optional properties.
%	  (passed to tests_db/rankMatching)
%		
% Returns:
%	a_ranked_bundle: a model_ranked_to_physiol_bundle object containing the rankings.
%
% Example: (see example in physiol_bundle/matchingRow)
%
% See also: tests_db/rankMatching, model_ranked_to_physiol_bundle
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
