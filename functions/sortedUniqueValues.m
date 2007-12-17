function [rows, idx] = sortedUniqueValues(data)

% sortedUniqueValues - Find unique rows in an already sorted matrix 
%			(or column vector). Uses the derivation method.
%
% Usage:
% [rows, idx] = sortedUniqueValues(data)
%
% Description:
%	Parameters:
%		data: A ascending row-sorted matrix or column vector.
%	Returns:
%		rows: A matrix or column vector of unique rows.
%		idx: Indices of the unique rows in the original data matrix.
%
% See also: uniqueValues
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/27
% Based on J. Edgerton's derivation method.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Use diff to get unique rows
diffed = diff(data, 1, 1);

% Find non-zero rows
nonzerorows = [true(1); any(diffed, 2)];

idx = find(nonzerorows);
rows = data(idx, :);

