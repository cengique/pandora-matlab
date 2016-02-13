function a_plot = plot_abstract(a_doc, title_str, props)

% plot_abstract - Returns the plot_abstract object within the doc_plot.
%
% Usage: 
% a_plot = plot_abstract(a_doc, title_str, props)
%
% Description:
%   If a_doc is a vector, returns a vector of plot_abstract objects.
%
%   Parameters:
%	a_doc: A doc_plot object.
%	title_str: (Optional) String to replace plot title.
%	props: A structure with any optional properties.
%	  (rest passed to plot_abstract.)
%
%   Returns:
%	a_plot: A plot_abstract object or vector that can be visualized.
%
% See also: doc_plot/plot, plot_abstract
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

if ~ exist('title_str', 'var')
  title_str = '';
end

% If input is an array, then return array of plots
num_docs = length(a_doc);
if num_docs > 1 
  % Create array of plots
  % [a_plot(1:num_docs)] = deal(plot_abstract); causes segfault if plots
  % are subclasses 
  [a_plot(1:num_docs)] = deal(plot_abstract(a_doc(1), title_str, props));
  for plot_num = 1:num_docs
    a_plot(plot_num) = plot_abstract(a_doc(plot_num), title_str, props);
  end
  return;
end

a_plot = get(a_doc, 'plot');

% overwrite the title if requested
if ~ isempty(title_str)
  a_plot = set(a_plot, 'title', title_str);
end

% pass the props to original plot
a_plot = set(a_plot, 'props', mergeStructs(props, get(a_plot, 'props')));
