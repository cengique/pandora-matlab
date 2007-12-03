function a = set(a, varargin)
% set - Generic method for setting object attributes.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.
attr = varargin{1};
val = varargin{2};
if ~ isa(a, 'plot_abstract')
  builtin('set', a, attr, val);
else
  a.(attr) = val;
end
% recurse
if nargin > 3
  a = set(a, varargin{3:end});
end