function a_p = plot_abstract(a_mesh, title_str, props)

% plot_abstract - Prepare a plot the of the 3D mesh.
%
% Usage:
% a_p = plot_abstract(a_mesh, title_str, props)
%
% Parameters:
%   a_mesh: A voltage clamp object.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%     quiet: If 1, only use given title_str.
%		
% Returns:
%   a_p: A plot_abstract object.
%
% Description:
%   Can be stacked or superposed with other plot objects.
%
% Example:
% >> a_mesh = mesh_amira('my_amira.am', 'Neuron 1')
% >> plotFigure(plot_abstract(a_mesh, ' - side view'))
%
% See also: plotFigure, plot_superpose, plot_stack
%
% $Id: plot_abstract.m 456 2011-05-09 20:53:12Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2012/02/03

% Copyright (c) 2012 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);
title_str = defaultValue('title_str', '');

if isfield(props, 'quiet')
  all_title = properTeXLabel(title_str);
else
  all_title = ...
      properTeXLabel([ cell_name title_str ]);
end

% Go through vertices and plot edges as cylinders