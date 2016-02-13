function t = medianfilt(t, window_size)

% medianfilt - Applies a median filter to the trace data.
%
% Usage:
% t = medianfilt(t, window_size)
%
% Parameters:
%   t: A trace object.
%   window_size: N parameter of medianfilt1 (default=3).
%
% Returns:
%   t: updated trace object.
%
% Description:
%
% See also: trace, medianfilt1
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/04/05

% Copyright (c) 2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

window_size = defaultValue('window_size', 3);

t = set(t, 'data', medfilt1(get(t, 'data'), window_size));