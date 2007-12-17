function deriv2 = diff2T(x, dy)

%  diff2T - Estimate of second derivative using Taylor expansion.
%
% Usage:
% deriv2 = diff2T(x, dy)
%
% Parameters:
%	x: A vector of x = f(y).
%	dy: The resolution of the discrete points in the vector.
%
% Returns:
% 	deriv2: Estimate of the derivative.
%
% Description:
%   d^2 x     - x(k-2) + 16 * x(k-1) - 30 * x(k) + 16 * x(k+1) - x(k+2)
%  ------- = -----------------------------------------------------------
%   dy^2			        12 * dy^2
%
%   Taken from Sekerli, Del Negro, Lee and Butera. IEEE Trans. Biomed. Eng.,
%	51(9): 1665-71, 2004.
% Note: First and last two values of the deriv vector will contain boundary 
%	artifacts.
%
% $Id: diff2T.m,v 1.3 2005/05/08 00:13:40 cengiz Exp $
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


x16 = 16 * x;
x30 = 30 * x;

deriv2 = ...
    (- [0, 0, 0, 0, x] + [0, 0, 0, x16, 0] - [0, 0, x30, 0, 0] + ...
     [0, x16, 0, 0, 0] - [x, 0, 0, 0, 0]) ./ ( 12 * dy * dy );

% Strip off the boundaries
deriv2 = deriv2(3:(end-2));

if transposed
  deriv2 = deriv2';
end