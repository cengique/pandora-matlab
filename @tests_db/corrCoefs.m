function a_coefs_db = corrCoefs(db, col1, cols, props)

% corrCoefs - Generates a database of correlation coefficients 
%		by comparing col1 with other cols in the database. 
%		If db has multiple pages, then each page in db 
%		produces a row of coefficients and matching PageIndex.
%
% Usage:
% a_coefs_db = corrCoefs(db, col1, cols, props)
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
%	a_coefs_db: A corrcoefs_db of the coefficients and page indices.
%
% See also: tests_db, corrcoefs_db
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

%# Obsolete, need to remove NaNs
if isfield(props, 'excludeNaNs')
  excludeNaNs = props.excludeNaNs;
else
  excludeNaNs = 1;
end

%# translate column spec to array form
col1 = tests2cols(db, col1);
cols = tests2cols(db, cols);

num_pages = size(db.data, 3);
pages=(1:num_pages)';
coefs = repmat(NaN, [num_pages, length(cols), 3]);


%# Only if there are multiple observations
if size(db.data, 1) > 1
  %# One coefficient per page of observations
  for page_num=pages'

    col1nonnans = ~isnan(db.data(:, col1, page_num));

    %# Do each column separately
    for col_num=1:length(cols)
      data = db.data(col1nonnans, [col1 cols(col_num)], page_num);

      %# Remove rows with NaNs on column
      data = data(isnan(data(:, 2)), :);

      %# Check if any rows left
      if size(data, 1) < 2
	%#warning('tests_db:anyNaNs', 'No NaN-free rows found.');
	continue;
      end

      [coef_data, p, rlo, rup] = corrcoef(data);
      
      if ~ skipCoefs || p(1,2) <= 0.05
	coefs(page_num, col_num, :) = ...
	    [coef_data(1, 2), rlo(1, 2), rup(1, 2)];
      end
    end
  end
end

%# Cannot strip all the NaNs out, do it at histogram time
%# Only strip full NaN rows here.
nanrows = all(isnan(coefs(:,:,1)), 2);
coefs( nanrows, :, : ) = [];
pages( nanrows, : ) = [];

%# Triplicate pages
pages(:, :, 2) = pages(:, :, 1);
pages(:, :, 3) = pages(:, :, 1);

%# Check if any coefs left
if size(coefs, 1) == 0
  error('No coefficients found.');
end

%# Create the coefficient database
col_name_cell = fieldnames(get(db, 'col_idx'));
col1_name = col_name_cell{col1};
col_names = col_name_cell(cols);

a_coefs_db = corrcoefs_db(col1_name, coefs, col_names, pages, ...
			  [ 'Correlations to ' col1_name ...
			   ' in ' get(db, 'id') ], props);
