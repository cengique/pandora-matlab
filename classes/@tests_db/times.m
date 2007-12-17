function a_db = mtimes(left_obj, right_obj)

% mtimes - Multiplies the DB with a scalar.
%
% Usage:
% a_db = mtimes(left_obj, right_obj)
%
% Description:
%
%   Parameters:
%	left_obj, right_obj: Operands of the multiplication. One or more must be of type tests_db.
%		
%   Returns:
%	a_db: The resulting tests_db.
%
% See also: tests_db/times, mtimes
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/24

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_db = rop(left_obj, right_obj, @times, '.*');
