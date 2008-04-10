
function [rows, idx] = uniqueValues(data)

% uniqueValues - Find unique rows in a matrix (or column vector). 
%
% Usage:
% [rows, idx] = uniqueValues(data)
%
% Description:
%   Version which makes use of sort and diff. Maintains order of the
% original input.
%
% Parameters:
%   data: A matrix or column vector
%
% Returns:
%   rows: A matrix or column vector of unique rows.
%   idx: Indices of the unique rows in the original data matrix.
%
% See also: sortedUniqueValues
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/24
% Based on J. Edgerton's sorting approach.
% OBSOLETE? See matlab "unique" command.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ isempty(data)
    % Sort rows with Quicksort
    [sorted idx] = sortrows(data);

    [sorted_rows sorted_idx] = sortedUniqueValues(sorted);

    % Reorder unique rows
    inv_idx = sort(idx(sorted_idx));
    rows = data(inv_idx, :);
    idx = inv_idx;
else
    rows = zeros(0,size(data,2)); idx = [];
end