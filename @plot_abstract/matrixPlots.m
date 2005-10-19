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
%		
%   Returns:
%	a_plot: A plot_abstract object.
%
% See also: plot_abstract, plot_abstract/plot, plot_abstract/plotFigure
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/07

if ~ exist('title_str')
  title_str = '';
end

if ~ exist('props')
  props = struct([]);
end

%# Find best fit rectangular arrangement
num_plots = length(plots);

%# Iterative algorithm
num_max = num_plots;

iter_num = 0;
while iter_num < 10
  iter_num = iter_num + 1
  factors = factor(num_max)

  if length(factors) == 1
    %# Only one factor
    if goodRatio(1, factors, iter_num)
      side1 = 1;
      side2 = factors;
      break;
    else
      num_max = num_max + 1;
      continue;  %# Start over
    end
  elseif goodRatio(prod(factors(1:2:end)), prod(factors(2:2:end)), iter_num)
    %# interleaved product of factors
    side1 = prod(factors(1:2:end));
    side2 = prod(factors(2:2:end));
    break;
  else
    %# Try all factor combinations
    for one_facs=1:floor(length(factors)/2)
      combs = unique(combnk(factors, one_facs), 'rows');
      for frow=combs'
	side1 = prod(frow)
	side2 = num_max / side1
	if goodRatio(side1, side2, iter_num)
	  break;
	end
      end
      if goodRatio(side1, side2, iter_num)
	break;
      end
    end
  end

  if goodRatio(side1, side2, iter_num)
    break;
  else
    num_max = num_max + 1;
  end
end

%# TODO: If all fails, use sqrt here

%# Final width and height of tile matrix
width = max([side1 side2])
height = min([side1 side2])

%# 'titlesPos', 'none',
horz_props = struct('yLabelsPos', 'left', 'rotateYLabel', 30);

%# Create matrix of plots
vert_stacks = cell(1, height);
for y = 1:height
  if y < height
    horz_stacks = cell(1, width);
  else
    horz_stacks = cell(1, mod(length(plots), width) );
  end
  for x = 1:width
    plot_num = x + (y - 1) * width;
    if plot_num <= length(plots)
      horz_stacks{x} = plots(plot_num);
    end
  end
  vert_stacks{y} = plot_stack(horz_stacks, [], 'x', '', horz_props);
end
a_plot = plot_stack(vert_stacks, [], 'y', title_str, props)

function good = goodRatio(side1, side2, cost, iter_num)
  %# Try to see if it is within some % of the 3/4 ratio
  ratio = min([side1 side2])/max([side1 side2])
  goldratio = 3/4;
  margin = .2 * cost;		%# Increasing margin as cost rises
  if ratio > (1 - margin) * goldratio && ratio < (1 + margin) * goldratio
    good = true(1);
  else
    good = false(1);
  end
  disp(['Good: ' num2str(good) ' for ratio: ' num2str(ratio) ' ~= ' num2str(goldratio) ' +/- ' num2str(margin*goldratio) ]);
