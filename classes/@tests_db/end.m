function s = end(db, index, total)

% end - Overloaded primitive matlab function, returns maximal dimension size.
%
% Usage:
% s = end(db, index, total)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%		
%   Returns:
%	s: The size.
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
% http://opensource.org/licenses/afl-3.0.txt.

s = dbsize(db, index);
