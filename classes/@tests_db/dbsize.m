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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if exist('dim')
  s = size(db.data, dim);
else
  s = size(db.data);
end