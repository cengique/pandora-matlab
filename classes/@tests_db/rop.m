function a_db = rop(left_obj, right_obj, op_func, op_id)

% rop - Prepares aligned columns in two DBs or one DB and a scalar for an array arithmetic operation.
%
% Usage:
% a_db = rop(left_obj, right_obj, op_func, op_id)
%
% Description:
%   If DBs have mismatching columns only the common columns will be kept.
% In any case, the resulting DB columns will be sorted in the order of the
% left-hand-side DB. Array addition (plus), subtraction (minus),
% multiplication (mtimes) and division (rdivide) use this function to
% align columns.
%
% Parameters:
%   left_obj, right_obj: Operands of the operation. One must be of type tests_db
%		and the other can be a scalar or tests_db.
%   op_func: Operation function (e.g., @plus).
%   op_id: A string to represent the operation that will show up in the
%   	  returned id.
%		
% Returns:
%   a_db: The resulting tests_db.
%
% See also: tests_db/plus, tests_db/minus, tests_db/mtimes, tests_db/rdivide
%
% $Id: rop.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/12/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if isa(left_obj, 'tests_db') && isa(right_obj, 'tests_db')
  % check for column consistency
  [left_names, right_names] = ...
      checkConsistentCols(left_obj, right_obj, struct('useCommon', 1));
  if ~length(left_names) || ~length(right_names)
    error('No common columns between two databases!');
  end
  left_data = get(left_obj, 'data');
  % preserve column order of first DB
  right_data = get(onlyRowsTests(right_obj, ':', left_names), 'data');  
  a_db = left_obj;
  an_id = [ get(left_obj, 'id') ' ' op_id ' ' get(right_obj, 'id') ];
elseif isa(left_obj, 'tests_db')
  left_data = get(left_obj, 'data');
  right_data = right_obj;
  a_db = left_obj;
  if isscalar(right_data)
    right_label = num2str(right_data);
  else
    right_label = 'numeric matrix';
  end
  an_id = [ get(left_obj, 'id') ' ' op_id ' ' right_label ];
else
  if ~isnumeric(left_obj)
    error(['Array division is defined only between tests_db objects and scalars. ' ...
	   'You gave the type: ' class(left_obj) '.' ]);
  end

  % left's a scalar, right one must be a DB for us to be here
  right_data = get(right_obj, 'data');
  left_data = left_obj * ones(size(1, right_data), 1) * ones(1, size(2, right_data));
  an_id = [ num2str(a_scalar) ' ' op_id ' ' get(right_obj, 'id') ];
  a_db = right_obj;
end

a_db = set(a_db, 'id', an_id);
a_db = set(a_db, 'data', feval(op_func, left_data, right_data));
