function a_ps = plotParamsHists(a_db, title_str, props)

% plotParamsHists - Create a horizontal plot_stack of parameter histograms.
%
% Usage:
% a_ps = plotParamsHists(a_db, title_str, props)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A params_tests_db object.
%	title_str: (Optional) A string to be concatanated to the title.
%	props: A structure with any optional properties.
%	  quiet: Do not display the DB id on the plot title.
%		
%   Returns:
%	a_ps: A horizontal plot_stack of plots
%
% See also: plot_stack, paramsHists, plotEqSpaced
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/07

if ~exist('props')
  props = struct;
end

if ~exist('title_str')
  title_str = '';
end

if ~ isfield(props, 'quiet') && ~ isfield(get(a_db, 'props'), 'quiet')
  title_str = ['Parameter histograms of ' get(a_db, 'id') title_str ];
end

a_ps = plot_stack(plotEqSpaced(paramsHists(a_db)), [], 'x', title_str, ...
		  mergeStructs(props, struct('titlesPos', 'none', 'yLabelsPos', 'left')));