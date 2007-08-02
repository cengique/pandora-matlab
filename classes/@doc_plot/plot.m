function figure_handle = plot(a_doc, props)

% plot - Default plot method to preview the contained plot in a new figure.
%
% Usage:
% figure_handle = plot(a_doc, props)
%
% Description:
%   Only generate the contained plot for previewing. Opens a new figure.
%
% Parameters:
%	a_doc: A doc_plot object.
%	props: A structure with any optional properties.
%		
% Returns:
%	figure_handle: Handle of newly opened figure.
%
% Example:
%	>> figure_handle = plot(a_doc_plot)
%
% See also: plot_abstract/plotFigure, doc_generate, doc_plot
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/17

figure_handle = plotFigure(get(a_doc, 'plot'));

doc_props = get(a_doc, 'props');

if isfield(doc_props, 'orient')
  orient(figure_handle, doc_props.orient);
end
