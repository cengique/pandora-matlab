function rank_db = rankMatching(db, crit_db)

% rankMatching - Create a ranking db of row distances of db to given criterion db.
%
% Usage:
% rank_db = rankMatching(db, crit_db)
%
% Description:
%   crit_db can be created with the matchingRow method.
%
%   Parameters:
%	db: A tests_db to rank.
%	crit_db: A tests_db object holding the match criterion tests and stds.
%		
%   Returns:
%	rank_db: A tests_db object.
%
% See also: matchingRow, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/08

%# If not exists, add RowIndex column
if isfield(db.col_idx, 'RowIndex')
  row_index = db(:, 'RowIndex').data;
else
  row_index = (1:dbsize(db, 1))';
end

%# Strip out the RowIndex column from criterion db
crit_tests = setdiff(fieldnames(crit_db.col_idx), 'RowIndex');

%# Filter relevant columns
reduced_db = db(':', crit_tests);

%# Vectorize diff over cols and do the diff^2
%#####

%# Replicate 1st row of crit_db
first_row = onlyRowsTests(crit_db, 1, crit_tests);
rep_crit = ones(dbsize(db, 1), 1) * first_row.data;

%# Subtract from db
diff_data = reduced_db.data - rep_crit;

%# Weigh according to 2nd row of crit_db
second_row = onlyRowsTests(crit_db, 2, crit_tests);
rep_weight = ones(dbsize(db, 1), 1) * second_row.data;
wghd_data = diff_data ./ rep_weight;

%# Sum of squares: distance measure
wghd_data = sum(wghd_data .* wghd_data, 2);

%# Create new db with distances and row indices, sorted with distances
rank_db = sortrows(tests_db([wghd_data, row_index], ...
			    {'Distance', 'RowIndex'}, {}, ...
			    [ get(db, 'id') ' compared with ' get(crit_db, 'id') ]), ...
		   'Distance');