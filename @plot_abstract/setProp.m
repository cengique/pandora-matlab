function b = setProp(obj, attr, val)
% setProp - Generic method for setting optional object attributes.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/22
try
  a = obj.props;
  eval(['a(1).' attr ' = val;']);
  b = set(obj, 'props', a);
catch
  rethrow(lasterror);
end
