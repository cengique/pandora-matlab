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
%	props: Optional properties to be passed to plot_abstract.
%	  inverse: If 1, take inverse of the data matrix.
%	  crosscoef: If 1, normalize matrix elements as crosscoef would a cov matrix.
%	  logScale: If 1, take logarithm of values before plotting.
%		
%   Returns:
%	a_plot: A plot_abstract object or one of its subclasses.
%
% Example:
% >> plotFigure(plotCovar(cov(get(constrainedMeasuresPreset(pbundle2, 6), 'joined_control_db'))));
%
% See also: tests_db/cov, plotImage, tests_db/matchingRow.
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/05/30

if ~ exist('props')
  props = struct;
end

% TODO: put some sanity checks to make sure this DB is not too big to
% plot

image_data = a_db.data;

% normalize
if isfield(props, 'crosscoef')
  selfcov_rows = diag(image_data) * ones(1, size(image_data, 2));
  image_data = image_data ./ sqrt(selfcov_rows .* selfcov_rows');
end

% take inverse if requested
if isfield(props, 'inverse')
  image_data = inv(image_data);
end

% log scale
if isfield(props, 'logScale')
  pos_data = image_data > 0;
  log_cov_data = image_data;
  log_cov_data(pos_data) = log(1 + image_data(pos_data));
  log_cov_data(~pos_data) = - log(1 - image_data(~pos_data));
  image_data = log_cov_data;
end

% optimize locality
if isfield(props, 'localityIters')
  [image_data shuffle_idx] = ...
      optimize_cov_matrix(image_data, props.localityIters)
else
  shuffle_idx = 1:size(image_data, 1);
end

num_colors = 49;

if ~ exist('title_str') || isempty(title_str)
  title_str = [properTeXLabel(get(a_db, 'id'))];
end

plot_props = struct('YTick', 1:dbsize(a_db, 1), 'border', [0.07 0 0 0], ...
                    'colorbar', 1);
col_names = getColNames(a_db);
plot_props.YTickLabel = properTeXLabel(col_names(shuffle_idx));

% send this to the plot
plot_props.maxValue = max(max(abs(image_data)));

a_plot = plot_abstract({image_data ./ plot_props.maxValue * num_colors + num_colors, ...
                    @colormapBlueCrossRed, ...
                    num_colors, plot_props}, [], ...
		       title_str, {}, @plotImage, mergeStructs(props, ...
                                                  plot_props))
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

entropy_val = sum(sum(abs(diff(image_data, 1, 1))));

end