function a_3D_db = swapRowsPages(db)

% swapRowsPages - Swaps the row dimension with the page dimension of the
%		  tests_3D_db.
%
% Usage:
% a_3D_db = swapRowsPages(db)
%
% Description:
% Assuming that this is a invariant parameter and tests relations db, 
% this function swaps the pages with rows. Each resulting page correspond
% to a single value of the chosen parameter, with each row contianing a 
% test result with different combinations of the rest of the parameters.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# Reorder the row and page dimensions
a_3D_db = set(db, 'data', permute(get(db, 'data'), [3, 2, 1]));
a_3D_db = set(a_3D_db, 'row_idx', get(db, 'page_idx'));
a_3D_db = set(a_3D_db, 'page_idx', get(db, 'row_idx'));

