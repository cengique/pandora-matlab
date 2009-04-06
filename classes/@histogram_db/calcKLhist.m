function kl_bits = calcKLhist(two_hist_dbs, props)

% calcKLhist - Calculates the Kullback-Leibler divergence between two histograms with same bins.
%
% Usage:
% kl_bits = calcKLhist(two_hist_dbs, props)
%
% Parameters:
%   two_hist_dbs: Array of two histogram_db objects to calculate KL divergence.
%   props: Structure with optional parameters.
%     sym: calculate symmetric KL divergence. Can be 'sum' for sum of
%          divergences, 'avg' for  average, and 'res' for resistor average.
%		
% Returns:
%   kl_bits: The calculated non-negative divergence in bits.
%
% Description:
%   Histograms must have same bins! See example how to use
% tests_db/histogram to get same bins from multiple DBs.
%
% Example:
% % Find 100-bin histograms of column var1 from two DBs and calculate
% % their KL divergence
% >> kl_bits = calcKLhist(histogram([one_db, another_db], 'var1', 100))
%
% See also: histogram_db, calcKLmodel, tests_db/histogram
%
% $Id: calcKLhist.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/04/03

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

if ~ isa(two_hist_dbs, 'histogram_db') || length(two_hist_dbs) ~= 2
  error('Argument two_hist_dbs must be an array with two elements of type histogram_db.');
end

data = get(two_hist_dbs(1), 'data');
data2 = get(two_hist_dbs(2), 'data');

% Normalize histogram to simulate a probability distribution function
% (PDF) and make zero bins small numbers (EPS) for log calculations
data = data(:, 2) / sum(data(:, 2)) + eps;
data2 = data2(:, 2) / sum(data2(:, 2)) + eps;

% Calculate KL divergence
kl_bits = calcKL(data, data2);

if isfield(props, 'sym')
  kl_bits_right = calcKL(data2, data);
  switch props.sym
    case 'sum'
      kl_bits = kl_bits + kl_bits_right;
    case 'avg'
      kl_bits = (kl_bits + kl_bits_right)/2;
    case 'res'
      kl_bits = (kl_bits * kl_bits_right) / (kl_bits + kl_bits_right);
    otherwise
      error(['Property "sym" has unrecognized value: "' props.sym '"']);
  end
end