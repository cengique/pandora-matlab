function [mode_val, mode_mag] = mode(a_hist_db)

% mode - Finds the mode of the distribution, that is, the bin with the highest value.
%
% Usage:
% [mode_val, mode_mag] = mode(a_hist_db)
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/27

data = get(a_hist_db, 'data');

%# Find heaviest bin
[mode_mag, max_ind] = max(data(:, 2));

%# Lookup bin center
mode_val = data(max_ind, 1);
