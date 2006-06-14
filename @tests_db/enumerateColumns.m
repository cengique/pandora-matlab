function a_db = enumerateColumns(a_db, tests)

% enumerateColumns - Replaces each column value with an integer indicating its enumerated level.
%
% Usage:
% a_db = enumerateColumns(a_db, tests)
%
% Description:
%   Finds unique values of each column, and replaces the original values
% with the enumerated indices of these unique values. Useful for normalizing all 
% parameter values in a hypercube.
%
% Parameters:
%	a_db: A tests_db object.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/14

cols = tests2cols(a_db, tests);
data = get(a_db, 'data');

for col_num = cols
  data(:, col_num) = enumerateColumnVector(data(:, col_num));
end

a_db = set(a_db, 'data', data);

end

function col_vector = enumerateColumnVector(col_vector)
  num_total_rows = size(col_vector, 1);

  %# Sort rows
  [sorted idx] = sortrows(col_vector);

  %# Find unique rows
  [unique_rows unique_idx] = sortedUniqueValues(sorted);
  num_uniques = size(unique_rows, 1);
  
  %# For each unique row to next, fill with enumerated value
  for unique_num=1:num_uniques
    if unique_num < num_uniques
      page_rows = unique_idx(unique_num):(unique_idx(unique_num + 1) - 1);
    else
      page_rows = unique_idx(unique_num):num_total_rows;
    end

    %# Enumerated values start from 1
    sorted(page_rows) = unique_num;
  end

  col_vector(idx) = sorted;
end