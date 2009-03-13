function a_db = sum(a_db, dim, props)

% sum - Creates a tests_db by summing all rows.
%
% Usage:
% a_db = sum(a_db, dim, props)
%
% Description:
%   Applies the sum function to whole DB. The resulting DB will have one row.
%
%   Parameters:
%	a_db: A tests_db object.
%	props: Optional properties.
%		
%   Returns:
%	a_db: The resulting tests_db.
%
% See also: sum
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/24

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

if ~ exist('dim')
  dim = 1;                              % rows
end

% Always do row-wise
order = 1:length(dbsize(a_db));
if dim ~= 1
  order(dim) = 1;
  order(1) = dim;
  data = permute(a_db.data, order);
else
  data = a_db.data;
end

% Allocate results array
db_size = size(data);
s = repmat(NaN, [1 db_size(2:end)]);

[s, n] = recsum(data, length(db_size));

if dim ~= 1
  s = ipermute(s, order);
end

a_db = set(a_db, 'data', s);

a_db = set(a_db, 'id', [ 'summed ' get(a_db, 'id') ]);
switch (dim)
  case 1
    a_db = set(a_db, 'row_idx', makeIdx({'sum'}));
  case 2
    a_db = set(a_db, 'col_idx', makeIdx({'sum'}));
end

% Recursive std needed for stripping NaNs in each dimension
% TODO: taken from mean, generalize it!
function [s, n] = recsum(data, dim)
  if dim == 1
    sdata = data(~isnan(data(:)) & ~isinf(data(:)));
    n = size(sdata, 1);
    if n == 0
      % If a divide by zero error occured, 
      % give it NaN value instead of an empty matrix.
      s = NaN;
    else
      s = sum(sdata, 1);
    end
  else
    for num=1:size(data, dim)
      % Otherwise recurse
      [dims{1:(dim-1)}] = deal(':');
      dims{dim} = num;
      [s(dims{:}) n(dims{:})] = recsum(data(dims{:}), dim - 1);
    end
  end

