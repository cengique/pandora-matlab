function x_idx = maxima(x)

%  maxima - Find all local maxima.
%
% Usage:
% x_idx = maxima(x)
%
% Parameters:
%	x: A vector.
%
% Returns:
% 	x_idx: Indices of maxima.
%
% Description:
%   Finds derivative sign-flipping points where the second derivative is 
% less than zero.
%
% $Id: maxima.m,v 1.1 2005/05/08 00:13:40 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/18

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Find  local maxima in h (diffT does not give correct results)
dx = diff(x);

% Calculate sign flips (extrema)
% NOT ANYMORE: Skip first and last two points due to approx. error
dxflip = dx(2:end) .* dx(1:(end-1));

%dx2 = diff2T_h4(x, 1); % 2nd deriv

x_idx = find([false(1, 1) (dx(1:(end-1)) >= 0 & dxflip <= 0) false(1, 1)]);
