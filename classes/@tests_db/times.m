function a_db = times(left_obj, right_obj)

% times - Multiplies the DB with a scalar.
%
% Usage:
% a_db = times(left_obj, right_obj)
%
% Description:
%
%   Parameters:
%	left_obj, right_obj: Operands of the multiplication. One must be of type tests_db.
%		
%   Returns:
%	a_db: The resulting tests_db.
%
% See also: times
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/24

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if isa(left_obj, 'tests_db')
  a_db = left_obj;
  a_scalar = right_obj;
else
  a_db = right_obj;
  a_scalar = left_obj;
end

if ~isnumeric(a_scalar)
  error(['Multiplication for tests_db is not defined for types of ' class(a_scalar) '.' ]);
end

a_db = set(a_db, 'id', [ num2str(a_scalar) ' * ' get(a_db, 'id') ]);
a_db = set(a_db, 'data', a_scalar * get(a_db, 'data'));
