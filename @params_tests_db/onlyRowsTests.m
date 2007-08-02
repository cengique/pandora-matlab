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

%# Adjust the number of parameters and then delegate the filtering to 
%# tests_db/onlyRowsTests
if length(varargin) > 1
  cols = sort(tests2cols(obj, varargin{2}));
  obj = set(obj, 'num_params', sum(cols <= obj.num_params));
end
obj.tests_db = onlyRowsTests(obj.tests_db, varargin{:});
