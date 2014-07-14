function handles = decorate(a_plot, plot_handles)

% decorate - Places decorations using the first plot of the superposed plots.
%
% Usage:
% handles = decorate(a_plot, plot_handles)
%
% Parameters:
%   a_plot: A plot_abstract object, or a subclass object.
%   plot_handles: Handles of plots already drawn (structure returned by
%   	plot_superpose/plot). 
%		
% Returns:
%   handles: Handles of graphical objects drawn.
%
% Description:
%
% See also: plot_abstract, plot_abstract/plot
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/11

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Get props from plot_superpose
to_plot = set(a_plot, 'props', ...
	      mergeStructs(get(a_plot, 'props'), get(a_plot.plots{1}, 'props')));

handles = decorate(to_plot.plot_abstract, plot_handles);
