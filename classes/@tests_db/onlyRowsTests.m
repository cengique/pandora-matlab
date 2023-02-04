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
%	rows, tests: A logical or index vector of rows, or cell array of
%		names of rows. If ':', all rows. For names, regular expressions are
%		supported if quoted with slashes (e.g., '/a.*/'). See tests2idx.
%	pages: (Optional) A logical or index vector of pages. ':' for all pages.
%		
%   Returns:
%	obj: The new tests_db object.
%
% See also: subsref, tests_db, tests2idx, regexp
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Pages
if ~ exist('tests', 'var')
  tests = ':';
end

% translate tests spec to array form
cols = tests2idx(obj, 2, tests);
rows = tests2idx(obj, 1, rows);

% Pages
if ~ exist('pages', 'var')
  pages = ':';
end

% Do it
if ~ isempty(rows) && ~ isempty(cols) && ~ isempty(pages)
  obj.data = obj.data(rows, cols, pages);
else
  obj.data = [];
end

% Convert and get col_idx
col_names = fieldnames(obj.col_idx);
if ~ isempty(col_names)
  obj.col_idx = makeIdx({col_names{cols}});
end

% Convert and get row_idx
row_names = fieldnames(obj.row_idx);
if ~ isempty(row_names)
  row_numbers = cell2mat(struct2cell(obj.row_idx));
  row_common = ismember(row_numbers, rows);
  obj.row_idx = cell2struct(num2cell(row_numbers(row_common)), row_names(row_common), 1);
end

