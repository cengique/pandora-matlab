function a_plot = plotData(t, title_str, props)

% plotData - Plots a trace.
%
% Usage: 
% a_plot = plotData(t, title_str, props)
%
% Description:
%   If t is a vector of traces, returns a vector of plot objects.
%
%   Parameters:
%	t: A trace object.
%	title_str: (Optional) String to append to plot title.
%	props: A structure with any optional properties.
%	  timeScale: 's' for seconds, or 'ms' for milliseconds.
%	  quiet: If 1, only display given title_str.
%	  (rest passed to plot_abstract.)
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%
% See also: trace, trace/plot, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

title_str = defaultValue('title_str', '');

a_plot = plot_abstract(t, title_str, props);
