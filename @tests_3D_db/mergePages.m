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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/13

%# For each page to get tests from
num_pages = length(page_tests);

dbs = repmat(tests_3D_db, num_pages, 1);

%# Get desired tests from each page
num_tests = 0;
for page_num=1:num_pages
  tests = page_tests{page_num};
  dbs(page_num) = onlyRowsTests(db, ':', tests, page_num);
  num_tests = num_tests + length(tests);
end

%# New data matrix
data = repmat(NaN, dbsize(db, 1), num_tests);

%# Fill data matrix
num_tests = 0;
all_tests = {};
for page_num=1:num_pages
  tests = page_tests{page_num};
  these_tests = fieldnames(get(dbs(page_num), 'col_idx'));
  for test_num = 1:length(these_tests)
    these_tests{test_num} = [ these_tests{test_num} page_suffixes{page_num} ];
  end
  all_tests = { all_tests{:}, these_tests{:}};
  data(:, (num_tests + 1):(num_tests + length(tests))) = get(dbs(page_num), 'data');
  num_tests = num_tests + length(tests);
end

%# Create the new db
a_db = tests_db(data, all_tests, {}, get(db, 'id'), get(db, 'props'));
