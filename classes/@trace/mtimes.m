function res_tr = mtimes(left_tr, right_tr, props)

% mtimes - Matrix multiply trace object right_tr with left_tr.
%
% Usage:
% res_tr = mtimes(left_tr, right_tr, props)
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
% >> res_tr = mtimes(vc1, vc2)
% OR
% >> res_tr = vc1 * vc2;
% plot the resulting trace
% >> plot(res_tr)
%
% See also: trace, mtimes
%
% $Id: mtimes.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/11

if ~ exist('props', 'var')
  props = struct;
end

res_tr = binary_op(left_tr, right_tr, @mtimes, '*');
