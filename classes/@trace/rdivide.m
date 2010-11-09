function res_tr = rdivide(left_tr, right_tr, props)

% rdivide - Scalar divide trace object left_tr by right_tr.
%
% Usage:
% res_tr = rdivide(left_tr, right_tr, props)
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
% >> res_tr = rdivide(vc1, vc2)
% OR
% >> res_tr = vc1 ./ vc2;
% plot the resulting trace
% >> plot(res_tr)
%
% See also: trace, rdivide
%
% $Id: rdivide.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/11/09

if ~ exist('props', 'var')
  props = struct;
end

res_tr = binary_op(left_tr, right_tr, @rdivide, './');
