function a_histogram_db = histogram(db, col, num_bins)

% histogram - Generates a stack of histograms; one for each page in db.
%
% Usage:
% a_histogram_db = histogram(db, col, num_bins)
%
% Description:
% If one wants to get histograms of test values for each single value of
% the selected invariant parameter, then swapRowsPages should be done
% first on db.
%
%   Parameters:
%	db: A tests_3D_db object.
%	col: Column to find the histogram.
%	num_bins: Number of histogram bins (Optional, default=100)
%		
%   Returns:
%	a_histogram_db: A histogram_db object containing the histogram.
%
% See also: histogram_db, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/04

if ~ exist('num_bins')
  num_bins = 100;
end

%# For all pages, get histogram
num_pages = size(db.tests_db.data, 3);
pages=(1:num_pages)';
data = repmat(0, [num_bins, 2, num_pages]);
for page_num=pages'
  a_histogram_db = histogram(onlyRowsTests(db, ':', col, page_num), ...
			     1, num_bins);
  data(:, :, page_num) = get(a_histogram_db, 'data');
end

%# Create a new histogram_db with all the data
col_name_cell = fieldnames(get(db, 'col_idx'));
col_name = col_name_cell{col};

a_histogram_db = histogram_db(col_name, data(:,1,:), data(:,2,:), ...
			      [ col_name ' of ' get(db, 'id') ]);
