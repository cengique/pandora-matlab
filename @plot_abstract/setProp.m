function b = setProp(obj, varargin)
% setProp - Generic method for setting optional object properties.
%
% Usage:
% obj = setProp(obj, prop1, val1, prop2, val2, ...)
%
% Description:
%   Modifies or adds property values. As many property name-value 
% pairs can be specified.
%
%   Parameters:
%	obj: Any object that has a props field.
%	attr: Property name
%	val: Property value.
%
%   Returns:
%	obj: The new object with the updated properties.
%
% See also: 
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/22

for index=1:2:length(varargin)
  attr = varargin{index};
  val = varargin{index + 1};
  try
    a = obj.props;
    a(1).(attr) = val;
    b = set(obj, 'props', a);
  catch
    rethrow(lasterror);
  end
end
