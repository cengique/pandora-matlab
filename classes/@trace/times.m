function res_tr = times(left_tr, right_tr, props)

% times - Scalar multiply trace object right_tr with left_tr.
%
% Usage:
% res_tr = times(left_tr, right_tr, props)
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
% >> res_tr = times(vc1, vc2)
% OR
% >> res_tr = vc1 .* vc2;
% plot the resulting trace
% >> plot(res_tr)
%
% See also: trace, times
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/11

if ~ exist('props', 'var')
  props = struct;
end

res_tr = binary_op(left_tr, right_tr, @times, '.*');
