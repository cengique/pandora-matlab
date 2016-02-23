function t = lowpassfilt(t, n, cutoff_freq)

% lowpassfilt - Applies a low-pass Butterworth filter to the trace data.
%
% Usage:
% t = lowpassfilt(t, n, cutoff_freq)
%
% Parameters:
%   t: A trace object.
%   n: Order of the filter (e.g., 2)
%   cutoff_freq: Cutoff frequency, max <= sampling rate/2 [Hz].
%
% Returns:
%   t: updated trace object.
%
% Description:
%
% See also: trace, butter, filter, filtfilt
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/04/08

% Copyright (c) 2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

cutoff_norm = cutoff_freq * get(t, 'dt') * 2;

[b, a] = butter(n, cutoff_norm);

data = get(t, 'data');

for col_num=1:size(data, 2)
  data(:, col_num) = filtfilt(b, a, data(:, col_num));
end

t = set(t, 'data', data);
