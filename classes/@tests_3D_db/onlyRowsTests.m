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

% defaults
rows = defaultValue('rows', ':');
tests = defaultValue('tests', ':');

% delegate to super
a_tests_db = onlyRowsTests(obj.tests_db, rows, tests);

% Pages
if exist('pages', 'var')
  % translate tests spec to array form
  pages = tests2idx(obj, 3, pages);
else
  pages = ':';
end

% Index using pages alone (rows & columns done already)
if ~ isempty(pages)
  a_tests_db.data = a_tests_db.data(:, :, pages);
else
  a_tests_db.data = [];
end

% assign back
obj.tests_db = a_tests_db;

% Convert and get page_idx
page_names = fieldnames(obj.page_idx);
if ~ isempty(page_names)
  obj.page_idx = makeIdx({page_names{pages}});
end

