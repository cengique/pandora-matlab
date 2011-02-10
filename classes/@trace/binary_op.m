function result_tr = binary_op(left_tr, right_tr, op_func, op_id, props)

% binary_op - Generic binary operator applications for trace objects.
%
% Usage:
% result_tr = binary_op(left_tr, right_tr, op_func, op_id, props)
%
% Parameters:
%   left_tr, right_tr: trace objects.
%   op_func: Operation function (e.g., @plus).
%   op_id: A string to represent the operation that will show up in the
%   	  returned id.
%   props: A structure with any optional properties.
%		
% Returns:
%   result_tr: Resulting trace object.
%
% Description:
%
% Example:
% >> result_tr = binary_op(vc1, vc2, @minus, '-')
%
% See also: trace, plus, minus
%
% $Id: binary_op.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/05/21

if ~ exist('props', 'var')
  props = struct;
end

[left_data left_name a_tr] = getData(left_tr, []);
[right_data right_name a_tr] = getData(right_tr, a_tr);

result_tr = set(a_tr, 'data', feval(op_func, left_data, right_data));
result_tr = set(result_tr, 'id', ['(' left_name ' ' op_id ' ' right_name ')']);

end

function [data name a_tr] = getData(tr, a_tr)
if isa(tr, 'trace')
  data = get(tr, 'data');
  if isempty(a_tr), a_tr = tr; end
  name = get(tr, 'id');
elseif isnumeric(tr)
  data = tr;
  if length(tr) > 1
    name = 'a constant vector';
  else
    name = num2str(tr);
  end
else
  disp('Cannot use in subtraction:');
  disp(class(tr));
  error('One of the operands is neither a trace or numeric data. See above.');
end

end