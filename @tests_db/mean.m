function s = mean(db, dim)

% mean - Returns the mean of the data matrix of db. Ignores NaN values.
%
% Usage:
% s = mean(db, dim)
%
% Description:
%   Does a recursive operation over dimensions in order to remove NaN values.
% This takes considerable amount of time compared with a straightforward mean 
% operation. 
%
%   Parameters:
%	db: A tests_db object.
%	dim: Work down dimension.
%		
%   Returns:
%	s: The mean values.
%
% See also: mean, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

if ~ exist('dim')
  dim = 1; %# Go down rows by default
end

%# Always do row-wise
order = 1:length(size(db.data));
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
s = recmean(data, length(db_size));

if dim ~= 1
  s = ipermute(s, order);
end

%# Recursive std needed for stripping NaNs in each dimension
function s = recmean(data, dim)
  if dim == 1
    s = mean(data(~isnan(data(:))), 1);
  else
    for num=1:size(data, dim)
      %# Otherwise recurse
      [dims{1:(dim-1)}] = deal(':');
      dims{dim} = num;
      s(dims{:}) = recmean(data(dims{:}), dim - 1);
    end
  end

