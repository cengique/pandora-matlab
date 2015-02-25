function ranges = axis(a_plot)

% axis - Returns the estimated axis ranges of this plot according to its data.
%
% Usage:
% ranges = axis(a_plot)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%		
%   Returns:
%	ranges: The ranges as a vector in the same way 'axis' would return.
%
% See also: plot_abstract, plot_abstract/plot
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

switch a_plot.command
  case 'errorbar'
    if length(a_plot.data) > 3
      up_data = a_plot.data{4};
    else
      up_data = a_plot.data{3};
    end
    ranges = [ min(a_plot.data{1}) max(a_plot.data{1}) ...
	      min(a_plot.data{2} - a_plot.data{3}) max(a_plot.data{2} + up_data)];
  case 'bar'
    ranges = [ min(a_plot.data{1}) max(a_plot.data{1}) ...
               min(min(a_plot.data{2})) max(max(a_plot.data{2}))];
  otherwise
    if (length(a_plot.data) > 1)
      ranges = [ min(a_plot.data{1}) max(a_plot.data{1}) ...
                 min(a_plot.data{2}) max(a_plot.data{2})];
    else
      ranges = [0 0 0 0];
    end
end

