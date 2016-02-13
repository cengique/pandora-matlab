function a_db = uop(left_obj, op_func, op_id)

% uop - Unary operation.
%
% Usage:
% a_db = uop(left_obj, op_func, op_id)
%
% Description:
%   Applies the operation to the database contents and updates its id
% field. Unary minus (uminus) uses this function.
%
% Parameters:
%   left_obj: Operands of the operation.
%   op_func: Operation function (e.g., @plus).
%   op_id: A string to represent the operation that will show up in the
%   	  returned id.
%		
% Returns:
%   a_db: The resulting tests_db.
%
% See also: tests_db/uminus, uminus
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/01/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

an_id = [ op_id ' ' get(left_obj, 'id') ];

a_db = left_obj;
a_db = set(a_db, 'id', an_id);
a_db = set(a_db, 'data', feval(op_func, get(left_obj, 'data')));
