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

[left_data left_name a_tr] = getData(left_tr, []);
[right_data right_name a_tr] = getData(right_tr, a_tr);

sub_tr = set(a_tr, 'data', left_data - right_data);
sub_tr = set(sub_tr, 'id', [left_name ' sub ' right_name ]);

end

function [data name a_tr] = getData(tr, a_tr)
if isa(tr, 'trace')
  data = get(tr, 'data');
  if isempty(a_tr), a_tr = tr; end
  name = get(tr, 'id');
elseif isnumeric(tr)
  data = tr;
  name = 'a constant';
else
  disp('Cannot use in subtraction:');
  disp(class(tr));
  error('One of the operands is neither a trace or numeric data. See above.');
end

end