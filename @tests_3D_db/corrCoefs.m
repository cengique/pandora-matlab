function a_tests_db = corrCoefs(db, col1, col2, props)

% corrCoefs - Generates a database of correlation coefficients 
%		for two columns in the database. Each page in db 
%		produces a single coefficient.
%
% Usage:
% a_tests_db = corrCoefs(db, col1, col2, props)
%
% Description:
% Assuming the db was created with invarValues, this function finds the
% invariant correlation coefficients for two columns. 
% The invariant correlation coefficients are the correlation of one column
% value with another column value when some other column values are fixed.
% Since there are many occurences of the invariant coefficients, a histogram
% can then be created and returned from the tests_db object. The other
% columns that are fixed are not in this db object, but can be reached 
% using the row indices in this db. The page number is saved in the db created,
% so that it can be used to find the page from which the coefficient came.
% Then row indices of the page points to original constant column values.
%
%   Parameters:
%	db: A tests_db object.
%	col1, col2: Columns to compare.
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
coefs = repmat(NaN, num_pages, 1);

%# Only if there are multiple observations
if size(db.tests_db.data, 1) > 1
  %# One coefficient per page of observations
  for page_num=pages'
    [coef_data, p, rlo, rup] = ...
	corrcoef(db.tests_db.data(:, [col1 col2], page_num));

    if ~ skipCoefs | p(1,2) <= 0.05
      coefs(page_num) = coef_data(1, 2); %# Cross-correlation coefficient 
    end
  end
end

%# Strip the NaNs out
nans = isnan(coefs);
coefs( nans ) = [];
pages( nans ) = [];

%# Check if any coefs left
if length(coefs) == 0
  error('No coefficients found.');
end

%# Create the coefficient database
col_name_cell = fieldnames(get(db, 'col_idx'));
col1_name = col_name_cell{col1};
col2_name = col_name_cell{col2};

a_tests_db = tests_db([coefs, pages], {'CorrCoef', 'PageIndex'}, ...
		      [ col1_name ' vs. ' ...
		       col2_name ' from ' get(db, 'id') ], props);
