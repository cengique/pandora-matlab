function a_db = uminus(left_obj)

% uminus - Unary minus or negation.
%
% Usage:
% a_db = uminus(left_obj)
%
% Description:
%
%   Parameters:
%	left_obj: A tests_db object.
%		
%   Returns:
%	a_db: The resulting tests_db.
%
% See also: uminus, uop
%
% $Id: uminus.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/01/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_db = uop(left_obj, @uminus, '-');
