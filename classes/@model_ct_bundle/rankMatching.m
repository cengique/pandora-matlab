function a_ranked_db = rankMatching(a_mbundle, a_crit_db, props)

% rankMatching - Create a ranked_db from given criterion db.
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
%	a_ranked_db: a ranked_db object containing the rankings.
%
% Example: (see example in physiol_bundle/matchingRow)
%
% See also: tests_db/rankMatching, ranked_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/18

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('props', 'var')
  props = struct;
end

a_ranked_db = rankMatching(get(a_mbundle, 'joined_db'), a_crit_db, props);
