function a_stats_db = statsBounds(db, tests)

% statsBounds - Generates a stats_db object with two rows corresponding to 
%		the mean, min, and max of the tests' distributions.
%
% Usage:
% a_stats_db = statsBounds(db, tests)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	tests: A tests specification (see onlyRowsTests).
%		
%   Returns:
%	a_stats_db: A stats_db object.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

a_db = db(:, tests);
test_results = [mean(a_db.data, 1); min(a_db.data, [], 1); ...
		max(a_db.data, [], 1)];
row_names = {'mean', 'min', 'max'};

%# Original column names
cols = tests2cols(db, tests);
col_name_cell = fieldnames(db.col_idx);
col_names = col_name_cell(cols);

a_stats_db = stats_db(test_results, col_names, row_names, {}, ...
		      [ 'Bounds from ' db.id ]);
