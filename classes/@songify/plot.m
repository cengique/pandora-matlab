function h = plot(t, title_str)

% plot - Plots songify.
%
% Usage:
% h = plot(t)
%
% Description:
%
%   Parameters:
%	t: A songify object.
%	title_str: (Optional) String to append to plot title.
%
%   Returns:
%	h: Handle to figure object.
%
% See also: songify, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

title_one = 'Waveform';
title_two = 'Spectrogram';

if exist('title_str', 'var')
    title_one = [title_str, ' (', title_one, ')'];
    title_two = [title_str, ' (', title_two, ')'];
end

h = figure;

a(1) = subplot(2,1,1);

plot((1:numel(t.data))*t.dt, t.data*t.dy);
title(title_one);
xlabel('Time');
ylabel('Amplitude');

a(2) = subplot(2,1,2);

imagesc(t.sgram.timerange, t.sgram.freqrange, log(abs(t.sgram.data) + 3));
set(gca, 'YDir', 'normal');
title(title_two);
xlabel('Time');
ylabel('Frequency');

linkaxes(a, 'x');