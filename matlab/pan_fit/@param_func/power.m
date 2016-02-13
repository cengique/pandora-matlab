function a_pf = power(left_pf, right_pf, props)

% power - left_pf to the (array) power of right_pf.
%
% Usage:
% a_pf = power(left_pf, right_pf, props)
%
% Parameters:
%   left_pf, right_pf: param_func objects.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_pf: Resulting object.
%
% Description:
%
% Example:
% >> a_pf = power(vc1, vc2)
% OR
% >> a_pf = vc1 .^ vc2;
% plot the result
% >> plot(a_pf)
%
% See also: param_func, power
%
% $Id: power.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/11

a_pf = binary_op(left_pf, right_pf, @power, '^');
