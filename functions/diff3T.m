function deriv3 = diff3T(x, dy)

%  diff3T - Estimate of third derivative using Taylor expansion.
%
% Usage:
% deriv3 = diff3T(x, dy)
%
% Parameters:
%	x: A vector of x = f(y).
%	dy: The resolution of the discrete points in the vector.
%
% Returns:
% 	deriv3: Estimate of the derivative.
%
% Description:
%   d^3 x     x(k-3) - 8 * x(k-2) + 13 * x(k-1) - 13 * x(k+1) + 8 * x(k+2) - x(k+3)
%  ------- = -----------------------------------------------------------------------
%   dy^3			        8 * dy^3
%
%   Taken from Sekerli, Del Negro, Lee and Butera. IEEE Trans. Biomed. Eng.,
%	51(9): 1665-71, 2004.
% Note: First and last three values of the deriv vector will contain boundary 
%	artifacts.
%
% $Id: diff3T.m,v 1.3 2005/05/08 00:13:40 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/15

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if size(x, 1) > size(x, 2)
  transposed = 1;
  x = x';
else
  transposed = false(1);
end

x8 = 8 * x;
x13 = 13 * x;

deriv3 = ...
    ([0, 0, 0, 0, 0, 0, x] - [0, 0, 0, 0, 0, x8, 0] + [0, 0, 0, 0, x13, 0, 0] ...
     - [0, 0, x13, 0, 0, 0, 0] + [0, x8, 0, 0, 0, 0, 0] - [x, 0, 0, 0, 0, 0, 0]) ...
    ./ ( 8 * dy * dy * dy);

% Strip off the boundaries
deriv3 = deriv3(4:(end-3));

if transposed
  deriv3 = deriv3';
end