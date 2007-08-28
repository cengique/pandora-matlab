function idx = findVectorInMatrix(data, row)

% findVectorInMatrix - Finds rows of data that match row.
%
% Usage:
% idx = findVectorInMatrix(data, row)
%
% Description:
%   Matlab's eq (==) command unfortunately doesn't allow this directly.
%
%	Parameters:
%		data: A matrix or column vector.
%		row: A row vector.
%	Returns:
%		idx: Indices of matching rows in the original data matrix.
%
% See also: 
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/1

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.
diffed = (data - ones(size(data, 1), 1) * row) == 0;
idx = find(all(diffed, 2));