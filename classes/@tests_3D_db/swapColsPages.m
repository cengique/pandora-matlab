function a_3D_db = swapColsPages(a_3D_db)

% swapColsPages - Swaps the column dimension with the page dimension of the
%		  tests_3D_db.
%
% Usage:
% a_3D_db = swapColsPages(db)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%		
%   Returns:
%	a_3D_db: A tests_3D_db object.
%
% See also: tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2017/06/09

% Copyright (c) 2017 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% save from being erased
saved_col_idx = get(a_3D_db, 'col_idx');

% Call the super
a_3D_db.tests_db = swapColsPages(a_3D_db.tests_db);

% maintain metadata
a_3D_db = set(a_3D_db, 'col_idx', get(a_3D_db, 'page_idx'));
a_3D_db = set(a_3D_db, 'page_idx', saved_col_idx);

