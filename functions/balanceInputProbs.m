function [new_inputs, new_outputs] = ...
    balanceInputProbs(a_class_inputs, a_class_outputs, balance_ratio)

% balanceInputProbs - Balances samples according to prior class probabilities of the outputs.
%
% Usage:
% [new_inputs, new_outputs] = balanceInputProbs(a_class_inputs, a_class_outputs, balance_ratio)
%
% Description:
%   Uses the method in Lawrence, burns, Back, Tsoi and Lee Giles "Neural
% network classification and prior class probabilities" for
% probabilitic balancing of input and output samples when the number of
% samples in each class is vastly different and causes problems with
% classification without balancing.
%
%   Parameters:
%	a_class_inputs, a_class_outputs: Input and output vectors.
%	balance_ratio: c_s, between 0 and 1. If 1, equal samples from
%		each class if used. If 0, prior class probabilities are followed.
%	props: A structure with any optional properties.
%		
%   Returns:
%	new_inputs, new_outputs: New input and output vectors.
%
% See also: approxMappingNNet, tests_db
%
% $Id: balanceInputProbs.m 883 2007-12-13 17:28:47Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/01/09

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

% find uniques in the output classifier
[sorted_outputs sort_idx] = sort(a_class_outputs);

[unique_outs unique_idx] = ...
    uniqueValues(sorted_outputs');

% how many of each class
num_outs = size(a_class_outputs, 2);
num_in_class = [ diff(unique_idx); (num_outs - unique_idx(end) + 1)];
num_classes = length(num_in_class);

% do not take more than the samples in the smallest class
num_samples = min(num_in_class) * num_classes;

% calculate balanced class probabilities
class_probs = zeros(1, num_classes);
base = 0;
for class_num = 1:num_classes
  if class_num > 1, base = class_probs(class_num - 1); end
  % taken from Lawrence et al (1998)
  class_probs(class_num) = ...
      base + (1 - balance_ratio) * num_in_class(class_num) / num_outs + ...
      balance_ratio / num_classes;
end

if verbose
  unique_idx, num_in_class, num_samples
  disp([ 'probs: ' num2str([class_probs(1) diff(class_probs) ])]); 
end

% make each input
count_in_class = ones(1, num_classes);
new_inputs = repmat(NaN, size(a_class_inputs, 1), num_samples);
new_outputs = repmat(NaN, size(a_class_outputs, 1), num_samples);
for sample_num = 1:num_samples
  chosen_class = find(rand < class_probs);
  chosen_class = chosen_class(1);
  sample_offset = ...
      sort_idx(unique_idx(chosen_class) ...
               + count_in_class(chosen_class) - 1);
  new_inputs(:, sample_num) = ...
      a_class_inputs(:, sample_offset);
  new_outputs(:, sample_num) = ...
      a_class_outputs(:, sample_offset);
  % increment counter for that class, but stay within bounds
  count_in_class(chosen_class) = ...
      mod(count_in_class(chosen_class), num_in_class(chosen_class)) + 1;
  
end

end