function [rows, idx] = sortedUniqueValues(data)

% sortedUniqueValues - Find unique rows in an already sorted matrix (or column vector).
%
% Usage:
% [rows, idx] = sortedUniqueValues(data)
%
% Description:
%   Uses the derivation by Matlab diff function method.  Redundant with the
% Matlab function UNIQUE doing the same job:
% [rows, idx]= unique(data, 'rows', 'first'). 
% However, sortedUniqueValues is more efficient if the input data is already
% sorted for some other reason (see usage in tests_db/invarValues).
%
% Parameters:
%   data: A ascending row-sorted matrix or column vector.
%
% Returns:
%   rows: A matrix or column vector of unique rows.
%   idx: Indices of the unique rows in the original data matrix.
%
% See also: uniqueValues, unique
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/27
% Based on J. Edgerton's derivation method.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Use diff to get unique rows
if ~isempty(data)
    diffed = diff(data, 1, 1);

    % Find non-zero rows
    nonzerorows = [true(1); any(diffed, 2)];

    idx = find(nonzerorows);
    rows = data(idx, :);
else
    rows=zeros(0, size(data,2));
    idx=rows;
end