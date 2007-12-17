function [mode_val, mode_mag] = calcMode(a_hist_db)

% calcMode - Finds the mode of the distribution, that is, the bin with the highest value.
%
% Usage:
% [mode_val, mode_mag] = calcMode(a_hist_db)
%
% Description:
%
%   Parameters:
%	a_hist_db: A histogram_db object.
%		
%   Returns:
%	mode_val: The center of the bin that has most members.
%	mode_mag: The value of the histogram bin.
%
% See also: histogram_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/27

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

data = get(a_hist_db, 'data');

% Find heaviest bin
[mode_mag, max_ind] = max(data(:, 2));

% Lookup bin center
mode_val = data(max_ind, 1);
