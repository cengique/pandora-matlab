function a_plot = plot_abstract(a_ps, title_str, props)

% plot_abstract - Creates an object for plotting the function.
%
% Usage:
%   a_plot = plot_abstract(a_ps, title_str, props)
%
% Parameters:
%   a_ps: A param_func object.
%   title_str: (Optional) A string to be concatanated to the title.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_plot: A plot_abstract object that can be plotted.
%
% Description:
%   Calls plotTestsHistsMatrix. Subclasses should override this method
% to provide their own visualization.
%
% Example:
%   >> plot(a_ps, ': first impression')
% will call this function and send the generated plot to the plotFigure
% function. Explicitly:
%   >> plotFigure(plot_abstract(a_ps, ': test'))
%
% See also: plot_abstract/plot_abstract, plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/05/28

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str', 'var')
  title_str = '';
end

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% gather props from the param_func object
props = mergeStructs(props, get(a_ps, 'props'));

x_min = getFieldDefault(props, 'xMin', 0);
x_max = getFieldDefault(props, 'xMax', 1);

x_steps = 100;
x_vals = x_min:(x_max - x_min)/x_steps:x_max;

if ~ isfield(props, 'quiet')
  title_str = [ get(a_ps, 'id') title_str ];
end

a_plot = ...
    plot_abstract({x_vals, f(a_ps, x_vals)}, get(a_ps, 'var_names'), ...
                  title_str, {get(a_ps, 'id')}, 'plot', props);

