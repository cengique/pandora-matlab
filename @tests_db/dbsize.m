function s = dbsize(db, dim)

% dbsize - Returns the size of the data matrix of db.
%
% Usage:
% s = dbsize(db)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%		
%   Returns:
%	s: The size values.
%
% See also: size, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

if exist('dim')
  s = size(db, dim);
else
  s = size(db);
end