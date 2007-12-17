function levels = logLevels(min_val, max_val, num_levels)

%  logLevels - Returns a logarithmic-scaled series between min_val and max_val with num_levels elements.
%
% Usage:
% levels = logLevels(min_val, max_val, num_levels)
%
% Parameters:
%	min_val, max_val: The low and high boundaries for the output value.
%	num_levels: Number of elements to produce, including the boundaries.
%
% Returns:
% 	levels: A column vector of logarithmic series between min_val and max_val.
%
% Description:
%
% $Id: logLevels.m,v 1.1 2006/03/13 23:16:31 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/18

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if min_val == 0 
  b = 1e-6;
else
  b = 0;
end
a = exp(1); % use as the base

min_pow = log(min_val + b);
max_pow = log(max_val + b);

levels = exp(min_pow + (0:(num_levels - 1))' * (max_pow - min_pow) / (num_levels - 1)) - b;

