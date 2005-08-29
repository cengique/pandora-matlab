function a_stats_db = statsAll(db, tests, props)

% statsAll - Makes a stats_db with rows of mean, STD, SE, and CV of the tests' distributions in db.
%
% Usage:
% a_stats_db = statsAll(db, tests, props)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	tests: A selection of tests (see onlyRowsTests).
%	props: A structure with any optional properties for stats_db.
%		
%   Returns:
%	a_stats_db: A stats_db object.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/24

if ~ exist('props')
  props = struct([]);
end

if ~ exist('tests')
  tests = ':';
end

a_db = onlyRowsTests(db, ':', tests, ':');
[means n] = mean(a_db, 1);
stds = std(a_db, 0, 1);
test_results = [means; stds; stds ./ n; stds ./ means];
row_names = {'mean', 'STD', 'SE', 'CV'};

%# Original column names
cols = tests2cols(db, tests);
col_name_cell = fieldnames(db.col_idx);
col_names = col_name_cell(cols);

a_stats_db = stats_db(test_results, col_names, row_names, {}, ...
		      [ 'Statistics from ' db.id ], props);
