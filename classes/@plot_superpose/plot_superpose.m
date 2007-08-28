function obj = plot_superpose(plots, axis_labels, title_str, props)

% plot_superpose - Multiple plot_abstract objects superposed on the same axis.
%
% Usage:
% obj = plot_superpose(plots, axis_labels, title_str, props)
%
% Description:
%   Subclass of plot_abstract. Contains multiple plot_abstract objects to be
% plotted on the same axis. This is different than the
% plot_abstract/superpose, where only using the same plot command is
% allowed.  Here, each plot_abstract can have its own special plotting
% command. Subclasses of plot_abstract is also allowed here. The decorations
% comes from this object and not children plots. This behavior is different
% than plot_stack, where each plot has its own decorations. If you want each
% plot to have its own axis (e.g. an inset, or plot with multiple axis
% labels) then you should use plot_inset.
%
%   Parameters:
%	plots: Cell array of plot_abstract or subclass objects.
%	axis_labels: Cell array of axis label strings.
%	title_str: Plot description string.
%	props: A structure with any optional properties (passed to plot_abstract).
%		
%   Returns a structure object with the following fields:
%	plot_abstract, plots
%
% General operations on plot_superpose objects:
%   plot_superpose	- Construct a new plot_superpose object.
%   plot		- Plots this plot in the current axis. Abstract method,
%			needs to be defined for each subclass.
%
% Additional methods:
%	See methods('plot_superpose')
%
% See also: plot_abstract/superpose, plot_superpose/plot
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

%# TODO: decoration controls imposed by plot_stack is ignored!

if nargin == 0 %# Called with no params
  obj.plots = {};
  obj = class(obj, 'plot_superpose', plot_abstract);
elseif isa(plots, 'plot_superpose') %# copy constructor?
  obj = plots;
else
   if ~ exist('props')
     props = struct([]);
   end

   if ~ exist('axis_labels')
     axis_labels = [];
   end

   if ~ exist('title_str')
     title_str = '';
   end

   if ~ iscell(plots)
     plots = mat2cell(plots);
   end

   %# Check if plots are of same kind to call preferred superposePlots method instead
   plot_class = '';
   plot_command = '';
   superposable = true;
   %# replicate the first plot to pre-allocate the array
   plot_array = plots{1};
   for plot_num=1:length(plots)

     %# check if same plot classes are used
     if isempty(plot_class)
       plot_class = class(plots{plot_num});
     else
       %# break if different plot classes are combined
       if ~strcmp(plot_class, class(plots{plot_num}))
	 superposable = false;
	 break;
       end
     end 

     %# If same class, add to array
     plot_array(plot_num) = plots{plot_num};

     if strcmp(plot_class, 'plot_abstract')
       if isempty(plot_command)
	 plot_command = plots{plot_num}.command;
       else
	 %# break if different plot commands in plot_abstracts are combined
	 if ~strcmp(plot_command, plots{plot_num}.command)
	   superposable = false;
	   break;
	 end
       end
     end
   end

   %# Leave the constructor and call superposePlots
   if superposable
     obj = superposePlots(plot_array);
     return;
   end

  obj.plots = plots;

  legend = {};
  %# Check if contained plots feature axis_labels
  for plot_num=1:length(plots)
    plot_axis_labels = get(plots{plot_num}, 'axis_labels');

    if ~isempty(plot_axis_labels) 
      if ~isempty(plot_axis_labels{1})
	axis_labels{1} = plot_axis_labels{1};
      end
      if ~isempty(plot_axis_labels{2})
	axis_labels{2} = plot_axis_labels{2};
      end
    end

    plot_legend = get(plots{plot_num}, 'legend');
    if ~ isempty(plot_legend)
      legend = { legend{:}, plot_legend{1}};
    else
      legend = { legend{:}, ''};
    end
  end

  if isempty(title_str)
    title_str = plots{1}.title;
  end

  obj = class(obj, 'plot_superpose', plot_abstract({}, axis_labels, title_str, ...
						   legend, '', props));
end

