function a_db = enumerateColumns(a_db, tests, props)

% enumerateColumns - Replaces each value with an integer pointing to the index of enumerated unique values in a column.
%
% Usage:
% a_db = enumerateColumns(a_db, tests, props)
%
% Description:
%   Finds unique values of each column, and replaces the original values
% with the enumerated indices of these unique values. Useful for normalizing all 
% parameter values in a hypercube.
%
% Parameters:
%	a_db: A tests_db object.
%	tests: Array of tests to be enumerated.
%	props: Optional properties.
%	  truncateDecDigits: Use only up to this many decimal digits after the point 
%		when checking for uniqueness.
%
% Returns:
%	a_db: The modified DB.
%
% Example:
% >> enumerated_db = enumerateColumns(a_db(:, 1:9));
%
% See also: uniqueValues
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct([]);
end

cols = tests2cols(a_db, tests);
data = get(a_db, 'data');


for col_num = cols
  if isfield(props, 'truncateDecDigits')
    mult_factor = 10^props.truncateDecDigits;
    col_vals = round(data(:, col_num) * mult_factor) / mult_factor;
  else
    col_vals = data(:, col_num);
  end
  data(:, col_num) = enumerateColumnVector(col_vals);
end

a_db = set(a_db, 'data', data);

end

function col_vector = enumerateColumnVector(col_vector)
  num_total_rows = size(col_vector, 1);

  % Sort rows
  [sorted idx] = sortrows(col_vector);

  % Find unique rows
  [unique_rows unique_idx] = sortedUniqueValues(sorted);
  num_uniques = size(unique_rows, 1);
  
  % For each unique row to next, fill with enumerated value
  for unique_num=1:num_uniques
    if unique_num < num_uniques
      page_rows = unique_idx(unique_num):(unique_idx(unique_num + 1) - 1);
    else
      page_rows = unique_idx(unique_num):num_total_rows;
    end

    % Enumerated values start from 1
    sorted(page_rows) = unique_num;
  end

  col_vector(idx) = sorted;
end