function a_histogram_db = histogram(db, col, num_bins)

% histogram - Generates a tests_db object with rows corresponding to 
%		histogram entries.
%
% Usage:
% a_histogram_db = histogram(db, col, num_bins)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	num_bins: Number of histogram bins (Optional, default=100)
%		
%   Returns:
%	rows: A logical or index vector to be used in indexing db objects. 
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

if ~ exist('num_bins')
  num_bins = 100;
end

col_db = db(:, col);
[hist_results bins] = hist(col_db.data, num_bins);
col_name_cell = fieldnames(col_db.col_idx);
col_name = col_name_cell{1};

a_histogram_db = histogram_db(col_name, bins', hist_results', ...
			      [ col_name ' of ' db.id ]);