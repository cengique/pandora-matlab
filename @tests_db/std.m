function s = std(db, flag, dim)

% std - Returns the std of the data matrix of db.
%
% Usage:
% s = std(db, flag, dim)
%
% Description:
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

if ~ exist('flag')
  flag = 0; %# Normalize by N-1 by default
end

%# Always do row stds
if dim == 2
  data = db.data';
else
  data = db.data;
end

%# Allocate results array
s = repmat(NaN, [1 size(data, 2)]);

%# Do a loop over the other dimension
for num=1:size(data, 2)
  s(num) = std(data(~isnan(data(:,num)), num), flag, 1);
end

if dim == 2
  s = s';
end
