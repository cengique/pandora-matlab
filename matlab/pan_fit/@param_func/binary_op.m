function result_obj = binary_op(left_obj, right_obj, op_func, op_id, props)

% binary_op - Generalized binary operation between param_func objects.
%
% Usage:
% result_obj = binary_op(left_obj, right_obj, op_func, op_id, props)
%
% Parameters:
%   left_obj, right_obj: param_func or subclass objects.
%   op_func: Operation function (e.g., @plus).
%   op_id: A string to represent the operation that will show up in the
%   	  returned id.
%   props: A structure with any optional properties.
%		
% Returns:
%   result_obj: a new param_func object that contains the result of the operation.
%
% Description:
%
% Example:
% >> result_obj = binary_op(a_pf1, a_pf2, @minus, '-')
%
% See also: param_func, plus, minus, times, power
%
% $Id: binary_op.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/11

if ~ exist('props', 'var')
  props = struct;
end

pf_obj = [];
pf_objs = struct;

[func_left left_name] = getOperand(left_obj, 'left');
[func_right right_name] = getOperand(right_obj, 'right');

result_obj = ...
    param_mult(get(pf_obj, 'var_names'), [], {}, ...
               pf_objs, ...
               eval([ '@(fs, p, x) ' func2str(op_func) '(' func_left ', ' ...
                    func_right ')']), ...
               ['(' left_name '' op_id '' right_name ')'], ...
               props);

function [func name] = getOperand(op_obj, left_right)
if isa(op_obj, 'param_func')
  if isempty(pf_obj), pf_obj = op_obj; end
  op_props = get(op_obj, 'props');
  if isfield(op_props, 'name')
    left_right = op_props.name;
  end
  pf_objs.(left_right) = op_obj;
  func = [ 'f(fs.' left_right ', x)' ];
  name = get(op_obj, 'id');
elseif isnumeric(op_obj)
  % is a scalar
  func = [ left_right '_obj' ];
  name = 'a constant';
  if max(size(right_obj)) < 2
    try
      name = num2str(right_obj); % if this doesn't work: 'a constant'
    catch
    end
  end
else
  disp([ 'Cannot use in "' op_id '" operation:']);
  disp(class(op_obj));
  disp(op_obj);
  error('One of the operands is neither a param_func or numeric data. See above.');
end

end

end
