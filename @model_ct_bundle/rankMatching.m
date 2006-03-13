function a_ranked_db = rankMatching(a_mbundle, a_crit_db, props)

% rankMatching - Create a model_ranked_to_physiol_bundle from given criterion db.
%
% Usage:
% a_ranked_db = rankMatching(a_mbundle, a_crit_db, props)
%
% Description:
%
% Parameters:
%	a_mbundle: A model_ct_bundle object.
%	a_crit_db: A crit_db created by a matchingRow method.
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

a_ranked_db = rankMatching(get(a_mbundle, 'joined_db'), a_crit_db, props);
