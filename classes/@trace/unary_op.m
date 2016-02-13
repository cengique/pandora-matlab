function result_tr = unary_op(a_tr, op_func, op_id, props)

% unary_op - Generic unary operator applications for trace objects.
%
% Usage:
% result_tr = unary_op(a_tr, op_func, op_id, props)
%
% Parameters:
%   a_tr: A trace object.
%   op_func: Unary operation function (e.g., @uminus).
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
% >> result_tr = unary_op(vc1, @uminus, '-')
%
% See also: trace, binary_op, uminus, sqrt
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/11/09

if ~ exist('props', 'var')
  props = struct;
end

data = get(a_tr, 'data');
name = get(a_tr, 'id');

result_tr = set(a_tr, 'data', feval(op_func, data));
result_tr = set(result_tr, 'id', [op_id '(' name ')']);

end