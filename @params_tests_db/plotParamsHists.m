function a_ps = plotParamsHists(a_db, title_str)

% plotParamsHists - Create a horizontal plot_stack of parameter histograms.
%
% Usage:
% a_ps = plotParamsHists(a_db, title_str)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A params_tests_db object.
%	title_str: (Optional) A string to be concatanated to the title.
%		
%   Returns:
%	a_ps: A horizontal plot_stack of plots
%
% See also: plot_stack, paramsHists, plotEqSpaced
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/07

if ~ exist('title_str')
  title_str = '';
end

a_ps = plot_stack(plotEqSpaced(paramsHists(a_db)), [], 'x', ...
		  ['Parameter histograms of ' get(a_db, 'id') title_str ], ...
		  struct('titlesPos', 'none', 'yLabelsPos', 'left'))