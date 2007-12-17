function a_plot = plot_inset(plots, axis_locations, title_str, props)

% plot_inset - Superpose multiple plots with individual axis at arbitrary locations.
%
% Usage:
% a_plot = plot_inset(plots, axis_locations, title_str, props)
%
% Description:
%   Subclass of plot_abstract. Contains other plot_abstract objects or
% subclasses thereof to be layout in arbitaray format. Allows overlapping
% and therefore good for insets and special plots.
%
%   Parameters:
%	plots: Cell array of plot_abstract or subclass objects.
%	axis_locations: Matrix of four-element vectors for each given plot.
%	title_str: Title to go on top of the stack
%	props: A structure with any optional properties.
%	  positioning: axis_locations interpreted as 'absolute' values or
%	  	'relative' to the 1st plot (default='absolute'). 
%		Relative positioning doesn't work well.
%		
%   Returns a structure object with the following fields:
%	plot_abstract, plots, axis_locations.
%
% General operations on plot_inset objects:
%   plot_inset		- Construct a new plot_inset object.
%   plot		- Layout this stack at given axis position.
%
% Additional methods:
%	See methods('plot_inset')
%
% See also: plot_abstract, plot_abstract/plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/06/05

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  a_plot.plots = {};
  a_plot.axis_locations = [];
  a_plot = class(a_plot, 'plot_inset', plot_abstract);
 elseif isa(plots, 'plot_inset') % copy constructor?
   a_plot = plots;
 else
   if ~ exist('props', 'var')
     props = struct([]);
   end

   if ~ exist('axis_locations', 'var') || isempty(axis_locations)
     axis_locations = repmat([0 0 1 1], length(plots), 1);
   end

   if ~ exist('title_str', 'var')
     title_str = '';
   end

   if ~ iscell(plots)
     plots = num2cell(plots);
   end
   
   a_plot.plots = plots;
   a_plot.axis_locations = axis_locations;

   % Initialize with empty plot_abstract instance
   % because we override most of the default behavior
   % defined there anyway. 
   a_plot = ...
       class(a_plot, 'plot_inset', ...
	     plot_abstract([], {}, title_str, {}, '', props));
end

