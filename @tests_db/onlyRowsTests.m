function obj = onlyRowsTests(obj, rows, tests, pages)

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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

%# Setup lookup tables
col_names = fieldnames(obj.col_idx);

%# Pages
if ~ exist('tests')
  tests = ':';
end

%# translate tests spec to array form
cols = tests2cols(obj, tests);

%# Pages
if ~ exist('pages')
  pages = ':';
end

%# Do it
obj.data = obj.data(rows, cols, pages);

%# Convert and get col_idx
numsCell = col_names(cols);
[only_names{1:length(cols)}] = deal(numsCell{:});
obj.col_idx = makeIdx(only_names);

