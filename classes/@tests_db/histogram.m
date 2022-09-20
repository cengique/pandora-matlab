function a_histogram_db = histogram(db, col, num_bins, props)

% histogram - Returns histogram of chosen database column.
%
% Usage:
% a_histogram_db = histogram(db, col, num_bins, props)
%
% Description:
%   Generates a histogram_db object with rows corresponding to histogram
% entries. If an array of DBs is given, finds and uses common histogram bin centers.
%
%   Parameters:
%	db: A tests_db object.
%	col: Column to find the histogram.
%	num_bins: Number of histogram bins (Optional, default=100), or
%		  vector of histogram bin centers.
%	props: A structure with any optional properties.
%	  shortId: If 1, only include db Id in label.
%	  normalized: If 1, normalize histogram counts.
%
%   Returns:
%	a_histogram_db: A histogram_db object containing the histogram.
%
% Example:
% >> a_hist_db = histogram(my_db, 'spike_width');
% >> plot(a_hist_db);
%
% See also: histogram_db, tests_db, hist
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('num_bins', 'var') || isempty(num_bins)
  num_bins = 100;
end

num_dbs = length(db);
if num_dbs > 1
  % If given array of DBs, find maximal bounds to create bins accordingly
  min_val = +Inf;
  max_val = -Inf;
  for db_num=1:num_dbs
    col_db = onlyRowsTests(db(db_num), ':', col);
    col_db = onlyRowsTests(col_db, ~ isnan(col_db.data) & ~ isinf(col_db.data), 1);
    bounds_data = get(statsBounds(col_db), 'data');
    min_val = min(min_val, bounds_data(2));
    max_val = max(max_val, bounds_data(3));
  end

  % If a scalar, then apply limits and get bins
  if length(num_bins) == 1
    num_bins = min_val + (1:num_bins - 1) .* (max_val - min_val) ./ (num_bins - 1);
  end

  % It's not A histogram db anymore
  [a_histogram_db(1:num_dbs)] = deal(histogram_db);
  for db_num=1:num_dbs
    % recurse
    a_histogram_db(db_num) = histogram(db(db_num), col, num_bins, props);
  end  

else

col_db = onlyRowsTests(db, ':', col);

% Remove NaN or Inf values 
col_db = onlyRowsTests(col_db, ~ isnan(col_db.data) & ~ isinf(col_db.data), 1);
%col_db = col_db( ~ isnan(col_db(:, 1)), 1);
% I don't know why the above doesn't work!? 
% [ because matlab doesn't call member funcs from here]

% If any rows left
if dbsize(col_db, 1) > 0
  [hist_results bins] = hist(col_db.data, num_bins);
else
  
  if length(num_bins) > 1
    % if bin edges were given
    bins = num_bins;
  else
    % if number of bin was given
    bins = zeros(1, num_bins);
  end
  hist_results = zeros(1, length(bins));
end

if isfield(props, 'normalized') && props.normalized == 1
  hist_results = hist_results ./ max(hist_results);
end

col_name_cell = fieldnames(col_db.col_idx);
col_name = col_name_cell{1};

if isfield(props, 'shortId')
    hist_id = db.id;
else
    hist_id = [ col_name ' of ' db.id ];
end

a_histogram_db = histogram_db(col_name, bins', hist_results', ...
			      hist_id, props);
end