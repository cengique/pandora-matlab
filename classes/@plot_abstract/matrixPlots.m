function a_plot = matrixPlots(plots, axis_labels, title_str, props)

% matrixPlots - Superpose multiple plots with common command onto a single axis.
%
% Usage:
% a_plot = matrixPlots(plots, axis_labels, title_str, props)
%
% Description:
%
%   Parameters:
%	plots: Array of plot_abstract or subclass objects.
%	axis_labels: Cell array of axis label strings (optional, taken from plots).
%	title_str: Plot description string (optional, taken from plots).
%	props: A structure with any optional properties passed to the Y stack_plot.
%	  titlesPos, yLabelsPos, yTicksPos: if specified, passed to the X stack_plots.
%	  rotateYLabel: if specified, passed to the X stack_plots.
%	  axisLimits: if specified, passed to the X stack_plots.
%	  goldratio: try to make the figure in this aspect ratio.
%	  width, height: if specified, make the figure have this many plots in 
%		corresponding dimension.
%		
%   Returns:
%	a_plot: A plot_abstract object.
%
% See also: plot_abstract, plot_abstract/plot, plot_abstract/plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/07

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str')
  title_str = '';
end

if ~ exist('props')
  props = struct([]);
end

% Get generic verbose switch setting
vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if isfield(props, 'goldratio')
  goldratio = props.goldratio;
else
  goldratio = 3/4;
end

if isfield(props, 'width') || isfield(props, 'height')
  if isfield(props, 'width') && isfield(props, 'height')
    width = props.width;
    height = props.height;
  elseif isfield(props, 'width')
    width = props.width;
    height = ceil(length(plots) / width);
  else                                  % Only height is given
    height = props.height;
    width = ceil(length(plots) / height);    
  end
else
  [width, height] = findBestRectangle;
end

horz_props = struct('xLabelsPos', 'none', 'rotateYLabel', 30);
if isfield(props, 'titlesPos')
  horz_props.titlesPos = props.titlesPos;
else
  horz_props.titlesPos = 'none';
end

if isfield(props, 'yLabelsPos')
  horz_props.yLabelsPos = props.yLabelsPos;
else
  horz_props.yLabelsPos = 'left';
end

if isfield(props, 'yTicksPos')
  horz_props.yTicksPos = props.yTicksPos;
else
  horz_props.yTicksPos = 'left';
end

if isfield(props, 'axisLimits')
  axis_limits = props.axisLimits;
else
  axis_limits = [];
end

% Create matrix of plots
vert_stacks = cell(1, height);
for y = 1:height
  if y < height
    horz_stacks = cell(1, width);
  else
    horz_stacks = cell(1, mod(length(plots), width) );
    horz_props.xLabelsPos = 'bottom';
  end
  for x = 1:width
    plot_num = x + (y - 1) * width;
    if plot_num <= length(plots)
      horz_stacks{x} = plots(plot_num);
    end
  end
  vert_stacks{y} = plot_stack(horz_stacks, axis_limits, 'x', '', horz_props);
end
a_plot = plot_stack(vert_stacks, [], 'y', title_str, props);

function good = goodRatio(side1, side2, cost, goldratio)
  % Try to see if it is within some % of the gold ratio
  %ratio = min([side1 side2])/max([side1 side2]);
  % more strict definition
  ratio = side1/side2;
  if verbose
    disp([ 'ratio: ' num2str(ratio)]);
  end

  margin = .2 * cost;		% Increasing margin as cost rises
  if ratio > (1 - margin) * goldratio && ratio < (1 + margin) * goldratio
    good = true(1);
  else
    good = false(1);
  end
  %disp(['Good: ' num2str(good) ' for ratio: ' num2str(ratio) ' ~= ' num2str(goldratio) ' +/- ' num2str(margin*goldratio) ]);
end

function [width, height] = findBestRectangle()
% Find best fit rectangular arrangement
  num_plots = length(plots);

% Iterative algorithm
num_max = num_plots;

iter_num = 0;
while iter_num < 10
  iter_num = iter_num + 1;
  factors = factor(num_max);

  if verbose
    disp([ 'iter_num: ' num2str(iter_num) ', factors: ' num2str(factors)]);
  end

  if length(factors) == 1
    % Only one factor
    if goodRatio(1, factors, iter_num, goldratio)
      side1 = 1;
      side2 = factors;
      break;
    else
      num_max = num_max + 1;
      continue;  % Start over
    end
  elseif goodRatio(prod(factors(1:2:end)), prod(factors(2:2:end)), ...
		   iter_num, goldratio)
    % interleaved product of factors
    side1 = prod(factors(1:2:end));
    side2 = prod(factors(2:2:end));
    break;
  else
    % Try all factor combinations
    for one_facs=1:floor(length(factors)/2)
      combs = unique(combnk(factors, one_facs), 'rows');
      for frow=combs'
	side1 = prod(frow);
	side2 = num_max / side1;
	if verbose
	  disp([ 'side1: ' num2str(side1) ', side2: ' num2str(side2)]);
	end
	if goodRatio(side1, side2, iter_num, goldratio)
	  break;
	end
      end
      if goodRatio(side1, side2, iter_num, goldratio)
	break;
      end
    end
  end

  if goodRatio(side1, side2, iter_num, goldratio)
    break;
  else
    num_max = num_max + 1;
  end
end

% TODO: If all fails, use sqrt here

% Final width and height of tile matrix
%width = max([side1 side2]);
%height = min([side1 side2]);
width = side1;
height = side2;
if verbose
  disp([ 'width: ' num2str(width) ', height: ' num2str(height)]);
end
  
end

end
