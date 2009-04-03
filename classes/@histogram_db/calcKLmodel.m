function [kl_bits, a_plot] = calcKLmodel(a_hist_db, dist_model, props)

% calcKLmodel - Calculates the Kullback-Leibler divergence of the histogram to a model distribution.
%
% Usage:
% [mode_val, mode_mag] = calcKLmodel(a_hist_db)
%
% Parameters:
%   a_hist_db: A histogram_db object.
%   dist_model: Structure that contains the distribution parameters. Must
%   	be one of these:
%	Normal distribution: struct('dist', 'norm', 'mu', mean, 'sigma', var)
%	Poisson distribution: struct('dist', 'pois', 'lambda', l)
%	Exponential distribution: struct('dist', 'exp', 'mu', m)
%	Uniform distribution: struct('dist', 'uni')
%   props: Structure with optional parameters.
%     plot: If 1, return a plot_abstract object with both distributions.
%		
% Returns:
%   kl_bits: The calculated divergence in bits.
%
% Description:
%
% See also: histogram_db
%
% $Id: calcKLmodel.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/03/24

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

data = get(a_hist_db, 'data');

% approximate bin size from first two bin centers
bin_size = diff(data(1:2, 1));

% Normalize histogram to simulate a probability distribution function
% (PDF)
norm_data = data(:, 2) / sum(data(:, 2));

% Find ranges
%data_range = [ min(data(:, 1)) max(data(:, 1))];

% Calculate theoretical distribution

% TODO: put these in common place in private directory to plot on top of
% histogram
switch dist_model.dist
  case 'norm'
    prob_func = ...
        @(x)(1./(dist_model.sigma * sqrt(2 * pi)) * ...
             exp( - (x-dist_model.mu).^2./(2*dist_model.sigma^2)));
  case 'pois'
  case 'exp'
  case 'uni'
  otherwise
    error([ 'Probability distribution "' dist_model.dist ' not recognized.']);
end

% multiply by bin size to get average prob for the whole bin
% (integration would've been more accurate)
dist_data = prob_func(data(:, 1)) * bin_size;

% Calculate KL divergence
kl_bits = calcKL(norm_data, dist_data);

if isfield(props, 'plot')
  a_hist_db.tests_db.data = [ data(:, 1), norm_data ];
  a_plot = ...
      plot_superpose({...
        plot_abstract(a_hist_db, ...
                      ['Compare to ' dist_model.dist ...
                      ' distribution'], ...
                      mergeStructs(props, struct('shading', ...
                                                 'flat'))), ...
                     plot_abstract({data(:, 1), dist_data}, ...
                                   {}, '', { [ dist_model.dist ' dist.'] }, ...
                                   'plot', props)});
end
  