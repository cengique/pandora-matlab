function a_db = minus(left_obj, right_obj)

% minus - Subtracts two DBs or a scalar from one.
%
% Usage:
% a_db = minus(left_obj, right_obj)
%
% Description:
%   If DBs have mismatching columns only the common columns will be kept.
% In any case, the resulting DB columns will be sorted in the order of the
% left-hand-side DB.
%
%   Parameters:
%	left_obj, right_obj: Operands of the subtraction. One must be of type tests_db
%		and the other can be a scalar.
%		
%   Returns:
%	a_db: The resulting tests_db.
%
% See also: minus
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/24

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if isa(left_obj, 'tests_db') && isa(right_obj, 'tests_db')
  %# check for column consistency
  [left_names, right_names] = ...
      checkConsistentCols(left_obj, right_obj, struct('useCommon', 1));
  left_data = get(left_obj, 'data');
  %# preserve column order of first DB
  right_data = get(onlyRowsTests(right_obj, ':', left_names), 'data');  
  a_db = left_obj;
  an_id = [ get(left_obj, 'id') ' - ' get(right_obj, 'id') ];
elseif isa(left_obj, 'tests_db')
  left_data = get(left_obj, 'data');
  right_data = right_obj;
  a_db = left_obj;
  an_id = [ get(left_obj, 'id') ' - ' num2str(right_data) ];
else
  if ~isnumeric(left_obj)
    error(['Subtraction is defined only between tests_db objects and scalars. ' ...
	   'You gave the type: ' class(left_obj) '.' ]);
  end

  %# left's a scalar, right one must be a DB for us to be here
  right_data = get(right_obj, 'data');
  left_data = left_obj * ones(size(1, right_data), 1) * ones(1, size(2, right_data));
  an_id = [ num2str(a_scalar) ' - ' get(right_obj, 'id') ];
  a_db = right_obj;
end

a_db = set(a_db, 'id', an_id);
a_db = set(a_db, 'data', left_data - right_data);
