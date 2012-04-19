function sub_tr = plus(left_tr, right_tr, props)

% plus - Subtract trace object right_tr from left_tr.
%
% Usage:
% sub_tr = plus(left_tr, right_tr, props)
%
% Parameters:
%   left_tr, right_tr: trace objects.
%   props: A structure with any optional properties.
%		
% Returns:
%   sub_tr: trace object with subtracted data of left_tr.
%
% Description:
%
% Example:
% >> sub_tr = plus(vc1, vc2)
% OR
% >> sub_tr = vc1 + vc2;
% plot the subtracted voltage clamp
% >> plot(sub_tr)
%
% See also: trace, plus
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/11

if ~ exist('props', 'var')
  props = struct;
end

sub_tr = binary_op(left_tr, right_tr, @plus, '+');
