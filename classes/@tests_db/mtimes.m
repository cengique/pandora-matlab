function a_db = mtimes(left_obj, right_obj)

% mtimes - Multiplies the DB with a scalar.
%
% Usage:
% a_db = mtimes(left_obj, right_obj)
%
% Description:
%
%   Parameters:
%	left_obj, right_obj: Operands of the multiplication. One must be of type tests_db.
%		
%   Returns:
%	a_db: The resulting tests_db.
%
% See also: tests_db/times, mtimes
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/24

a_db = times(left_obj, right_obj);