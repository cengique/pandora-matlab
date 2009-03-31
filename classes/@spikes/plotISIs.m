function a_plot = plotISIs(s, title_str)

% plotISIs - Plots a spikes object.
%
% Usage: 
% a_plot = plotISIs(s, title_str)
%
% Description:
%   If s is a vector of spikes objects, returns a vector of plot objects.
%
%   Parameters:
%	s: A spikes object.
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%	title_str: (Optional) String to append to plot title.
%
% See also: trace, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/10/21

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str', 'var')
  title_str = '';
end

% If input is an array, then return array of plots
num_dbs = length(s);
if num_dbs > 1 
  % Create array of plots
  [a_plot(1:num_dbs)] = deal(plot_abstract);
  for plot_num = 1:num_dbs
    a_plot(plot_num) = plotISIs(s(plot_num), title_str);
  end
  return;
end

ms_factor = s.dt * 1e3;

% Remove all '_' characters, because they interfere with TeX interpretation
class_name = strrep(class(s), '_', ' ');
isis = getISIs(s) * ms_factor;
a_plot = plot_abstract({s.times(1:end-1) * ms_factor, isis}, ...
		       {'time [ms]', 'ISI [ms]'}, ...
		       [ sprintf('%s ISIs: %s', class_name, s.id) title_str], ...
		       {s.id}, 'plot', struct);
