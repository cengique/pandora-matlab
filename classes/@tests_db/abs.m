function a_db = abs(left_obj)

% abs - Take absolute value of all db elements.
%
% Usage:
% a_db = abs(left_obj)
%
% Parameters:
%   left_obj: A tests_db object.
%		
% Returns:
%   a_db: The resulting tests_db.
%
% Description:
%
% See also: abs, uop
%
% $Id: abs.m 1334 2012-04-19 18:02:13Z cengique $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/01/16

% Copyright (c) 2007-14 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_db = uop(left_obj, @abs, '-');
