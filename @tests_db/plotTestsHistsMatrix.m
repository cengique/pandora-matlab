function a_pm = plotTestsHistsMatrix(a_db, title_str)

% plotTestsHistsMatrix - Create a matrix plot of test histograms.
%
% Usage:
% a_pm = plotTestsHistsMatrix(a_db, title_str)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A params_tests_db object.
%	title_str: (Optional) A string to be concatanated to the title.
%		
%   Returns:
%	a_pm: A plot_stack with the plots organized in matrix form
%
% See also: params_tests_profile, plotVar
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

if ~ exist('title_str')
  title_str = '';
end

a_pm = matrixPlots(plot_abstract(testsHists(a_db), 'bar', ...
				 struct('rotateXLabel', 20)), ...
		   {}, ['Measure histograms for ' get(a_db, 'id') title_str ]);

