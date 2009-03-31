function a_plot = plotVarBox(a_db, test1, test2, notch, sym, vert, whis, props)

% plotVarBox - Generates a boxplot of the variation between two tests.
%
% Usage:
% a_plot = plotVarBox(a_db, test1, test2, notch, sym, vert, whis, props)
%
% Description:
%   It is assumed that each page of the db contains a different parameter value.
%
%   Parameters:
%	a_db: A tests_3D_db object.
%	test1: Test column for the x-axis, only mean values are used.
%	test2: Test column for the y-axis, used for boxplot.
%	notch, sym, vert, whis: See boxplot, defaults = (1, '+', 1, 1.5).
%	props: Optional properties to be passed to plot_abstract.
%		
%   Returns:
%	a_plot: A plot_abstract object or one of its subclasses.
%
% See also: boxplot, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct([]);
end

if ~ exist('notch', 'var')
   notch = 1;
end

if ~ exist('sym', 'var')
  sym = '+';
end

if ~ exist('vert', 'var')
  vert = 1;
end

if ~ exist('whis', 'var')
  whis = 1.5;
end

% Assuming the 3D_db is made especially for test1, it can be reused for multiple test2s.
if ischar(test2)
  num_test2s = 1;
else
  num_test2s = length(test2);
end
if num_test2s > 1
  % Then, vectorize the plots
  [a_plot(1:num_test2s)] = deal(plot_abstract);
  for test2_num = 1:num_test2s
    a_plot(test2_num) = plotVarBox(a_db, test1, test2{test2_num}, ...
				   notch, sym, vert, whis, props);
  end

else

col1 = tests2cols(a_db, test1);
col2 = tests2cols(a_db, test2);

% Setup lookup tables
col_names = fieldnames(get(a_db, 'col_idx'));
data = get(a_db, 'data');

% remove the column dimension from in-between
% (squeeze me macaroni)
col1data = squeeze(data(:, col1, :)); % Grouping variable
col2data = squeeze(data(:, col2, :));

% Flatten into a single dimension, since boxplot can still distinguish by looking
% at distinct values of the grouping variable
% (see "help reshape the world")
bicoldata = [reshape(col1data, prod(size(col1data)), 1), ...
	     reshape(col2data, prod(size(col2data)), 1)];

% Remove rows with any NaN values since they will disrupt the statistics
bicoldata = bicoldata(~any(isnan(bicoldata), 2) & ~any(isinf(bicoldata), 2), :);

col1name = strrep(col_names{col1}, '_', ' ');
col2name = strrep(col_names{col2}, '_', ' ');

if isfield(props, 'quiet')
  all_title = '';
else
  all_title = ['Variations in ' lower(get(a_db, 'id')) ];
end

a_plot = plot_abstract({bicoldata(:, 2), bicoldata(:, 1), ...
			notch, sym, vert, whis, struct('nooutliers', 1)}, ...
		       {col1name, col2name}, ...
		       all_title, {}, 'boxplotp', props);
end