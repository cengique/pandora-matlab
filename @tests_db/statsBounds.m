function a_stats_db = statsBounds(a_db, tests, props)

% statsBounds - Generates a stats_db object with three rows corresponding to 
%		the mean, min, and max of the tests' distributions. A page is
%		generated for each page of data in db.
%
% Usage:
% a_stats_db = statsBounds(a_db, tests, props)
%
% Description:
%
%   Parameters:
%	a_db: A tests_db object.
%	tests: A selection of tests (see onlyRowsTests).
%	props: A structure with any optional properties for stats_db.
%		
%   Returns:
%	a_stats_db: A stats_db object.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

if ~ exist('props')
  props = struct([]);
end

cols = tests2cols(a_db, tests);

num_pages = size(a_db, 3);
pages=1:num_pages;
data = repmat(0, [3, length(cols), num_pages]);
for page_num=pages
  a_page_db = a_db(:, tests, page_num);
  data(:, :, page_num) = [mean(a_page_db, 1); min(a_page_db.data, [], 1); ...
			  max(a_page_db.data, [], 1)];
end

row_names = {'mean', 'min', 'max'};

%# Original column names
col_name_cell = fieldnames(a_db.col_idx);
col_names = col_name_cell(cols);

a_stats_db = stats_db(data, col_names, row_names, {}, ...
		      [ 'Mean value and min-max bounds from ' get(a_db, 'id') ], props);
