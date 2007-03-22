function a_pm = plot_abstract(a_db, title_str, props)

% plot_abstract - Default visualization for a database.
%
% Usage:
% a_pm = plot_abstract(a_db, title_str)
%
% Description:
%   Calls plotTestsHistsMatrix. Subclasses should override this method
% to provide their own visualization.
%
%   Parameters:
%	a_db: A params_tests_db object.
%	title_str: (Optional) A string to be concatanated to the title.
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_pm: A plot_stack with the plots organized in matrix form
%
% Example:
%   >> plot(my_db, ': first impression')
% will call this function and send the generated plot to the plotFigure function.
%
% See also: plot_abstract/plot_abstract, plotTestsHistsMatrix, plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/17

if ~ exist('title_str')
  title_str = '';
end

if ~ exist('props')
  props = struct;
end

a_pm = plotTestsHistsMatrix(a_db, title_str, props);

