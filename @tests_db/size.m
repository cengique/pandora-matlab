function s = size(db)

% size - Returns the size of the data matrix of db.
%
% Usage:
% s = size(db)
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

s = size(db.data);
