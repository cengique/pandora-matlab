function val = interpValByIndex(idx, data)
% interpValByIndex - Finds the interpolated value by using the real valued index from the data vector.
%
% Usage:
% val = interpValByIndex(idx, data)
%
% Description:
%   Parameters:
%	idx: A real-valued index.
%	data: A data vector.
%
%   Returns:
%	val: the value taken from the nearest integer indices of data and interpolated.
%
% Example:
% >> a= [1 2 3];
% >> interpValByIndex(1.5, a)
% ans =
%    1.5000
%
% See also: spike_shape
%
% $Id: interpValByIndex.m,v 1.1 2005/10/24 19:42:15 cengiz Exp $
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/08/02
%   Based on @spike_trace/shapestats by Jeremy Edgerton.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Find floor and ceil integers
fi = floor(idx);
ci = ceil(idx);

if fi <= 0 
  val = data(1);
elseif (ci - fi) > 0 
  val = interp1([fi, ci], [data(fi), data(ci)], idx);
else
  val = data(idx);
end
