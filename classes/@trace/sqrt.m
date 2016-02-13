function res_tr = sqrt(a_tr, props)

% sqrt - Square root of trace object.
%
% Usage:
% res_tr = sqrt(a_tr, props)
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
% >> a_tr = sqrt(vc1)
% plot the result
% >> plot(a_tr)
%
% See also: trace, sqrt
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/11

if ~ exist('props', 'var')
  props = struct;
end

res_tr = unary_op(a_tr, @sqrt, 'sqrt');
