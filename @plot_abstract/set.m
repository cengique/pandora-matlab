function b = set(a, varargin)
% set - Generic method for setting object attributes.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08
attr = varargin{1};
val = varargin{2};
if ~ isa(a, 'plot_abstract')
  builtin('set', a, attr, val);
else
  eval(['a.' attr ' = val;']);
  b = a;
end
% recurse
if nargin > 3
  b = set(a, varargin{3:end});
end