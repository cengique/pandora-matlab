function res_tr = uminus(a_tr, props)

% uminus - Revert sign of trace object.
%
% Usage:
% res_tr = uminus(a_tr, props)
%
% Parameters:
%   a_tr: A trace object.
%   props: A structure with any optional properties.
%		
% Returns:
%   res_tr: Resulting trace object.
%
% Description:
%
% Example:
% >> a_tr = uminus(vc1)
% OR
% >> a_tr = -vc1;
% plot the result
% >> plot(a_tr)
%
% See also: trace, uminus
%
% $Id: uminus.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/11

if ~ exist('props', 'var')
  props = struct;
end

res_tr = unary_op(a_tr, @uminus, '-');
