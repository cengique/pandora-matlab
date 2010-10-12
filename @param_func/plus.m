function plus_pf = plus(left_pf, right_pf, props)

% plus - Add function objects right_pf and left_pf.
%
% Usage:
% plus_pf = plus(left_pf, right_pf, props)
%
% Parameters:
%   left_pf, right_pf: param_func objects.
%   props: A structure with any optional properties.
%		
% Returns:
%   plus_pf: trace object with subtracted data of left_pf.
%
% Description:
%
% Example:
% >> plus_pf = plus(vc1, vc2)
% OR
% >> plus_pf = vc1 + vc2;
% plot the result
% >> plot(plus_pf)
%
% See also: param_func, plus
%
% $Id: plus.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/11

plus_pf = binary_op(left_pf, right_pf, @plus, '+');
