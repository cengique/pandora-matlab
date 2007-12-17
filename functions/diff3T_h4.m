function deriv2 = diff3T_h4(x, dy)

%  diff3T_h4 - Estimate of third derivative using Taylor expansion (derived with same method as diffT and diff2T_h4).
%
% Usage:
% deriv2 = diff3T_h4(x, dy)
%
% Parameters:
%	x: A vector of x = f(y).
%	dy: The resolution of the discrete points in the vector.
%
% Returns:
% 	deriv2: Estimate of the derivative.
%
% Description:
%   d^3 x     - x(k-2) + 2 * x(k-1) - 2 * x(k+1) + x(k+2)
%  ------- = ---------------------------------------------
%   dy^3			12 * dy^3
%
% Note: First and last two values of the deriv vector will contain boundary 
%	artifacts.
%
% $Id: diff3T_h4.m,v 1.1 2005/05/08 00:13:40 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/18

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

x2 = 2 * x;

deriv2 = ...
    ( - [0, 0, 0, 0, x] + [0, 0, 0, x2, 0] - ...
     [0, x2, 0, 0, 0] + [x, 0, 0, 0, 0]) ./ ( 12 * dy * dy * dy );

% Strip off the boundaries
deriv2 = deriv2(3:(end-2));

if transposed
  deriv2 = deriv2';
end