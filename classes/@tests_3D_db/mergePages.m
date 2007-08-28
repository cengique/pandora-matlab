function a_db = mergePages(db, page_tests, page_suffixes)

% mergePages - Merges tests from separate pages into a 2D params_tests_db.
%
% Usage:
% a_db = mergePages(db, page_tests, page_suffixes)
%
% Description:
%   Keeps uniqueness by adding suffixes to test names.
% If you're using invarParams, do swapRowsPages, then join with original db to get
% the parameter values.
%
%   Parameters:
%	db: A tests_3D_db object.
%	page_tests: Cell array of list of tests to take from each page.
%	page_suffixes: Cell array of suffixes to append to tests from each page.
%		
%   Returns:
%	a_db: A tests_db object.
%
% See also: tests_db, tests_3D_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

%# For each page to get tests from
num_pages = length(page_tests);

%#dbs = repmat(tests_3D_db, num_pages, 1);

row_index_col = tests2cols(db, 'RowIndex');

%# Get desired tests from each page
num_tests = 0;
tests_list = cell(1, num_pages);
for page_num=1:num_pages
  tests = tests2cols(db, page_tests{page_num});

  %# Add the RowIndex column even if it's not specified
  %# (only for suffixes that hasn't been used yet)
  if length(find(row_index_col == tests)) == 0 && ...
	length(find(strmatch(page_suffixes{page_num}, {page_suffixes{1:page_num}}))) == 1
    tests = [tests, row_index_col];
  end

  %# Count tests
  num_tests = num_tests + length(tests);
  tests_list{page_num} = tests;
end

%# New data matrix
data = repmat(NaN, dbsize(db, 1), num_tests);

%# Fill data matrix
num_tests = 0;
all_tests = {};
orig_tests = fieldnames(get(db, 'col_idx'));
for page_num=1:num_pages
  tests = tests_list{page_num};
  %#these_tests = fieldnames(get(dbs(page_num), 'col_idx'));
  these_tests = orig_tests(tests);
  for test_num = 1:length(these_tests)
    these_tests{test_num} = [ these_tests{test_num} page_suffixes{page_num} ];
  end
  all_tests = { all_tests{:}, these_tests{:}};
  data(:, (num_tests + 1):(num_tests + length(these_tests))) = ...
      get(onlyRowsTests(db, ':', tests, page_num), 'data');
  num_tests = num_tests + length(these_tests);
end

%# Create the new db
a_db = tests_db(data, all_tests, {}, get(db, 'id'), get(db, 'props'));
