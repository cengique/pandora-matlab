function obj = onlyRowsTests(obj, varargin)

% onlyRowsTests - Returns a tests_db that only contains the desired 
%		tests and rows (and pages).
%
% Usage:
% obj = onlyRowsTests(obj, rows, tests, pages)
%
% Description:
% Selects the given dimensions and returns in a new tests_db object.
%
%   Parameters:
%	obj: A tests_db object.
%	rows: A logical or index vector of rows. If ':', all rows.
%	tests: Cell array of test names or column indices. If ':', all tests.
%	pages: (Optional) A logical or index vector of pages. ':' for all pages.
%		
%   Returns:
%	obj: The new tests_db object.
%
% See also: subsref, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# DOESN'T WORK when called from subsref???
%#'zaaaart'

%# Retain object identity
obj.tests_3D_db = onlyRowsTests(obj.tests_3D_db, varargin{:});
