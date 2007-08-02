function a_stats_db = statsMeanStd(db, tests, props)

% statsMeanStd - Generates a stats_db object with two rows corresponding to 
%		the mean and std of the tests' distributions.
%
% Usage:
% a_stats_db = statsMeanStd(db, tests, props)
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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

if ~ exist('props')
  props = struct([]);
end

if ~ exist('tests')
  tests = ':';
end

a_db = onlyRowsTests(db, ':', tests, ':');
[means, n] = mean(a_db, 1);
test_results = [means.data; get(std(a_db, 0, 1), 'data'); n];
row_names = {'mean', 'STD', 'n'};

%# Original column names
cols = tests2cols(db, tests);
col_name_cell = fieldnames(db.col_idx);
col_names = col_name_cell(cols);

a_stats_db = stats_db(test_results, col_names, row_names, {}, ...
		      [ 'Mean and STDs of ' db.id ], props);
