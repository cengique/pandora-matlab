function s = mean(db, dim)

% mean - Returns the mean of the data matrix of db.
%
% Usage:
% s = mean(db)
%
% Description:
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

%# Always do row means
if dim == 2
  data = db.data';
else
  data = db.data;
end

%# Allocate results array
s = repmat(NaN, [1 size(data, 2)]);

%# Do a loop over the other dimension
for num=1:size(data, 2)
  s(num) = mean(data(~isnan(data(:,num)), num), 1);
end

if dim == 2
  s = s';
end
