function a_tests_db = corrCoefs(db, col1, cols, props)

% corrCoefs - Generates a database of correlation coefficients 
%		by comparing col1 with other cols in the database. 
%		If db has multiple pages, then each page in db 
%		produces a row of coefficients and matching PageIndex.
%
% Usage:
% a_tests_db = corrCoefs(db, col1, cols, props)
%
% Description:
% Assuming the db was created with invarValues, this function finds the
% invariant correlation coefficients between its columns. 
% The invariant correlation coefficients are the correlation of one column
% value with another column value when some other column values are fixed.
% Since there are many occurences of the invariant coefficients, a histogram
% can then be created and returned from the created db. The other
% columns that are fixed are not in this db object, but can be reached 
% using the row indices in the original db. The page number is saved in the 
% created db, so that it can be used to find the page from which the 
% coefficient came. Then row indices of the page points to original 
% constant column values.
%
%   Parameters:
%	db: A tests_db object.
%	col1: Column to compare.
%	cols: Columns to be compared with col1.
%	props: A structure any optional properties.
%		skipCoefs: If coefficients of less confidence than %95 
%			should be skipped.
%		
%   Returns:
%	a_tests_db: A tests_db object with the coefficients and page indices.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/30

if ~ exist('props')
  props = struct([]);
end

if isfield(props, 'skipCoefs')
  skipCoefs = props.skipCoefs;
else
  skipCoefs = 1;
end

num_pages = size(db.tests_db.data, 3);
pages=(1:num_pages)';
coefs = repmat(NaN, num_pages, length(cols));

%# Only if there are multiple observations
if size(db.tests_db.data, 1) > 1
  %# One coefficient per page of observations
  for page_num=pages'
    [coef_data, p, rlo, rup] = ...
	corrcoef(db.tests_db.data(:, [col1 col2], page_num));

    if ~ skipCoefs
      set_cols = p(1,2:end) <= 0.05;
    else
      set_cols = true(length(cols));
    end
    coefs(page_num, set_cols) = coef_data(1, [false(1), set_cols]);
  end
end

%# Cannot strip all the NaNs out, do it at histogram time
%# Only strip full NaN rows here.
nanrows = all(isnan(coefs), 2);
coefs( nanrows, : ) = [];
pages( nanrows, : ) = [];

%# Check if any coefs left
if size(coefs, 1) == 0
  error('No coefficients found.');
end

%# Create the coefficient database
col_name_cell = fieldnames(get(db, 'col_idx'));
col1_name = col_name_cell{col1};
col_names = col_name_cell(cols);

a_tests_db = tests_db([coefs, pages], ...
		      {col_names{:}, 'PageIndex'}, ...
		      [ 'Correlations to ' col1_name ...
		       ' in ' get(db, 'id') ], props);
