function a_histogram_db = histogram(db, col, num_bins)

% histogram - Generates a histogram_db object with rows corresponding to 
%		histogram entries.
%
% Usage:
% a_histogram_db = histogram(db, col, num_bins)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	col: Column to find the histogram.
%	num_bins: Number of histogram bins (Optional, default=100), or
%		  vector of histogram bin centers.
%		
%   Returns:
%	a_histogram_db: A histogram_db object containing the histogram.
%
% See also: histogram_db, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

if ~ exist('num_bins')
  num_bins = 100;
end

col_db = onlyRowsTests(db, ':', col);

%# Remove NaN values 
col_db = onlyRowsTests(col_db, ~ isnan(col_db.data), 1);
%#col_db = col_db( ~ isnan(col_db(:, 1)), 1);
%# I don't know why the above doesn't work!?

%# If any rows left
if dbsize(col_db, 1) > 0
  [hist_results bins] = hist(col_db.data, num_bins);
else
  hist_results = zeros(1, num_bins);
  bins = zeros(1, num_bins);
end

col_name_cell = fieldnames(col_db.col_idx);
col_name = col_name_cell{1};

a_histogram_db = histogram_db(col_name, bins', hist_results', ...
			      [ col_name ' of ' db.id ]);
