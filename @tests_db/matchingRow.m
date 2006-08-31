function crit_db = matchingRow(db, row, props)

% matchingRow - Creates a criterion database for matching the tests of a row.
%
% Usage:
% crit_db = matchingRow(db, row, props)
%
% Description:
%   Copies selected test values from row as the first row into the 
% criterion db. Adds a second row for the STD of each column in the db.
%
%   Parameters:
%	db: A tests_db object.
%	row: A row index to match.
%	props: A structure with any optional properties.
%		std_db: Take the standard deviation from this db instead.
%		
%   Returns:
%	crit_db: A tests_db with two rows for values and STDs.
%
%   Example:
%	>> crit_db = matchingRow(phys_control_compare_db, 
%		find(phys_control_compare_db(:, 'TracesetIndex') == 61))
%
% See also: rankMatching, tests_db, tests2cols
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/08

if ~ exist('props')
  props = struct;
end

tests = ':';

cols = tests2cols(db, tests);
col_db = onlyRowsTests(db, row, tests);

%# Check for std_db
if isfield(props, 'std_db')
  std_db = props.std_db;
else
  std_db = db;
end

%# Add the row index
col_added_db = addColumns(col_db, {'RowIndex'}, row);

%# Add the STD row
std_db = addLastRow(col_added_db, [ get(std(std_db(:, tests)), 'data'), 0 ]);

%# Adjust other fields
crit_db = set(std_db, 'row_idx', makeIdx({'Values', 'STD'}));
crit_db = set(crit_db, 'id', ['Criterion for matching row ' num2str(row) ...
			      ' from ' db.id ]);
