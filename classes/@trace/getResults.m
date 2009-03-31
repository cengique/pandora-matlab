function results = getResults(t, plotit)

% getResults - Runs all tests defined by this class and return them in a 
%		structure.
%
% Usage:
% results = getResults(t)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	results: A structure associating test names to values 
%		in ms and mV (or mA).
%
% See also: spike_shape
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('plotit', 'var')
  plotit = 0;
end

% Check for empty object first.
if isempty(t.data) 
  results.min = NaN;
  results.avg = NaN;
  results.max = NaN;
  return;
end

% convert all to ms/mV(mA)
ms_factor = 1e3 * t.dt;
mV_factor = 1e3 * t.dy;

% Run tests
results.min = calcMin(t) * mV_factor;
results.max = calcMax(t) * mV_factor;
results.avg = calcAvg(t) * mV_factor;
