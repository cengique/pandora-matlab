function h = plot(a_hist_db, command)

% plot - Plots this histogram in a fingure.
%
% Usage:
% h = plot(a_hist_db, command)
%
% Description:
%
%   Parameters:
%	a_hist_db: A histogram_db object.
%	command: Plot command (Optional, default='bar')
%		
%   Returns:
%	h: The figure handle created.
%
% See also: plot_abstract, plotFigure
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

%# Defaults
if ~ exist('command')
  command = 'bar';
end

h = plotFigure(plot_abstract(a_hist_db, command));
