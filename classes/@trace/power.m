function res_tr = power(left_tr, right_tr, props)

% power -  left_tr to the power of right_tr (either can be scalars).
%
% Usage:
% res_tr = power(left_tr, right_tr, props)
%
% Parameters:
%   left_tr, right_tr: trace objects.
%   props: A structure with any optional properties.
%
% Returns:
%   res_tr: resulting trace object
%
% Description:
%
% Example:
% >> res_tr = power(vc1, 3)
% OR
% >> res_tr = vc1 .^ 2;
% plot the resulting trace
% >> plot(res_tr)
%
% See also: trace, power
%
% $Id: power.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/11/09

if ~ exist('props', 'var')
  props = struct;
end

res_tr = binary_op(left_tr, right_tr, @power, '.^');
