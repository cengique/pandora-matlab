function a_db = diff(a_db, props)

% diff - Creates a tests_db by taking the derivative of all tests.
%
% Usage:
% a_db = diff(a_db, props)
%
% Description:
%   Applies the diff function to whole DB. The resulting DB will have one less row.
%
%   Parameters:
%	a_db: A tests_db object.
%	props: Optional properties.
%		
%   Returns:
%	a_db: The resulting tests_db.
%
% See also: diff, tests_3D_db/getDiff2DDB
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/24

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct([]);
end

if dbsize(a_db, 1) <= 1
  error('More than one row is required to take diffs!');
end

a_db = set(a_db, 'id', [ 'diffed ' get(a_db, 'id') ]);
a_db = set(a_db, 'data', diff(get(a_db, 'data')));
