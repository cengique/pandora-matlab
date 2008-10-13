function a_db = swapRowsPages(db)

% swapRowsPages - Swaps the row dimension with the page dimension of the tests_db.
%
% Usage:
% a_db = swapRowsPages(db)
%
% Parameters:
%	db: A tests_db object.
%		
% Returns:
%	a_db: A tests_db object.
%
% Description:
%   Watered-down version of the tests_3D_db/swapRowsPages function that
% does not touch row indices. 
%
% See also: tests_db
%
% $Id: swapRowsPages.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Reorder the row and page dimensions
a_db = set(db, 'data', permute(get(db, 'data'), [3, 2, 1]));

