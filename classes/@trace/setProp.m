function obj = setProp(obj, varargin)
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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/22
num = length(obj);
if num > 1
  %# If a vector, loop and do for all
  for i=1:num
    obj(i) = setProp(obj(i), varargin{:});
  end
else
  for index=1:2:length(varargin)
    attr = varargin{index};
    val = varargin{index + 1};
    try
      a = obj.props;
      a(1).(attr) = val;
      obj = set(obj, 'props', a);
    catch
      rethrow(lasterror);
    end
  end
end