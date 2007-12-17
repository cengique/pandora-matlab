function a_db = sum(a_db, props)

% sum - Creates a tests_db by summing all rows.
%
% Usage:
% a_db = sum(a_db, props)
%
% Description:
%   Applies the sum function to whole DB. The resulting DB will have one row.
%
%   Parameters:
%	a_db: A tests_db object.
%	props: Optional properties.
%		
%   Returns:
%	a_db: The resulting tests_db.
%
% See also: sum
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/24

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

%# TODO: doesn't conform to the mean, std methods here. Make them work like this, too.

if ~ exist('props')
  props = struct([]);
end

a_db = set(a_db, 'id', [ 'summed ' get(a_db, 'id') ]);
a_db = set(a_db, 'row_idx', makeIdx({'sum'}));
a_db = set(a_db, 'data', sum(get(a_db, 'data')));
