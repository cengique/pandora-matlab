function a_tests_db = invarCorrCoefs(db, col1, col2, props)

% invarCorrCoefs - Generates a database of invariant correlation 
%		coefficients for two columns in the database.
%
% Usage:
% a_tests_db = invarCorrCoefs(db, col1, col2, props)
%
% Description:
% The invariant correlation coefficients are the correlation of one column
% value with another column value when all other column values are fixed.
% Since there are many occurences of the invariant coefficients, a histogram
% can then be created and returned from the tests_db object.
%
%   Parameters:
%	db: A tests_db object.
%	num_bins: Number of histogram bins (Optional, default=100)
%	props: A structure any optional properties.
%		skipCoefs: If coefficients of less confidence than %95 
%			should be skipped.
%		
%   Returns:
%	a_tests_db: A tests_db object with the coefficients and row indices.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/28

if ~ exist('props')
  props = struct([]);
end

if isfield(props, 'skipCoefs')
  skipCoefs = props.skipCoefs;
else
  skipCoefs = 1;
end

%# Remove given columns
wo_cols = db.data;
wo_cols(:, [col1 col2]) = [];

%# Sort rows
[sorted idx] = sortrows(wo_cols, 1);

%# Find unique rows
[unique_rows unique_idx] = sortedUniqueValues(sorted);

%# Get the columns back
sorted = db.data(idx, :);

%# Initialize
num_rows = length(unique_idx);
coefs = repmat(NaN, num_rows, 1);

%# For each unique row to next, find correlation coefficients of col1, col2
for row_num=1:num_rows
  if row_num < num_rows
    rows = unique_idx(row_num):(unique_idx(row_num + 1) - 1);
  else
    rows = unique_idx(row_num):size(sorted, 1);
  end
  %# Only if there are multiple observations
  if length(rows) > 1
    [coef_data, p, rlo, rup] = corrcoef(sorted(rows, [col1 col2]));
    if ~ skipCoefs | p(1,2) <= 0.05
      coefs(row_num) = coef_data(1, 2); %# Cross-correlation coefficient 
    end
  end
end

%# Strip the NaNs out
nans = isnan(coefs);
coefs( nans ) = [];
unique_idx( nans ) = [];

%# Check if any coefs left
if length(coefs) == 0
  error('No coefficients found.');
end

%# Translate to find original row indices 
row_idx = idx(unique_idx);

%# Create the coefficient database
col_name_cell = fieldnames(db.col_idx);
col1_name = col_name_cell{col1};
col2_name = col_name_cell{col2};

a_tests_db = tests_db([coefs, row_idx], {'CorrCoef', 'RowIndex'}, ...
		      [ col1_name ' vs. ' ...
		       col2_name ' from ' db.id ], props);
