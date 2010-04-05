function sub_tr = minus(left_tr, right_tr, props)

% minus - Subtract trace object right_tr from left_tr.
%
% Usage:
% sub_tr = minus(left_tr, right_tr, props)
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
% >> sub_tr = minus(vc1, vc2)
% OR
% >> sub_tr = vc1 - vc2;
% plot the subtracted voltage clamp
% >> plot(sub_tr)
%
% See also: trace, minus
%
% $Id: minus.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/11

if ~ exist('props', 'var')
  props = struct;
end

sub_tr = set(left_tr, 'data', get(left_tr, 'data') - get(right_tr, 'data'));
sub_tr = set(sub_tr, 'id', [get(left_tr, 'id') ' sub ' get(right_tr, 'id') ]);
