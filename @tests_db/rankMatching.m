function a_ranked_db = rankMatching(db, crit_db)

% rankMatching - Create a ranking db of row distances of db to given criterion db.
%
% Usage:
% a_ranked_db = rankMatching(db, crit_db)
%
% Description:
%   crit_db can be created with the matchingRow method.
%
%   Parameters:
%	db: A tests_db to rank.
%	crit_db: A tests_db object holding the match criterion tests and stds.
%		
%   Returns:
%	a_ranked_db: A ranked_db object.
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

%# Strip out the RowIndex and ItemIndex columns from criterion db
crit_tests = setdiff(fieldnames(crit_db.col_idx), {'RowIndex', 'ItemIndex'});

%# Filter relevant columns
reduced_db = db(':', crit_tests);
dbsize(reduced_db)

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
%# Look for NaN values, skip them and count the non-NaN values to normalize the SS
ss_data = wghd_data .* wghd_data;
nans = isnan(ss_data);
ss_data(nans) = 0; %# Replace NaNs with 0s
summed_data = sum(ss_data, 2) ./ sum(~nans, 2); %# Sum distances and normalize by non-NaNs

%# Ignore NaN rows (there will be non NaN rows after the above)
nans = isnan(summed_data);
summed_data = summed_data(~nans);
row_index = row_index(~nans);
wghd_data = wghd_data(~nans, :);

%# Create a ranked_db with distances and row indices, sorted with distances
a_ranked_db = ranked_db([wghd_data, summed_data, row_index], ...
			{crit_tests{:}, 'Distance', 'RowIndex'}, db, crit_db, ...
			[ lower(get(db, 'id')) ' ranked to ' lower(get(crit_db, 'id')) ]);
