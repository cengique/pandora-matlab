function kl_bits = calcKLhist(a_hist_db, a2_hist_db, props)

% calcKLhist - Calculates the Kullback-Leibler divergence between two histograms with same bins.
%
% Usage:
% kl_bits = calcKLhist(a_hist_db, a2_hist_db, props)
%
% Parameters:
%   a_hist_db, a2_hist_db: histogram_db objects to calculate KL divergence.
%   props: Structure with optional parameters.
%		
% Returns:
%   kl_bits: The calculated non-negative divergence in bits.
%
% Description:
%   Histograms must have same bins!
%
% See also: histogram_db, calcKLmodel
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

data = get(a_hist_db, 'data');
data2 = get(a2_hist_db, 'data');

% Normalize histogram to simulate a probability distribution function
% (PDF)
data = data(:, 2) / sum(data(:, 2));
data2 = data2(:, 2) / sum(data2(:, 2));


% Calculate KL divergence
kl_bits = calcKL(data, data2);
