function s = std(db, sflag, dim)

% std - Returns the std of the data matrix of db. Ignores NaN values.
%
% Usage:
% s = std(db, sflag, dim)
%
% Description:
%   Does a recursive operation over dimensions in order to remove NaN values.
% This takes considerable amount of time compared with a straightforward std
% operation. 
%
%   Parameters:
%	db: A tests_db object.
%	dim: Work down dimension.
%		
%   Returns:
%	s: The std values.
%
% See also: std, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

if ~ exist('dim')
  dim = 1; %# Go down rows by default
end

if ~ exist('sflag')
  sflag = 0; %# Normalize by N-1 by default
end

%# Always do row stds
order = 1:length(dbsize(db));
if dim ~= 1
  order(dim) = 1;
  order(1) = dim;
  data = permute(db.data, order);
else
  data = db.data;
end

%# Allocate results array
db_size = size(data);
s = repmat(NaN, [1 db_size(2:end)]);

%# Do a loop over EACH other dimension (!)
s = recstd(data, sflag, length(db_size));

if dim ~= 1
  s = ipermute(s, order);
end

%# Recursive std needed for stripping NaNs in each dimension
function s = recstd(data, sflag, dim)
  if dim == 1
    sdata = data(~isnan(data(:)));
    if size(sdata, 1) == 0
      %# If no data exists, give it NaN value instead of an empty
      %# matrix.
      s = NaN;
    else
      s = std(sdata, sflag, 1);
    end
  else
    for num=1:size(data, dim)
      %# Otherwise recurse
      [dims{1:(dim-1)}] = deal(':');
      dims{dim} = num;
      s(dims{:}) = recstd(data(dims{:}), sflag, dim - 1);
    end
  end