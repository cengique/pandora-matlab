function crit_db = matchingRow(db, row, tests)

% matchingRow - Creates a criterion database for matching the tests of a row.
%
% Usage:
% crit_db = matchingRow(db, row, tests)
%
% Description:
%   Copies selected test values from row as the first row into the 
% criterion db. Adds a second row for the STD of each column in the db.
%
%   Parameters:
%	db: A tests_db object.
%	row: A row index to match.
%	tests: Test name of column indices (see tests2cols).
%		
%   Returns:
%	crit_db: A tests_db with two rows for values and STDs.
%
% See also: rankMatching, tests_db, tests2cols
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/08

cols = tests2cols(db, tests);

col_db = db(row, tests)

%# Add the row index
data = [ col_db.data, row; std(db(:, tests)), 0 ];

%# Create the criterion database
col_name_cell = fieldnames(db.col_idx);
col_names = col_name_cell(cols);

%# TODO: put the invarName in the title?
crit_db = tests_db(data, {col_names{:}, 'RowIndex'}, {'Values', 'STD'}, ...
		   ['Criterion for matching row ' num2str(row) ...
		    ' from ' db.id ], db.props);
