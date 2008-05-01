function a_plot = plotCovar(a_db, title_str, props)

% plotCovar - Generates an image plot of the covariance-type values in a_db.
%
% Usage:
% a_plot = plotCovar(a_db, title_str, props)
%
% Description:
%
%   Parameters:
%	a_db: A tests_db object that resulted from a function like cov.
%	title_str: (Optional) String to append to plot title.
%	props: Optional properties.
%	  inverse: If 1, take inverse of the data matrix.
%	  corrcoef: If 1, normalize matrix elements to get corrcoef values.
%	  logScale: If 1, take logarithm of values before plotting.
%	  localityIters: Apply a locality optimization algorithm with
%	  	this many iterations.
%	  (rest passed to plot_image.)
%		
%   Returns:
%	a_plot: A plot_abstract object or one of its subclasses.
%
% Example:
% >> plotFigure(plotCovar(cov(get(constrainedMeasuresPreset(pbundle2, 6), 'joined_control_db'))));
%
% See also: tests_db/cov, plotImage, tests_db/matchingRow, corrcoefs.
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/05/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct;
end

% TODO: put some sanity checks to make sure this DB is not too big to
% plot

image_data = a_db.data(:, :, 1);

if isa(a_db, 'tests_3D_db')
  data_label = fieldnames(get(a_db, 'page_idx'))
  data_label = data_label{1};
else
  data_label = 'covariance';
end

% normalize
if isfield(props, 'corrcoef')
  selfcov_rows = diag(image_data) * ones(1, size(image_data, 2));
  image_data = image_data ./ sqrt(selfcov_rows .* selfcov_rows');
  data_label = 'cross correlation';
end

% take inverse if requested
if isfield(props, 'inverse')
  image_data = inv(image_data);
  data_label = [ 'inverse ' data_label ];
end

% log scale
if isfield(props, 'logScale')
  pos_data = image_data > 0;
  log_cov_data = image_data;
  log_cov_data(pos_data) = log(1 + image_data(pos_data));
  log_cov_data(~pos_data) = - log(1 - image_data(~pos_data));
  image_data = log_cov_data;
  data_label = [ data_label ' in log-scale' ];
end

% optimize locality
if isfield(props, 'localityIters')
  [image_data shuffle_idx] = ...
      optimize_cov_matrix(image_data, props.localityIters);
else
  shuffle_idx = 1:size(image_data, 1);
end

num_colors = 49;

if ~ exist('title_str') || isempty(title_str)
  title_str = [properTeXLabel(get(a_db, 'id'))];
end

plot_props = struct('YTick', 1:dbsize(a_db, 1), 'border', [0.07 0 0.03 0], ...
                    'colorbar', 1, 'XTick', []);
col_names = getColNames(a_db);
plot_props.YTickLabel = properTeXLabel(col_names(shuffle_idx));

plot_props.truncateDecDigits = 2;

a_plot = ...
    plot_image(image_data, {}, properTeXLabel(data_label), title_str, ...
               mergeStructs(props, plot_props));
end

function [image_data, idx] = optimize_cov_matrix(image_data, num_iters)

total_entropy = inf;
num_rows = size(image_data, 1);
idx=1:num_rows;
for iter_num = 1:num_iters
  cand_row_1 = ceil(rand(1) * num_rows);
  cand_row_2 = ceil(rand(1) * num_rows);
  
  new_image_data = image_data;
  new_image_data([cand_row_1 cand_row_2], :) = ...
      image_data([cand_row_2 cand_row_1], :);
  new_image_data(:, [cand_row_1 cand_row_2]) = ...
      new_image_data(:, [cand_row_2 cand_row_1]);
  
  new_entropy = entropy_cov_matrix(new_image_data);
  
  % accept if ended up in lower energy or by 10% chance
  if new_entropy < total_entropy %|| rand(1) < 0.1
    image_data = new_image_data;
    total_entropy = new_entropy;
    idx([cand_row_1 cand_row_2]) = idx([cand_row_2 cand_row_1]);
  end
  
  % must keep track of flips if it works
end

end

function entropy_val = entropy_cov_matrix(image_data)

diff_vals = diff(image_data, 1, 1);
entropy_val = sum(sum(abs(diff_vals(~isnan(diff_vals)))));

end