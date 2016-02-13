function a_db = flattenPages(a_db)

% flattenPages - Convert from 3D to 2D by simply flattening pages.
%
% Usage:
% a_db = flattenPages(a_db)
%
% Parameters:
%   a_db: A tests_3D_db object.
%		
% Returns:
%   a_db: A tests_db object.
%
% Description:
%   Allows to get the original database after doing invarValues or
% invarParams and then using joinRows.
%
% See also: tests_db/invarValues, params_tests_db/invarParams, tests_db/joinRows
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2014/05/07

% Copyright (c) 2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_db = get(set(a_db, 'data', ...
                 permute(reshape(permute(get(a_db, 'data'), [2 1 3]), ...
                                 dbsize(a_db, 2), ...
                                 dbsize(a_db, 1) * dbsize(a_db, 3)), ...
                         [2 1 3])), 'tests_db');
