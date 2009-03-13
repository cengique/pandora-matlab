function a_p = plotImage(a_db, par1, par2, col, title_str, short_title, props)

% plotImage - Create an image plot of a measure changing with the given two parameters.
%
% Usage:
% a_p = plotImage(a_db, par1, par2, col, title_str, short_title, props)
%
% Parameters:
%	a_db: A tests_db object.
%	par1, par2: X & Y variables.
%	col: Plot this column.
%	title_str: (Optional) A string to be concatanated to the title.
%	short_title: (Optional) Few words that may appear in legends of multiplot.
%	props: A structure with any optional properties.
%	  logScale: If 1, take logarithm of values before plotting.
%	  quiet: If 1, don't include database name on title.
%		
% Returns:
%	a_p: A plot_abstract.
%
% Description:
%
% See also: plotScatter, plotScatter3D
%
% $Id: plotImage.m 1096 2008-05-27 20:24:25Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/02/17

% Copyright (c) 2005-2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if ~ exist('title_str')
  title_str = '';
end

if ~ exist('props')
  props = struct;
end

% only keep what we care about
a_db = sortrows(onlyRowsTests(a_db, ':', {par1, par2, col}), {par1, par2});

% get names
col_names = getColNames(a_db);

% find uniques
par1_values = get(unique(onlyRowsTests(a_db, ':', par1)), 'data');
par2_values = get(unique(onlyRowsTests(a_db, ':', par2)), 'data');

% Make pages for each par2 value
fold_3d_db = groupBy(a_db, par2);

% get rid of the column dimension
image_data = squeeze(get(onlyRowsTests(fold_3d_db, ':', col, ':'), 'data'));

data_label = properTeXLabel(col_names{3});

if isfield(props, 'logScale')
  pos_data = image_data > 0;
  log_cov_data = image_data;
  log_cov_data(pos_data) = log(1 + image_data(pos_data));
  log_cov_data(~pos_data) = - log(1 - image_data(~pos_data));
  image_data = log_cov_data;
  data_label = [ data_label ' (log)' ];
end

if ~ exist('short_title') || isempty(short_title)
  short_title = [ properTeXLabel(col_names{3}) ' with changing ' ...
                  properTeXLabel(col_names{1}) ' and ' ...
                  properTeXLabel(col_names{2}) ];
end

all_title = [ properTeXLabel(get(a_db, 'id')) ': ' short_title title_str ];

axis_labels = properTeXLabel([col_names([2 1])]);

plot_props = struct('XTick', 1:length(par2_values), 'YTick', 1:length(par1_values), ...
                    'border', [0 0 0.05 0], 'colorbar', 1);
plot_props.XTickLabel = par2_values;
plot_props.YTickLabel = par1_values;
plot_props.truncateDecDigits = 2;

if isfield(props, 'quiet')
  plot_props.noTitle = 1;
end

a_p = ...
    plot_image(image_data, axis_labels, data_label, all_title, ...
               mergeStructs(props, plot_props));
