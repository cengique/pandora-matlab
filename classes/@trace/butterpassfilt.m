function t = butterpassfilt(t, n, cutoff_freq, filter_type)

% butterpassfilt - Applies a Butterworth filter to the trace data.
%
% Usage:
% t = butterpassfilt(t, n, cutoff_freq)
%
% Parameters:
%   t: A trace object.
%   n: Order of the filter (e.g., 2)
%   cutoff_freq: Cutoff frequency, max <= sampling rate/2 [Hz]. (can be
%   array)
%   filter_type: The type of filer to perform (e.g., low, high,
%   band, stop)
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

if ~ exist('filter_type', 'var')
    filter_type = 'low';
    sz = size(cutoff_norm);
    if sz(2) == 2
        filter_type = 'band';
    end
end

switch filter_type
    case 'high'
        [b, a] = butter(n, cutoff_norm, "high");
    case 'band'
        [b, a] = butter(n, cutoff_norm, "bandpass");
    case 'stop'
        [b, a] = butter(n, cutoff_norm, "stop");
    otherwise
        [b, a] = butter(n, cutoff_norm);
end

data = get(t, 'data');

for col_num=1:size(data, 2)
  data(:, col_num) = filtfilt(b, a, data(:, col_num));
end

t = set(t, 'data', data);
